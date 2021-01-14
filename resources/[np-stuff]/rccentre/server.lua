ESX = nil

TriggerEvent('esx:getSharAVACedObject', function(obj)
    ESX = obj
end)


local original = {
	{1015.4642333984,-3110.4521484375,-38.99991607666,["time"] = 0,["used"] = false},  
	{1011.2679443359,-3110.8725585938,-38.99991607666,["time"] = 0,["used"] = false},  
	{1005.8571777344,-3110.6271972656,-38.99991607666,["time"] = 0,["used"] = false},  
	{995.37841796875,-3108.6293945313,-38.99991607666,["time"] = 0,["used"] = false}, 
	{1003.0407104492,-3104.7854003906,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1008.2990112305,-3106.94140625,-38.999881744385,["time"] = 0,["used"] = false},  
	{1010.9890136719,-3104.5573730469,-38.999881744385,["time"] = 0,["used"] = false},  
	{1013.3607788086,-3106.8874511719,-38.999881744385,["time"] = 0,["used"] = false},  
	{1017.8317260742,-3104.5822753906,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1019.0430297852,-3098.9851074219,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1013.7381591797,-3100.9680175781,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1009.3251342773,-3098.8120117188,-38.999881744385,["time"] = 0,["used"] = false},  
	{1005.9111938477,-3100.9387207031,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1003.2393798828,-3093.9182128906,-38.999885559082,["time"] = 0,["used"] = false}, 
	{1008.0280151367,-3093.384765625,-38.999885559082,["time"] = 0,["used"] = false}, 
	{1010.8000488281,-3093.544921875,-38.999885559082,["time"] = 0,["used"] = false}, 
	{1016.1090087891,-3095.3405761719,-38.999885559082,["time"] = 0,["used"] = false},  
	{1018.2312011719,-3093.1293945313,-38.999885559082,["time"] = 0,["used"] = false},  
	{1025.1221923828,-3091.4680175781,-38.999885559082,["time"] = 0,["used"] = false}, 
	{1024.9321289063,-3096.4670410156,-38.999885559082,["time"] = 0,["used"] = false}, 
}

RegisterServerEvent("missionSystem:UpdateClients")
AddEventHandler("missionSystem:UpdateClients", function(RecyclePoints, i)
    local result = RecyclePoints
    if next(result) then
        table.remove(result, i)
        TriggerClientEvent("missionSystem:updatePoints", -1, result)
    else
        TriggerClientEvent("missionSystem:updatePoints", -1, original)
    end
end)


RegisterServerEvent("mission:weedsold")
AddEventHandler('mission:weedsold', function(payment)
xPlayer = ESX.GetPlayerFromId(source)
local weed = 250
	xPlayer.addMoney(weed)
end)

RegisterServerEvent("mission:fishsell")
AddEventHandler('mission:fishsell', function(payment)
xPlayer = ESX.GetPlayerFromId(source)
local fish = 250
	xPlayer.addMoney(fish)
end)

RegisterServerEvent("missionSystem:caughtMoney")
AddEventHandler('missionSystem:caughtMoney', function(payment)
xPlayer = ESX.GetPlayerFromId(source)
local cash = math.random( 22,85)
	xPlayer.addMoney(cash)
end)