fx_version 'bodacious'
games { 'rdr3', 'gta5' }

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/server.lua',
	'server/s_chopshop.lua',
	'server/server_imp.lua'
}

client_script {
	'@es_extended/locale.lua',
	'client/client.lua',
	'client/illegal_parts.lua',
	'client/chopshop.lua',
	'client/client_imp.lua',
	'client/gui.lua'
}

