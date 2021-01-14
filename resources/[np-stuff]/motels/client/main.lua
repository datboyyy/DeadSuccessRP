local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                   = nil
local PlayerId        = GetPlayerServerId (PlayerId ())
local robberyinPro    = false
local PlayerData = {}
local builtRooms = {}
local myRoom = {}
local myMotel = {}
local ownsMotel = false
local inmotel = false
local showmenushit = false
local showClothing = false
forcedID = 0
local roomInfo = {}
local depthZ = 75
hid = 0 
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
 ESX.PlayerData.job = job
end)



RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
 TriggerServerEvent('pw-motels:updateRooms')
end)


RegisterNetEvent('pw-motels:receiveOwners')
AddEventHandler('pw-motels:receiveOwners', function(rooms)
 Config.Rooms = rooms
 myMotel = {}

 ownsMotel = false

 for i=1, #Config.Rooms, 1 do
  roomid = Config.Rooms[i]
  if roomid.owner == PlayerId then
   ownsMotel = true
   myMotel = {id = roomid.roomno, motel = roomid.motelid}
  end
 end
end)

 local found = false

RegisterCommand('enterroom', function(source, args)
 local found = false
 local playerPed = PlayerPedId()
 local pCoords = GetEntityCoords(playerPed)
 local roomNumber = tonumber(args[1])
 if args[1] ~= nil then
  for i=1, #Config.Rooms, 1 do
   rid = Config.Rooms[i]
   if tonumber(rid.roomno) == roomNumber then
    motelDist = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, Config.Complexs[rid.motelid].x, Config.Complexs[rid.motelid].y, Config.Complexs[rid.motelid].z, true)
    if motelDist < 200 then
     entryDist = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, rid.entry.x, rid.entry.y, rid.entry.z, true)
     if entryDist < 1.2 then
      if rid.owner == PlayerId then
       depthZ = math.random(30, 150)
       TriggerServerEvent('hotel:createRoom', {id = rid.roomno, x = rid.entry.x, y = rid.entry.y, z = rid.entry.z-depthZ, outZ = rid.entry.outZ})
       showmenushit = true
       roomInfo = rid
       showClothing = true
      else
       if rid.lock then
        TriggerEvent('notification', 'Room Locked', 2)
       else
        TriggerServerEvent('hotel:createRoom', {id = rid.roomno, x = rid.entry.x, y = rid.entry.y, z = rid.entry.z-depthZ, outZ = rid.entry.outZ})
        showmenushit = false
        roomInfo = rid
        showClothing = true
       end
      end
     else
      TriggerEvent('notification', 'Room Locked', 2)
     end
    end
   end
  end
 else
  TriggerEvent('notification', 'Please specify a room number', 2)
 end
end)

RegisterCommand('breach', function(source, args)
 local playerPed = PlayerPedId()
 local pCoords = GetEntityCoords(playerPed)
 local found = false
 if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
  for i=1, #Config.Rooms, 1 do
   entryDist = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, Config.Rooms[i].entry.x, Config.Rooms[i].entry.y, Config.Rooms[i].entry.z, true)
   if entryDist < 1.0 and Config.Rooms[i].owner ~= nil then
    found = true
    roomInfo = Config.Rooms[i]
    TriggerServerEvent('hotel:createRoom', {id = Config.Rooms[i].roomno, x = Config.Rooms[i].entry.x, y = Config.Rooms[i].entry.y, z = Config.Rooms[i].entry.z-depthZ, outZ = Config.Rooms[i].entry.outZ})
   end
  end

  if not found then
   TriggerEvent('notification', "This room isn't owned", 2)
  end
 else
  TriggerEvent('notification', "You are not police", 2)
 end
end)

RegisterCommand('raidroom', function(source, args)
 local playerPed = PlayerPedId()
 local pCoords = GetEntityCoords(playerPed)
 local found = false
 if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
  for i=1, #Config.Rooms, 1 do
   entryDist = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, Config.Rooms[i].entry.x, Config.Rooms[i].entry.y, Config.Rooms[i].entry.z, true)
   if entryDist < 1.0 and Config.Rooms[i].owner ~= nil then
    found = true
    roomInfo = Config.Rooms[i]
    TriggerServerEvent('hotel:createRoom', {id = Config.Rooms[i].roomno, x = Config.Rooms[i].entry.x, y = Config.Rooms[i].entry.y, z = Config.Rooms[i].entry.z-depthZ})
    showmenushit = true
   end
  end

  if not found then
   TriggerEvent('notification', "This room isn't owned", 2)
  end
 else
  TriggerEvent('notification', "You are not police", 2)
 end
