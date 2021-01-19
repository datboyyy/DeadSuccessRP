-- Swxy#0001 thx nikez
useNativeAudio = false
use3dAudio = true
useSendingRangeOnly = true

-- function GetMaxChunkId()
--     return Config.gridSize << 2
-- end

-- local maxChannel = GetMaxChunkId() << 1 -- Double the max just in case

RegisterNetEvent("np:voice:connection:state")
AddEventHandler("np:voice:connection:state", function(state)
    TriggerClientEvent('np:voice:connection:state', -1, source, state)
end)


RegisterNetEvent("np:voice:transmission:state")
AddEventHandler("np:voice:transmission:state", function(group, context, transmitting, isMult)
    local _source = source
    if isMult then
        for k,v in pairs(group) do
            TriggerClientEvent('np:voice:transmission:state', v, _source, context, transmitting)
        end
    else
        TriggerClientEvent('np:voice:transmission:state', group, _source, context, transmitting)
    end
end)

  
AddEventHandler("onResourceStart", function(resName) -- Initialises the script, sets up voice related convars
    if GetCurrentResourceName() ~= resName then
        return
    end

    -- Set voice related convars
    --SetConvarReplicated("voice_useNativeAudio", true )
    -- SetConvarReplicated("voice_use2dAudio", use3dAudio and "false" or "true")
    SetConvarReplicated("voice_use3dAudio", use3dAudio)    
    SetConvarReplicated("voice_useSendingRangeOnly", useSendingRangeOnly )    

    -- for i = 1, maxChannel do
    --     MumbleCreateChannel(i)
    -- end

    Debug("[np:voice] Initialised Script -Swxy#0001")
end)