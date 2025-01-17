Citizen.CreateThread(function()
    RequestIpl("gabz_pillbox_milo_")
  
    local interiorID = GetInteriorAtCoords(311.2546, -592.4204, 42.32737)
  
    if IsValidInterior(interiorID) then
      RemoveIpl("rc12b_fixed")
      RemoveIpl("rc12b_destroyed")
      RemoveIpl("rc12b_default")
      RemoveIpl("rc12b_hospitalinterior_lod")
      RemoveIpl("rc12b_hospitalinterior")
      RefreshInterior(interiorID)
    end
  end)


Citizen.CreateThread(function()


    RequestIpl("gabz_import_milo_")
    
        interiorID = GetInteriorAtCoords(941.00840000, -972.66450000, 39.14678000)
        
        
        if IsValidInterior(interiorID) then
        --EnableInteriorProp(interiorID, "basic_style_set")
        --EnableInteriorProp(interiorID, "urban_style_set")		
        EnableInteriorProp(interiorID, "branded_style_set")
        EnableInteriorProp(interiorID, "car_floor_hatch")
        
        RefreshInterior(interiorID)
        
        end
        
    end)
    




---- arcade ---
local int_arcade1 = GetInteriorAtCoordsWithType(743.26500000, -816.71220000, 21.66042000, "int_arcade")
local int_plan1 = GetInteriorAtCoordsWithType(710.87930000, -813.11000000, 15.19892000, "int_plan")

RefreshInterior(int_arcade1)
RefreshInterior(int_plan1)

DisableInteriorProp(int_arcade1, "entity_set_arcade_set_ceiling_flat")--blue shell
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_ceiling_beams")--brick
EnableInteriorProp(int_arcade1, "entity_set_screens")-- TV sets
EnableInteriorProp(int_arcade1, "entity_set_big_screen")-- big telly
EnableInteriorProp(int_arcade1, "entity_set_constant_geometry")-- glass shelves + bar
EnableInteriorProp(int_arcade1, "entity_set_ret_light_no_neon")
EnableInteriorProp(int_arcade1, "ch_chint02_00_dropped_ceiling")
EnableInteriorProp(int_arcade1, "entity_set_hip_light_no_neon")
EnableInteriorProp(int_arcade1, "arcade_bar")
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_streetx4")--assault rifles
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_ceiling_mirror")--mirror ceiling

DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict_carpet")-- carpets
DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict")--dirty shell
DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict")--mud
DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict_clean_up")--dirt
DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict_clean_up")-- closed vending machines

EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_claw")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_monkey")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_patriot")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_retro")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_brawler")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_racer")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_love")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_cabs")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_gunner")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_teller")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_king")--no
EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_strife")--no

EnableInteriorProp(int_arcade1, "entity_set_plushie_01")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_02")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_03")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_04")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_05")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_06")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_07")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_08")-- a toy
EnableInteriorProp(int_arcade1, "entity_set_plushie_09")-- a toy

DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_01")--signboard
DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_02")--signboard
DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_03")--signboard
DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_04")--signboard
DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_05")--signboard
EnableInteriorProp(int_arcade1, "entity_set_mural_neon_option_06")--signboard
EnableInteriorProp(int_arcade1, "entity_set_mural_neon_option_07")--signboard
EnableInteriorProp(int_arcade1, "entity_set_mural_neon_option_08")--signboard

DisableInteriorProp(int_arcade1, "entity_set_mural_option_01")--wall paint
DisableInteriorProp(int_arcade1, "entity_set_mural_option_02")--wall paint
DisableInteriorProp(int_arcade1, "entity_set_mural_option_03")--wall paint
DisableInteriorProp(int_arcade1, "entity_set_mural_option_04")--wall paint
DisableInteriorProp(int_arcade1, "entity_set_mural_option_05")--wall paint
EnableInteriorProp(int_arcade1, "entity_set_mural_option_06")--wall paint
DisableInteriorProp(int_arcade1, "entity_set_mural_option_07")--wall paint
DisableInteriorProp(int_arcade1, "entity_set_mural_option_08")--wall paint

DisableInteriorProp(int_arcade1, "entity_set_floor_option_01")--painted floor
DisableInteriorProp(int_arcade1, "entity_set_floor_option_02")--painted floor
DisableInteriorProp(int_arcade1, "entity_set_floor_option_03")--painted floor
EnableInteriorProp(int_arcade1, "entity_set_floor_option_04")--painted floor
DisableInteriorProp(int_arcade1, "entity_set_floor_option_05")--painted floor
DisableInteriorProp(int_arcade1, "entity_set_floor_option_06")--painted floor
DisableInteriorProp(int_arcade1, "entity_set_floor_option_07")--painted floor
DisableInteriorProp(int_arcade1, "entity_set_floor_option_08")--painted floor

EnableInteriorProp(int_plan1, "set_plan_casino")--casino on the table
EnableInteriorProp(int_plan1, "set_plan_computer")--comp
EnableInteriorProp(int_plan1, "set_plan_keypad")

EnableInteriorProp(int_plan1, "set_plan_hacker")
EnableInteriorProp(int_plan1, "set_plan_mechanic")
EnableInteriorProp(int_plan1, "set_plan_weapons")

