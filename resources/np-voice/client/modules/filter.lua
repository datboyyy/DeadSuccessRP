local SubmixList, SubmixCount = {}, -1

function RegisterContextSubmix(pContext)
    local data = {}

    SubmixCount = SubmixCount + 1

    data.slot = SubmixCount
    data.submix = CreateAudioSubmix(GetHashKey(pContext))

    AddAudioSubmixOutput(data.submix, data.slot)

    Transmissions:setContextData(pContext, "submix", pContext)

    SubmixList[pContext] = data

    Debug('[Filter] Registered Submix | %s', pContext)
end

function SetFilterParameters(pContext, pSettings)
    local data = SubmixList[pContext]

    if not data or not pSettings then return end

    data.setting = pSettings

    SetAudioSubmixEffectRadioFx(data.submix, data.slot)
    SetAudioSubmixEffectParamInt(data.submix, data.slot, GetHashKey('default'), 1)

    for _, setting in ipairs(pSettings) do
        SetAudioSubmixEffectParamFloat(data.submix, data.slot, GetHashKey(setting.name), setting.value)
    end

    Debug('[Filter] Updated Submix parameters | %s', pContext)
end

function SetPlayerFilter(pServerId, pContext)
    local data = SubmixList[pContext]

    if not data then return end

    MumbleSetSubmixForServerId(pServerId, data.submix)

    Debug('[Filter] Changed Player Submix | Server ID: %s | Submix: %s', pServerId, pContext)
end

function SetTransmissionFilters(serverID, context)
    local submix = context.submix and context.submix or 'default'

    SetPlayerFilter(serverID, submix)
end

function CanUseFilter(transmitting, context)
    if not VoiceEnabled then
        return false
    elseif transmitting and context == "radio" and not IsRadioOn then
        return false
    end

    return true
end

RegisterNetEvent("np:voice:connection:state")
AddEventHandler("np:voice:connection:state", function (serverID, isConnected)
    if not isConnected and Config.enableSubmixes then
        SetPlayerFilter(serverID, 'default')
        Debug("[Filter] Submix Reset | Player: %s ", serverID)
    end
end)

AddEventHandler('np:voice:state', function (isActive)
    if not isActive and Config.enableSubmixes then
        Transmissions:contextIterator(function (pServerId)
            SetPlayerFilter(pServerId, 'default')
        end)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() or not Config.enableSubmixes then return end

    Transmissions:contextIterator(function (pServerId)
        SetPlayerFilter(pServerId, 'default')
    end)
end)