Config = {}

Config.ItemNeeded = "laptop" -- put any item here for item to hack.
Config.MaxLives = 3 -- this is the max lives in hacking thing 5 is max.
Config.CopsNeeded = 0 -- this is how many cops it needs to be. haha

Config.Banks = {
    ["Main Fleeca"] = {
        ["start"] = { 
            ["pos"] = vector3(-2956.5498046875, 481.62054443359, 15.697087287903), 
            ["heading"] = 359.48452758789 
        },
        ["door"] = { 
            ["pos"] = vector3(-2957.7080078125, 481.89660644531, 15.697031974792),
            ["model"] = -63539571
        },
        ["device"] = {
            ["model"] = -160937700
        },
        ["trolleys"] = {
            ["left"] = { 
                ["pos"] = vector3(-2952.837890625, 485.85018920898, 15.675424575806), 
                ["heading"] = 315.0 + 180.0
            },
            ["right"] = { 
                ["pos"] = vector3(-2952.984375, 482.74969482422, 15.675343513489), 
                ["heading"] = 220.0 + 180.0
            },
        }
    }
}

Config.Trolley = {
    ["cash"] = { 1 }, -- this is what you receive every cash stack math.random(1, 2)
    ["model"] = GetHashKey("hei_prop_hei_cash_trolly_01")
}

Config.EmptyTrolley = {
    ["model"] = GetHashKey("hei_prop_hei_cash_trolly_03")
}