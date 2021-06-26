
lua54 'yes'
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Show Radar while Driving'		

client_script {										
	'CLIENT/MinimapValues.lua',
	'CLIENT/RadarWhileDriving.lua',
}

exports {
	'DisplayingStreet',
	'getMenuIsOpen',
}