EnableInteriorProp(int_plan1, "set_plan_vault")
EnableInteriorProp(int_plan1, "set_plan_wall")--stone wall
EnableInteriorProp(int_plan1, "set_plan_setup")--light for plan
EnableInteriorProp(int_plan1, "set_plan_bed")--the room
DisableInteriorProp(int_plan1, "set_plan_pre_setup")-- trash everywhere
DisableInteriorProp(int_plan1, "set_plan_no_bed")--trash in the bed
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

local emitters = {
        
        "se_walk_radio_d_picked",
}

Citizen.CreateThread(function()
    for i = 1, #emitters do
        SetStaticEmitterEnabled(emitters[i], false)
    end
end)




Citizen.CreateThread(function()
    RequestIpl("brown_goldreserve_milo_")
    
    -- Vault
    local interiorid = GetInteriorAtCoords(-1575.77000000, -557.00060000, 32.03579000)
    
    -- Interior props / entitysets
    -- BIG GLASS DOOR
    ActivateInteriorEntitySet(interiorid, "set_doors_closed")-- Recommended to use with a script and change it to "set_doors_opened" after hacking/minigame
    --ActivateInteriorEntitySet(interiorid, "set_doors_opened")
    -- BIG VAULT DOOR
    --ActivateInteriorEntitySet(interiorid, "set_vault_door_closed") -- Recommended to use with a script and change it to "set_vault_door_destroyed" after explosion/minigame
    -- ActivateInteriorEntitySet(interiorid, "set_vault_door_destroyed") -- ^^
    --ActivateInteriorEntitySet(interiorid, "set_vault_door_opened") -- Openable but clips through wall
    -- BIG VAULT DOOR KEYPADS (Different versions)
    ActivateInteriorEntitySet(interiorid, "vault_keypad_normal")
    -- ActivateInteriorEntitySet(interiorid, "vault_keypad_error")
    -- ActivateInteriorEntitySet(interiorid, "vault_keypad_damaged")
    -- INSIDE VAULT DOOR KEYPADS (Different versions)
    ActivateInteriorEntitySet(interiorid, "vaultdoor_keypad_normal")
    -- ActivateInteriorEntitySet(interiorid, "vaultdoor_keypad_error")
    -- ActivateInteriorEntitySet(interiorid, "vaultdoor_keypad_damaged")
    -- This disables different MLOs/interiors in this building (collides with the elevator shaft).
    RemoveIpl("ex_sm_13_office_01a")
    RemoveIpl("ex_sm_13_office_01b")
    RemoveIpl("ex_sm_13_office_01c")
    RemoveIpl("ex_sm_13_office_02a")
    RemoveIpl("ex_sm_13_office_02b")
    RemoveIpl("ex_sm_13_office_02c")
    RemoveIpl("ex_sm_13_office_03a")
    RemoveIpl("ex_sm_13_office_03b")
    RemoveIpl("ex_sm_13_office_03c")
    RemoveIpl("imp_sm_13_cargarage_a")
    RemoveIpl("imp_sm_13_cargarage_b")
    RemoveIpl("imp_sm_13_cargarage_c")
    
    RefreshInterior(interiorid)

end)


local Interior = GetInteriorAtCoords(440.84, -983.14, 30.69)

LoadInterior(Interior)



Citizen.CreateThread(function()


    RequestIpl("gabz_biker_milo_")
    
        interiorID = GetInteriorAtCoords(994.47870000, -122.99490000, 73.11467000)
        
        
        if IsValidInterior(interiorID) then
        EnableInteriorProp(interiorID, "walls_02")
        SetInteriorPropColor(interiorID, "walls_02", 8)
        EnableInteriorProp(interiorID, "Furnishings_02")
        SetInteriorPropColor(interiorID, "Furnishings_02", 8)
        EnableInteriorProp(interiorID, "decorative_02")
        EnableInteriorProp(interiorID, "mural_03")
        EnableInteriorProp(interiorID, "lower_walls_default")
        SetInteriorPropColor(interiorID, "lower_walls_default", 8)
        EnableInteriorProp(interiorID, "mod_booth")
        EnableInteriorProp(interiorID, "gun_locker")
        EnableInteriorProp(interiorID, "cash_small")
        EnableInteriorProp(interiorID, "id_small")
        EnableInteriorProp(interiorID, "weed_small")
        
        RefreshInterior(interiorID)
        
        end
        
    end)
    

    Citizen.CreateThread(function()


        RequestIpl("gabz_mrpd_milo_")
        
            interiorID = GetInteriorAtCoords(451.0129, -993.3741, 29.1718)
                
            
            if IsValidInterior(interiorID) then      
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm1")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm2")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm3")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm4")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm5")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm6")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm7")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm8")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm9")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm10")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm11")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm12")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm13")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm14")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm15")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm16")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm17")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm18")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm19")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm20")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm21")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm22")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm23")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm24")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm25")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm26")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm27")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm28")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm29")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm30")
                    EnableInteriorProp(interiorID, "v_gabz_mrpd_rm31")
                    
            RefreshInterior(interiorID)
        
            end
        
        end)