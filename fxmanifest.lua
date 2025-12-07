fx_version 'cerulean'
games { 'gta5' }

lua54 'yes'

shared_script '@ox_lib/init.lua'

escrow_ignore {
	'config.lua',
	'client.lua',
}

client_scripts {
	'config.lua',
	'client.lua'
}

server_scripts {
	'server.lua'
}
