resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
	-- Base
	'JAM_Main.lua',
	'JAM_Client.lua',
	'JAM_Utilities.lua',
	'JAM_VehicleShop/JAM_VehicleShop_Config.lua',
	'JAM_VehicleShop/JAM_VehicleShop_Client.lua',

}

server_scripts {	
	-- Base
	'JAM_Main.lua',
	'JAM_Server.lua',
	'JAM_Utilities.lua',
	'@mysql-async/lib/MySQL.lua',
	'JAM_VehicleShop/JAM_VehicleShop_Config.lua',
	'JAM_VehicleShop/JAM_VehicleShop_Server.lua',

}

files {	
	-- Safecracker
	--'JAM_SafeCracker/LockPart1.png',
	--'JAM_SafeCracker/LockPart2.png',
}
