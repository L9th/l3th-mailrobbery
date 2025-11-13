return {
  debug = true, -- Enable debug messages in the server console and F8 console
  interaction = 'ox', -- 'ox', 'qb' or make your own. ;) (Target, Progressbar and notify)
  minigame = 'sk-minigames', -- 'sk-minigames', 'ox', 'bl_ui' or make your own. ;)
  dispatch = 'tk_dispatch',  -- 'none', 'tk_dispatch', 'ps-dispatch', 'cd_dispatch', 'fd-dispatch' or make your own. ;)

  item = 'lockpick', -- Item required to rob mailbox / To see the target on mailbox
  item2 = 'WEAPON_CROWBAR', -- Item required to rob mailbox / To see the target on mailbox

  duration = 10000, -- Duration (in ms) to rob mailbox with lockpick
  duration2 = 8000, -- Duration (in ms) to rob mailbox with crowbar

  mailBoxes = {
    'prop_postbox_ss_01a',
    'prop_postbox_01a',
    'prop_letterbox_01',
    'prop_letterbox_02',
    'prop_letterbox_03',
    'prop_letterbox_04'
  },

  maxDistance = 1.4, -- Max distance to rob mailbox

  policeChance = 20, -- Chance to call the police (in percentage)
  policeChanceAdded = 25, -- Extra chance if using crowbar (in percentage)

  resetTime = 1800000 -- Time (in seconds) until a mailbox can be robbed again
}