Citizen.CreateThread(function()
     while true do
          Citizen.Wait(0)
          SetPlayerHealthRechargeLimit(PlayerId(), 0.0)
     end
end)

Citizen.CreateThread(function()
    if Config.Debug then
        while true do
            local limbs = ''
            for k, v in pairs(injured) do
                if limbs ~= '' then
                    limbs = limbs .. '~s~, ~r~' .. v.part .. '~s~[~r~' .. v.severity .. '~s~]'
                else
                    limbs = v.part .. '~s~[~r~' .. v.severity .. '~s~]'
                end
            end

            DrawUIText(4, 0, 0.015, 0.78, 0.35, 255, 255, 255, 255, 'Hospitalized: ~r~' .. tostring(isInHospitalBed))
            DrawUIText(4, 0, 0.015, 0.76, 0.35, 255, 255, 255, 255, 'Hidden Usable: ~r~' .. tostring(not usedHiddenRev))
            DrawUIText(4, 0, 0.015, 0.74, 0.35, 255, 255, 255, 255, 'Injured: ~r~' .. limbs)
            DrawUIText(4, 0, 0.015, 0.72, 0.35, 255, 255, 255, 255, 'Next Damage: ~r~' .. tonumber(isBleeding) * Config.BleedTickDamage)
            DrawUIText(4, 0, 0.015, 0.7, 0.35, 255, 255, 255, 255, 'Bleed: ~r~' .. bleedTickTimer .. '~s~ / ~r~' .. Config.BleedTickRate .. '~s~ | ~r~' .. isBleeding)
            DrawUIText(4, 0, 0.015, 0.68, 0.35, 255, 255, 255, 255, 'Adv. Bleed: ~r~' .. advanceBleedTimer .. '~s~ / ~r~' .. Config.AdvanceBleedTimer)
            DrawUIText(4, 0, 0.015, 0.66, 0.35, 255, 255, 255, 255, 'Fadeout: ~r~' .. fadeOutTimer .. '~s~ / ~r~' .. Config.FadeOutTimer)
            DrawUIText(4, 0, 0.015, 0.64, 0.35, 255, 255, 255, 255, 'Blackout: ~r~' .. blackoutTimer .. '~s~ / ~r~' .. Config.BlackoutTimer)
            DrawUIText(4, 0, 0.015, 0.62, 0.35, 255, 255, 255, 255, 'Adrenaline: ~r~' .. onDrugs .. ' ~s~| ~r~' .. tostring(wasOnDrugs))
            DrawUIText(4, 0, 0.015, 0.60, 0.35, 255, 255, 255, 255, 'Painkiller: ~r~' .. onPainKiller .. ' ~s~| ~r~' .. tostring(wasOnPainKillers))
            DrawUIText(4, 0, 0.015, 0.58, 0.35, 255, 255, 255, 255, 'Limping: ~r~' .. tostring(IsInjuryCausingLimp() and not (onPainKiller > 0)))
            Citizen.Wait(1)
        end
    end
end)