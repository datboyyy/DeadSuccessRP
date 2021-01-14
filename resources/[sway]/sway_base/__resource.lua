resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'
client_script "@errorlog/client/cl_errorlog.lua"



files{
    'weapons.meta'

}



data_file 'WEAPONINFO_FILE_PATCH' 'weapons.meta'



server_scripts{
    'config.lua',
    'server.lua',
    'cheat.lua',
    "log_server.lua",
    '@mysql-async/lib/MySQL.lua',
    "sv_emergencyblips.lua"
}

client_scripts{
    'client.lua',
    'config.lua',
    'ClothesOnOff.lua',
    'recoil.lua',
    'trunk.lua',
    "log_client.lua",
    --"watermark.lua",
    "cl_emergencyblips.lua"
}

export "GetClosestNPC"
export "IsPedNearCoords"
export "isPed"
export "GroupRank"
export "GlobalObject"
export "retreiveBusinesses"



