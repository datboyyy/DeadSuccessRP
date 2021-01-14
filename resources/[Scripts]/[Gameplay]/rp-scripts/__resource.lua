-- https://wiki.fivem.net/wiki/Resource_manifest

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script "@errorlog/client/cl_errorlog.lua"


description 'An series of scripts'

version '1.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	--'server/afkkick-server.lua',
	'server/discordbot_server.lua',
	'server/gpstools-server.lua',
	'server/commands-server.lua',
	'server/generic_messages-server.lua'
	--'server/restart_alert-server.lua'
	--'server/check_name-server.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'client/fixtraffic-client.lua',
	'client/pointfinger-client.lua',
	--'client/no_drive_by-client.lua',
	--'client/afkkick-client.lua',
	'client/handsup-client.lua',
	'client/gpstools-client.lua',
	'client/commands-client.lua',
	'client/no_vehicle_rewards-client.lua',

}







