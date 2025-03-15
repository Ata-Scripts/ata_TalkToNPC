

RegisterNetEvent('buyitemsCash')
AddEventHandler('buyitemsCash', function(items)
    local source = source
    if not items or type(items) ~= "table" then return end
    
    local totalPrice = 0
    for _, item in ipairs(items) do
        if not item.price or not item.count or item.price < 0 or item.count < 1 then
            return exports['ata_core']:Notification(source, Locales['en']['invalid_item_data'], 'error')
        end
        totalPrice = totalPrice + (item.price * item.count)
    end

    if not exports['ata_core']:HaveMoney(source, totalPrice, "cash") then
        return exports['ata_core']:Notification(source, Locales['en']['not_enough_money_cash'], 'error')
    end

    local success = true
    local addedItems = {}
    
    for _, item in ipairs(items) do
        local addItem = exports['ata_core']:AddItem(source, item.name, item.count)
        if addItem then
            table.insert(addedItems, {name = item.name, count = item.count, price = item.price})
        else
            success = false
            break
        end
    end

    if success then
        exports['ata_core']:RemoveMoney(source, totalPrice, "cash")
        TriggerClientEvent('ata_talktonpc:successItems', source)
    else
        -- Rollback added items if something failed
        for _, item in ipairs(addedItems) do
            exports['ata_core']:RemoveItem(source, item.name, item.count)
        end
        exports['ata_core']:Notification(source, Locales['en']['failed_to_add_items'], 'error')
    end
end)

RegisterNetEvent('buyitemsBank')
AddEventHandler('buyitemsBank', function(items)
    local source = source
    if not items or type(items) ~= "table" then return end
    
    local totalPrice = 0
    for _, item in ipairs(items) do
        if not item.price or not item.count or item.price < 0 or item.count < 1 then
            return exports['ata_core']:Notification(source, Locales['en']['invalid_item_data'], 'error')
        end
        totalPrice = totalPrice + (item.price * item.count)
    end

    if not exports['ata_core']:HaveMoney(source, totalPrice, "bank") then
        return exports['ata_core']:Notification(source, Locales['en']['not_enough_money_bank'], 'error')
    end

    local success = true
    local addedItems = {}
    
    for _, item in ipairs(items) do
        print(item.name)
        local addItem = exports['ata_core']:AddItem(source, item.name, item.count)
        if addItem then
            table.insert(addedItems, {name = item.name, count = item.count, price = item.price})
        else
            success = false
            break
        end
    end

    if success then
        exports['ata_core']:RemoveMoney(source, totalPrice, "bank")
        TriggerClientEvent('ata_talktonpc:successItems', source)
    else
        -- Rollback added items if something failed
        for _, item in ipairs(addedItems) do
            exports['ata_core']:RemoveItem(source, item.name, item.count)
        end
        exports['ata_core']:Notification(source, Locales['en']['failed_to_add_items'], 'error')
    end
end)

RegisterNetEvent('sellitemsCash')
AddEventHandler('sellitemsCash', function(items)
    local source = source
    if not items or type(items) ~= "table" then 
        return exports['ata_core']:Notification(source, Locales['en']['invalid_items_data'], 'error')
    end

    local totalPrice = 0
    local soldItems = {}

    -- Validate and check all items first
    for _, item in ipairs(items) do
        if not item.name or not item.count or not item.price or item.count < 1 or item.price < 0 then
            return exports['ata_core']:Notification(source, Locales['en']['invalid_item_data'], 'error')
        end
        
        if not exports['ata_core']:PlayerHasItem(source, item.name, item.count) then
            return exports['ata_core']:Notification(source, Locales['en']['item_not_enough'], 'error')
        end
    end

    -- Process the sale after validation
    for _, item in ipairs(items) do
        exports['ata_core']:RemoveItem(source, item.name, item.count)
        local itemPrice = item.price * item.count
        totalPrice = totalPrice + itemPrice
        table.insert(soldItems, {
            name = item.name,
            label = item.label,
            count = item.count,
            price = item.price
        })
    end

    exports['ata_core']:AddMoney(source, totalPrice, "cash")
    TriggerClientEvent('ata_talktonpc:deleteItems', source, totalPrice)
    exports['ata_core']:Notification(source, Locales['en']['items_sold_successfully'] .. totalPrice, 'success')
end)

RegisterNetEvent('sellitemsBank')
AddEventHandler('sellitemsBank', function(items)
    local source = source
    if not items or type(items) ~= "table" then 
        return exports['ata_core']:Notification(source, Locales['en']['invalid_items_data'], 'error')
    end

    local totalPrice = 0
    local soldItems = {}

    -- Validate and check all items first
    for _, item in ipairs(items) do
        if not item.name or not item.count or not item.price or item.count < 1 or item.price < 0 then
            return exports['ata_core']:Notification(source, Locales['en']['invalid_item_data'], 'error')
        end
        
        if not exports['ata_core']:PlayerHasItem(source, item.name, item.count) then
            return exports['ata_core']:Notification(source, Locales['en']['item_not_enough'], 'error')
        end
    end

    -- Process the sale after validation
    for _, item in ipairs(items) do
        exports['ata_core']:RemoveItem(source, item.name, item.count)
        local itemPrice = item.price * item.count
        totalPrice = totalPrice + itemPrice
        table.insert(soldItems, {
            name = item.name,
            label = item.label,
            count = item.count,
            price = item.price
        })
    end

    exports['ata_core']:AddMoney(source, totalPrice, "bank")
    TriggerClientEvent('ata_talktonpc:deleteItems', source, totalPrice)
    exports['ata_core']:Notification(source, Locales['en']['items_sold_successfully'] .. totalPrice, 'success')
end)

RegisterNetEvent('getInventoryItems') 
AddEventHandler('getInventoryItems', function()
    local inventory = exports['ata_core']:GetPlayerInventory(source)
    TriggerClientEvent('ata_talktonpc:setInventoryItems', source, inventory)
end)


exports['ata_core']:CreateCallback('ata_talktonpc:GetJobsCanUse', function(source, cb, jobs)
    if not jobs or #jobs == 0 then
        cb(true)
        return
    end

    local playerJob = exports['ata_core']:GetPlayerJob(source)
    
    if type(playerJob) == 'table' then
        playerJob = playerJob.name -- For QBCore which returns job table
    end

    for _, job in ipairs(jobs) do
        if playerJob == job then
            cb(true)
            return
        end
    end

    cb(false)
end)


CreateThread(function()
    Wait(10000)
    exports['ata_core']:VersionCheck('ata_talktonpc')
end)
