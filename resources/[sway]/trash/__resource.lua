resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script "@errorlog/client/cl_errorlog.lua"


client_script 'cl/cl.lua'
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'sv/sv.lua'
 }


