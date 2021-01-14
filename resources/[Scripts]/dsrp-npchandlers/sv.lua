--Stop Models from spawning
-- Server Side Suppression

BlacklistedModels = {
    [`a_c_seagull`] = true,
    [`a_c_pigeon`] = true,
    [`s_m_y_armymech_01`] = true,
    [`csb_mweather`] = false,
    [`csb_ramp_marine`] = true,
    [`s_m_m_marine_01`] = true,
    [`s_m_y_marine_01`] = true,
    [`s_m_m_marine_02`] = true,
    [`s_m_y_marine_02`] = true,
    [`s_m_m_marine_03`] = true,
    [`s_m_y_sway_01`] = true,
    [`s_f_y_cop_01`] = true,
    [`s_m_y_cop_01`] = true,
    [`csb_cop`] = true,
    [`s_m_y_hway_cop_01`] = true,
    [`s_m_m_security_01`] = true,
    [`mp_m_securoguard_01`] = true,
    [`a_m_m_hillbilly_02`] = {car = `sanchez`},

    --Vehicles to supress from spawning on the street
    [`blimp`] = true,
    [`blimp2`] = true,
    [`JET`] = true,
    [`LAZER`] = true,
    [`TITAN`] = true,
    [`BARRACKS`] = true,
    [`BARRACKS2`] = true,
    [`CRUSADER`] = true,
    [`RHINO`] = true,
    [`POLICE`] = true,
    [`POLICE2`] = true,
    [`POLICE3`] = true,
    [`POLICE4`] = true,
    [`POLMAV`] = true,
    [`PREDATOR`] = true,
    [`AMBULANCE`] = true,
    [`BUZZARD`] = true,
    [`AIRTUG`] = true,
    [`BUZZARD2`] = true,
    [`CARGOBOB`] = true,
    [`CARGOBOB2`] = true,
    [`CARGOBOB3`] = true,
    [`CARGOBOB4`] = true,
    [`SHERIFF`] = true,
    [`FROGGER`] = true,
    [`FIRETRUK`] = true,
    [`SHERIFF2`] = true,
}

RegisterNetEvent('entityCreating')
AddEventHandler('entityCreating', function(entity)
    local model = GetEntityModel(entity)
    local ref = BlacklistedModels[model]
    if not ref then return end
    if ref == true then 
        CancelEvent()
        return
    end
    if ref.car then 

        local veh = GetVehiclePedIsIn(entity, false)
        if veh ~= 0 and GetEntityModel(veh) == ref.car then 
            DeleteEntity(veh)
            CancelEvent()
        end
    end
end)


--[[AddEventHandler('explosionEvent', function(sender, ev)
    CancelEvent()
    print(GetPlayerName(sender), json.encode(ev))
end)]]--

RegisterNetEvent('peds:rogue')
AddEventHandler('peds:rogue', function(toDelete)
  if toDelete == nil then return end

  TriggerClientEvent("peds:rogue:delete", toDelete)
end)