
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script "@errorlog/client/cl_errorlog.lua"


ui_page "nui/radar.html"

files {
	"nui/digital-7.regular.ttf", 
	"nui/radar.html",
	"nui/radar.css",
	"nui/radar.js"
}

client_script 'cl_radar.lua'

