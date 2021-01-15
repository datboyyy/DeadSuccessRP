ESX = nil
Citizen.CreateThread(function()
    while true do
        Wait(5)
        if ESX ~= nil then
            
            else
            ESX = nil
            TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        end
    end
end)

local isJudge = false
local isPolice = false
local isMedic = false
local isDoctor = false
local isNews = false
local isInstructorMode = false
local myJob = "unemployed"
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}

rootMenuConfig = {
    {
        id = "general",
        displayName = "General",
        icon = "#globe-europe",
        enableMenu = function()
            fuck = exports["ambulancejob"]:GetDeath()
            return not fuck
        end,
        subMenus = {"general:flipvehicle",  "general:keysgive", "general:apartgivekey", "general:aparttakekey", "general:housekey", "general:removehousekey"}
    },
    {
        id = "police-action",
        displayName = "Police Actions",
        icon = "#police-action",
        enableMenu = function()
            local ped = PlayerPedId()
            PlayerData = ESX.GetPlayerData()
            fuck = exports["ambulancejob"]:GetDeath()
            if PlayerData.job.name == "police" and not fuck then
                return true
            end
        end,
        subMenus = {"cuffs:cuff", "cuffs:softcuff", "cuffs:uncuff", "police:escort", "police:putinvehicle", "police:unseatnearest", --[[ "cuffs:remmask",  "police:frisk", ]] --[[ "police:removeweapons" ]] "police:revive", "police:gsr", "police:openmdt", "police:getid", "police:impound", "police:spikes"}
    },
    
    {
        id = "veh-list",
        displayName = "Vehicle List",
        icon = "#general-keys-give",
        functionName = "govcarlist",
        enableMenu = function()
            local pdgarage = PolyZone:Create({
                    --Name: PD Garage | 2020-12-11T08:14:17Z
                    vector2(459.05844116211, -1026.9284667969),
                    vector2(411.14721679688, -1033.1063232422),
                    vector2(411.07965087891, -1018.5704956055),
                    vector2(427.30352783203, -1017.8433837891),
                    vector2(427.80291748047, -1011.6103515625),
                    vector2(429.04846191406, -1006.1866455078),
                    vector2(438.98165893555, -1006.1931152344),
                    vector2(444.93954467773, -1006.2022705078),
                    vector2(454.86288452148, -1006.2206420898),
                    vector2(459.02944946289, -1006.9439697266)
            }, {
                name = "PD Garage",
                minZ = 27.338989257813,
                maxZ = 34.40362739563,
                debugGrid = false,
                gridDivisions = 30
            })
            local ped = PlayerPedId()
            local coord = GetEntityCoords(ped)
            PlayerData = ESX.GetPlayerData()
            pdgaragein = pdgarage:isPointInside(coord)
            fuck = exports["ambulancejob"]:GetDeath()
            if not fuck and pdgaragein == true and PlayerData.job.name == "police" then
                return true
            end
        end,
    },
    {
        id = "veh-listt",
        displayName = "Vehicle List",
        icon = "#general-keys-give",
        functionName = "govcarlist",
        enableMenu = function()
            local emsgarage = PolyZone:Create({
                vector2(301.9016418457, -603.13061523438),
                vector2(296.80221557617, -618.150390625),
                vector2(281.29574584961, -615.21624755859),
                vector2(293.74243164063, -598.75592041016)
            }, {
                name = "ambulancearea",
                minZ = 40.301704406738,
                maxZ = 45.450912475586,
                debugGrid = false,
                gridDivisions = 30
            })
            local ped = PlayerPedId()
            local coord = GetEntityCoords(ped)
            PlayerData = ESX.GetPlayerData()
            ambulancearea = emsgarage:isPointInside(coord)
            fuck = exports["ambulancejob"]:GetDeath()
            if not fuck and ambulancearea == true and PlayerData.job.name == 'ambulance' then
                return true
            end
        end,
    },
    {
        id = "mdt",
        displayName = "MDT",
        icon = "#police-check",
        functionName = "execmdt",
        enableMenu = function()
            PlayerData = ESX.GetPlayerData()
            fuck = exports["ambulancejob"]:GetDeath()
            if not fuck and PlayerData.job.name == 'police' then
                return true
            end
        end,
    },
    
    --[[{
        id = "blips",
        displayName = "Blips",
        icon = "#blips",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return not isDead
        end,
        subMenus = {"blips:gasstations", "blips:trainstations", "blips:garages", "blips:barbershop", "blips:tattooshop"}
    },]]--
    {
        id = "police-vehicle",
        displayName = "Police Vehicle",
        icon = "#police-vehicle",
        enableMenu = function()
            local ped = PlayerPedId()
            PlayerData = ESX.GetPlayerData()
            fuck = exports["ambulancejob"]:GetDeath()
            if PlayerData.job.name == "police" and not fuck and IsPedInAnyVehicle(PlayerPedId(), false) then
                return true
            end
        end,
        subMenus = {--[[ "general:unseatnearest", ]] "police:runplate", --[[ "police:toggleradar" ]]}
    },
    
    {
        id = "policeDead",
        displayName = "10-13",
        icon = "#police-dead",
        functionName = "tp:panicTrigger",
        enableMenu = function()
            local ped = PlayerPedId()
            PlayerData = ESX.GetPlayerData()
            fuck = exports["ambulancejob"]:GetDeath()
            if PlayerData.job.name == "police" and fuck then
                return true
            end
        end,
    },
    {
        id = "emsDead",
        displayName = "10-14",
        icon = "#ems-dead",
        functionName = "tp:panicTriggerMedic",
        enableMenu = function()
            local ped = PlayerPedId()
            PlayerData = ESX.GetPlayerData()
            fuck = exports["ambulancejob"]:GetDeath()
            if PlayerData.job.name == "ambulance" and fuck then
                return true
            end
        end,
    },
    {
        id = "animations",
        displayName = "Walking Styles",
        icon = "#walking",
        enableMenu = function()
            fuck = exports["ambulancejob"]:GetDeath()
            return not fuck
        end,
        subMenus = {"animations:brave", "animations:hurry", "animations:business", "animations:tipsy", "animations:injured", "animations:tough", "animations:default", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:maneater", "animations:chichi", "animations:sassy", "animations:sad", "animations:posh", "animations:alien",
            
            --new
            "animations:arrogant", "animations:casual", "animations:casual2", "animations:casual3", "animations:casual4", "animations:casual5", "animations:casual6", "animations:confident", "animations:business2", "animations:business3", "animations:femme", "animations:flee", "animations:gangster", "animations:gangster2", "animations:gangster3", "animations:gangster4", "animations:gangster5", "animations:heels", "animations:heels2", "animations:muscle", "animations:quick", "animations:wide", "animations:scared", }
    },
    {
        id = "expressions",
        displayName = "Expressions",
        icon = "#expressions",
        enableMenu = function()
            fuck = exports["ambulancejob"]:GetDeath()
            return not fuck
        end,
        subMenus = {"expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
    },
    {
        id = "judge-raid",
        displayName = "Judge Raid",
        icon = "#judge-raid",
        enableMenu = function()
            return (not isDead and isJudge)
        end,
        subMenus = {"judge-raid:checkowner", "judge-raid:seizeall", "judge-raid:takecash", "judge-raid:takedm"}
    },
    {
        id = "judge-licenses",
        displayName = "Judge Licenses",
        icon = "#judge-licenses",
        enableMenu = function()
            return (not isDead and isJudge)
        end,
        subMenus = {"police:checklicenses", "judge:grantDriver", "judge:grantBusiness", "judge:grantWeapon", "judge:grantHouse", "judge:grantBar", "judge:grantDA", "judge:removeDriver", "judge:removeBusiness", "judge:removeWeapon", "judge:removeHouse", "judge:removeBar", "judge:removeDA", "judge:denyWeapon", "judge:denyDriver", "judge:denyBusiness", "judge:denyHouse"}
    },
    --[[     {
    id = "judge-actions",
    displayName = "Judge Actions",
    icon = "#judge-actions",
    enableMenu = function()
    return (not isDead and isJudge)
    end,
    subMenus = { "police:cuff", "cuffs:uncuff", "general:escort", "police:frisk", "cuffs:checkinventory", "police:checkbank"}
    }, ]]
    -- (exports["dsrp-inventory"]:hasEnoughOfItem("cuffs",1,false))
    {
        id = "cuff",
        displayName = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "civ:cuffFromMenu",
        enableMenu = function()
            fuck = exports["ambulancejob"]:GetDeath()
            return not fuck and (exports["dsrp-inventory"]:hasEnoughOfItem("cuffs", 1, false))
        end,
        subMenus = {"cuffs:softcuff", "cuffs:uncuff", "police:escort", "police:unseatnearest", "police:putinvehicle"}
    },
    {
        id = "judge-actions",
        displayName = "Mechanic Actions",
        icon = "#police-vehicle",
        enableMenu = function()
            local ped = PlayerPedId()
            PlayerData = ESX.GetPlayerData()
            fuck = exports["ambulancejob"]:GetDeath()
            if PlayerData.job.name == "mechanic" and not fuck then
                return true
            end
        end,
        subMenus = {"mechanic:hijack", "mechanic:repair", "mechanic:clean", "mechanic:impound"}
    },
    {
        id = "medic",
        displayName = "Medical",
        icon = "#medic",
        enableMenu = function()
            local ped = PlayerPedId()
            PlayerData = ESX.GetPlayerData()
            fuck = exports["ambulancejob"]:GetDeath()
            if PlayerData.job.name == "ambulance" and not fuck then
                return true
            end
        end,
        subMenus = {"medic:revive", "medic:heal", "medic:bigheal", "medic:drag", "medic:undrag", "medic:putinvehicle", "medic:takeoutvehicle", }
    },
    {
        id = "doctor",
        displayName = "Doctor",
        icon = "#doctor",
        enableMenu = function()
            return (not isDead and isDoctor)
        end,
        subMenus = {"general:escort", "medic:revive", "general:checktargetstates", "medic:heal"}
    },
    {
        id = "news",
        displayName = "News",
        icon = "#news",
        enableMenu = function()
            return (not isDead and isNews)
        end,
        subMenus = {"news:setCamera", "news:setMicrophone", "news:setBoom"}
    },
    {
        id = "vehicle",
        displayName = "Vehicle",
        icon = "#vehicle-options-vehicle",
        functionName = "veh:options",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
        end
    },
    {
        id = "impound",
        displayName = "Impound Vehicle",
        icon = "#impound-vehicle",
        functionName = "impoundVehicle",
        enableMenu = function()
            fuck = exports["ambulancejob"]:GetDeath()
            if not fuck and myJob == "towtruck" and #(GetEntityCoords(PlayerPedId()) - vector3(549.47796630859, -55.197559356689, 71.069190979004)) < 10.599 then
                return true
            end
            return false
        end
    }, {
        id = "oxygentank",
        displayName = "Remove Oxygen Tank",
        icon = "#oxygen-mask",
        functionName = "RemoveOxyTank",
        enableMenu = function()
            fuck = exports["ambulancejob"]:GetDeath()
            return not fuck and hasOxygenTankOn
        end
    }, {
        id = "cocaine-status",
        displayName = "Request Status",
        icon = "#cocaine-status",
        functionName = "cocaine:currentStatusServer",
        enableMenu = function()
            fuck = exports["ambulancejob"]:GetDeath()
            if not fuck and gangNum == 2 and #(GetEntityCoords(PlayerPedId()) - vector3(1087.3937988281, -3194.2138671875, -38.993473052979)) < 0.5 then
                return true
            end
            return false
        end
    }, {
        id = "cocaine-crate",
        displayName = "Remove Crate",
        icon = "#cocaine-crate",
        functionName = "cocaine:methCrate",
        enableMenu = function()
            fuck = exports["ambulancejob"]:GetDeath()
            if not fuck and gangNum == 2 and #(GetEntityCoords(PlayerPedId()) - vector3(1087.3937988281, -3194.2138671875, -38.993473052979)) < 0.5 then
                return true
            end
            return false
        end
    }
}

newSubMenus = {

    ['general:keysgive'] = {
        title = "Give Key",
        icon = "#general-keys-give",
        functionName = "vehkey"
    },
    ['general:apartgivekey'] = {
        title = "Place Speaker",
        icon = "#speaker",
        functionName = "kepo_speaker:place"
    },
    ['general:aparttakekey'] = {
        title = "Carry",
        icon = "#general-escort",
        functionName = "carrytrigger"
    },
    ['general:housekey'] = {
        title = "Give House Key",
        icon = "#housekey",
        functionName = "cash-playerhousing:client:giveHouseKey"
    },
    ['general:removehousekey'] = {
        title = "Remove House Key",
        icon = "#housekey",
        functionName = "cash-playerhousing:client:removeHouseKey"
    },
    --[[     ['general:checkoverself'] = {
    title = "Examine Self",
    icon = "#general-check-over-self",
    functionName = "Evidence:CurrentDamageList"
    },
    ['general:checktargetstates'] = {
    title = "Examine Target",
    icon = "#general-check-over-target",
    functionName = "requestWounds"
    }, ]]
    --[[     ['general:checkvehicle'] = {
    title = "Examine Vehicle",
    icon = "#general-check-vehicle",
    functionName = "towgarage:annoyedBouce"
    }, ]]
    ['general:putinvehicle'] = {
        title = "Seat Vehicle",
        icon = "#general-put-in-veh",
        functionName = "police:forceEnter"
    },
    ['general:unseatnearest'] = {
        title = "Unseat Nearest",
        icon = "#general-unseat-nearest",
        functionName = "unseatPlayer"
    },
    ['general:flipvehicle'] = {
        title = "Flip Vehicle",
        icon = "#general-flip-vehicle",
        functionName = "FlipVehicle"
    },
    ['animations:brave'] = {
        title = "Brave",
        icon = "#animation-brave",
        functionName = "AnimSet:Brave"
    },
    ['animations:hurry'] = {
        title = "Hurry",
        icon = "#animation-hurry",
        functionName = "AnimSet:Hurry"
    },
    ['animations:business'] = {
        title = "Business",
        icon = "#animation-business",
        functionName = "AnimSet:Business"
    },
    ['animations:tipsy'] = {
        title = "Tipsy",
        icon = "#animation-tipsy",
        functionName = "AnimSet:Tipsy"
    },
    ['animations:injured'] = {
        title = "Injured",
        icon = "#animation-injured",
        functionName = "AnimSet:Injured"
    },
    ['animations:tough'] = {
        title = "Tough",
        icon = "#animation-tough",
        functionName = "AnimSet:ToughGuy"
    },
    ['animations:sassy'] = {
        title = "Sassy",
        icon = "#animation-sassy",
        functionName = "AnimSet:Sassy"
    },
    ['animations:sad'] = {
        title = "Sad",
        icon = "#animation-sad",
        functionName = "AnimSet:Sad"
    },
    ['animations:posh'] = {
        title = "Posh",
        icon = "#animation-posh",
        functionName = "AnimSet:Posh"
    },
    ['animations:alien'] = {
        title = "Alien",
        icon = "#animation-alien",
        functionName = "AnimSet:Alien"
    },
    ['animations:nonchalant'] =
    {
        title = "Nonchalant",
        icon = "#animation-nonchalant",
        functionName = "AnimSet:NonChalant"
    },
    ['animations:hobo'] = {
        title = "Hobo",
        icon = "#animation-hobo",
        functionName = "AnimSet:Hobo"
    },
    ['animations:money'] = {
        title = "Money",
        icon = "#animation-money",
        functionName = "AnimSet:Money"
    },
    ['animations:swagger'] = {
        title = "Swagger",
        icon = "#animation-swagger",
        functionName = "AnimSet:Swagger"
    },
    ['animations:shady'] = {
        title = "Shady",
        icon = "#animation-shady",
        functionName = "AnimSet:Shady"
    },
    ['animations:maneater'] = {
        title = "Man Eater",
        icon = "#animation-maneater",
        functionName = "AnimSet:ManEater"
    },
    ['animations:chichi'] = {
        title = "ChiChi",
        icon = "#animation-chichi",
        functionName = "AnimSet:ChiChi"
    },
    
   --[[ ['blips:gasstations'] = {
        title = "Gas Stations",
        icon = "#blips-gasstations",
        functionName = "CarPlayerHud:ToggleGas"
    },
    ['blips:trainstations'] = {
        title = "Train Stations",
        icon = "#blips-trainstations",
        functionName = "Trains:ToggleTainsBlip"
    },
    ['blips:garages'] = {
        title = "Garages",
        icon = "#blips-garages",
        functionName = "Garages:ToggleGarageBlip"
    },
    ['blips:barbershop'] = {
        title = "Barber Shop",
        icon = "#blips-barbershop",
        functionName = "hairDresser:ToggleHair"
    },
    ['blips:tattooshop'] = {
        title = "Tattoo Shop",
        icon = "#blips-tattooshop",
        functionName = "tattoo:ToggleTattoo"
    },]]--
    ['animations:default'] = {
        title = "Default",
        icon = "#animation-default",
        functionName = "AnimSet:default"
    },
    ['mechanic:hijack'] = {
        title = "Lockpick",
        icon = "#impound-vehicle",
        functionName = "lockpickveh"
    },
    ['mechanic:repair'] = {
        title = "Repair",
        icon = "#fix-car",
        functionName = "fixveh"
    },
    ['mechanic:clean'] = {
        title = "Clean",
        icon = "#cleancar",
        functionName = "cleanveh"
    },
    ['mechanic:impound'] = {
        title = "Impound",
        icon = "#police-vehicle",
        functionName = "tp:menuimpound"
    },
    ['k9:spawn'] = {
        title = "Summon",
        icon = "#k9-spawn",
        functionName = "K9:Create"
    },
    ['k9:delete'] = {
        title = "Dismiss",
        icon = "#k9-dismiss",
        functionName = "K9:Delete"
    },
    ['k9:follow'] = {
        title = "Follow",
        icon = "#k9-follow",
        functionName = "K9:Follow"
    },
    ['k9:vehicle'] = {
        title = "Get in/out",
        icon = "#k9-vehicle",
        functionName = "K9:Vehicle"
    },
    ['k9:sit'] = {
        title = "Sit",
        icon = "#k9-sit",
        functionName = "K9:Sit"
    },
    ['k9:lay'] = {
        title = "Lay",
        icon = "#k9-lay",
        functionName = "K9:Lay"
    },
    ['k9:stand'] = {
        title = "Stand",
        icon = "#k9-stand",
        functionName = "K9:Stand"
    },
    ['k9:sniff'] = {
        title = "Sniff Person",
        icon = "#k9-sniff",
        functionName = "tp:k9drugsniff"
    },
    ['cuffs:cuff'] = {
        title = "Hard Cuff",
        icon = "#cuffs-cuff",
        functionName = "tp:handcuff"
    },
    ['cuffs:softcuff'] = {
        title = "Soft Cuff",
        icon = "#cuffs-cuff",
        functionName = "tp:softcuff"
    },
    ['cuffs:uncuff'] = {
        title = "Uncuff",
        icon = "#cuffs-uncuff",
        functionName = "tp:uncuff"
    },
    
    ['cuffs:civuncuff'] = {
        title = "Cuff/Un-Cuff",
        icon = "#cuffs-uncuff",
        functionName = "tp:uncuff"
    },
    ['cuffs:civremmask'] = {
        title = "Remove Mask Hat",
        icon = "#cuffs-remove-mask",
        functionName = "people-search"
    },
    
    ['cuffs:unseat'] = {
        title = "Unseat",
        icon = "#cuffs-unseat-player",
        functionName = "esx_ambulancejob:pullOutVehicle"
    },
    ['cuffs:checkphone'] = {
        title = "Read Phone",
        icon = "#cuffs-check-phone",
        functionName = "police:checkPhone"
    },
    ['medic:revive'] = {
        title = "Revive",
        icon = "#medic-revive",
        functionName = "tp:emsRevive"
    },
    ['medic:putinvehicle'] = {
        title = "Put in vehicle",
        icon = "#general-put-in-veh",
        functionName = "tp:emsputinvehicle"
    },
    ['medic:takeoutvehicle'] = {
        title = "Take out vehicle",
        icon = "#general-unseat-nearest",
        functionName = "tp:takeoutvehicle"
    },
    ['medic:drag'] = {
        title = "Drag",
        icon = "#general-escort",
        functionName = "tp:emsdrag"
    },
    ['medic:undrag'] = {
        title = "Undrag",
        icon = "#general-escort",
        functionName = "tp:emsundrag"
    },
    ['police:spikes'] = {
        title = "Deploy Spikes",
        icon = "#k9-spawn",
        functionName = "c_setSpike"
    },
    ['police:escort'] = {
        title = "Escort",
        icon = "#general-escort",
        functionName = "tp:escort"
    },
    ['police:revive'] = {
        title = "Revive",
        icon = "#medic-revive",
        functionName = "tp:pdrevive"
    },
    ['police:putinvehicle'] = {
        title = "Seat Vehicle",
        icon = "#general-put-in-veh",
        functionName = "police:forceEnter"
    },
    ['police:unseatnearest'] = {
        title = "Unseat Nearest",
        icon = "#general-unseat-nearest",
        functionName = "tp:takeoutvehicle"
    },
    ['police:impound'] = {
        title = "Impound",
        icon = "#police-vehicle",
        functionName = "tp:menuimpound"
    },
    ['police:cuff'] = {
        title = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "police:cuffFromMenu"
    },
    ['police:checkbank'] = {
        title = "Check Bank",
        icon = "#police-check-bank",
        functionName = "police:checkBank"
    },
    ['police:checklicenses'] = {
        title = "Check Licenses",
        icon = "#police-check-licenses",
        functionName = "police:checkLicenses"
    },
    --[[     ['police:removeweapons'] = {
    title = "Remove Weapons License",
    icon = "#police-action-remove-weapons",
    functionName = "police:removeWeapon"
    }, ]]
    ['police:gsr'] = {
        title = "GSR Test",
        icon = "#police-action-gsr",
        functionName = "tp:checkGSR"
    },
    
    --[[     ['police:toggleradar'] = {
    title = "Toggle Radar",
    icon = "#police-vehicle-radar",
    functionName = "startSpeedo"
    }, ]]
    --[[     ['police:frisk'] = {
    title = "Frisk",
    icon = "#police-action-frisk",
    functionName = "police:frisk"
    }, ]]
    ['judge:grantDriver'] = {
        title = "Grant Drivers",
        icon = "#judge-licenses-grant-drivers",
        functionName = "police:grantDriver"
    },
    ['judge:grantBusiness'] = {
        title = "Grant Business",
        icon = "#judge-licenses-grant-business",
        functionName = "police:grantBusiness"
    },
    ['judge:grantWeapon'] = {
        title = "Grant Weapon",
        icon = "#judge-licenses-grant-weapon",
        functionName = "police:grantWeapon"
    },
    ['judge:grantHouse'] = {
        title = "Grant House",
        icon = "#judge-licenses-grant-house",
        functionName = "police:grantHouse"
    },
    ['judge:grantBar'] = {
        title = "Grant BAR",
        icon = "#judge-licenses-grant-bar",
        functionName = "police:grantBar"
    },
    ['judge:grantDA'] = {
        title = "Grant DA",
        icon = "#judge-licenses-grant-da",
        functionName = "police:grantDA"
    },
    ['judge:removeDriver'] = {
        title = "Remove Drivers",
        icon = "#judge-licenses-remove-drivers",
        functionName = "police:removeDriver"
    },
    ['judge:removeBusiness'] = {
        title = "Remove Business",
        icon = "#judge-licenses-remove-business",
        functionName = "police:removeBusiness"
    },
    ['judge:removeWeapon'] = {
        title = "Remove Weapon",
        icon = "#judge-licenses-remove-weapon",
        functionName = "police:removeWeapon"
    },
    ['judge:removeHouse'] = {
        title = "Remove House",
        icon = "#judge-licenses-remove-house",
        functionName = "police:removeHouse"
    },
    ['judge:removeBar'] = {
        title = "Remove BAR",
        icon = "#judge-licenses-remove-bar",
        functionName = "police:removeBar"
    },
    ['judge:removeDA'] = {
        title = "Remove DA",
        icon = "#judge-licenses-remove-da",
        functionName = "police:removeDA"
    },
    ['judge:denyWeapon'] = {
        title = "Deny Weapon",
        icon = "#judge-licenses-deny-weapon",
        functionName = "police:denyWeapon"
    },
    ['judge:denyDriver'] = {
        title = "Deny Drivers",
        icon = "#judge-licenses-deny-drivers",
        functionName = "police:denyDriver"
    },
    ['judge:denyBusiness'] = {
        title = "Deny Business",
        icon = "#judge-licenses-deny-business",
        functionName = "police:denyBusiness"
    },
    ['judge:denyHouse'] = {
        title = "Deny House",
        icon = "#judge-licenses-deny-house",
        functionName = "police:denyHouse"
    },
    ['news:setCamera'] = {
        title = "Camera",
        icon = "#news-job-news-camera",
        functionName = "camera:setCamera"
    },
    ['news:setMicrophone'] = {
        title = "Microphone",
        icon = "#news-job-news-microphone",
        functionName = "camera:setMic"
    },
    ['news:setBoom'] = {
        title = "Microphone Boom",
        icon = "#news-job-news-boom",
        functionName = "camera:setBoom"
    },
    ['weed:currentStatusServer'] = {
        title = "Request Status",
        icon = "#weed-cultivation-request-status",
        functionName = "weed:currentStatusServer"
    },
    ['weed:weedCrate'] = {
        title = "Remove A Crate",
        icon = "#weed-cultivation-remove-a-crate",
        functionName = "weed:weedCrate"
    },
    ['cocaine:currentStatusServer'] = {
        title = "Request Status",
        icon = "#meth-manufacturing-request-status",
        functionName = "cocaine:currentStatusServer"
    },
    ['cocaine:methCrate'] = {
        title = "Remove A Crate",
        icon = "#meth-manufacturing-remove-a-crate",
        functionName = "cocaine:methCrate"
    },
    ["expressions:angry"] = {
        title = "Angry",
        icon = "#expressions-angry",
        functionName = "expressions",
        functionParameters = {"mood_angry_1"}
    },
    ["expressions:drunk"] = {
        title = "Drunk",
        icon = "#expressions-drunk",
        functionName = "expressions",
        functionParameters = {"mood_drunk_1"}
    },
    ["expressions:dumb"] = {
        title = "Dumb",
        icon = "#expressions-dumb",
        functionName = "expressions",
        functionParameters = {"pose_injured_1"}
    },
    ["expressions:electrocuted"] = {
        title = "Electrocuted",
        icon = "#expressions-electrocuted",
        functionName = "expressions",
        functionParameters = {"electrocuted_1"}
    },
    ["expressions:grumpy"] = {
        title = "Grumpy",
        icon = "#expressions-grumpy",
        functionName = "expressions",
        functionParameters = {"mood_drivefast_1"}
    },
    ["expressions:happy"] = {
        title = "Happy",
        icon = "#expressions-happy",
        functionName = "expressions",
        functionParameters = {"mood_happy_1"}
    },
    ["expressions:injured"] = {
        title = "Injured",
        icon = "#expressions-injured",
        functionName = "expressions",
        functionParameters = {"mood_injured_1"}
    },
    ["expressions:joyful"] = {
        title = "Joyful",
        icon = "#expressions-joyful",
        functionName = "expressions",
        functionParameters = {"mood_dancing_low_1"}
    },
    ["expressions:mouthbreather"] = {
        title = "Mouthbreather",
        icon = "#expressions-mouthbreather",
        functionName = "expressions",
        functionParameters = {"smoking_hold_1"}
    },
    ["expressions:normal"] = {
        title = "Normal",
        icon = "#expressions-normal",
        functionName = "expressions:clear"
    },
    ["expressions:oneeye"] = {
        title = "One Eye",
        icon = "#expressions-oneeye",
        functionName = "expressions",
        functionParameters = {"pose_aiming_1"}
    },
    ["expressions:shocked"] = {
        title = "Shocked",
        icon = "#expressions-shocked",
        functionName = "expressions",
        functionParameters = {"shocked_1"}
    },
    ["expressions:sleeping"] = {
        title = "Sleeping",
        icon = "#expressions-sleeping",
        functionName = "expressions",
        functionParameters = {"dead_1"}
    },
    ["expressions:smug"] = {
        title = "Smug",
        icon = "#expressions-smug",
        functionName = "expressions",
        functionParameters = {"mood_smug_1"}
    },
    ['animations:arrogant'] = {
        title = "Arrogant",
        icon = "#animation-arrogant",
        functionName = "AnimSet:Arrogant"
    },
    
    ['animations:casual'] = {
        title = "Casual",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual"
    },
    ['animations:casual2'] = {
        title = "Casual 2",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual2"
    },
    ['animations:casual3'] = {
        title = "Casual 3",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual3"
    },
    ['animations:casual4'] = {
        title = "Casual 4",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual4"
    },
    ['animations:casual5'] = {
        title = "Casual 5",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual5"
    },
    ['animations:casual6'] = {
        title = "Casual 6",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual6"
    },
    ['animations:confident'] = {
        title = "Confident",
        icon = "#animation-confident",
        functionName = "AnimSet:Confident"
    },
    
    ['animations:business2'] = {
        title = "Business 2",
        icon = "#animation-business",
        functionName = "AnimSet:Business2"
    },
    ['animations:business3'] = {
        title = "Business 3",
        icon = "#animation-business",
        functionName = "AnimSet:Business3"
    },
    
    ['animations:femme'] = {
        title = "Femme",
        icon = "#animation-female",
        functionName = "AnimSet:Femme"
    },
    ['animations:flee'] = {
        title = "Flee",
        icon = "#animation-flee",
        functionName = "AnimSet:Flee"
    },
    ['animations:gangster'] = {
        title = "Gangster",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster"
    },
    ['animations:gangster2'] = {
        title = "Gangster 2",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster2"
    },
    ['animations:gangster3'] = {
        title = "Gangster 3",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster3"
    },
    ['animations:gangster4'] = {
        title = "Gangster 4",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster4"
    },
    ['animations:gangster5'] = {
        title = "Gangster 5",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster5"
    },
    ['animations:heels'] = {
        title = "Heels",
        icon = "#animation-female",
        functionName = "AnimSet:Heels"
    },
    ['animations:heels2'] = {
        title = "Heels 2",
        icon = "#animation-female",
        functionName = "AnimSet:Heels2"
    },
    ['animations:muscle'] = {
        title = "Muscle",
        icon = "#animation-tough",
        functionName = "AnimSet:Muscle"
    },
    
    ['animations:quick'] = {
        title = "Quick",
        icon = "#animation-quick",
        functionName = "AnimSet:Quick"
    },
    ['animations:wide'] = {
        title = "Wide",
        icon = "#animation-wide",
        functionName = "AnimSet:Wide"
    },
    ['animations:scared'] = {
        title = "Scared",
        icon = "#animation-scared",
        functionName = "AnimSet:Scared"
    },
    ["expressions:speculative"] = {
        title = "Speculative",
        icon = "#expressions-speculative",
        functionName = "expressions",
        functionParameters = {"mood_aiming_1"}
    },
    ["expressions:stressed"] = {
        title = "Stressed",
        icon = "#expressions-stressed",
        functionName = "expressions",
        functionParameters = {"mood_stressed_1"}
    },
    ["expressions:sulking"] = {
        title = "Sulking",
        icon = "#expressions-sulking",
        functionName = "expressions",
        functionParameters = {"mood_sulk_1"},
    },
    ["expressions:weird"] = {
        title = "Weird",
        icon = "#expressions-weird",
        functionName = "expressions",
        functionParameters = {"effort_2"}
    },
    ["expressions:weird2"] = {
        title = "Weird 2",
        icon = "#expressions-weird2",
        functionName = "expressions",
        functionParameters = {"effort_3"}
    }
}

RegisterNetEvent("menu:setCuffState")
AddEventHandler("menu:setCuffState", function(pTargetId, pState)
    cuffStates[pTargetId] = pState
end)


RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
    isJudge = true
end)

RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
    isJudge = false
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
end)

RegisterNetEvent('execmdt')
AddEventHandler('execmdt', function()
    ExecuteCommand('mdt')
end)

RegisterNetEvent("drivingInstructor:instructorToggle")
AddEventHandler("drivingInstructor:instructorToggle", function(mode)
    if myJob == "driving instructor" then
        isInstructorMode = mode
    end
end)

RegisterNetEvent("police:currentHandCuffedState")
AddEventHandler("police:currentHandCuffedState", function(pIsHandcuffed, pIsHandcuffedAndWalking)
    isHandcuffedAndWalking = pIsHandcuffedAndWalking
    isHandcuffed = pIsHandcuffed
end)

RegisterNetEvent("menu:hasOxygenTank")
AddEventHandler("menu:hasOxygenTank", function(pHasOxygenTank)
    hasOxygenTankOn = pHasOxygenTank
end)

RegisterNetEvent('enablegangmember')
AddEventHandler('enablegangmember', function(pGangNum)
    gangNum = pGangNum
end)

function GetPlayers()
    local players = {}
    
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players + 1] = i
        end
    end
    
    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        for index, value in ipairs(players) do
            local target = GetPlayerPed(value)
            if (target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if (closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end


RegisterNetEvent('cleanveh')
AddEventHandler('cleanveh', function()
    local playerPed = PlayerPedId()
    local vehicle = ESX.Game.GetVehicleInDirection()
    local coords = GetEntityCoords(playerPed)
    
    if IsPedSittingInAnyVehicle(playerPed) then
        TriggerEvent('notification', 'Cannot Clean While in Car', 1)
        return
    end
    if DoesEntityExist(vehicle) then
        isBusy = true
        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
        Citizen.CreateThread(function()
            Citizen.Wait(10000)
            
            SetVehicleDirtLevel(vehicle, 0)
            ClearPedTasksImmediately(playerPed)
            
            TriggerEvent('notification', 'Vehicle Cleaned', 1)
            isBusy = false
        end)
    else
        TriggerEvent('notification', 'No Car Nearby', 1)
    end
end)

RegisterNetEvent('fixveh')
AddEventHandler('fixveh', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle
        
        if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
        else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        end
        
        if DoesEntityExist(vehicle) then
            
            TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
            Citizen.CreateThread(function()
                exports["sway_taskbar"]:taskBar(10000, "Fixing Vehicle")
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                ClearPedTasksImmediately(playerPed)
                TriggerEvent('notification', 'Vehicle Fixed', 1)
            end)
        end
    end
end)



RegisterNetEvent('lockpickveh')
AddEventHandler('lockpickveh', function()
    local playerPed = PlayerPedId()
    local vehicle = ESX.Game.GetVehicleInDirection()
    local coords = GetEntityCoords(playerPed)
    
    if IsPedSittingInAnyVehicle(playerPed) then
        TriggerEvent('notification', 'Cannot be inside vehicle', 1)
        return
    end
    
    if DoesEntityExist(vehicle) then
        isBusy = true
        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
        Citizen.CreateThread(function()
            exports["sway_taskbar"]:taskBar(10000, "Lockpicking Vehicle")
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent('garage:addKeys', plate)
            SetVehicleDoorsLocked(vehicle, 1)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            ClearPedTasksImmediately(playerPed)
            
            TriggerEvent('notification', 'Vehicle picked', 1)
            isBusy = false
        end)
    else
        TriggerEvent('notification', 'No Vehicle Nearby', 1)
    end
end)
