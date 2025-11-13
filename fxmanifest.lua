fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
author 'L3th'
description 'Mail Box Robbery'
lua54 'yes'

files {
    'configs/*.lua',
    'locales/*.json',
    'utils/*.lua',
    'bridge/**/client.lua',
    'bridge/**/server.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}


ox_libs {
    'math',
    'locale',
}
