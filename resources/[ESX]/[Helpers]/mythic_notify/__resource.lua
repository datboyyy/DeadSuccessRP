resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script "@errorlog/client/cl_errorlog.lua"


name 'Mythic Framework Notification System'
author 'Alzar - https://github.com/Alzar'
version 'v1.1.0'

ui_page {
    'html/ui.html',
}

files {
	'html/ui.html',
	'html/js/app.js', 
	'html/css/style.css',
}

client_scripts {
	'client/main.lua',
}

exports {
	'SendAlert',
	'SendUniqueAlert',
	'PersistentAlert',
	'PersistentHudText',
}



