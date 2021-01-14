Config = {}

Config.VehicleMenu = true -- enable this if you wan't a vehicle menu.
Config.VehicleMenuButton = 344 -- change this to the key you want to open the menu with. buttons: https://docs.fivem.net/game-references/controls/
Config.RangeCheck = 25.0 -- this is the change you will be able to control the vehicle.

Config.Garages = {
    ["A"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(215.92279052734,-809.75280761719,30.730318069458),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(229.96076965332,-798.373046875,30.470), 
                ["heading"] = 157.0,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = {  -- camera is not needed just if you want cool effects.
            ["x"] = 227.534, 
            ["y"] = -791.370, 
            ["z"] = 33.560, 
            ["rotationX"] = -31.401574149728, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -160.40157422423 
        }
    },

    ["B"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(273.67422485352, -344.15573120117, 44.919834136963),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(272.50082397461, -337.40579223633, 44.919834136963), 
                ["heading"] = 160.0,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = 283.28225708008, 
            ["y"] = -333.24017333984, 
            ["z"] = 50.004745483398, 
            ["rotationX"] = -21.637795701623, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 125.73228356242 
        }
    },

    ["C"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-1803.8967285156, -341.45928955078, 43.986347198486),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(-1810.7857666016, -337.13592529297, 43.552074432373), 
                ["heading"] = 320.0,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = -1813.5513916016, 
            ["y"] = -340.40087890625, 
            ["z"] = 46.962894439697, 
            ["rotationX"] = -39.496062710881, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -42.110235854983 
        }
    },

    ["D"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-69.272, -1831.736, 26.942),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(-56.404, -1837.997, 26.583), 
                ["heading"] = 320.0,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = -62.077, 
            ["y"] = -1836.178, 
            ["z"] = 29.942, 
            ["rotationX"] = -39.496062710881, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -100.110235854983 
        }
    },

    ["E"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(1738.005, 3711.975, 34.133),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(1724.141, 3714.975, 34.177), 
                ["heading"] = 20.0,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = 1728.876, 
            ["y"] = 3721.503, 
            ["z"] = 37.064, 
            ["rotationX"] = -30.496062710881, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -220.110235854983 
        }
    },

    ["F"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(125.202, 6644.688, 31.784),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(117.742, 6652.241, 30.776), 
                ["heading"] = 134.0,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = 117.909, 
            ["y"] = 6647.187, 
            ["z"] = 31.588, 
            ["rotationX"] = -0.496062710881, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -0.110235854983 
        }
    },

    ["MC"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(953.53881835938,-122.51171112061,74.353179931641),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(956.79351806641,-128.50393676758,74.065739440918), 
                ["heading"] = 218.956,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = 958.711, 
            ["y"] = -139.062, 
            ["z"] = 77.630, 
            ["rotationX"] = -0.496062710881, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -0.110235854983 
        }
    },

    ["G"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3( 1158.36, -466.84, 66.64),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3( 1145.32, -470.72, 66.56), 
                ["heading"] = 248.19,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = 1150.84, 
            ["y"] = -471.4, 
            ["z"] = 69.96, 
            ["rotationX"] = -29.637795701623, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 100.73228356242 
        }
    },

    
    ["H"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3( 55.48, -878.44, 30.36),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(40.64, -866.08, 30.52), 
                ["heading"] = 248.19,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = 43.44, 
            ["y"] = -879.2, 
            ["z"] = 38.32, 
            ["rotationX"] = -29.637795701623, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 10.73228356242 
        }
    },

    ["I"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-331.68, -782.04, 33.96),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(-347.32, -775.2, 33.96), 
                ["heading"] = 0.76,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = -344.72, 
            ["y"] = -779.16, 
            ["z"] = 36.32, 
            ["rotationX"] = -29.637795701623, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 10.73228356242 
        }
    },

    ["J"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-1611.08, -1018.08, 13.12),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(-1611.88, -1006.24, 13.0), 
                ["heading"] = 49.38,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = -1609.32, 
            ["y"] = -1010.84, 
            ["z"] = 16.0, 
            ["rotationX"] = -29.637795701623, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 10.73228356242 
        }
    },

    ["K"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-75.32, -2004.4, 18.0),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(-79.16, -1994.04, 18.0), 
                ["heading"] = 84.08,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = -73.64, 
            ["y"] = -1995.36, 
            ["z"] = 21.970, 
            ["rotationX"] = -29.637795701623, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 100.73228356242 
        }
    },

    ["L"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-1268.72, 278.56, 64.92),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(-1276.8, 270.72, 64.72), 
                ["heading"] = 231.58,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = -1283.59, 
            ["y"] = 274.51, 
            ["z"] = 68.48, 
            ["rotationX"] = -25.637795701623, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -87.73228356242 
        }
    },

    ["M"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-3144.72, 1118.92, 20.84),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(-3136.64, 1115.76, 20.68), 
                ["heading"] = 231.58,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = -3145.72, 
            ["y"] =  1114.4, 
            ["z"] = 25.72, 
            ["rotationX"] = -21.637795701623, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -87.73228356242 
        }
    },

    ["N"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(1695.04, 4785.68, 42.0),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(1687.56, 4797.72, 41.92), 
                ["heading"] = 180.58,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = 1689.64, 
            ["y"] =  4788.28, 
            ["z"] = 45.92, 
            ["rotationX"] = -29.637795701623, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 10.73228356242 
        }
    },

    ["Truck"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(913.513, -1273.216, 27.092),
                ["text"] = "[ ~o~E~s~ ] Garage",
            },
            ["vehicle"] = {
                ["position"] = vector3(912.942, -1259.862, 25.731), 
                ["heading"] = 5.744,
                ["text"] = "[ ~o~E~s~ ] Store Vehicle",
            }
        },
        ["camera"] = { 
            ["x"] = 901.102, 
            ["y"] = -1256.479, 
            ["z"] = 31.271, 
            ["rotationX"] = -21.637795701623, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -120.73228356242 
        }
    }
}


Config.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

Config.AlignMenu = "right" -- this is where the menu is located [left, right, center, top-right, top-left etc.]