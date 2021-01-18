
Config = {}
Config.Locale = 'en'

Config.KickPossibleCheaters = true -- If true it will kick the player that tries store a vehicle that they changed the Hash or Plate.
Config.UseCustomKickMessage = true -- If KickPossibleCheaters is true you can set a Custom Kick Message in the locales.

Config.UseDamageMult = true -- If true it costs more to store a Broken Vehicle.
Config.DamageMult = 2 -- Higher Number = Higher Repair Price.

Config.CarPoundPrice      = 375 -- Car Pound Price.
Config.BoatPoundPrice     = 550 -- Boat Pound Price.
Config.AircraftPoundPrice = 2500 -- Aircraft Pound Price.

Config.PolicingPoundPrice  = 175 -- Policing Pound Price.
Config.AmbulancePoundPrice = 175 -- Ambulance Pound Price.

Config.UseCarGarages        = true -- Allows use of Car Garages.
Config.UseBoatGarages       = false -- Allows use of Boat Garages.
Config.UseAircraftGarages   = false -- Allows use of Aircraft Garages.
Config.UseJobCarGarages     = false -- Allows use of Job Garages.

Config.DontShowPoundCarsInGarage = false -- If set to true it won't show Cars at the Pound in the Garage.
Config.ShowVehicleLocation       = true -- If set to true it will show the Location of the Vehicle in the Pound/Garage in the Garage menu.
Config.UseVehicleNamesLua        = true -- Must setup a vehicle_names.lua for Custom Addon Vehicles.

Config.ShowGarageSpacer1 = true -- If true it shows Spacer 1 in the List.
Config.ShowGarageSpacer2 = false -- If true it shows Spacer 2 in the List | Don't use if spacer3 is set to true.
Config.ShowGarageSpacer3 = true -- If true it shows Spacer 3 in the List | Don't use if Spacer2 is set to true.

Config.ShowPoundSpacer2 = false -- If true it shows Spacer 2 in the List | Don't use if spacer3 is set to true.
Config.ShowPoundSpacer3 = true -- If true it shows Spacer 3 in the List | Don't use if Spacer2 is set to true.

Config.MarkerType   = 1
Config.DrawDistance = 100.0

Config.BlipGarage = {
	Sprite = 290,
	Color = 38,
	Display = 2,
	Scale = 0.8
}

Config.BlipGaragePrivate = {
	Sprite = 290,
	Color = 53,
	Display = 2,
	Scale = 0.8
}

Config.BlipPound = {
	Sprite = 380,
	Color = 64,
	Display = 2,
	Scale = 0.8
}

Config.BlipJobPound = {
	Sprite = 380,
	Color = 49,
	Display = 2,
	Scale = 0.8
}

Config.PointMarker = {
	r = 0, g = 255, b = 0,     -- Green Color
	x = 1.5, y = 1.5, z = 1.0  -- Standard Size Circle
}

Config.DeleteMarker = {
	r = 255, g = 0, b = 0,     -- Red Color
	x = 5.0, y = 5.0, z = 1.0  -- Big Size Circle
}

Config.PoundMarker = {
	r = 0, g = 0, b = 100,     -- Blue Color
	x = 1.5, y = 1.5, z = 1.0  -- Standard Size Circle
}

Config.JobPoundMarker = {
	r = 255, g = 0, b = 0,     -- Red Color
	x = 1.5, y = 1.5, z = 1.0  -- Standard Size Circle
}

-- Start of Jobs

Config.PolicePounds = {
	Pound_LosSantos = {
		PoundPoint = { x = 374.42, y = -1620.68, z = 28.29 },
		SpawnPoint = { x = 391.74, y = -1619.0, z = 28.29, h = 318.34 }
	},
	Pound_Sandy = {
		PoundPoint = { x = 1646.01, y = 3812.06, z = 37.65 },
		SpawnPoint = { x = 1627.84, y = 3788.45, z = 33.77, h = 308.53 }
	},
	Pound_Paleto = {
		PoundPoint = { x = -223.6, y = 6243.37, z = 30.49 },
		SpawnPoint = { x = -230.88, y = 6255.89, z = 30.49, h = 136.5 }
	}
}

