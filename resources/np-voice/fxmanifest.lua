fx_version "cerulean"

games { "gta5" }

description "Voice System"

ui_page "nui/ui.html"

server_scripts {
    "config.lua",
    "server/modules/*.lua",
    "server/server.lua",
}

client_scripts {
    "config.lua",
    "client/tools/*.lua",
    "client/classes/*.lua",
    "client/modules/*.lua",
    "client/client.lua",
}


if GetConvar("sv_environment", "prod") == "debug" then
    server_script "tests/sv_*.lua"
    client_script "tests/cl_*.lua"
end
