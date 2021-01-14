local int_arcade1 = GetInteriorAtCoordsWithType(743.26500000,-816.71220000,21.66042000,"int_arcade")
local int_plan1 = GetInteriorAtCoordsWithType(710.87930000,-813.11000000,15.19892000,"int_plan")

RefreshInterior(int_arcade1)
RefreshInterior(int_plan1)

DisableInteriorProp(int_arcade1, "entity_set_arcade_set_ceiling_flat") --blue shell
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_ceiling_beams") --brick
EnableInteriorProp(int_arcade1, "entity_set_screens") -- TV sets
EnableInteriorProp(int_arcade1, "entity_set_big_screen") -- big telly
EnableInteriorProp(int_arcade1, "entity_set_constant_geometry") -- glass shelves + bar
EnableInteriorProp(int_arcade1, "entity_set_ret_light_no_neon")
EnableInteriorProp(int_arcade1, "ch_chint02_00_dropped_ceiling")
EnableInteriorProp(int_arcade1, "entity_set_hip_light_no_neon")
EnableInteriorProp(int_arcade1, "arcade_bar")
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_streetx4") --assault rifles
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_ceiling_mirror") --mirror ceiling

DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict_carpet") -- carpets
DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict") --dirty shell
DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict") --mud
DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict_clean_up") --dirt
DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict_clean_up") -- closed vending machines

EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_claw")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_monkey")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_patriot")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_retro")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_brawler")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_racer")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_love")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_cabs")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_gunner") --no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_teller")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_king") --no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_strife") --no

EnableInteriorProp(int_arcade1, "entity_set_plushie_01")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_02")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_03")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_04")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_05")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_06")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_07")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_08") -- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_09")-- a toy

DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_01") --signboard
DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_02")--signboard
DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_03")--signboard
DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_04")--signboard
DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_05")--signboard
EnableInteriorProp(int_arcade1, "entity_set_mural_neon_option_06")--signboard
EnableInteriorProp(int_arcade1, "entity_set_mural_neon_option_07")--signboard
EnableInteriorProp(int_arcade1, "entity_set_mural_neon_option_08")--signboard

DisableInteriorProp(int_arcade1, "entity_set_mural_option_01") --wall paint
DisableInteriorProp(int_arcade1, "entity_set_mural_option_02") --wall paint
DisableInteriorProp(int_arcade1, "entity_set_mural_option_03") --wall paint
DisableInteriorProp(int_arcade1, "entity_set_mural_option_04") --wall paint
DisableInteriorProp(int_arcade1, "entity_set_mural_option_05") --wall paint
EnableInteriorProp(int_arcade1, "entity_set_mural_option_06") --wall paint
DisableInteriorProp(int_arcade1, "entity_set_mural_option_07") --wall paint
DisableInteriorProp(int_arcade1, "entity_set_mural_option_08") --wall paint

DisableInteriorProp(int_arcade1, "entity_set_floor_option_01") --painted floor
DisableInteriorProp(int_arcade1, "entity_set_floor_option_02") --painted floor
DisableInteriorProp(int_arcade1, "entity_set_floor_option_03") --painted floor
EnableInteriorProp(int_arcade1, "entity_set_floor_option_04") --painted floor
DisableInteriorProp(int_arcade1, "entity_set_floor_option_05") --painted floor
DisableInteriorProp(int_arcade1, "entity_set_floor_option_06") --painted floor
DisableInteriorProp(int_arcade1, "entity_set_floor_option_07") --painted floor
DisableInteriorProp(int_arcade1, "entity_set_floor_option_08")--painted floor

EnableInteriorProp(int_plan1, "set_plan_casino") --casino on the table
EnableInteriorProp(int_plan1, "set_plan_computer") --comp
EnableInteriorProp(int_plan1, "set_plan_keypad")

EnableInteriorProp(int_plan1, "set_plan_hacker")
EnableInteriorProp(int_plan1, "set_plan_mechanic")
EnableInteriorProp(int_plan1, "set_plan_weapons")

EnableInteriorProp(int_plan1, "set_plan_vault")
EnableInteriorProp(int_plan1, "set_plan_wall") --stone wall
EnableInteriorProp(int_plan1, "set_plan_setup") --light for plan
EnableInteriorProp(int_plan1, "set_plan_bed") --the room
DisableInteriorProp(int_plan1, "set_plan_pre_setup") -- trash everywhere
DisableInteriorProp(int_plan1, "set_plan_no_bed") --trash in the bed
EnableInteriorProp(int_plan1, "set_plan_garage")
EnableInteriorProp(int_plan1, "set_plan_scribbles")
EnableInteriorProp(int_plan1, "set_plan_arcade_x4")
EnableInteriorProp(int_plan1, "set_plan_plans")
EnableInteriorProp(int_plan1, "set_plan_plastic_explosives")
EnableInteriorProp(int_plan1, "set_plan_cockroaches")
EnableInteriorProp(int_plan1, "set_plan_electric_drill")
EnableInteriorProp(int_plan1, "set_plan_vault_drill")
EnableInteriorProp(int_plan1, "set_plan_vault_laser")
EnableInteriorProp(int_plan1, "set_plan_stealth_outfits")
EnableInteriorProp(int_plan1, "set_plan_hacking_device")
EnableInteriorProp(int_plan1, "set_plan_gruppe_sechs_outfits")
EnableInteriorProp(int_plan1, "set_plan_fireman_helmet")
EnableInteriorProp(int_plan1, "set_plan_drone_parts")
EnableInteriorProp(int_plan1, "set_plan_vault_keycard_01a")
EnableInteriorProp(int_plan1, "set_plan_swipe_card_01b")
EnableInteriorProp(int_plan1, "set_plan_swipe_card_01a")
EnableInteriorProp(int_plan1, "set_plan_vault_drill_alt")
EnableInteriorProp(int_plan1, "set_plan_vault_laser_alt")
