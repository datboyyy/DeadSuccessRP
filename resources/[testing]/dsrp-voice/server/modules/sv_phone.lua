local activeCallsByNumber = {}
local activeCallsBySource = {}

RegisterServerEvent("lol:voice:server:phone:startCall")
AddEventHandler("lol:voice:server:phone:startCall", function(phoneNumber, receiverID)
    local src = source
    startCall(phoneNumber, src, receiverID)
end)

RegisterServerEvent("lol:voice:server:phone:endCall")
AddEventHandler("lol:voice:server:phone:endCall", function(phoneNumber)
    endCall(phoneNumber)
end)

AddEventHandler('playerDropped', function(pData)
    if activeCallsBySource[pData.source] then
        if activeCallsByNumber[activeCallsBySource[pData.source]].caller == pData.source then
            activeCallsByNumber[activeCallsBySource[pData.source]].caller = nil
        else
            activeCallsByNumber[activeCallsBySource[pData.source]].receiver = nil
        end
        endCall(activeCallsBySource[pData.source])
    end
end)

function startCall(phoneNumber, callerID, receiverID)
    if activeCallsByNumber[phoneNumber] then
        --busy
    else
        activeCallsByNumber[phoneNumber] = {caller = callerID, receiver = receiverID}
        activeCallsBySource[callerID] = phoneNumber
        activeCallsBySource[receiverID] = phoneNumber
        TriggerClientEvent('lol:voice:phone:call:start2', tonumber(callerID), tonumber(phoneNumber), tonumber(receiverID))
        TriggerClientEvent('lol:voice:phone:call:start2', tonumber(receiverID), tonumber(phoneNumber), tonumber(callerID))
    end
end

function endCall(phoneNumber)
    local data = activeCallsByNumber[phoneNumber]
    if data then
        if data.caller then
            TriggerClientEvent('lol:voice:phone:call:end', data.caller, data.receiver, phoneNumber)
        end

        if data.receiver then
            TriggerClientEvent('lol:voice:phone:call:end', data.receiver, data.caller, phoneNumber)
        end
    end
end