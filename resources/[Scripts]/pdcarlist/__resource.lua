resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
ui_page "html/ui.html"
files {
  "html/ui.html",
  "html/style.css",
}
  client_scripts {
    '@PolyZone/client.lua',
    'config.lua',
    'cl.lua'
}

server_script {
  'sv.lua'
}