end)

function OpenStash(owner, motel, room)
 ESX.TriggerServerCallback("pw-motels:getPropertyInventoryBed", function(inventory)
  TriggerEvent("esx_inventoryhud:openMotelsInventoryBed", inventory, owner, motel, room)
 end, owner, motel, room)
end

function OpenInv(owner, motel, room)
 ESX.TriggerServerCallback("pw-motels:getPropertyInventory", function(inventory)
  TriggerEvent("esx_inventoryhud:openMotelsInventory", inventory, owner, motel, room)
 end, owner, motel, room)
end

-- Generate Room Markers
Citizen.CreateThread(function()
 while true do
  Citizen.Wait(1)
  local cid = exports["isPed"]:isPed("cid")
  player = PlayerPedId()
  myCoords = GetEntityCoords(player)


  for i=1, #Config.Complexs do
   complex = Config.Complexs[i]
   if GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, complex.reception.x, complex.reception.y, complex.reception.z, false) < 20 then
    if GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, complex.reception.x, complex.reception.y, complex.reception.z, false) < 2.5 then
     if ownsMotel then
      DrawText3D(complex.reception.x, complex.reception.y, complex.reception.z+0.25, "~w~Press ~g~E~w~ to renew your motel ($~g~"..complex.price.."~w~)")
     else
      DrawText3D(complex.reception.x, complex.reception.y, complex.reception.z+0.25, "~w~Press ~g~E~w~ to rent a motel room ($~g~"..complex.price.."~w~)")
     end
     if IsControlJustPressed(0, 38) then
      local allHotelS = {}
      local totalRooms = 0

      TriggerEvent('dooranim')

      for id,v in pairs(Config.Rooms) do
       if v.motelid == complex.id then
        allHotelS[totalRooms] = v

        if v.owner == nil then
         totalRooms = totalRooms + 1
        end
       end
      end


      if not ownsMotel then

       if totalRooms >= 1 then
        ESX.TriggerServerCallback('motels:mycash', function(cash)
         if cash >= complex.price then
          local testHotel = {}

          if totalRooms == 1 then
           testHotel = allHotelS[0]
          else
           testHotel = allHotelS[math.random(1, totalRooms)]
          end

          TriggerServerEvent('pw-motels:rentRoom', testHotel.roomno, testHotel.motelid)
         else
          TriggerEvent('notification', 'You do not have enough money in the bank', 2)
         end
        end)
       else
        TriggerEvent('notification', 'No rooms available', 2)
       end
      end

      if ownsMotel then
       if Config.Complexs[i].name == Config.Complexs[myMotel.motel].name then
        TriggerServerEvent('pw-motels:rentRoom', myMotel.id, myMotel.motel)
       else
        TriggerEvent('notification', "You can only renew your motel room at "..Config.Complexs[tonumber(myMotel.motel)].name, 2 )
       end
      end
     end
    end
   end
  end




  for i=1, #Config.Rooms, 1 do
   roomid = Config.Rooms[i]
   motel = roomid.motelid
   offset = Config.Complexs[motel].offsets

   entryDist = GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, roomid.entry.x, roomid.entry.y, roomid.entry.z, true)

   if entryDist < 10.0 then
    if roomid.owner == PlayerId then
     DrawMarker(20, roomid.entry.x, roomid.entry.y, roomid.entry.z+0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 43, 196, 253, 200, false, true, 2, 1, nil, nil, false)
    end
   end

   if entryDist < 1.5 then
    if roomid.owner == PlayerId then
     if roomid.lock then
      DrawText3D(roomid.entry.x, roomid.entry.y, roomid.entry.z+0.25, "~g~H~w~ to enter | ~g~G~w~ to unlock ("..roomid.roomno..')')
      if IsControlJustReleased(0,  Keys['G']) then
       TriggerEvent('notification', 'Unlocked!', 2)
       TriggerEvent('dooranim')
       TriggerServerEvent('pw-motels:toggleLock', roomid.motelid, roomid.roomno, false)
      end
      if IsControlJustReleased(0,  Keys['H']) then
       depthZ = math.random(30, 150)
       TriggerServerEvent('hotel:createRoom', {id = roomid.roomno, x = roomid.entry.x, y = roomid.entry.y, z = roomid.entry.z-depthZ, outZ = roomid.entry.outZ})
       showmenushit = true
       roomInfo = roomid
       showClothing = true
      end
     else 
      DrawText3D(roomid.entry.x, roomid.entry.y, roomid.entry.z+0.25, "~g~H~w~ to enter | ~g~G~w~ to lock ("..roomid.roomno..')')
      if IsControlJustReleased(0,  Keys['G']) then
       TriggerEvent('notification', 'Locked!', 2)
       TriggerEvent('dooranim')
       TriggerServerEvent('pw-motels:toggleLock', roomid.motelid, roomid.roomno, true)
      end
      if IsControlJustReleased(0,  Keys['H']) then
       TriggerServerEvent('hotel:createRoom', {id = roomid.roomno, x = roomid.entry.x, y = roomid.entry.y, z = roomid.entry.z-depthZ, outZ = roomid.entry.outZ})
       roomInfo = roomid
       showmenushit = true
       showClothing = true
       depthZ = math.random(30, 150)
      end
      if IsControlJustReleased(0,  Keys['J']) then
       TriggerServerEvent('pw-motels:cancelRoom', roomid.roomno, roomid.motelid)
      end
     end
    end
   end
  end

  if inmotel then
   exitDist = GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, myRoom.x - 1.15, myRoom.y - 4.2, myRoom.z+1.20, true)

   if exitDist < 1.0 then
     DrawText3D(myRoom.x - 1.15, myRoom.y - 4.2, myRoom.z + 1.20, "~g~H~w~ to leave")
     if IsControlJustReleased(0, Keys['H']) then
      TriggerServerEvent('hotel:deleteRoom', myRoom.id)
     -- TriggerServerEvent("kGetWeather")
     end
   end

  if showmenushit then

   clothDist = GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, myRoom.x-2, myRoom.y+ 2.5, myRoom.z+1.25, true)
   stashDist = GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, myRoom.x-1.6, myRoom.y+1.2, myRoom.z+1.15, true)
   if stashDist < 1.2 then
    num = GetPlayerServerId()
    DrawText3D(myRoom.x-1.6, myRoom.y+1.2, myRoom.z+1.25, "~g~E ~w~- access stash")
    if IsControlJustReleased(0, 38) then
      TriggerEvent("server-inventory-open", "1", "motel-stash"..myRoom.id)
      TriggerEvent('InteractSound_CL:PlayOnOne', 'zip', 0.6)
    end
  end
   stashDist2 = GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, myRoom.x+1.6, myRoom.y+0.3, myRoom.z+0.20, true)

   if stashDist2 < 2.5 then
    DrawText3D(myRoom.x+1.6, myRoom.y+0.3, myRoom.z+0.25, "~g~E~w~ - access bed stash")
    if IsControlJustReleased(0, 38) then
      TriggerEvent("server-inventory-open", "1", "motel-bed"..myRoom.id)
     TriggerEvent('InteractSound_CL:PlayOnOne', 'zip', 0.6)
    end
   end
 end
  end
 end
