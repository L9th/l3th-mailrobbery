local inventory = {}

if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
end

inventory.addItem = function(source, item, count, metadata)
    if GetResourceState('ox_inventory') == 'started' then
        return exports.ox_inventory:AddItem(source, item, count, metadata or nil)
    elseif GetResourceState('qb-inventory') == 'started' then
        return exports['qb-inventory']:AddItem(source, item, count)
    elseif GetResourceState('ps-inventory') == 'started' then
        return exports['ps-inventory']:AddItem(source, item, count)
    end
end

return inventory