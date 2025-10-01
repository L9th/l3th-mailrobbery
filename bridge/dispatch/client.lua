local client = require 'configs.client'
local dispatch = {}

dispatch.sendCall = function(data)
  if client.dispatch == 'tk_dispatch' then
    exports.tk_dispatch:addCall({
      title = data.title or "Suspicious activity",
      code = data.code or "10-34",
      priority = data.priority or "Priority 3",
      message = data.message or "A person is seen robbing a mail box!",
      coords = data.coords or GetEntityCoords(PlayerPedId()),
      showLocation = true,
      showDirection = false,
      showGender = true,
      showVehicle = false,
      platePercentage = 50,
      showWeapon = false,
      takePhoto = false,
      removeTime = 1000 * 60 * 5,
      showTime = 10000,
      blip = {
        color = 1,
        sprite = 161,
        scale = 1.2,
        radius = 40.0,
        flash = false,
      },
      radius = {
        enabled = true,
        color = 3,
        scale = 25.0,
      },
      jobs = { "police", "sheriff" },
      playSound = true,
    })

  elseif client.dispatch == 'ps-dispatch' then
    exports['ps-dispatch']:SuspiciousActivity()

  elseif client.dispatch == 'cd_dispatch' then
    local playerInfo = exports['cd_dispatch']:GetPlayerInfo()
    TriggerServerEvent('cd_dispatch:AddNotification', {
      job_table = { 'police' },
      coords = data.coords or GetEntityCoords(PlayerPedId()),
      title = data.title or '10-34 - Suspicious Activity',
      message = 'A ' .. playerInfo.sex .. ' robbing a mailbox at ' .. playerInfo.street,
      flash = 0,
      unique_id = playerInfo.unique_id,
      sound = 1,
      blip = {
        sprite = 161,
        scale = 1.2,
        colour = 1,
        flashes = false,
        text = data.title or '911 - Suspicious Activity',
        time = 5,
        radius = 0,
      }
    })

  elseif client.dispatch == 'fd-dispatch' then
    local alertData = {
      title = locale('dispatch.title'),
      description = locale('dispatch.message'),
      blip = {
        sprite = 161,
        color = 1,
        scale = 1.2,
        time = 15 * 1000
      },
      groups = { 'police' },
      priority = 2,
      code = data.code or '10-34',
      location = data.coords or GetEntityCoords(PlayerPedId()),
      isShooting = true
    }

    TriggerServerEvent('fd_dispatch:events:addAlert', alertData)
  end
end

return dispatch