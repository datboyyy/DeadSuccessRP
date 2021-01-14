RegisterCommand('wipepeds', function(source, args, rawCommand) 
    if IsPlayerAceAllowed(source, "sway_admin") then
    TriggerClientEvent("DeadSuccessRP:wipePeds", -1)
    end
 end)

RegisterCommand("wipeobjects", function(source, args, rawCommand)
    TriggerClientEvent("DeadSuccessRP:wipeObjects", -1)
end, true)

RegisterCommand('wipecars', function(source, args, rawCommand) 
    if IsPlayerAceAllowed(source, "sway_admin") then
    TriggerClientEvent("DeadSuccessRP:WipeWhips", -1)
end
 end)