end)


RegisterNetEvent('hotel:sendToRoom')
AddEventHandler('hotel:sendToRoom', function(data)
 buildHotel(data)
end)

RegisterNetEvent('hotel:deleteRoom')
AddEventHandler('hotel:deleteRoom', function(data)
 removeHotel(data)
end)


function buildHotel(generator)
  TriggerEvent('outfit:canUse', true)
  myRoom = generator
  inmotel = true


 TriggerEvent('InteractSound_CL:PlayOnOne', 'doorenter', 0.8)
 TriggerEvent('notification', 'Please wait!')

  TriggerEvent('dooranim')
  Citizen.Wait(500)
  DoScreenFadeOut(100)
  Citizen.Wait(500)
  RequestModel(GetHashKey("np_motel_1"))
  while not HasModelLoaded(GetHashKey("np_motel_1")) do
   Citizen.Wait(0)
  end
	SetEntityCoords(PlayerPedId(), 152.09986877441, -1004.7946166992, -98.999984741211)
	Citizen.Wait(4500)

	builtRooms['building'] = CreateObject(GetHashKey("np_motel_1"),generator.x-0.695,generator.y-0.355,generator.z-90, false, false, false)
	builtRooms['frontDoor'] = CreateObject(GetHashKey("v_ilev_moteldoorcso"),generator.x-2.15,generator.y-4.28,generator.z+0.10, true, true, true)
	builtRooms['stuff'] = CreateObject(GetHashKey("v_49_motelmp_stuff"),generator.x,generator.y,generator.z, false, false, false)
	builtRooms['bed'] = CreateObject(GetHashKey("v_49_motelmp_bed"),generator.x+1.4,generator.y-0.55,generator.z, false, false, false)
	builtRooms['clothes'] = CreateObject(GetHashKey("v_49_motelmp_clothes"),generator.x-2.0,generator.y+2.0,generator.z+0.15, false, false, false)
	builtRooms['winframe'] = CreateObject(GetHashKey("v_49_motelmp_winframe"),generator.x+0.74,generator.y-4.26,generator.z+1.11, false, false, false)
	builtRooms['glass'] = CreateObject(GetHashKey("v_49_motelmp_glass"),generator.x+0.74,generator.y-4.26,generator.z+1.13, false, false, false)
	builtRooms['curtains'] = CreateObject(GetHashKey("v_49_motelmp_curtains"),generator.x+0.74,generator.y-4.17,generator.z+0.9, false, false, false)
	builtRooms['screen'] = CreateObject(GetHashKey("v_49_motelmp_screen"),generator.x-2.21,generator.y-0.6,generator.z+0.79, false, false, false)
	builtRooms['trainer1'] = CreateObject(GetHashKey("v_res_fa_trainer02r"),generator.x-1.9,generator.y+3.0,generator.z+0.38, false, false, false)
	builtRooms['trainer2'] = CreateObject(GetHashKey("v_res_fa_trainer02l"),generator.x-2.1,generator.y+2.95,generator.z+0.38, false, false, false)
	builtRooms['sink'] = CreateObject(GetHashKey("prop_sink_06"),generator.x+1.1,generator.y+4.0,generator.z, false, false, false)
	builtRooms['chair1'] = CreateObject(GetHashKey("prop_chair_04a"),generator.x+2.1,generator.y-2.4,generator.z, false, false, false)
	builtRooms['chair2'] = CreateObject(GetHashKey("prop_chair_04a"),generator.x+0.7,generator.y-3.5,generator.z, false, false, false)
	builtRooms['kettle'] = CreateObject(GetHashKey("prop_kettle"),generator.x-2.3,generator.y+0.6,generator.z+0.9, false, false, false)
	builtRooms['tvCabinet'] = CreateObject(GetHashKey("Prop_TV_Cabinet_03"),generator.x-2.3,generator.y-0.6,generator.z, false, false, false)
	builtRooms['tv'] = CreateObject(GetHashKey("prop_tv_06"),generator.x-2.3,generator.y-0.6,generator.z+0.7, false, false, false)
	builtRooms['toilet'] = CreateObject(GetHashKey("Prop_LD_Toilet_01"),generator.x+2.1,generator.y+2.9,generator.z, false, false, false)
	builtRooms['clock'] = CreateObject(GetHashKey("Prop_Game_Clock_02"),generator.x-2.55,generator.y-0.6,generator.z+2.0, false, false, false)
	builtRooms['phone'] = CreateObject(GetHashKey("v_res_j_phone"),generator.x+2.4,generator.y-1.9,generator.z+0.64, false, false, false)
	builtRooms['ironBoard'] = CreateObject(GetHashKey("v_ret_fh_ironbrd"),generator.x-1.7,generator.y+3.5,generator.z+0.15, false, false, false)
	builtRooms['iron'] = CreateObject(GetHashKey("prop_iron_01"),generator.x-1.9,generator.y+2.85,generator.z+0.63, false, false, false)
	builtRooms['mug1'] = CreateObject(GetHashKey("V_Ret_TA_Mug"),generator.x-2.3,generator.y+0.95,generator.z+0.9, false, false, false)
	builtRooms['mug2'] = CreateObject(GetHashKey("V_Ret_TA_Mug"),generator.x-2.2,generator.y+0.9,generator.z+0.9, false, false, false)
	builtRooms['binder'] = CreateObject(GetHashKey("v_res_binder"),generator.x-2.2,generator.y+1.3,generator.z+0.87, false, false, false)

	FreezeEntityPosition(builtRooms['building'], true)
  FreezeEntityPosition(builtRooms['frontDoor'], true)
	FreezeEntityPosition(builtRooms['sink'], true)
	FreezeEntityPosition(builtRooms['chair1'], true)
	FreezeEntityPosition(builtRooms['chair2'], true)
	FreezeEntityPosition(builtRooms['tvCabinet'], true)
	FreezeEntityPosition(builtRooms['tv'], true)
	SetEntityHeading(builtRooms['frontDoor'], GetEntityHeading(builtRooms['frontDoor'])+180)
	SetEntityHeading(builtRooms['chair1'], GetEntityHeading(builtRooms['chair1'])+270)
	SetEntityHeading(builtRooms['chair2'], GetEntityHeading(builtRooms['chair2'])+180)
	SetEntityHeading(builtRooms['kettle'], GetEntityHeading(builtRooms['kettle'])+90)
	SetEntityHeading(builtRooms['tvCabinet'], GetEntityHeading(builtRooms['tvCabinet'])+90)
	SetEntityHeading(builtRooms['tv'], GetEntityHeading(builtRooms['tv'])+90)
	SetEntityHeading(builtRooms['toilet'], GetEntityHeading(builtRooms['toilet'])+270)
	SetEntityHeading(builtRooms['clock'], GetEntityHeading(builtRooms['clock'])+90)
	SetEntityHeading(builtRooms['phone'], GetEntityHeading(builtRooms['phone'])+220)
	SetEntityHeading(builtRooms['ironBoard'], GetEntityHeading(builtRooms['ironBoard'])+90)
	SetEntityHeading(builtRooms['iron'], GetEntityHeading(builtRooms['iron'])+230)
	SetEntityHeading(builtRooms['mug1'], GetEntityHeading(builtRooms['mug1'])+20)
	SetEntityHeading(builtRooms['mug2'], GetEntityHeading(builtRooms['mug2'])+230)

  Citizen.Wait(2500)
  SetEntityCoords(PlayerPedId(), generator.x-1.0755,generator.y-4.20,generator.z+0.10)
  SetEntityHeading(PlayerPedId(), 350.25)
  FreezeEntityPosition(PlayerPedId(), true)
  Wait(2000)
  FreezeEntityPosition(PlayerPedId(), false)
  DoScreenFadeIn(500)
