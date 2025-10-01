local utils = {}
local client = require 'configs.client'

utils.isNearCoords = function(entity, coords)
    local entityCoords = GetEntityCoords(entity)
    local distance = #(entityCoords - coords)
    return distance < 10.0
end

utils.notify = function(data)
    if client.interaction == 'ox' then
        TriggerClientEvent('ox_lib:notify', data.source, data)
    elseif client.interaction == 'qb' then
        TriggerClientEvent('QBCore:Notify', data.source, data.description, data.type or 'success', data.length or 5000)
    end
end

return utils