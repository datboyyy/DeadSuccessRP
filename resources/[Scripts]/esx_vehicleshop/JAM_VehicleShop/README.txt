https://www.ModFreakz.net
https://discord.gg/ukgQa5K

JAM_VehicleShop : Installation Instructions

----------------
-- JAM Folder --
----------------
1. Download JAM_Base : www.github.com/justanothermodder/jam_base
  -- Make sure you're using the latest update!
2. Download JAM_VehicleShop
3. Place JAM_VehicleShop folder inside of JAM_Base folder (resources/JAM/JAM_VehicleShop)
4. Add to JAM/__resource.lua:
    client_scripts { 
	'JAM_VehicleShop/JAM_VehicleShop_Config.lua',
	'JAM_VehicleShop/JAM_VehicleShop_Client.lua',
    }    

    server_scripts { 
	'JAM_VehicleShop/JAM_VehicleShop_Config.lua',
	'JAM_VehicleShop/JAM_VehicleShop_Server.lua',
    }
5. Add to server.cfg: 
    start JAM

----------------
--  Database  --
----------------
Database
Any custom cars you want to display on the showroom floor, place them in the vehicles table with inshop
set to 0 and place them in either the importbikes or importcars categories, respectively.
A bunch of supercars have been added to the importcars and a few standard bikes to the importbikes, just so you can
load the mod immediately. Once you substitute these for custom cars, consider placing them back in-store by
setting their "inshop" value to 1 (in the `vehicles` database table) and setting them back into their respective category.