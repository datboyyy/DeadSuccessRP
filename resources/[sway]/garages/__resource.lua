resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
-- What to run
client_scripts {
    'client.lua',
    'gui.lua'
}
server_scripts {
    "@mysql-async/lib/MySQL.lua",
    'server.lua',
    'gui.lua'
}

-- Extra data can be used as well
my_data 'one' { two = 42 }
my_data 'three' { four = 69 }

-- due to Lua syntax, the following works too:
my_data('nine')({ninety = "nein"})
