
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "ui/index.html"

files {
    "ui/index.html",
    "ui/vue.min.js",
    "ui/script.js",
    "ui/badge.png",
	"ui/footer.png",
	"ui/mugshot.png"
}

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	"sv_records.lua",
	"sv_vehcolors.lua"
}

client_script "cl_records.lua"


