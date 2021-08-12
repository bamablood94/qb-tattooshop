fx_version 'cerulean'
games { 'gta5' }

shared_script '@qb-core/import.lua'

client_scripts {
	'client/jaymenu.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'server/main.lua'
}

file 'AllTattoos.json'