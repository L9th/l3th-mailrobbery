local inventory = {}
local QBCore = nil

if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
end

inventory.hasItem = function(item, count)
    if GetResourceState('ox_inventory') == 'started' then
        return exports.ox_inventory:Search('count', item) >= count
    elseif GetResourceState('qb-inventory') then
        return exports['qb-inventory']:HasItem(item, count)
    elseif GetResourceState('ps-inventory') then
        return exports['ps-inventory']:HasItem(item, count)
    end
end

return inventory