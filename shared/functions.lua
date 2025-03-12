function GetFrameworkObject()
    local object = nil
    if Config.Framework == "esx" then
          object = exports['es_extended']:getSharedObject()
    elseif Config.Framework == "qb-core" then
        object = exports['qb-core']:GetCoreObject()
    end
    return object
end

function addInventoryItem(source, item, count)
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:AddItem(source, item, count)
    elseif Config.Inventory == "qb-inventory" then
        if Config.Framework == "qb-core" then
            local player = Framework.Functions.GetPlayer(source)
            player.Functions.AddItem(item, count)
        end
    else -- esx_inventory
        local player = Framework.GetPlayerFromId(source)
        player.addInventoryItem(item, count)
    end
end

function removeInventoryItem(source, item, count)
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:RemoveItem(source, item, count)
    elseif Config.Inventory == "qb-inventory" then
        if Config.Framework == "qb-core" then
            local player = Framework.Functions.GetPlayer(source)
            player.Functions.RemoveItem(item, count)
        end
    else -- esx_inventory
        local player = Framework.GetPlayerFromId(source)
        player.removeInventoryItem(item, count)
    end
end

function getInventoryItem(source, item)
    local count = 0
    if Config.Inventory == "ox_inventory" then
        local inventory = exports.ox_inventory:GetInventoryItems(source)
        for _, invItem in pairs(inventory) do
            if invItem.name == item then
                count = invItem.count
                break
            end
        end
    elseif Config.Inventory == "qb-inventory" then
        if Config.Framework == "qb-core" then
            local player = Framework.Functions.GetPlayer(source)
            local invItem = player.Functions.GetItemByName(item)
            if invItem then
                count = invItem.amount
            end
        end
    else -- esx_inventory
        local player = Framework.GetPlayerFromId(source)
        local invItem = player.getInventoryItem(item)
        if invItem then
            count = invItem.count
        end
    end
    return count
end

function addItem(source, item, count)
    if Config.Framework == "esx" then
        local player = Framework.GetPlayerFromId(source)
        player.addInventoryItem(item, count)
    else
        local player = Framework.Functions.GetPlayer(source)
        player.Functions.AddItem(item, count)
    end
end

function GetxPlayeridentifier(xPlayer)
    if Config.Framework == "esx" then
        return xPlayer.identifier
    else
        return xPlayer.PlayerData.citizenid
    end
end

function getCash(xPlayer)
    if Config.Framework == "esx" then
        return xPlayer.getAccount('money').money
    else
        return xPlayer.PlayerData.money['cash']
    end
end

function getBank(xPlayer)
    if Config.Framework == "esx" then
        return xPlayer.getAccount('bank').money
    else
        return xPlayer.PlayerData.money['bank']
    end
end

function removeMoney(xPlayer, moneytype, amount)
    if Config.Framework == "esx" then
        if moneytype == "cash" then moneytype = 'money' end
        return xPlayer.removeAccountMoney(moneytype, amount)
    else
        return xPlayer.Functions.RemoveMoney(moneytype, amount)
    end
end

function addMoney(xPlayer, moneytype, amount)
    if Config.Framework == "esx" then
        if moneytype == "cash" then moneytype = 'money' end
        xPlayer.addAccountMoney(moneytype, amount)
    else
        return xPlayer.Functions.AddMoney(moneytype, amount)
    end
end

function getxPlayerName(xPlayer)
    if Config.Framework == "esx" then
        return xPlayer.getName()
    else
        return xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
    end
end

function getPlayerData()
    if Config.Framework == "esx" then
        return Framework.GetPlayerData()
    else
        return Framework.Functions.GetPlayerData()
    end
end

function GetPlayerFromId(src)
    if Config.Framework == "esx" then
        return Framework.GetPlayerFromId(src)
    else
        return Framework.Functions.GetPlayer(src)
    end
end
