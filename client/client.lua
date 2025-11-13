local client = require("configs.cl_config")
local utils = require("utils.cl_utils")
local dispatch = require("bridge.dispatch.client")

local function playParticleEffect(entity, effectName, assetName, scale)
  if not HasNamedPtfxAssetLoaded(assetName) then
    lib.requestNamedPtfxAsset(assetName)
    while not HasNamedPtfxAssetLoaded(assetName) do
      Wait(0)
    end
  end

  UseParticleFxAssetNextCall(assetName)
  lib.removeNamedPtfxAsset(assetName)
  StartParticleFxNonLoopedOnEntity(effectName, entity, 0.0, 0.0, 0.5, 0.0, 0.0, 0.0, scale, false, false, false)
end

local function playLockpickAnim(ped)
  local animDict = 'missheistfbisetup1'
  local anim = 'hassle_intro_loop_f'
  lib.requestAnimDict(animDict)
  TaskPlayAnim(ped, animDict, anim, 8.0, -8.0, -1, 1, 0.0, false, false, false)
end

local function playCrowbarAnim(ped)
  local animDict = 'random@mugging4'
  local anim = 'struggle_loop_b_thief'

  lib.requestAnimDict(animDict)
  TaskPlayAnim(ped, animDict, anim, 4.0, -4.0, -1, 1+32, 0.0, false, false, false)

  local crowbarHash = GetHashKey(client.item2)
  lib.requestWeaponAsset(crowbarHash, 31)
  while not HasWeaponAssetLoaded(crowbarHash) do
    Wait(10)
  end

  GiveWeaponToPed(ped, crowbarHash, 1, false, true)
  SetCurrentPedWeapon(ped, crowbarHash, true)
  RemoveWeaponAsset(crowbarHash)
end

local function robMailbox(data, method)
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

    if math.random(100) <= (method == 'crowbar' and client.policeChance + client.policeChanceAdded or client.policeChance) then
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

    if method == 'lockpick' then
      playLockpickAnim(ped)
    else
      playCrowbarAnim(ped)
    end

    local success = utils.minigame(method)

    if success then

      if method == 'crowbar' then
        playParticleEffect(entity, 'ent_sht_paper_bails', 'core', 3.0)
      end

      local result = utils.progressBar({
        duration = (method == 'crowbar' and client.duration2 or client.duration),
        label = locale('robbing.label'),
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true },
        anim = {
          dict = 'oddjobs@shop_robbery@rob_till',
          clip = 'loop',
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
      utils.notify({
        description = (method == 'crowbar' and locale('robbing.failedbreak') or locale('robbing.failedlockpick')),
        type = 'error'
      })
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
        onSelect = function(data)
          robMailbox(data, 'lockpick')
        end,
      },
      {
        label = locale('robbing.target_label2'),
        icon = 'fa-solid fa-lock',
        items = client.item2,
        distance = client.maxDistance,
        onSelect = function(data)
          robMailbox(data, 'crowbar')
        end,
        canInteract = function(entity, distance, coords, name)
          local ped = PlayerPedId()
          local weapon = GetSelectedPedWeapon(ped)
          local requiredWeapon = joaat(client.item2)
          return weapon == requiredWeapon
        end
      },
    },
  })
end

startUtils()
