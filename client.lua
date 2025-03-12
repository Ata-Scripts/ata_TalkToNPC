local currentNPC = nil
PlayerData = {}
local pedList = {}
local cam = nil



-- Function to handle NPC interaction
local function HandleNPCInteraction(v)

    ClearHelp(true)  -- Add this to clear any active help notifications
    
    
    local npcEntity = nil
    
    if v.entity and DoesEntityExist(v.entity) then
        npcEntity = v.entity

    
    -- Method 2: Search in Config.TalkToNPC
    else
        for k, npc in pairs(Config.TalkToNPC) do
            -- Compare by coordinates and name to find the right NPC
            if npc.coordinates[1] == v.coordinates[1] and 
               npc.coordinates[2] == v.coordinates[2] and
               npc.coordinates[3] == v.coordinates[3] and
               npc.name == v.name then
                
                if npc.entity and DoesEntityExist(npc.entity) then
                    npcEntity = npc.entity
                    v.entity = npcEntity
                    break
                end
            end
        end
        
        -- Method 3: Search in pedList 
        if not npcEntity then
            for k, ped in pairs(pedList) do
                -- Compare coordinates to find matching ped
                if ped.pedCoords[1] == v.coordinates[1] and 
                   ped.pedCoords[2] == v.coordinates[2] and
                   ped.pedCoords[3] == v.coordinates[3] and
                   DoesEntityExist(ped.entity) then
                     
                    npcEntity = ped.entity
                    -- Update the passed data with the entity
                    v.entity = npcEntity
                    break
                end
            end
        end
    end
    
    -- Store NPC information
    currentNPC = v
    
    -- Start camera if we have an entity
    if npcEntity then
        StartCam(v.coordinates, npcEntity)
    end
    
    Citizen.Wait(500)
    TriggerEvent('ataTalkToNpc:checkInventory')
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openUI',
        name = v.name,
        dialog = v.dialog,
        options = v.options,
        SellItem = v.SellItem,
        BuyItem = v.BuyItem,
        config = Config
    })
end

-- CREATE NPCs
Citizen.CreateThread(function()
    -- Initialize pedList array
    pedList = {}
    
    if Config.NPCinteraction == 'target' then
        for k, v in pairs(Config.TalkToNPC) do
            -- Create the NPC
            local npc = exports['ata_core']:CreateNPCWithKey(
                v.npc, -- NPC model
                v.coordinates,
                v.heading,  -- heading 
                v.textUI, -- interaction text
                'ataTalkToNpc:interact', -- event name to trigger
                v,
                'client', -- event type
                'strip_club', -- animation type 
                true 
            )
            
            -- Ensure we have a valid entity
            if npc and DoesEntityExist(npc) then
                
                -- Store NPC entity in the config table for later use
                Config.TalkToNPC[k].entity = npc
                
                -- Also store in pedList for camera functions
                table.insert(pedList, {
                    name = v.name,
                    model = v.npc,
                    pedCoords = v.coordinates,
                    entity = npc
                })
           
            end
        end 
    else
        for k, v in pairs(Config.TalkToNPC) do
            -- Create the NPC 
            local npc = exports['ata_core']:CreateNPCWithKey(
                v.npc, -- NPC model
                v.coordinates,
                v.heading,  -- heading
                v.textUI, -- interaction text
                'ataTalkToNpc:interact', -- event name to trigger
                v,
                'client', -- event type
                'strip_club', -- animation type
                false
            )
            
            -- Ensure we have a valid entity
            if npc and DoesEntityExist(npc) then
              
                
                Config.TalkToNPC[k].entity = npc
                
                table.insert(pedList, {
                    name = v.name,
                    model = v.npc,
                    pedCoords = v.coordinates,
                    entity = npc
                })
           
            end
        end
    end
end)



RegisterNUICallback('onTypingStart', function(data, cb) 
    cb({})
end)

RegisterNUICallback('onTypingEnd', function(data, cb)
    cb({})
end)

RegisterNUICallback('action', function(data, cb)
    if data.action.followUp then
        if data.action.args then
            TriggerEvent(data.action.event, table.unpack(data.action.args))
        end
        Citizen.Wait(1000)
        
        SendNUIMessage({
            action = "setFollowUpOptions",
            options = data.action.followUp
        })
    else
        if data.action.serverSide then
            if data.action.args then
                TriggerServerEvent(data.action.event, table.unpack(data.action.args))
            else
                TriggerServerEvent(data.action.event)
            end
        else
            if data.action.args then
                TriggerEvent(data.action.event, table.unpack(data.action.args))
            else

                TriggerEvent(data.action.event)
            end
        end
    end
    cb(true)
end)


RegisterNUICallback('buyitemsCash', function(data, cb)
	TriggerServerEvent('buyitemsCash', data.items)
end)



RegisterNUICallback('buyitemsBank', function(data, cb)
	TriggerServerEvent('buyitemsBank', data.items)
end)



RegisterNUICallback('sellitemsCash', function(data, cb)
	TriggerServerEvent('sellitemsCash', data.items)
end)


RegisterNUICallback('sellitemsBank', function(data, cb)
	TriggerServerEvent('sellitemsBank', data.items)
end)

RegisterNUICallback('closeUI', function(data, cb)
    currentNPC = nil
    SetNuiFocus(false, false)
    EndCam()
    inMenu = false
    waitMore = false
    cb({})
end)



