ESX   = nil


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)


local isJudge = false
local isPolice = false
local isMedic = false
local isMechanic = false
local isNews = false
local isDead = false
local isInstructorMode = false
local myJob = "unemployed"
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}

rootMenuConfig =  {
    {
        id = "general",
        displayName = "General",
        icon = "#globe-europe",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return not isDead
        end,
        subMenus = {"general:escort", "general:putinvehicle", "general:unseatnearest", "general:flipvehicle",  "general:keysgive", "general:emotes"}
    },
    {
        id = "police-action",
        displayName = "Police Actions",
        icon = "#police-action",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return (ESX.GetPlayerData().job.name == "police" and not isDead)
        end,
        subMenus = {"general:putinvehicle", "general:escort", "medic:revive", "cuffs:remmask", "general:unseatnearest", "police:panic"}
    },
    {
        id = "police-check",
        displayName = "Police Checks",
        icon = "#police-check",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return (ESX.GetPlayerData().job.name == "police" and not isDead)
        end,
        subMenus = {"police:checkbank", "cuffs:checkinventory", "police:gsr"}
    },
    {
        id = "police-vehicle",
        displayName = "Police Vehicle",
        icon = "#police-vehicle",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return (ESX.GetPlayerData().job.name == "police" and not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
        end,
        subMenus = {"general:unseatnearest", "police:runplate", "police:toggleradar"}
    },
    {
        id = "mechanic-actions",
        displayName = "Mechanic",
        icon = "#police-vehicle",
        enableMenu = function()
            local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           fuck = exports["ambulancejob"]:GetDeath()
            if PlayerData.job.name == "mechanic" and not fuck then
                return true
            end
        end,
        subMenus = { "mechanic:hijack", "mechanic:repair", "mechanic:clean", "mechanic:impound"}
    },
    {
        id = "policeDeadA",
        displayName = "10-13A",
        icon = "#police-dead",
        functionName = "police:tenThirteenA",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return (ESX.GetPlayerData().job.name == "police" and isDead)
        end
    },
    {
        id = "policeDeadB",
        displayName = "10-13B",
        icon = "#police-dead",
        functionName = "police:tenThirteenB",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return (ESX.GetPlayerData().job.name == "police" and isDead)
        end
    },
    {
        id = "emsDeadA",
        displayName = "10-14A",
        icon = "#ems-dead",
        functionName = "police:tenForteenA",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return (ESX.GetPlayerData().job.name == "ambulance" and isDead)
        end
    },
    {
        id = "emsDeadB",
        displayName = "10-14B",
        icon = "#ems-dead",
        functionName = "police:tenForteenB",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return (ESX.GetPlayerData().job.name == "ambulance" and isDead)
        end
    },
    {
        id = "animations",
        displayName = "Gait",
        icon = "#walking",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return not isDead
        end,
        subMenus = { "animations:brave", "animations:hurry", "animations:business", "animations:tipsy", "animations:injured","animations:tough", "animations:default", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:maneater", "animations:chichi", "animations:sassy", "animations:sad", "animations:posh", "animations:alien",
        
        --new
        "animations:arrogant","animations:casual","animations:casual2","animations:casual3","animations:casual4","animations:casual5","animations:casual6","animations:confident","animations:business2","animations:business3","animations:femme","animations:flee","animations:gangster","animations:gangster2","animations:gangster3","animations:gangster4","animations:gangster5","animations:heels","animations:heels2","animations:muscle","animations:quick","animations:wide","animations:scared", }
    },
    {
        id = "expressions",
        displayName = "Expressions",
        icon = "#expressions",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return not isDead
        end,
        subMenus = { "expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
    },
    {
        id = "blips",
        displayName = "Blips",
        icon = "#blips",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return not isDead
        end,
        subMenus = { "blips:gasstations", "blips:trainstations", "blips:garages", "blips:barbershop", "blips:tattooshop"}
    },
    {
        id = "cuff",
        displayName = "Cuff Actions",
        icon = "#cuffs",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            if not isDead and not IsPlayerFreeAiming(PlayerId()) and not IsPedInAnyVehicle(PlayerPedId(), false) and not isHandcuffed and not isHandcuffedAndWalking and exports["dsrp-inventory"]:hasEnoughOfItem("cuffs",1,false) then
                return true
            end
            return false
        end,
        subMenus = { "cuffs:uncuff", "cuffs:remmask", "cuffs:unseat", "police:seat"}
    },
    {
        id = "cuff",
        displayName = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "civ:cuffFromMenu",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return (not isDead and exports["dsrp-inventory"]:hasEnoughOfItem("cuffs",1,false))

       
        end
    },
    {
        id = "medic",
        displayName = "Medical",
        icon = "#medic",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return (not isDead and ESX.GetPlayerData().job.name == "ambulance")
        end,
        subMenus = {"medic:revive", "medic:heal", "general:escort", "general:putinvehicle", "general:unseatnearest","police:panic"}
    },
    {
        id = "news",
        displayName = "News",
        icon = "#news",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return (not isDead and ESX.GetPlayerData().job.name == "reporter")
        end,
        subMenus = { "news:setCamera", "news:setMicrophone", "news:setBoom"}
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
        id = "oxygentank",
        displayName = "Remove Oxygen Tank",
        icon = "#oxygen-mask",
        functionName = "RemoveOxyTank",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return not isDead and hasOxygenTankOn
        end
    },  
    {
        id = "mdt",
        displayName = "MDT",
        icon = "#mdt",
        functionName = "mdt:hotKeyOpen",
        enableMenu = function()
            isDead = exports["ambulancejob"]:GetDeath()
            return (ESX.GetPlayerData().job.name == "police" and not isDead)
        end,
    }



}

newSubMenus = {
    ['general:emotes'] = {
        title = "Emotes",
        icon = "#general-emotes",
        functionName = "emotes:OpenMenu"
    },    
    ['general:keysgive'] = {
        title = "Give Key",
        icon = "#general-keys-give",
        functionName = "keys:give"
    },
    ['general:escort'] = {
        title = "Escort",
        icon = "#general-escort",
        functionName = "escortPlayer"
    },
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
    -- ['general:checkvehicle'] = {
    --     title = "Examine Vehicle",
    --     icon = "#general-check-vehicle",
    --     functionName = "veh:requestUpdate"
    -- },
    ['animations:joy'] = {
        title = "Joy",
        icon = "#animation-joy",
        functionName = "AnimSet:Joy"
    },
    ['animations:sexy'] = {
        title = "Sexy",
        icon = "#animation-sexy",
        functionName = "AnimSet:Sexy"
    },
    ['animations:moon'] = {
        title = "Moon",
        icon = "#animation-moon",
        functionName = "AnimSet:Moon"
    },
    ['animations:tired'] = {
        title = "Tired",
        icon = "#animation-tired",
        functionName = "AnimSet:Tired"
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
    
    ['animations:hipster'] = {
        title = "Hipster",
        icon = "#animation-hipster",
        functionName = "AnimSet:Hipster"
    },
    ['animations:hiking'] = {
        title = "Hiking",
        icon = "#animation-hiking",
        functionName = "AnimSet:Hiking"
    },
    
    ['animations:jog'] = {
        title = "Jog",
        icon = "#animation-jog",
        functionName = "AnimSet:Jog"
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
    ['animations:guard'] = {
        title = "Guard",
        icon = "#animation-guard",
        functionName = "AnimSet:Guard"
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
    ['animations:default'] = {
        title = "Default",
        icon = "#animation-default",
        functionName = "AnimSet:default"
    },
    ['blips:gasstations'] = {
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
    },
    ['cuffs:cuff'] = {
        title = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "civ:cuffFromMenu"
    },
    ['cuffs:uncuff'] = {
        title = "Uncuff",
        icon = "#cuffs-uncuff",
        functionName = "police:uncuffMenu"
    },
    ['cuffs:remmask'] = {
        title = "Remove Mask Hat",
        icon = "#cuffs-remove-mask",
        functionName = "police:remmask"
    },
    ['cuffs:checkinventory'] = {
        title = "Search Person",
        icon = "#cuffs-check-inventory",
        functionName = "police:checkInventory"
    },
    ['cuffs:unseat'] = {
        title = "Unseat",
        icon = "#cuffs-unseat-player",
        functionName = "unseatPlayerCiv"
    },
    ['medic:revive'] = {
        title = "Revive",
        icon = "#medic-revive",
        functionName = "revive:PD"
    },
    ['medic:heal'] = {
        title = "Heal",
        icon = "#medic-heal",
        functionName = "ems:heal"
    },
    ['medic:stomachpump'] = {
        title = "Stomach pump",
        icon = "#medic-stomachpump",
        functionName = "ems:stomachpump"
    },
    ['police:cuff'] = {
        title = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "police:cuffFromMenu"
    },
    ['police:checkbank'] = {
        title = "Check Bank",
        icon = "#police-check-bank",
        functionName = "check-bank"
    },
    ['police:checklicenses'] = {
        title = "Check Licenses",
        icon = "#police-check-licenses",
        functionName = "police:checkLicenses"
    },
    ['police:removeweapons'] = {
        title = "Remove Weapons License",
        icon = "#police-action-remove-weapons",
        functionName = "police:removeWeapon"
    },
    ['police:panic'] = {
        title = "Panic",
        icon = "#medic-stomachpump",
        functionName = "Police:panic"
    },
    ['police:gsr'] = {
        title = "GSR Test",
        icon = "#police-action-gsr",
        functionName = "police:gsr"
    },
    ['police:dnaswab'] = {
        title = "DNA Swab",
        icon = "#police-action-dna-swab",
        functionName = "evidence:dnaSwab"
    },
    ['police:toggleradar'] = {
        title = "Toggle Radar",
        icon = "#police-vehicle-radar",
        functionName = "startSpeedo"
    },
    ['police:runplate'] = {
        title = "Run Plate",
        icon = "#police-vehicle-plate",
        functionName = "clientcheckLicensePlate"
    },
    ['mechanic:hijack'] = {
        title = "Hijack",
        icon = "#police-vehicle",
        functionName = "tp:hijack"
    },
    ['mechanic:repair'] = {
        title = "Repair",
        icon = "#police-vehicle",
        functionName = "tp:mechrepair"
    },
    ['mechanic:clean'] = {
        title = "Clean",
        icon = "#police-vehicle",
        functionName = "tp:mechclean"
    },
    ['mechanic:impound'] = {
        title = "Impound",
        icon = "#police-vehicle",
        functionName = "tp:mechimpound"
    },
    ['news:setCamera'] = {
        title = "Camera",
        icon = "#news-job-news-camera",
        functionName = "Cam:ToggleCam"
    },
    ['news:setMicrophone'] = {
        title = "Microphone",
        icon = "#news-job-news-microphone",
        functionName = "Mic:ToggleMic"
    },
    ['news:setBoom'] = {
        title = "Microphone Boom",
        icon = "#news-job-news-boom",
        functionName = "Mic:ToggleBMic"
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
        title="Angry",
        icon="#expressions-angry",
        functionName = "expressions",
        functionParameters =  { "mood_angry_1" }
    },
    ["expressions:drunk"] = {
        title="Drunk",
        icon="#expressions-drunk",
        functionName = "expressions",
        functionParameters =  { "mood_drunk_1" }
    },
    ["expressions:dumb"] = {
        title="Dumb",
        icon="#expressions-dumb",
        functionName = "expressions",
        functionParameters =  { "pose_injured_1" }
    },
    ["expressions:electrocuted"] = {
        title="Electrocuted",
        icon="#expressions-electrocuted",
        functionName = "expressions",
        functionParameters =  { "electrocuted_1" }
    },
    ["expressions:grumpy"] = {
        title="Grumpy",
        icon="#expressions-grumpy",
        functionName = "expressions", 
        functionParameters =  { "mood_drivefast_1" }
    },
    ["expressions:happy"] = {
        title="Happy",
        icon="#expressions-happy",
        functionName = "expressions",
        functionParameters =  { "mood_happy_1" }
    },
    ["expressions:injured"] = {
        title="Injured",
        icon="#expressions-injured",
        functionName = "expressions",
        functionParameters =  { "mood_injured_1" }
    },
    ["expressions:joyful"] = {
        title="Joyful",
        icon="#expressions-joyful",
        functionName = "expressions",
        functionParameters =  { "mood_dancing_low_1" }
    },
    ["expressions:mouthbreather"] = {
        title="Mouthbreather",
        icon="#expressions-mouthbreather",
        functionName = "expressions",
        functionParameters = { "smoking_hold_1" }
    },
    ["expressions:normal"]  = {
        title="Normal",
        icon="#expressions-normal",
        functionName = "expressions:clear"
    },
    ["expressions:oneeye"]  = {
        title="One Eye",
        icon="#expressions-oneeye",
        functionName = "expressions",
        functionParameters = { "pose_aiming_1" }
    },
    ["expressions:shocked"]  = {
        title="Shocked",
        icon="#expressions-shocked",
        functionName = "expressions",
        functionParameters = { "shocked_1" }
    },
    ["expressions:sleeping"]  = {
        title="Sleeping",
        icon="#expressions-sleeping",
        functionName = "expressions",
        functionParameters = { "dead_1" }
    },
    ["expressions:smug"]  = {
        title="Smug",
        icon="#expressions-smug",
        functionName = "expressions",
        functionParameters = { "mood_smug_1" }
    },
    ["expressions:speculative"]  = {
        title="Speculative",
        icon="#expressions-speculative",
        functionName = "expressions",
        functionParameters = { "mood_aiming_1" }
    },
    ["expressions:stressed"]  = {
        title="Stressed",
        icon="#expressions-stressed",
        functionName = "expressions",
        functionParameters = { "mood_stressed_1" }
    },
    ["expressions:sulking"]  = {
        title="Sulking",
        icon="#expressions-sulking",
        functionName = "expressions",
        functionParameters = { "mood_sulk_1" },
    },
    ["expressions:weird"]  = {
        title="Weird",
        icon="#expressions-weird",
        functionName = "expressions",
        functionParameters = { "effort_2" }
    },
    ["expressions:weird2"]  = {
        title="Weird 2",
        icon="#expressions-weird2",
        functionName = "expressions",
        functionParameters = { "effort_3" }
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

RegisterNetEvent("krp:playerBecameJob")
AddEventHandler("krp:playerBecameJob", function(job, name, notify)
    if isMedic and job ~= "ambulance" then isMedic = false end
    if isPolice and job ~= "police" then isPolice = false end
    if isMechanic and job ~= "mechanic" then isMechanic = false end
    if isNews and job ~= "reporter" then isNews = false end
    if job == "police" then isPolice = true end
    if job == "ambulance" then isMedic = true end
    if job == "reporter" then isNews = true end
    if job == "mechanic" then isMechanic = true end
    myJob = job
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
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
            players[#players+1]= i
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
        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end

trainstations = {
    {-547.34057617188,-1286.1752929688,25.3059978411511},
    {-892.66284179688,-2322.5168457031,-13.246466636658},
    {-1100.2299804688,-2724.037109375,-8.3086919784546},
    {-1071.4924316406,-2713.189453125,-8.9240007400513},
    {-875.61907958984,-2319.8686523438,-13.241264343262},
    {-536.62890625,-1285.0009765625,25.301458358765},
    {270.09558105469,-1209.9177246094,37.465930938721},
    {-287.13568115234,-327.40936279297,8.5491418838501},
    {-821.34295654297,-132.45257568359,18.436864852905},
    {-1359.9794921875,-465.32354736328,13.531299591064},
    {-498.96591186523,-680.65930175781,10.295949935913},
    {-217.97073364258,-1032.1605224609,28.724565505981},
    {113.90325164795,-1729.9976806641,28.453630447388},
    {117.33223724365,-1721.9318847656,28.527353286743},
    {-209.84713745117,-1037.2414550781,28.722997665405},
    {-499.3971862793,-665.58514404297,10.295639038086},
    {-1344.5224609375,-462.10494995117,13.531820297241},
    {-806.85192871094,-141.39852905273,18.436403274536},
    {-302.21514892578,-327.28854370117,8.5495929718018},
    {262.01733398438,-1198.6135253906,37.448017120361},
--  {2072.4086914063,1569.0856933594,76.712524414063},
    {664.93090820313,-997.59942626953,22.261747360229},
    {190.62687683105,-1956.8131103516,19.520135879517},
--  {2611.0278320313,1675.3806152344,26.578210830688},
    {2615.3901367188,2934.8666992188,39.312232971191},
    {2885.5346679688,4862.0146484375,62.551517486572},
    {47.061096191406,6280.8969726563,31.580261230469},
    {2002.3624267578,3619.8029785156,38.568252563477},
    {2609.7016601563,2937.11328125,39.418235778809}
}
