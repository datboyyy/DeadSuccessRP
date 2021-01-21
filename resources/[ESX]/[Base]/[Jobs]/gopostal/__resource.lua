resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script "@errorlog/client/cl_errorlog.lua"


description 'ESX Go Postal Job script |'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/sv.lua'
}

client_scripts {
	'@PolyZone/client.lua',
	'client/base.lua',
	'client/cl.lua'
}

dependencies {
	'es_extended'
}


