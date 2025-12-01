fx_version 'cerulean'
lua54 'yes'
game 'gta5'
use_experimental_fxv2_oal 'yes'
author 'L3th'
version 'v1.0.1'
repository 'https://github.com/L9th/l3th-mailrobbery'
description 'Mail Box Robbery'

files {
    'configs/*.lua',
    'locales/*.json',
    'utils/*.lua',
    'bridge/**/client.lua',
    'bridge/**/server.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    '@lation_ui/init.lua',
}

ox_libs {
	'math',
	'locale',
}

client_scripts {
	'client/*.lua',
}

server_scripts {
	'server/*.lua',
}