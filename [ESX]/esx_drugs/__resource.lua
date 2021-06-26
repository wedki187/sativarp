resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Drugs'

version '1.0.2'

server_scripts {
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'server/server.lua',
	'config.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'config.lua',
	'client/client.lua'
}
