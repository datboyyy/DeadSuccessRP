resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

ui_page 'html/ui.html'



files {
	'html/ui.html',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/*.png',
}

server_script('server.lua')
server_script('@mysql-async/lib/MySQL.lua')


client_script 'client.lua'



