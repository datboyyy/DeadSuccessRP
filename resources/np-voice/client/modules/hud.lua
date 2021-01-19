function PlayRemoteRadioClick(transmitting)
    if transmitting and Settings.remoteClickOn or not transmitting and Settings.remoteClickOff then
        SendNUIMessage({ type = 'remoteClick', state = transmitting})
    end
end

function PlayLocalRadioClick(transmitting)
    if transmitting and Settings.localClickOn or not transmitting and Settings.localClickOff then
        SendNUIMessage({ type = 'localClick', state = transmitting})
        TriggerEvent("hud:voice:transmitting", transmitting)
    end
end

function UpdateRadioPowerState(state)
    SendNUIMessage({ type = 'radioPowerState', state = state })
end

function UpdateHudSettings()
    SendNUIMessage({ type = 'settings', settings = Settings })
end