local beds = {
    { x = 359.46, y = -586.23, z = 44.20, h = 255.05, taken = false, model = 1631638868 },
    { x = 311.34, y = -582.71, z = 44.20, h = -161.03, taken = false, model = -1091386327 },
    { x = 317.88, y = -585.28, z = 44.20, h = -172.71, taken = false, model = 1631638868 },
    { x = 324.14, y = -582.90, z = 44.20, h = -351.42, taken = false, model = -1091386327 },
    { x = 322.76, y = -587.14, z = 44.20, h = 167.72, taken = false, model = -1091386327 },
    { x = 361.29, y = -581.31, z = 44.19, h = 77.75, taken = false, model = -1091386327 },
    { x = 313.84, y = -579.11, z = 44.20, h = -74.29, taken = false, model = -1091386327 },
    { x = 365.49, y = -585.90, z = 44.21, h = -68.55, taken = false, model = -1091386327 },
    { x = 363.72, y = -588.94, z = 44.21, h = 223.39, taken = false, model = 2117668672 },
    { x = 357.28, y = -598.10, z = 43.99, h = 264.68, taken = false, model = 2117668672 },
    { x = 354.16, y = -593.23, z = 43.99, h = 45.23, taken = false, model = 2117668672 },
    { x = 346.83, y = -590.02, z = 43.99, h = 130.43, taken = false, model = 2117668672 },
}

local bedsTaken = {}

AddEventHandler('playerDropped', function()
    if bedsTaken[source] ~= nil then
        beds[bedsTaken[source]].taken = false
    end
end)

RegisterServerEvent('mythic_hospital:server:RequestBed')
AddEventHandler('mythic_hospital:server:RequestBed', function()
    for k, v in pairs(beds) do
        if not v.taken then
            v.taken = true
            bedsTaken[source] = k
            TriggerClientEvent('mythic_hospital:client:SendToBed', source, k, v)
            return
        end
    end

    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'No Beds Available' })
end)

RegisterServerEvent('mythic_hospital:server:RPRequestBed')
AddEventHandler('mythic_hospital:server:RPRequestBed', function(plyCoords)
    local foundbed = false
    for k, v in pairs(beds) do
        local distance = #(vector3(v.x, v.y, v.z) - plyCoords)
        if distance < 3.0 then
            if not v.taken then
                v.taken = true
                foundbed = true
                TriggerClientEvent('mythic_hospital:client:RPSendToBed', source, k, v)
                return
            else
                TriggerEvent('chatMessage', '', { 0, 0, 0 }, 'NThat Bed Is Taken')
            end
        end
    end

    if not foundbed then
        TriggerEvent('chatMessage', '', { 0, 0, 0 }, 'Not Near A Hospital Bed')
    end
end)

RegisterServerEvent('mythic_hospital:server:EnteredBed')
AddEventHandler('mythic_hospital:server:EnteredBed', function()
    local src = source
    local totalBill = CalculateBill(GetCharsInjuries(src), Config.InjuryBase)

    
    if BillPlayer(src, totalBill) then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { text = 'You\'ve Been Treated & Billed', type = 'inform', style = { ['background-color'] = '#760036' }})
        TriggerClientEvent('mythic_hospital:client:FinishServices', src, false, true)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { text = 'You were revived, but did not have the funds to cover further medical services', type = 'inform', style = { ['background-color'] = '#760036' }})
        TriggerClientEvent('mythic_hospital:client:FinishServices', src, false, false)
    end
end)

RegisterServerEvent('mythic_hospital:server:LeaveBed')
AddEventHandler('mythic_hospital:server:LeaveBed', function(id)
    beds[id].taken = false
end)