resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script 'cl_spawn.lua'
server_script '@mysql-async/lib/MySQL.lua'
server_script 'sv_spawn.lua'

ui_page 'ui/index.html'

files{
    "ui/index.html",
    "ui/main.js",
    "ui/style.css",
    "ui/bg.png",
    "ui/gpsping.png",
    "ui/all.min.css"
}