function StartCam(coords, npcEntity)
    ClearFocus()
    
    if not npcEntity or not DoesEntityExist(npcEntity) then
        -- Try to get entity from currentNPC
        if currentNPC and currentNPC.entity and DoesEntityExist(currentNPC.entity) then
            npcEntity = currentNPC.entity
        else
            -- Search in pedList
            for k, v in pairs(pedList) do
                if v.pedCoords[1] == coords[1] and 
                   v.pedCoords[2] == coords[2] and 
                   v.pedCoords[3] == coords[3] and
                   DoesEntityExist(v.entity) then
                    npcEntity = v.entity
                    break
                end
            end
        end
    end
    
    if not npcEntity or not DoesEntityExist(npcEntity) then
        return 
    end

    -- Get NPC's position and bone position
    local npcCoords = GetEntityCoords(npcEntity)
    local boneIndex = GetPedBoneIndex(npcEntity, 31086) -- Head bone
    local boneCoords = GetPedBoneCoords(npcEntity, boneIndex)
    
    -- Clean up existing camera
    if cam ~= nil then
        DestroyCam(cam, true)
    end
    
    -- Create and setup camera
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    
    -- Attach camera to NPC head bone with adjusted heading
    AttachCamToPedBone(cam, npcEntity, boneIndex, 0.15 , 0.7, 0.63, true)
    
    -- Set camera FOV for face focus
    SetCamFov(cam, 40.0)
    
    -- Get NPC heading
    local npcHeading = GetEntityHeading(npcEntity)
    
    -- Set camera rotation to face NPC
    SetCamRot(cam, 0.0, 0.0, npcHeading + 180.0, 2)
    
    -- Enable camera with transition
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, false)
    
    -- Update currentNPC with the entity if needed
    if currentNPC and not currentNPC.entity then
        currentNPC.entity = npcEntity
    end
end

function EndCam()
    if cam then
        RenderScriptCams(false, true, 500, true, false)
        DestroyCam(cam, true)
        cam = nil
    end
    ClearFocus()
    currentNPC = nil
end




RegisterNetEvent('ataTalkToNpc:addChat')
AddEventHandler('ataTalkToNpc:addChat', function (atype, data)

	if atype == "buy" then
		SendNUIMessage({
			action = "addBuy",
			stype = "buy",
		})
	elseif atype == "sell" then
		SendNUIMessage({
			action = "addSell",
			stype = "sell",
		})
	else
		SendNUIMessage({
			action = "addMessage",
			stype = atype,
			data = data,
			left = false
		})
	end
   
end)


RegisterNetEvent('ataTalkToNpc:setInventoryItems')
AddEventHandler('ataTalkToNpc:setInventoryItems', function(inventory)
	SendNUIMessage({
		action = "setInventoryItems",
		items = inventory,
	})
end)

RegisterNetEvent('ataTalkToNpc:notification')
AddEventHandler('ataTalkToNpc:notification', function(actions)
	SendNUIMessage({
		action = "notification",
		title = actions.title,
		message = actions.message,
		options = actions.options,
		icon = actions.icon,
		event = actions.event,
		serverSide = actions.serverSide,
	})
end)

RegisterNetEvent('ataTalkToNpc:successItems')
AddEventHandler('ataTalkToNpc:successItems', function (data)
	SendNUIMessage({
		action = "successItems"
	})
    Citizen.Wait(1000)
    TriggerEvent('ataTalkToNpc:closeUI')
end)

RegisterNetEvent('ataTalkToNpc:deleteItems')
AddEventHandler('ataTalkToNpc:deleteItems', function (price)
	SendNUIMessage({
		action = "deleteItems",
		price = price
	})
	Citizen.Wait(1000)
    TriggerEvent('ataTalkToNpc:closeUI')
end)

RegisterNetEvent('ataTalkToNpc:closeUI')
AddEventHandler('ataTalkToNpc:closeUI', function ()
    SendNUIMessage({action = "closeUI"})
	SetNuiFocus(false, false)
	EndCam()
end)


RegisterNetEvent('ataTalkToNpc:buyItems')
AddEventHandler('ataTalkToNpc:buyItems', function ()
    TriggerEvent("ataTalkToNpc:addChat", "buy")
end)


RegisterNetEvent('ataTalkToNpc:sellItems')
AddEventHandler('ataTalkToNpc:sellItems', function ()
    TriggerEvent("ataTalkToNpc:addChat", "sell")
end)


RegisterNetEvent('ataTalkToNpc:checkInventory')
AddEventHandler('ataTalkToNpc:checkInventory', function()
    TriggerServerEvent('getInventoryItems')
end)

RegisterNetEvent('ataTalkToNpc:interact')
AddEventHandler('ataTalkToNpc:interact', function(data)
    exports['ata_core']:CallBackServer('ataTalkToNpc:GetJobsCanUse', function(CanUse)
        if CanUse then
            if data then
                HandleNPCInteraction(data)
            end
        else
            exports['ata_core']:Notification(Locales['en']['no_permission'], 'error')
        end
    end, data.jobs)
end)

-- Exports
exports('addChat', function(type, message)
    TriggerEvent('ataTalkToNpc:addChat', type, message)
end)

exports('showNotification', function(data)
    TriggerEvent('ataTalkToNpc:notification', data)
end)

exports('openBuyMenu', function()
    TriggerEvent('ataTalkToNpc:buyItems')
end)

exports('openSellMenu', function()
    TriggerEvent('ataTalkToNpc:sellItems')
end)

exports('closeUI', function()
    TriggerEvent('ataTalkToNpc:closeUI')
end)

exports('interactWithNPC', function(npcData)
    if npcData then
        HandleNPCInteraction(npcData)
    end
end)
