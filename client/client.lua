local client = require("configs.client")
local utils = require("utils.client")
local dispatch = require("bridge.dispatch.client")

local function playRobAnimation(ped)
  local animDict = 'missheistfbisetup1'
  local anim = 'hassle_intro_loop_f'
  lib.requestAnimDict(animDict)
  TaskPlayAnim(ped, animDict, anim, 8.0, -8.0, -1, 1, 0.0, false, false, false)
end

local function robMailbox(data)
  if isRobbing then return end
  isRobbing = true

  local ped = PlayerPedId()
  local entity = data.entity
  if not DoesEntityExist(entity) then
    utils.notify({ description = locale('error.mailbox_not_found'), type = 'error' })
    isRobbing = false
    return
  end

  local coords = GetEntityCoords(entity)
  local obj = GetEntityModel(entity)

  lib.callback('mailboxRob:isRobbed', false, function(isRobbed)
    if isRobbed then
      utils.notify({ description = locale('error.just_robbed'), type = 'error' })
      isRobbing = false
      return
    end

    if math.random(100) <= client.policeChance then
      dispatch.sendCall({
        title = locale('dispatch.title'),
        code = locale('dispatch.code'),
        priority = locale('dispatch.priority'),
        message = locale('dispatch.message'),
        coords = coords,
        showLocation = true,
        showDirection = false,
        showGender = true,
      })
    end

    TaskTurnPedToFaceEntity(ped, entity, -1)
    playRobAnimation(ped)

    local success = utils.minigame()

    if success then
      local result = utils.progressBar({
        duration = 10000,
        label = locale('robbing.label'),
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true },
        anim = {
          dict = 'amb@prop_human_bum_bin@idle_a',
          clip = 'idle_a'
        }
      })

      ClearPedTasks(ped)

      if result then
        TriggerServerEvent('mailboxRob:robMailbox', coords, obj)
      else
        utils.notify({ description = locale('robbing.cancelled'), type = 'error' })
      end
    else
      ClearPedTasks(ped)
      utils.notify({ description = locale('robbing.failedlockpick'), type = 'error' })
    end

    isRobbing = false
  end, coords, obj)
end

local function startUtils()
  utils.addModel({
    models = client.mailBoxes,
    options = {
      {
        label = locale('robbing.target_label'),
        icon = 'fa-solid fa-lock',
        items = client.item,
        distance = client.maxDistance,
        onSelect = robMailbox,
      },
    },
  })
end

startUtils()