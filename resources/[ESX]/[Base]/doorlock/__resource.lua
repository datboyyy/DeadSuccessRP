resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script "@errorlog/client/cl_errorlog.lua"
client_script '@PolyZone/client.lua'

description 'ESX Door Lock'

version '1.4.0'

server_scripts {
	'@es_extended/locale.lua',
	'server/*.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client/*.lua'
}


