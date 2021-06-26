resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
lua54 'yes'
description 'ESX piekarz'

version '0.0.1'

client_scripts {
  'config.lua',
  'client.lua'
}

server_scripts {
  'config.lua',
  '@mysql-async/lib/MySQL.lua',
  'server.lua'
}









