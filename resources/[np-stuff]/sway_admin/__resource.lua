resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"




client_script "@warmenu/warmenu.lua"

ui_page "html/index.html"

files({
    "html/index.html",
    "html/script.js",
    "html/styles.css"
})

server_script "shared/sh_admin.lua"
server_script "shared/sh_commands.lua"
server_script "shared/sh_ranks.lua"

client_script "shared/sh_admin.lua"

client_script "client/cl_menu.lua"

client_script "shared/sh_commands.lua"
client_script "shared/sh_ranks.lua"

server_script "server/sv_db.lua"
server_script "server/sv_admin.lua"
server_script 'server/sv_shit.lua'
client_script "client/cl_admin.lua"

dependencies {
	'essentialmode',
}


