local ForbiddenEvents = {
    "hentailover:xdlol",
    "vrp_slotmachine:server:2",
   -- "esx-qalle-jail:jailPlayer",
  --  "esx-qalle-jail:unJailPlayer",
   -- "esx-qalle-jail:updateJailTime",
   -- "esx-qalle-jail:prisonWorkReward",
  --  "esx-qalle-jail:retrieveJailedPlayers",
  --  "esx-qalle-jail:retrieveJailTime",
 --   "esx-qalle-jail:openJailMenu",
    "esx_jail:sendToJail",
  	"esx_jailer:sendToJail",
  	"ljail:jailplayer",
  	"scratchoffs:dispenseReward",
  	"scratchoffs:dispenseUsedScratchoff",
    "qalle_policearmory:giveWeapon",
    "qalle_policearmory:pedExists",
    "DSRP:BAN_ME",
    "bank:transfer",
    "esx_society:openBossMenu",
    "esx_society:getSocietyMoney",
    "esx_society:setJobSalary",
    "esx_society:getJob",
    "esx_society:setJob",
    "esx_society:getOnlinePlayers",
    "esx_society:getEmployees",
    "esx_society:washMoney",
    "esx_society:depositMoney",
    "esx_society:withdrawMoney",
    "esx_society:isBoss",
    "bankrobberies:receiveCash",
    "esx_policejob:spawned",
    "jailbitchmf",
   -- "kashactersS:DeleteCharacter",
    "esx:clientLog",
    "d0pamine_xyz:getFuckedNigger",
    "^4d0pamine_xyz:getFuckedNigger",
    "eulencheats:LuaExecScriptHook",
    "esx_taxijob:success",
    "esx_banksecurity:pay",
    "getFuckedNigger",
    "esx_inventoryhud:openPlayerInventory",
    "esx_ambulancejob:setDeathStatus",
    "esx:giveInventoryItem",
    "redst0nia:checking",
  "gcPhone:_internalAddMessage",
  "gcPhone:tchat_channel",
  "esx_vehicleshop:setVehicleOwned",
  "esx_mafiajob:confiscatePlayerItem",
  "lscustoms:payGarage",
  "vrp_slotmachine:server:2",
  "Banca:deposit",
  "bank:deposit",
  "esx_jobs:caution",
  "give_back",
  "esx_fueldelivery:pay",
  "esx_carthief:pay",
  "esx_godirtyjob:pay",
  "esx_pizza:pay",
  "esx_ranger:pay",
  "esx_garbagejob:pay",
  "esx_truckerjob:pay",
  "AdminMenu:giveBank",
  "AdminMenu:giveCash",
  "esx_gopostaljob:pay",
  "esx_banksecurity:pay",
  "esx_slotmachine:sv:2",
  "esx:giveInventoryItem",
  "NB:recruterplayer",
  "esx_billing:sendBill",
  "esx_jailer:sendToJail",
  "esx_jail:sendToJail",
  "js:jailuser",
  "esx-qalle-jail:jailPlayer",
  "esx_dmvschool:pay", 
  "LegacyFuel:PayFuel",
  "OG_cuffs:cuffCheckNearest",
  "CheckHandcuff",
  "cuffServer",
  "cuffGranted",
  "police:cuffGranted",
  "esx_handcuffs:cuffing",
  "esx_policejob:handcuff",
  "bank:withdraw",
  "dmv:success",
  "esx_skin:responseSaveSkin",
  "esx_dmvschool:addLicense",
  "esx_mechanicjob:startCraft",
  "esx_drugs:startHarvestWeed",
  "esx_drugs:startTransformWeed",
  "esx_drugs:startSellWeed",
  "esx_drugs:startHarvestCoke",
  "esx_drugs:startTransformCoke",
  "esx_drugs:startSellCoke",
  "esx_drugs:startHarvestMeth",
  "esx_drugs:startTransformMeth",
  "esx_drugs:startSellMeth",
  "esx_drugs:startHarvestOpium",
  "esx_drugs:startSellOpium",
  "esx_drugs:startTransformOpium",
  "esx_blanchisseur:startWhitening",
  "esx_drugs:stopHarvestCoke",
  "esx_drugs:stopTransformCoke",
  "esx_drugs:stopSellCoke",
  "esx_drugs:stopHarvestMeth",
  "esx_drugs:stopTransformMeth",
  "esx_drugs:stopSellMeth",
  "esx_drugs:stopHarvestWeed",
  "esx_drugs:stopTransformWeed",
  "esx_drugs:stopSellWeed",
  "esx_drugs:stopHarvestOpium",
  "esx_drugs:stopTransformOpium",
  "esx_drugs:stopSellOpium",
  "esx_society:openBossMenu",
  "esx_jobs:caution",
  "esx_tankerjob:pay",
  "esx_vehicletrunk:giveDirty",
  "gambling:spend",
  "AdminMenu:giveDirtyMoney",
  "esx_moneywash:deposit",
  "esx_moneywash:withdraw",
  "mission:completed",
  "truckerJob:success",
  "99kr-burglary:addMoney",
  "esx_jailer:unjailTime",
  "esx_ambulancejob:revive",
  "DiscordBot:playerDied",
  "hentailover:xdlol",
  "antilynx8:anticheat",
  "antilynxr6:detection",
  "esx:getSharedObject",
  "esx_society:getOnlinePlayers",
  "_chat:messageEntered",
  "antilynx8r4a:anticheat",
  "antilynxr4:detect",
  "js:jailuser", 
  "ynx8:anticheat",
  "lynx8:anticheat",
  "adminmenu:allowall",
  "h:xd",
  "ljail:jailplayer",
  "adminmenu:setsalary",
  "adminmenu:cashoutall",
  "bank:transfer",
  "paycheck:bonus",
  "paycheck:salary",
  "HCheat:TempDisableDetection",
  "esx_drugs:pickedUpCannabis",
  "esx_drugs:processCannabis",
  "esx-qalle-hunting:reward",
  "esx-qalle-hunting:sell",
  "esx_mecanojob:onNPCJobCompleted",
  "BsCuff:Cuff696999",
  "veh_SR:CheckMoneyForVeh",
  "esx_carthief:alertcops",
  "mellotrainer:adminTempBan",
  "mellotrainer:adminKick",
  "esx_society:putVehicleInGarage",
}

    


for i, eventName in ipairs(ForbiddenEvents) do
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function()     
        local _source = source
        local name = GetPlayerName(_source)
        local ip = GetPlayerEndpoint(source)
        local ping = GetPlayerPing(source)
        local steamhex = GetPlayerIdentifier(source)
        
        TriggerEvent('banCheater', _source, "Tried Triggering event "..eventName)
    end)
end




Citizen.CreateThread(function()
	local uptimeMinute, uptimeHour, uptime = 0, 0, ''

	while true do
		Citizen.Wait(1000 * 60) -- every minute
		uptimeMinute = uptimeMinute + 1

		if uptimeMinute == 60 then
			uptimeMinute = 0
			uptimeHour = uptimeHour + 1
		end

		uptime = string.format("%02dh %02dm", uptimeHour, uptimeMinute)
		SetConvarServerInfo('Uptime', uptime)


		TriggerClientEvent('uptime:tick', -1, uptime)
		TriggerEvent('uptime:tick', uptime)
	end
end)


