local client = require 'configs.client'
local utils = {}

utils.notify = function(data)
    if client.interaction == 'ox' then
        lib.notify({
            title = data.title or '',
            description = data.description or '',
            type = data.type or 'info',
            position = data.position or 'bottom',
            duration = data.duration or 3000,
        })
    elseif client.interaction == 'qb' then
        TriggerEvent('QBCore:Notify', data.description or '', data.type or 'primary', data.duration or 3000)
    end
end

utils.progressBar = function(data)
    local success

    if client.interaction == 'ox' then
        success = lib.progressCircle({
            duration = data.duration,
            position = 'bottom',
            label = data.label,
            useWhileDead = false,
            canCancel = data.canCancel ~= false,
            disable = data.disable,
            anim = data.anim,
            prop = data.prop,
        })

    elseif client.interaction == 'qb' then
        exports['qb-core']:Progressbar(data.label, data.label, data.duration, false, data.canCancel ~= false, {
            disableMovement = data.disable and data.disable.move or false,
            disableCarMovement = data.disable and data.disable.car or false,
        }, {
            animDict = data.anim and data.anim.dict,
            anim = data.anim and data.anim.clip,
        }, {}, {}, function()
            success = true
            if data.onSuccess then data.onSuccess() end
        end, function()
            success = false
            if data.onCancel then data.onCancel() end
        end)

        return
    end

    if success then
        if data.onSuccess then data.onSuccess() end
        return true
    else
        if data.onCancel then data.onCancel() end
        return false
    end
end


utils.getTargetOptions = function(options)
    local targetOptions = {}

    if client.interaction == 'ox' then
        for i = 1, #options do
            targetOptions[i] = {
                icon = options[i].icon,
                item = options[i].items,
                label = options[i].label,
                onSelect = options[i].onSelect, -- ox supports this
                canInteract = options[i].canInteract,
                distance = options[i].distance or 2.0,
            }
        end

    elseif client.interaction == 'qb' then
        for i = 1, #options do
            targetOptions[i] = {
                icon = options[i].icon,
                item = options[i].items,
                label = options[i].label,
                action = options[i].onSelect, -- qb expects action/event instead
                canInteract = options[i].canInteract,
                distance = options[i].distance or 2.0,
            }
        end
    end

    return targetOptions
end

utils.addModel = function(data)
    if client.interaction == 'ox' then
        exports.ox_target:addModel(data.models, utils.getTargetOptions(data.options))
    elseif client.interaction == 'qb' then
        exports['qb-target']:AddTargetModel(data.models, {
            options = utils.getTargetOptions(data.options),
            distance = client.maxDistance or 2.0,
        })
    end
end

utils.minigame = function()
    if client.minigame == 'sk-minigames' then
        return exports["SK-Minigames"]:Start("lockpick", {
            holeCount = 4,
            speed = 15,
            skipCountdown = 0
        })
    elseif client.minigame == 'ox' then
        return lib.skillCheck({'easy', 'medium', 'hard'}, {'w','a','s','d'})
    end
end

return utils