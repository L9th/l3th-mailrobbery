local clConfig = require 'configs.cl_config'
local svConfig = require 'configs.sv_config'
local utils = require 'utils.sv_utils'
local inventory = require 'bridge.inventory.server'
local mailCache = {}

local function validObj(obj)
  for _, model in pairs(clConfig.mailBoxes) do
    if GetHashKey(model) == tonumber(obj) then
      return true
    end
  end
  return false
end

local function removeRobbed(coords, obj)
  for k, v in pairs(mailCache) do
    if #(v.coords - coords) < 0.1 and v.obj == obj then
      table.remove(mailCache, k)
      if clConfig.debug then print('^3[Mailbox]^7 Mailbox reset after cooldown!') end
      break
    end
  end
end

local function alreadyRobbed(coords, obj)
  for _, v in pairs(mailCache) do
    if #(v.coords - coords) < 0.1 and v.obj == obj then
      return true
    end
  end
  return false
end

RegisterNetEvent('mailboxRob:robMailbox', function(coords, obj)
  local src = source
  local ped = GetPlayerPed(src)
  local playerCoords = GetEntityCoords(ped)

  if not validObj(obj) then
    if clConfig.debug then print(('[Mailbox] Invalid mailbox object: %s'):format(obj)) end
    return
  end

  if #(playerCoords - coords) > 5.0 then
    utils.notify({
      source = src,
      description = locale('error.too_far_from_mailbox'),
      type = 'error'
    })
    if clConfig.debug then print(('[Mailbox] %s tried to rob too far from mailbox!'):format(GetPlayerName(src))) end
    return
  end

  if alreadyRobbed(coords, obj) then
    utils.notify({ source = src, description = locale('error.just_robbed'), type = 'error' })
    return
  end

  table.insert(mailCache, { coords = coords, obj = obj })

  local function getReward()
    local roll = math.random(1, 100)
    local cumulative = 0
    for _, reward in ipairs(svConfig.Reward) do
      cumulative = cumulative + reward.chance
      if roll <= cumulative then
        return reward
      end
    end
  end

  local reward = getReward()
  if reward and reward.item then
    inventory.addItem(src, reward.item, reward.amount)
  else
    utils.notify({ source = src, description = locale('error.nothing_found'), type = 'info' })
  end

  CreateThread(function()
    Wait(clConfig.resetTime * 1000)
    removeRobbed(coords, obj)
  end)
end)

lib.callback.register('mailboxRob:isRobbed', function(source, coords, obj)
  return alreadyRobbed(coords, obj)
end)