end

function removeHotel(pos)
 TriggerEvent('outfit:canUse', false)
 showClothing = false
 inmotel = false
 showmenushit = false
 TriggerEvent('dooranim')
 TriggerEvent('InteractSound_CL:PlayOnOne', 'doorexit', 0.8)

 Citizen.Wait(500)
 DoScreenFadeOut(250)
 Citizen.Wait(1000)

 for id,v in pairs(builtRooms) do
  DeleteObject(v)
 end

 SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.outZ)
 SetEntityHeading(PlayerPedId(), pos.heading)
 Citizen.Wait(1000)
 DoScreenFadeIn(250)
end



-- Generate Motel Blips
Citizen.CreateThread(function()
 for i=1, #Config.Complexs, 1 do
  Complex = AddBlipForCoord(tonumber(Config.Complexs[i].x), tonumber(Config.Complexs[i].y), tonumber(Config.Complexs[i].z))
  SetBlipSprite (Complex, 350)
  SetBlipColour(Complex, 9)
  SetBlipDisplay(Complex, 4)
  SetBlipScale  (Complex, 0.6)
  SetBlipAsShortRange(Complex, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('Motel')
  EndTextCommandSetBlipName(Complex)
 end
end)


RegisterNetEvent('dooranim')
AddEventHandler('dooranim', function()
 ClearPedSecondaryTask(GetPlayerPed(-1))
 loadAnimDict("anim@heists@keycard@")
 TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
 Citizen.Wait(850)
 ClearPedTasks(GetPlayerPed(-1))
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end


function DrawText3D(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)

  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end