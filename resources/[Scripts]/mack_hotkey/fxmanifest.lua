fx_version 'adamant'
games { 'rdr3', 'gta5' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Mackgame4'
description 'A standalone custom hotkey resource to FiveM by Mackgame4'
version '1.0.0'

ui_page {
    'html/ui.html'
}

files {
	'html/ui.html',
	'html/js/app.js', 
	'html/css/style.css'
}

client_scripts {
	'client/main.lua'
}

exports {
	'SendHotKey',
	'ExitHotKey'
}