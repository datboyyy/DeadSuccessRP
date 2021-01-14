-- RegisterCommand("jailmenu", function(source, args)

-- 	if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" then
-- 		OpenJailMenu()
-- 	else
-- 		ESX.ShowNotification("You are not an officer!")
-- 	end
-- end)

function LoadAnim(animDict)
	RequestAnimDict(animDict)

	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

function LoadModel(model)
	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(10)
	end
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

function Cutscene()
	DoScreenFadeOut(100)
	Citizen.Wait(500)
	TriggerEvent('InteractSound_CL:PlayOnOne', 'handcuff', 1.0)

	local Male = GetHashKey("mp_m_freemode_01")
	TriggerEvent('skinchanger:getSkin', function(skin)

    end)

	LoadModel(-1320879687)
	local PolicePosition = Config.Cutscene["PolicePosition"]
	local Police = CreatePed(5, -1320879687, PolicePosition["x"], PolicePosition["y"], PolicePosition["z"], PolicePosition["h"], false)
	TaskStartScenarioInPlace(Police, "WORLD_HUMAN_PAPARAZZI", 0, false)
	local PlayerPosition = Config.Cutscene["PhotoPosition"]
	local PlayerPed = PlayerPedId()
	SetEntityCoords(PlayerPed, PlayerPosition["x"], PlayerPosition["y"], PlayerPosition["z"] - 1)
	SetEntityHeading(PlayerPed, PlayerPosition["h"])
	FreezeEntityPosition(PlayerPed, true)
	Citizen.Wait(1500)
	Cam()
	DoScreenFadeIn(100)
	Citizen.Wait(10000)	
	DoScreenFadeOut(250)
	local JailPosition = Config.JailPositions["Cell"]
	SetEntityCoords(PlayerPed, JailPosition["x"], JailPosition["y"], JailPosition["z"])
	DeleteEntity(Police)
	SetModelAsNoLongerNeeded(-1320879687)
	Citizen.Wait(1000)
	TriggerEvent('InteractSound_CL:PlayOnOne', 'cell', 1.0)
	Citizen.Wait(2000)
	DoScreenFadeIn(500)
	RenderScriptCams(false,  false,  0,  true,  true)
	FreezeEntityPosition(PlayerPed, false)
	DestroyCam(Config.Cutscene["CameraPos"]["cameraId"])
	InJail()
end

function Cam()
	local CamOptions = Config.Cutscene["CameraPos"]
	CamOptions["cameraId"] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(CamOptions["cameraId"], CamOptions["x"], CamOptions["y"], CamOptions["z"])
	SetCamRot(CamOptions["cameraId"], CamOptions["rotationX"], CamOptions["rotationY"], CamOptions["rotationZ"])
	RenderScriptCams(true, false, 0, true, true)	
end


Citizen.CreateThread(function()
	local blip = AddBlipForCoord(1846.045, 2566.024, 45.5649)

    SetBlipSprite (blip, 188)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.8)
    SetBlipColour (blip, 49)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Boilingbroke Penitentiary')
    EndTextCommandSetBlipName(blip)
end)