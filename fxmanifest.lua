
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
author 'L3th'
description 'Mail Box Robbery'
lua54 'yes'
game 'gta5'

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

ox_libs {
	'math',
	'locale',
}

server_scripts {
	'server/*.lua',
}

escrow_ignore {
    'bridge/**/*.lua',
    'configs/*.lua',
    'locales/*.json',
    'utils/*.lua',
}
dependency '/assetpacks'