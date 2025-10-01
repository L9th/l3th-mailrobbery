local clConfig = require 'configs.client'
local svConfig = require 'configs.server'
local utils = require 'utils.server'
local inventory = require 'bridge.inventory.server'
local mailCache = {}

local function validObj(obj)
  for _, v in pairs(clConfig.mailBoxes) do
    if tonumber(v) == tonumber(obj) then
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

  if not validObj(obj) then
    if clConfig.debug then print(('[Mailbox] Invalid mailbox object: %s'):format(obj)) end
    return
  end

  if alreadyRobbed(coords, obj) then
    utils.notify({ source = source, description = locale('error.just_robbed'), type = 'error' })
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

    return nil -- fallback
  end

  local selectedReward = getReward()
  if selectedReward and selectedReward.item then
    inventory.addItem(src, selectedReward.item, selectedReward.amount)
  else
    if clConfig.debug then print(('[Mailbox] No reward given to %s'):format(GetPlayerName(src))) end
    utils.notify({ source = source, description = locale('error.nothing_found'), type = 'info' })
  end

  CreateThread(function()
    Wait(clConfig.resetTime * 1000)
    removeRobbed(coords, obj)
  end)
end)

lib.callback.register('mailboxRob:isRobbed', function(source, coords, obj)
  return alreadyRobbed(coords, obj)
end)