local client = require 'configs.cl_config'
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
    success = lib.progressBar({
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
    local QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.Progressbar(
      data.label,
      data.label,
      data.duration,
      false,
      data.canCancel ~= false,
      {
        disableMovement = data.disable and data.disable.move or false,
        disableCarMovement = data.disable and data.disable.car or false,
      },
      data.anim and {
        animDict = data.anim.dict,
        anim = data.anim.clip,
      } or {},
      {},
      {},
      function()
        success = true
        if data.onSuccess then data.onSuccess() end
      end,
      function()
        success = false
        if data.onCancel then data.onCancel() end
      end
    )

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
        items = type(options[i].items) == 'table' and options[i].items or { options[i].items },
        label = options[i].label,
        onSelect = options[i].onSelect,
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
        action = function(entity, distance, data)
          options[i].onSelect({
            entity = entity,
            distance = distance,
            data = data
          })
        end,
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

utils.minigame = function(method)
  if client.minigame == 'sk-minigames' then
    if method == 'crowbar' then
      -- Harder, faster version for crowbar
      return exports["SK-Minigames"]:Start("arrowClicker", {
        arrowCount = 10,
        time = 5000,
        text = locale('robbing.target_label2'),
      })
    else
      -- Default lockpick version
      return exports["SK-Minigames"]:Start("lockpick", {
        holeCount = 4,
        speed = 15,
        skipCountdown = 0
      })
    end

  elseif client.minigame == 'ox' then
    if method == 'crowbar' then
      -- Simpler skillcheck but with tighter timing
      return lib.skillCheck({'medium', 'hard', 'medium'}, {'a','d'})
    else
      -- Standard lockpick sequence
      return lib.skillCheck({'easy', 'medium', 'hard'}, {'w','a','s','d'})
    end

  elseif client.minigame == 'glitch-minigames' then
    if method == 'crowbar' then
      -- Harder, faster version for crowbar
      return exports['glitch-minigames']:StartSurgeOverride( { 'E' }, 30, 3, false)
    else
      -- Default lockpick version
      return exports['glitch-minigames']:StartSurgeOverride( { 'E' }, 20, 2, false)
    end

  elseif client.minigame == 'custom' then
    print('^3No Minigame configured.')
  end
end


return utils