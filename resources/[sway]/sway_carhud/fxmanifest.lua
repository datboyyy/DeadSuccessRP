fx_version 'adamant'
games { 'gta5' }

ui_page 'html/ui.html'

files {
	'html/*',
}

client_script 'client.lua'
server_script 'server.lua'

exports {
	'SetFuel',
	'GetFuel'
}



