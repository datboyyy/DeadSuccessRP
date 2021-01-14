resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script "@errorlog/client/cl_errorlog.lua"


ui_page('html/index.html') 

files({
  'html/index.html',
  'html/style.css',
})

client_scripts {
  'config.lua',
  'client/main.lua',
}

server_scripts {
  'config.lua',
  'server/main.lua',
  '@mysql-async/lib/MySQL.lua'
}


