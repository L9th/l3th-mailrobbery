return {
  debug = false, -- Enable debug messages in the server console and F8 console
  minigame = 'ox', -- 'sk-minigames', 'ox' or make your own. ;)
  interaction = 'ox', -- 'ox', 'qb' or make your own. ;) (Target, Progressbar and notify)
  dispatch = 'tk_dispatch', -- 'tk_dispatch' or make you own. ;)

  item = 'lockpick', -- Item required to rob mailbox / To see the target on mailbox

  mailBoxes = {
    `prop_postbox_ss_01a`,
    `prop_postbox_01a`,
    `prop_letterbox_01`,
    `prop_letterbox_02`,
    `prop_letterbox_03`,
    `prop_letterbox_04`
  },

  maxDistance = 1.4, -- Max distance to rob mailbox

  policeChance = 20, -- Chance to call the police (in percentage)

  resetTime = 1800000 -- Time (in seconds) until a mailbox can be robbed again
}