Config.AmbulancePounds = {
	Pound_LosSantos = {
		PoundPoint = { x = 374.42, y = -1620.68, z = 28.29 },
		SpawnPoint = { x = 391.74, y = -1619.0, z = 28.29, h = 318.34 }
	},
	Pound_Sandy = {
		PoundPoint = { x = 1646.01, y = 3812.06, z = 37.65 },
		SpawnPoint = { x = 1627.84, y = 3788.45, z = 33.77, h = 308.53 }
	},
	Pound_Paleto = {
		PoundPoint = { x = -223.6, y = 6243.37, z = 30.49 },
		SpawnPoint = { x = -230.88, y = 6255.89, z = 30.49, h = 136.5 }
	}
}

-- End of Jobs
-- Start of Cars

Config.CarGarages = {
	Garage_CentralLS = {
		GaragePoint = { x = 55.97, y = -876.36, z = 29.61 },
		SpawnPoint = { x = 53.08, y = -880.88, z = 29.83, h = 65.41 },
		DeletePoint = { x = 19.35, y = -888.32, z = 29.61 }
	},
	Garage_Sandy = {
		GaragePoint = { x = 1737.59, y = 3710.2, z = 33.14 },
		SpawnPoint = { x = 1737.84, y = 3719.28, z = 33.04, h = 21.22 },
		DeletePoint = { x = 1746.31, y = 3719.86, z = 33.21 }
	},
	Garage_Paleto = {
		GaragePoint = { x = 105.359, y = 6613.586, z = 31.3973 },
		SpawnPoint = { x = 128.7822, y = 6622.9965, z = 30.7828, h = 315.01 },
		DeletePoint = { x = 126.3572, y = 6608.4150, z = 30.8565 }
	},
	Garage_Grove = {
		GaragePoint = { x = -73.31, y = -1821.73, z = 26.12 },
		SpawnPoint = { x = -69.04, y = -1830.43, z = 26.94, h = 317.91 },
		DeletePoint = { x = -47.56, y = -1845.62, z = 25.09 }
	},
	Garage_PlayBoy = {
		GaragePoint = { x = -1231.17, y = -663.71, z = 29.73 },
		SpawnPoint = { x = -1229.18, y = -667.29, z = 30.72, h = 240.24 },
		DeletePoint = { x = -1208.11, y = -657.33, z = 29.65 }
	},
	Garage_PinkCage = {
		GaragePoint = { x = 275.69, y = -344.78, z = 44.17 },
		SpawnPoint = { x = 289.66, y = -341.62, z = 44.92, h = 170.81 },
		DeletePoint = { x = 276.07, y = -323.84, z = 44.17 }
	},
	Garage_West_Vinewood = {
		GaragePoint = { x = -340.68, y = 266.04, z = 84.67 },
		SpawnPoint = { x = -344.80, y = 273.36, z = 85.36, h = 359.73 },
		DeletePoint = { x = -330.04, y = 270.19, z = 85.26 }
	},
	Garage_PizzaJob = {
		GaragePoint = { x = 596.48, y = 90.68, z = 92.12 },
		SpawnPoint = { x = 601.04, y = 90.24, z = 92.35, h = 339.22 },
		DeletePoint = { x = 597.46, y = 85.33, z = 91.70 }
	},
	Garage_MirrorPark = {
		GaragePoint = { x = 1036.18, y = -763.36, z = 57.01 },
		SpawnPoint = { x = 1039.62, y = -770.09, z = 58.02, h = 195.42 },
		DeletePoint = { x = 1012.33, y = -766.24, z = 57.01 }
	},
	Garage_SouthVespucci = {
		GaragePoint = { x = -1184.38, y = -1509.41, z = 4.65},
		SpawnPoint = { x = -1184.8, y = -1501.55, z = 3.87, h = 215.82 },
		DeletePoint = { x = -1021.02, y = -1480.02, z = 3.87 }
	},
}

