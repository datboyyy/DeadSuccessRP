resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'


ui_page 'nui/ui.html'

files {
	'nui/ui.html',
	'nui/pricedown.ttf',
	'nui/default.png',
	'nui/background.png',
	'nui/invbg.png',
	'nui/styles.css',
	'nui/scripts.js',
	'nui/debounce.min.js',
	'nui/loading.gif',
	'nui/loading.svg',
	'nui/icons/*',
}
client_script '@PolyZone/client.lua'
shared_script 'shared_list.js'
client_script 'client.js'
client_script 'functions.lua'
server_script 'server.js'
server_script 'sv_functions.lua'


exports{
	'hasEnoughOfItem',
	'getQuantity',
	'GetCurrentWeapons',
	'GetItemInfo'
}

