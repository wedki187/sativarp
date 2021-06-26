-- szymczakovv#1937 a zostawie od siebie ;p

fx_version 'adamant'
games { 'gta5' }

client_script 'config.lua'
client_script 'client.lua'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}
client_script "api-ac_zrtRohGGKxbK.lua"