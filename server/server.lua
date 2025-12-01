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


local resourceName = 'l3th-mailrobbery'
local currentVersion = GetResourceMetadata(resourceName, 'version', 0)

local function checkversion()
  if not currentVersion then
    print("^1[Error]: Unable to determine current resource version for '" ..resourceName.. "'^0")
    return
  end
  SetTimeout(1000, function()
    PerformHttpRequest('https://api.github.com/repos/L9th/' ..resourceName.. '/releases/latest', function(status, response)
      if status ~= 200 then return end
      response = json.decode(response)
      local latestVersion = response.tag_name
      if not latestVersion or latestVersion == currentVersion then return end
      if latestVersion ~= currentVersion then
        print('^3An update is available for ' ..resourceName.. '^0')
        print('^3Your Version: ^1' ..currentVersion.. '^0 | ^3Latest Version: ^2' ..latestVersion.. '^0')
        print('^3Download the latest release from https://github.com/L9th/'..resourceName..'/releases/'..latestVersion..'^0')
        print('^3For more information about this update visit our Discord: https://discord.gg/jK46kHYKxJ^0')
      end
    end, 'GET')
  end)
end

checkversion()