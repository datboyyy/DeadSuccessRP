IsOnPhoneCall, CurrentCall = false

function StartPhoneCall(serverId, callId)
    if IsOnPhoneCall then return end

    IsOnPhoneCall = true

    CurrentCall = { callId = callId, targetId = serverId }

    AddPlayerToTargetList(serverId, "phone", true)

    Debug('[Phone] Call Started | Call ID %s | Player %s', callId, serverId)
end

function StopPhoneCall(serverId, callId)
    if not IsOnPhoneCall or CurrentCall.callId ~= callId then return end

    IsOnPhoneCall = false

    CurrentCall = nil

    RemovePlayerFromTargetList(serverId, "phone", true, true)

    Debug('[Phone] Call Ended | Call ID %s | Player %s', callId, serverId)
end

function LoadPhoneModule()
    RegisterModuleContext("phone", 1)
    UpdateContextVolume("phone", Config.settings.phoneVolume)

    RegisterKeyMapping('+loudspeaker', "Loud speaker", 'keyboard', Config.phoneLoudSpeaker)
    RegisterCommand('+loudspeaker', CycleVoiceProximity, false)
    RegisterCommand('-loudspeaker', function() end, false)

    RegisterNetEvent("lol:voice:phone:call:start2")
    AddEventHandler("lol:voice:phone:call:start2", function(serverId, callId)
        StartPhoneCall(callId, serverId)  
    end)

    RegisterNetEvent("lol:voice:phone:call:end")
    AddEventHandler("lol:voice:phone:call:end", function(serverId, callId)
        StopPhoneCall(serverId, callId)
    end)

    if Config.enableFilters.phone then
      local filters = {
          { filterType = "biquad",	type = "highpass", frequency = 500.0, q = 1.0,	gain = 0.0 },
          { filterType = "biquad",	type = "lowpass", frequency = 10000.0, q = 5.0,	gain = 0.0 },
          { filterType = "waveshaper",	type = "curve", distortion = 0, curve = GetDistortionCurve(0) },
      }

      UpdateContextFilter("phone", filters)
    end

    TriggerEvent("lol:voice:phone:ready")

    Debug("[Phone] Module Loaded")
end