Config.CarPounds = {
	Pound_LosSantos = {
		PoundPoint = { x = 408.61, y = -1625.47, z = 28.29 },
		SpawnPoint = { x = 405.64, y = -1643.4, z = 27.61, h = 229.54 }
	},
	Pound_Sandy = {
		PoundPoint = { x = 1651.38, y = 3804.84, z = 37.65 },
		SpawnPoint = { x = 1627.84, y = 3788.45, z = 33.77, h = 308.53 }
	},
	Pound_Paleto = {
		PoundPoint = { x = -234.82, y = 6198.65, z = 30.84 },
		SpawnPoint = { x = -230.08, y = 6190.24, z = 30.49, h = 140.24 }
	},
	PoundLuxAutos = {
		PoundPoint = { x = -722.92, y = -425.39, z = 34.57 },
		SpawnPoint = { x = -731.35, y = -408.68, z = 35.24, h = 176.29 }
	}	
}

-- End of Cars
-- Start of Boats

Config.BoatGarages = {
	Garage_LSDock = {
		GaragePoint = { x = -735.87, y = -1325.08, z = 0.6 },
		SpawnPoint = { x = -718.87, y = -1320.18, z = -0.47477427124977, h = 45.0 },
		DeletePoint = { x = -731.15, y = -1334.71, z = -0.47477427124977 }
	},
	Garage_SandyDock = {
		GaragePoint = { x = 1333.2, y = 4269.92, z = 30.5 },
		SpawnPoint = { x = 1334.61, y = 4264.68, z = 29.86, h = 87.0 },
		DeletePoint = { x = 1323.73, y = 4269.94, z = 29.86 }
	},
	Garage_PaletoDock = {
		GaragePoint = { x = -283.74, y = 6629.51, z = 6.3 },
		SpawnPoint = { x = -290.46, y = 6622.72, z = -0.47477427124977, h = 52.0 },
		DeletePoint = { x = -304.66, y = 6607.36, z = -0.47477427124977 }
	}
}

Config.BoatPounds = {
	Pound_LSDock = {
		PoundPoint = { x = -738.67, y = -1400.43, z = 4.0 },
		SpawnPoint = { x = -738.33, y = -1381.51, z = 0.12, h = 137.85 }
	},
	Pound_SandyDock = {
		PoundPoint = { x = 1299.36, y = 4217.93, z = 32.91 },
		SpawnPoint = { x = 1294.35, y = 4226.31, z = 29.86, h = 345.0 }
	},
	Pound_PaletoDock = {
		PoundPoint = { x = -270.2, y = 6642.43, z = 6.36 },
		SpawnPoint = { x = -290.38, y = 6638.54, z = -0.47477427124977, h = 130.0 }
	}
}

-- End of Boats
-- Start of Aircrafts

Config.AircraftGarages = {
	Garage_LSAirport = {
		GaragePoint = { x = -1617.14, y = -3145.52, z = 12.99 },
		SpawnPoint = { x = -1657.99, y = -3134.38, z = 12.99, h = 330.11 },
		DeletePoint = { x = -1642.12, y = -3144.25, z = 12.99 }
	},
	Garage_SandyAirport = {
		GaragePoint = { x = 1723.84, y = 3288.29, z = 40.16 },
		SpawnPoint = { x = 1710.85, y = 3259.06, z = 40.69, h = 104.66 },
		DeletePoint = { x = 1714.45, y = 3246.75, z = 40.07 }
	},
	Garage_GrapeseedAirport = {
		GaragePoint = { x = 2152.83, y = 4797.03, z = 40.19 },
		SpawnPoint = { x = 2122.72, y = 4804.85, z = 40.78, h = 115.04 },
		DeletePoint = { x = 2082.36, y = 4806.06, z = 40.07 }
	}
}

Config.AircraftPounds = {
	Pound_LSAirport = {
		PoundPoint = { x = -1243.0, y = -3391.92, z = 12.94 },
		SpawnPoint = { x = -1272.27, y = -3382.46, z = 12.94, h = 330.25 }
	}
}