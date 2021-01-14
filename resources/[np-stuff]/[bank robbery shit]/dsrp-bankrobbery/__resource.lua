--sydres & sway
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'


client_script "@errorlog/client/cl_errorlog.lua"

ui_page "html/index.html"

client_scripts {
    'client/fleeca.lua',
    'client/pacific.lua',
    'client/powerstation.lua',
    'client/doors.lua',
    'config.lua',
}

server_scripts {
    'server/main.lua',
    'config.lua',
}

files {
    'html/*',
}

