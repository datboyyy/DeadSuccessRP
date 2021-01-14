ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
-- Entity Enumerators
function DeleteObjects(object)
    if DoesEntityExist(object) then
        NetworkRequestControlOfEntity(object)
        while not NetworkHasControlOfEntity(object) do
            Citizen.Wait(1)
        end
        if IsEntityAttached(object) then
            DetachEntity(object, 0, false)
        end

        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
        SetEntityAsMissionEntity(object, true, true)
        DeleteObject(object)
    end
end

function DeleteVehicles(entity)
    if DoesEntityExist(entity) then
        NetworkRequestControlOfEntity(entity)

        if IsEntityAttached(entity) then
            DetachEntity(entity, 0, false)
        end

        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
    end
end

function DeletePeds(ped)
    if DoesEntityExist(ped) then
        NetworkRequestControlOfEntity(ped)

        if IsEntityAttached(ped) then
            DetachEntity(ped, 0, false)
        end

        SetEntityCollision(ped, false, false)
        SetEntityAlpha(ped, 0.0, true)
        SetEntityAsMissionEntity(ped, true, true)
        DeletePed(ped)
    end
end


WeaponBL = {
    ["WEAPON_RAILGUN"] = true,
    ["WEAPON_GARBAGEBAG"] = true,
    ["WEAPON_MINIGUN"] = true,
    ["WEAPON_PROXMINE"] = true
}
ObjectsBL = {
    ["prop_tanktrailer_01a"] = true,
    ["prop_flag_uk"] = true,
    ["hei_prop_crate_stack_01"] = true,
    ["hei_prop_carrier_radar_1_l1"] = true,
    ["v_res_mexball"] = true,
    ["prop_rock_1_a"] = true,
    ["prop_rock_1_b"] = true,
    ["prop_rock_1_c"] = true,
    ["prop_rock_1_d"] = true,
    ["prop_player_gasmask"] = true,
    ["prop_rock_1_e"] = true,
    ["prop_rock_1_f"] = true,
    ["prop_rock_1_g"] = true,
    ["prop_rock_1_h"] = true,
    ["p_ld_stinger_s"] = true,
    ["prop_test_boulder_01"] = true,
    ["prop_test_boulder_02"] = true,
    ["prop_test_boulder_03"] = true,
    ["prop_test_boulder_04"] = true,
    ["apa_mp_apa_crashed_usaf_01a"] = true,
    ["ex_prop_exec_crashdp"] = true,
    ["apa_mp_apa_yacht_o1_rail_a"] = true,
    ["apa_mp_apa_yacht_o1_rail_b"] = true,
    ["apa_mp_h_yacht_armchair_01"] = true,
    ["apa_mp_h_yacht_armchair_03"] = true,
    ["apa_mp_h_yacht_armchair_04"] = true,
    ["apa_mp_h_yacht_barstool_01"] = true,
    ["apa_mp_h_yacht_bed_01"] = true,
    ["apa_mp_h_yacht_bed_02"] = true,
    ["apa_mp_h_yacht_coffee_table_01"] = true,
    ["apa_mp_h_yacht_coffee_table_02"] = true,
    ["apa_mp_h_yacht_floor_lamp_01"] = true,
    ["apa_mp_h_yacht_side_table_01"] = true,
    ["apa_mp_h_yacht_side_table_02"] = true,
    ["apa_mp_h_yacht_sofa_01"] = true,
    ["apa_mp_h_yacht_sofa_02"] = true,
    ["apa_mp_h_yacht_stool_01"] = true,
    ["apa_mp_h_yacht_strip_chair_01"] = true,
    ["apa_mp_h_yacht_table_lamp_01"] = true,
    ["apa_mp_h_yacht_table_lamp_02"] = true,
    ["apa_mp_h_yacht_table_lamp_03"] = true,
    ["prop_flag_columbia"] = true,
    ["apa_mp_apa_yacht_o2_rail_a"] = true,
    ["apa_mp_apa_yacht_o2_rail_b"] = true,
    ["apa_mp_apa_yacht_o3_rail_a"] = true,
    ["apa_mp_apa_yacht_o3_rail_b"] = true,
    ["apa_mp_apa_yacht_option1"] = true,
    ["proc_searock_01"] = true,
    ["apa_mp_h_yacht_"] = true,
    ["apa_mp_apa_yacht_option1_cola"] = true,
    ["apa_mp_apa_yacht_option2"] = true,
    ["apa_mp_apa_yacht_option2_cola"] = true,
    ["apa_mp_apa_yacht_option2_colb"] = true,
    ["apa_mp_apa_yacht_option3"] = true,
    ["apa_mp_apa_yacht_option3_cola"] = true,
    ["apa_mp_apa_yacht_option3_colb"] = true,
    ["apa_mp_apa_yacht_option3_colc"] = true,
    ["apa_mp_apa_yacht_option3_cold"] = true,
    ["apa_mp_apa_yacht_option3_cole"] = true,
    ["apa_mp_apa_yacht_jacuzzi_cam"] = true,
    ["apa_mp_apa_yacht_jacuzzi_ripple003"] = true,
    ["apa_mp_apa_yacht_jacuzzi_ripple1"] = true,
    ["apa_mp_apa_yacht_jacuzzi_ripple2"] = true,
    ["apa_mp_apa_yacht_radar_01a"] = true,
    ["apa_mp_apa_yacht_win"] = true,
    ["prop_crashed_heli"] = true,
    ["apa_mp_apa_yacht_door"] = true,
    ["prop_shamal_crash"] = true,
    ["xm_prop_x17_shamal_crash"] = true,
    ["apa_mp_apa_yacht_door2"] = true,
    ["apa_mp_apa_yacht"] = true,
    ["prop_flagpole_2b"] = true,
    ["prop_flagpole_2c"] = true,
    ["prop_flag_canada"] = true,
    ["apa_prop_yacht_float_1a"] = true,
    ["apa_prop_yacht_float_1b"] = true,
    ["apa_prop_yacht_glass_01"] = true,
    ["apa_prop_yacht_glass_02"] = true,
    ["apa_prop_yacht_glass_03"] = true,
    ["apa_prop_yacht_glass_04"] = true,
    ["apa_prop_yacht_glass_05"] = true,
    ["apa_prop_yacht_glass_06"] = true,
    ["apa_prop_yacht_glass_07"] = true,
    ["apa_prop_yacht_glass_08"] = true,
    ["apa_prop_yacht_glass_09"] = true,
    ["apa_prop_yacht_glass_10"] = true,
    ["prop_flag_canada_s"] = true,
    ["prop_flag_eu"] = true,
    ["prop_flag_eu_s"] = true,
    ["prop_target_blue_arrow"] = true,
    ["prop_target_orange_arrow"] = true,
    ["prop_target_purp_arrow"] = true,
    ["prop_target_red_arrow"] = true,
    ["apa_prop_flag_argentina"] = true,
    ["apa_prop_flag_australia"] = true,
    ["apa_prop_flag_austria"] = true,
    ["apa_prop_flag_belgium"] = true,
    ["apa_prop_flag_brazil"] = true,
    ["apa_prop_flag_canadat_yt"] = true,
    ["apa_prop_flag_china"] = true,
    ["apa_prop_flag_columbia"] = true,
    ["apa_prop_flag_croatia"] = true,
    ["apa_prop_flag_czechrep"] = true,
    ["apa_prop_flag_denmark"] = true,
    ["apa_prop_flag_england"] = true,
    ["apa_prop_flag_eu_yt"] = true,
    ["apa_prop_flag_finland"] = true,
    ["apa_prop_flag_france"] = true,
    ["apa_prop_flag_german_yt"] = true,
    ["apa_prop_flag_hungary"] = true,
    ["apa_prop_flag_ireland"] = true,
    ["apa_prop_flag_israel"] = true,
    ["apa_prop_flag_italy"] = true,
    ["apa_prop_flag_jamaica"] = true,
    ["apa_prop_flag_japan_yt"] = true,
    ["apa_prop_flag_canada_yt"] = true,
    ["apa_prop_flag_lstein"] = true,
    ["apa_prop_flag_malta"] = true,
    ["apa_prop_flag_mexico_yt"] = true,
    ["apa_prop_flag_netherlands"] = true,
    ["apa_prop_flag_newzealand"] = true,
    ["apa_prop_flag_nigeria"] = true,
    ["apa_prop_flag_norway"] = true,
    ["apa_prop_flag_palestine"] = true,
    ["apa_prop_flag_poland"] = true,
    ["apa_prop_flag_portugal"] = true,
    ["apa_prop_flag_puertorico"] = true,
    ["apa_prop_flag_russia_yt"] = true,
    ["apa_prop_flag_scotland_yt"] = true,
    ["apa_prop_flag_script"] = true,
    ["apa_prop_flag_slovakia"] = true,
    ["apa_prop_flag_slovenia"] = true,
    ["apa_prop_flag_southafrica"] = true,
    ["apa_prop_flag_southkorea"] = true,
    ["apa_prop_flag_spain"] = true,
    ["apa_prop_flag_sweden"] = true,
    ["apa_prop_flag_switzerland"] = true,
    ["apa_prop_flag_turkey"] = true,
    ["apa_prop_flag_uk_yt"] = true,
    ["apa_prop_flag_us_yt"] = true,
    ["apa_prop_flag_wales"] = true,
    ["prop_flag_uk"] = true,
    ["prop_flag_uk_s"] = true,
    ["prop_flag_us"] = true,
    ["prop_flag_usboat"] = true,
    ["prop_flag_us_r"] = true,
    ["prop_flag_us_s"] = true,
    ["prop_flag_france"] = true,
    ["prop_flag_france_s"] = true,
    ["prop_flag_german"] = true,
    ["prop_flag_german_s"] = true,
    ["prop_flag_ireland"] = true,
    ["prop_flag_ireland_s"] = true,
    ["prop_flag_japan"] = true,
    ["prop_flag_japan_s"] = true,
    ["prop_flag_ls"] = true,
    ["prop_flag_lsfd"] = true,
    ["prop_flag_lsfd_s"] = true,
    ["prop_flag_lsservices"] = true,
    ["prop_flag_lsservices_s"] = true,
    ["prop_flag_ls_s"] = true,
    ["prop_flag_mexico"] = true,
    ["prop_flag_mexico_s"] = true,
    ["prop_flag_russia"] = true,
    ["prop_flag_russia_s"] = true,
    ["prop_flag_s"] = true,
    ["prop_flag_sa"] = true,
    ["prop_flag_sapd"] = true,
    ["prop_flag_sapd_s"] = true,
    ["prop_flag_sa_s"] = true,
    ["prop_flag_scotland"] = true,
    ["prop_flag_scotland_s"] = true,
    ["prop_flag_sheriff"] = true,
    ["prop_flag_sheriff_s"] = true,
    ["prop_flag_uk"] = true,
    ["prop_flag_uk_s"] = true,
    ["prop_flag_us"] = true,
    ["prop_flag_usboat"] = true,
    ["prop_flag_us_r"] = true,
    ["prop_flag_us_s"] = true,
    ["prop_flamingo"] = true,
    ["prop_swiss_ball_01"] = true,
    ["prop_air_bigradar_l1"] = true,
    ["prop_air_bigradar_l2"] = true,
    ["prop_air_bigradar_slod"] = true,
    ["p_fib_rubble_s"] = true,
    ["prop_money_bag_01"] = true,
    ["p_cs_mp_jet_01_s"] = true,
    ["prop_poly_bag_money"] = true,
    ["prop_air_radar_01"] = true,
    ["hei_prop_carrier_radar_1"] = true,
    ["prop_air_bigradar"] = true,
    ["prop_carrier_radar_1_l1"] = true,
    ["prop_asteroid_01"] = true,
    ["prop_xmas_ext"] = true,
    ["p_oil_pjack_01_amo"] = true,
    ["p_oil_pjack_01_s"] = true,
    ["p_oil_pjack_02_amo"] = true,
    ["p_oil_pjack_03_amo"] = true,
    ["p_oil_pjack_02_s"] = true,
    ["p_oil_pjack_03_s"] = true,
    ["prop_aircon_l_03"] = true,
    ["prop_med_jet_01"] = true,
    ["p_med_jet_01_s"] = true,
    ["hei_prop_carrier_jet"] = true,
    ["bkr_prop_biker_bblock_huge_01"] = true,
    ["bkr_prop_biker_bblock_huge_02"] = true,
    ["bkr_prop_biker_bblock_huge_04"] = true,
    ["bkr_prop_biker_bblock_huge_05"] = true,
    ["hei_prop_heist_emp"] = true,
    ["prop_weed_01"] = true,
    ["prop_air_bigradar"] = true,
    ["prop_juicestand"] = true,
    ["prop_lev_des_barge_02"] = true,
    ["hei_prop_carrier_defense_01"] = true,
    ["prop_aircon_m_04"] = true,
    ["prop_mp_ramp_03"] = true,
    ["stt_prop_stunt_track_dwuturn"] = true,
    ["ch3_12_animplane1_lod"] = true,
    ["ch3_12_animplane2_lod"] = true,
    ["hei_prop_hei_pic_pb_plane"] = true,
    ["light_plane_rig"] = true,
    ["prop_cs_plane_int_01"] = true,
    ["prop_dummy_plane"] = true,
    ["prop_mk_plane"] = true,
    ["v_44_planeticket"] = true,
    ["prop_planer_01"] = true,
    ["ch3_03_cliffrocks03b_lod"] = true,
    ["ch3_04_rock_lod_02"] = true,
    ["csx_coastsmalrock_01_"] = true,
    ["csx_coastsmalrock_02_"] = true,
    ["csx_coastsmalrock_03_"] = true,
    ["csx_coastsmalrock_04_"] = true,
    ["mp_player_introck"] = true,
    ["Heist_Yacht"] = true,
    ["csx_coastsmalrock_05_"] = true,
    ["mp_player_int_rock"] = true,
    ["mp_player_introck"] = true,
    ["prop_flagpole_1a"] = true,
    ["prop_flagpole_2a"] = true,
    ["prop_flagpole_3a"] = true,
    ["prop_a4_pile_01"] = true,
    ["cs2_10_sea_rocks_lod"] = true,
    ["cs2_11_sea_marina_xr_rocks_03_lod"] = true,
    ["prop_gold_cont_01"] = true,
    ["prop_hydro_platform"] = true,
    ["ch3_04_viewplatform_slod"] = true,
    ["ch2_03c_rnchstones_lod"] = true,
    ["proc_mntn_stone01"] = true,
    ["prop_beachflag_le"] = true,
    ["proc_mntn_stone02"] = true,
    ["cs2_10_sea_shipwreck_lod"] = true,
    ["des_shipsink_02"] = true,
    ["prop_dock_shippad"] = true,
    ["des_shipsink_03"] = true,
    ["des_shipsink_04"] = true,
    ["prop_mk_flag"] = true,
    ["prop_mk_flag_2"] = true,
    ["proc_mntn_stone03"] = true,
    ["FreeModeMale01"] = true,
    ["rsn_os_specialfloatymetal_n"] = true,
    ["rsn_os_specialfloatymetal"] = true,
    ["cs1_09_sea_ufo"] = true,
    ["rsn_os_specialfloaty2_light2"] = true,
    ["rsn_os_specialfloaty2_light"] = true,
    ["rsn_os_specialfloaty2"] = true,
    ["rsn_os_specialfloatymetal_n"] = true,
    ["rsn_os_specialfloatymetal"] = true,
    ["P_Spinning_Anus_S_Main"] = true,
    ["P_Spinning_Anus_S_Root"] = true,
    ["cs3_08b_rsn_db_aliencover_0001cs3_08b_rsn_db_aliencover_0001_a"] = true,
    ["sc1_04_rnmo_paintoverlaysc1_04_rnmo_paintoverlay_a"] = true,
    ["rnbj_wallsigns_0001"] = true,
    ["proc_sml_stones01"] = true,
    ["proc_sml_stones02"] = true,
    ["maverick"] = true,
    ["Miljet"] = true,
    ["proc_sml_stones03"] = true,
    ["proc_stones_01"] = true,
    ["proc_stones_02"] = true,
    ["proc_stones_03"] = true,
    ["proc_stones_04"] = true,
    ["proc_stones_05"] = true,
    ["proc_stones_06"] = true,
    ["prop_coral_stone_03"] = true,
    ["prop_coral_stone_04"] = true,
    ["prop_gravestones_01a"] = true,
    ["prop_gravestones_02a"] = true,
    ["prop_gravestones_03a"] = true,
    ["prop_gravestones_04a"] = true,
    ["prop_gravestones_05a"] = true,
    ["prop_gravestones_06a"] = true,
    ["prop_gravestones_07a"] = true,
    ["prop_gravestones_08a"] = true,
    ["prop_gravestones_09a"] = true,
    ["prop_gravestones_10a"] = true,
    ["prop_prlg_gravestone_05a_l1"] = true,
    ["prop_prlg_gravestone_06a"] = true,
    ["test_prop_gravestones_04a"] = true,
    ["test_prop_gravestones_05a"] = true,
    ["test_prop_gravestones_07a"] = true,
    ["test_prop_gravestones_08a"] = true,
    ["test_prop_gravestones_09a"] = true,
    ["prop_prlg_gravestone_01a"] = true,
    ["prop_prlg_gravestone_02a"] = true,
    ["prop_prlg_gravestone_03a"] = true,
    ["prop_prlg_gravestone_04a"] = true,
    ["prop_stoneshroom1"] = true,
    ["prop_stoneshroom2"] = true,
    ["v_res_fa_stones01"] = true,
    ["test_prop_gravestones_01a"] = true,
    ["test_prop_gravestones_02a"] = true,
    ["prop_prlg_gravestone_05a"] = true,
    ["FreemodeFemale01"] = true,
    ["p_cablecar_s"] = true,
    ["stt_prop_stunt_tube_l"] = true,
    ["stt_prop_stunt_track_dwuturn"] = true,
    ["p_spinning_anus_s"] = true,
    ["prop_windmill_01"] = true,
    ["hei_prop_heist_tug"] = true,
    ["prop_air_bigradar"] = true,
    ["p_oil_slick_01"] = true,
    ["prop_dummy_01"] = true,
    ["hei_prop_heist_emp"] = true,
    ["p_tram_cash_s"] = true,
    ["hw1_blimp_ce2"] = true,
    ["prop_fire_exting_1a"] = true,
    ["prop_fire_exting_1b"] = true,
    ["prop_fire_exting_2a"] = true,
    ["prop_fire_exting_3a"] = true,
    ["hw1_blimp_ce2_lod"] = true,
    ["hw1_blimp_ce_lod"] = true,
    ["hw1_blimp_cpr003"] = true,
    ["hw1_blimp_cpr_null"] = true,
    ["hw1_blimp_cpr_null2"] = true,
    ["prop_lev_des_barage_02"] = true,
    ["hei_prop_carrier_defense_01"] = true,
    ["prop_juicestand"] = true,
    ["S_M_M_MovAlien_01"] = true,
    ["s_m_m_movalien_01"] = true,
    ["s_m_m_movallien_01"] = true,
    ["u_m_y_babyd"] = true,
    ["CS_Orleans"] = true,
    ["A_M_Y_ACult_01"] = true,
    ["S_M_M_MovSpace_01"] = true,
    ["U_M_Y_Zombie_01"] = true,
    ["s_m_y_blackops_01"] = true,
    ["a_f_y_topless_01"] = true,
    ["a_c_boar"] = true,
    ["a_c_cat_01"] = true,
    ["a_c_chickenhawk"] = true,
    ["a_c_chimp"] = true,
    ["s_f_y_hooker_03"] = true,
    ["a_c_chop"] = true,
    ["a_c_cormorant"] = true,
    ["a_c_cow"] = true,
    ["a_c_coyote"] = true,
    ["v_ilev_found_cranebucket"] = true,
    ["p_cs_sub_hook_01_s"] = true,
    ["a_c_crow"] = true,
    ["a_c_dolphin"] = true,
    ["a_c_fish"] = true,
    ["hei_prop_heist_hook_01"] = true,
    ["prop_rope_hook_01"] = true,
    ["prop_sub_crane_hook"] = true,
    ["s_f_y_hooker_01"] = true,
    ["prop_vehicle_hook"] = true,
    ["prop_v_hook_s"] = true,
    ["prop_dock_crane_02_hook"] = true,
    ["prop_winch_hook_long"] = true,
    ["a_c_hen"] = true,
    ["a_c_humpback"] = true,
    ["a_c_husky"] = true,
    ["a_c_killerwhale"] = true,
    ["a_c_mtlion"] = true,
    ["a_c_pigeon"] = true,
    ["a_c_poodle"] = true,
    ["prop_coathook_01"] = true,
    ["prop_cs_sub_hook_01"] = true,
    ["a_c_pug"] = true,
    ["a_c_rabbit_01"] = true,
    ["a_c_rat"] = true,
    ["a_c_retriever"] = true,
    ["a_c_rhesus"] = true,
    ["a_c_rottweiler"] = true,
    ["a_c_sharkhammer"] = true,
    ["a_c_sharktiger"] = true,
    ["a_c_shepherd"] = true,
    ["a_c_stingray"] = true,
    ["a_c_westy"] = true,
    ["CS_Orleans"] = true,
    ["prop_windmill_01"] = true,
    ["prop_Ld_ferris_wheel"] = true,
    ["p_tram_crash_s"] = true,
    ["p_oil_slick_01"] = true,
    ["p_ld_soc_ball_01"] = true,
    ["p_parachute1_s"] = true,
    ["p_cablecar_s"] = true,
    ["prop_beach_fire"] = true,
    ["prop_lev_des_barge_02"] = true,
    ["prop_lev_des_barge_01"] = true,
    ["prop_sculpt_fix"] = true,
    ["prop_flagpole_2b"] = true,
    ["prop_flagpole_2c"] = true,
    ["prop_winch_hook_short"] = true,
    ["prop_flag_canada"] = true,
    ["prop_flag_canada_s"] = true,
    ["prop_flag_eu"] = true,
    ["prop_flag_eu_s"] = true,
    ["prop_flag_france"] = true,
    ["prop_flag_france_s"] = true,
    ["prop_flag_german"] = true,
    ["prop_ld_hook"] = true,
    ["prop_flag_german_s"] = true,
    ["prop_flag_ireland"] = true,
    ["prop_flag_ireland_s"] = true,
    ["prop_flag_japan"] = true,
    ["prop_flag_japan_s"] = true,
    ["prop_flag_ls"] = true,
    ["prop_flag_lsfd"] = true,
    ["prop_flag_lsfd_s"] = true,
    ["prop_cable_hook_01"] = true,
    ["prop_flag_lsservices"] = true,
    ["prop_flag_lsservices_s"] = true,
    ["prop_flag_ls_s"] = true,
    ["prop_flag_mexico"] = true,
    ["prop_flag_mexico_s"] = true,
    ["csx_coastboulder_00"] = true,
    ["des_tankercrash_01"] = true,
    ["des_tankerexplosion_01"] = true,
    ["des_tankerexplosion_02"] = true,
    ["des_trailerparka_02"] = true,
    ["des_trailerparkb_02"] = true,
    ["des_trailerparkc_02"] = true,
    ["des_trailerparkd_02"] = true,
    ["des_traincrash_root2"] = true,
    ["des_traincrash_root3"] = true,
    ["des_traincrash_root4"] = true,
    ["des_traincrash_root5"] = true,
    ["des_finale_vault_end"] = true,
    ["des_finale_vault_root001"] = true,
    ["des_finale_vault_root002"] = true,
    ["des_finale_vault_root003"] = true,
    ["des_finale_vault_root004"] = true,
    ["des_finale_vault_start"] = true,
    ["des_vaultdoor001_root001"] = true,
    ["des_vaultdoor001_root002"] = true,
    ["des_vaultdoor001_root003"] = true,
    ["des_vaultdoor001_root004"] = true,
    ["des_vaultdoor001_root005"] = true,
    ["des_vaultdoor001_root006"] = true,
    ["des_vaultdoor001_skin001"] = true,
    ["des_vaultdoor001_start"] = true,
    ["des_traincrash_root6"] = true,
    ["prop_ld_vault_door"] = true,
    ["prop_vault_door_scene"] = true,
    ["prop_vault_door_scene"] = true,
    ["prop_vault_shutter"] = true,
    ["p_fin_vaultdoor_s"] = true,
    ["v_ilev_bk_vaultdoor"] = true,
    ["prop_gold_vault_fence_l"] = true,
    ["prop_gold_vault_fence_r"] = true,
    ["prop_gold_vault_gate_01"] = true,
    ["prop_bank_vaultdoor"] = true,
    ["des_traincrash_root7"] = true,
    ["prop_flag_russia"] = true,
    ["prop_flag_russia_s"] = true,
    ["prop_flag_s"] = true,
    ["ch2_03c_props_rrlwindmill_lod"] = true,
    ["prop_flag_sa"] = true,
    ["prop_flag_sapd"] = true,
    ["prop_flag_sapd_s"] = true,
    ["prop_flag_sa_s"] = true,
    ["prop_flag_scotland"] = true,
    ["prop_flag_scotland_s"] = true,
    ["prop_flag_sheriff"] = true,
    ["prop_flag_sheriff_s"] = true,
    ["prop_flag_uk"] = true,
    ["prop_yacht_lounger"] = true,
    ["prop_yacht_seat_01"] = true,
    ["prop_yacht_seat_02"] = true,
    ["prop_yacht_seat_03"] = true,
    ["marina_xr_rocks_02"] = true,
    ["marina_xr_rocks_03"] = true,
    ["prop_test_rocks01"] = true,
    ["prop_test_rocks02"] = true,
    ["prop_test_rocks03"] = true,
    ["prop_test_rocks04"] = true,
    ["marina_xr_rocks_04"] = true,
    ["marina_xr_rocks_05"] = true,
    ["marina_xr_rocks_06"] = true,
    ["prop_yacht_table_01"] = true,
    ["csx_searocks_02"] = true,
    ["csx_searocks_03"] = true,
    ["csx_searocks_04"] = true,
    ["csx_searocks_05"] = true,
    ["csx_searocks_06"] = true,
    ["p_yacht_chair_01_s"] = true,
    ["p_yacht_sofa_01_s"] = true,
    ["prop_yacht_table_02"] = true,
    ["csx_coastboulder_00"] = true,
    ["csx_coastboulder_01"] = true,
    ["csx_coastboulder_02"] = true,
    ["csx_coastboulder_03"] = true,
    ["csx_coastboulder_04"] = true,
    ["csx_coastboulder_05"] = true,
    ["csx_coastboulder_06"] = true,
    ["csx_coastboulder_07"] = true,
    ["csx_coastrok1"] = true,
    ["csx_coastrok2"] = true,
    ["csx_coastrok3"] = true,
    ["csx_coastrok4"] = true,
    ["csx_coastsmalrock_01"] = true,
    ["csx_coastsmalrock_02"] = true,
    ["csx_coastsmalrock_03"] = true,
    ["csx_coastsmalrock_04"] = true,
    ["csx_coastsmalrock_05"] = true,
    ["prop_yacht_table_03"] = true,
    ["prop_flag_uk_s"] = true,
    ["prop_flag_us"] = true,
    ["prop_flag_usboat"] = true,
    ["prop_flag_us_r"] = true,
    ["prop_flag_us_s"] = true,
    ["p_gasmask_s"] = true,
    ["prop_flamingo"] = true,
    ["prop_gas_pump_1a"] = true,
    ["prop_gas_pump_1b"] = true,
    ["prop_gas_pump_1c"] = true,
    ["prop_gas_pump_1d"] = true,
    ["prop_gas_pump_old2"] = true,
    ["prop_gas_pump_old3"] = true,
    ["prop_vintage_pump"] = true,
}

ObjectHash = {}

for k, v in pairs(ObjectsBL) do
    ObjectHash[GetHashKey(k)] = true
end
ObjectHash[-230239317]  = true
ObjectHash[-145066854]  = true
ObjectHash[1328154590]  = true
ObjectHash[1328154590]  = true
ObjectHash[-2129526670] = true
ObjectHash[1933174915]  = true
ObjectHash[1694452750]  = true
ObjectHash[2042668880]  = true
ObjectHash[1872312775]  = true
ObjectHash[-422877666]  = true
ObjectHash[1771868096]  = true
ObjectHash[1694452750]  = true
ObjectHash[-462817101]  = true
ObjectHash[-469694731]  = true
ObjectHash[-164877493]  = true
ObjectHash[1339433404]  = true







RegisterNetEvent("DeadSuccessRP:WipeWhips")
AddEventHandler("DeadSuccessRP:WipeWhips", function()
    local totalVehicles = 0

    for veh in EnumerateVehicles() do
        if DoesEntityExist(veh) and not IsPedAPlayer(GetPedInVehicleSeat(veh, -1)) then
            TriggerEvent('persistent-vehicles/forget-vehicle', veh)
            SetVehicleHasBeenOwnedByPlayer(veh, false)
            DeleteVehicles(veh)
            totalVehicles = totalVehicles + 1
        end
    end
    print('delleted')
    ESX.ShowNotification("DeadSuccessRP: Deleted " .. totalVehicles .. " vehicles.")
end)

RegisterNetEvent("DeadSuccessRP:wipeObjects")
AddEventHandler("DeadSuccessRP:wipeObjects", function()
    local totalobj = 0

    for object in EnumerateObjects() do
        if IsEntityAnObject(object) then
            DeleteObject(object)

            local name = GetPlayerName(PlayerId())
            print(name)
    
            totalobj = totalobj + 1
        end
    end
    print('delleted')
    ESX.ShowNotification("DeadSuccessRP: Deleted " .. totalobj .. " objects.")
end)

RegisterNetEvent("DeadSuccessRP:wipePeds")
AddEventHandler("DeadSuccessRP:wipePeds", function()
    local totalpeds = 0

    for ped in EnumeratePeds() do
        if not IsPedAPlayer(ped) then
            DeletePeds(ped)
            totalpeds = totalpeds + 1
        end
    end
    print('delleted')
    ESX.ShowNotification("DeadSuccessRP: Deleted " .. totalpeds .. " peds.")
end)


local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end

        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()

        if not id or id == 0 then
            disposeFunc(iter)

            return
        end

        local enum = {
            handle = iter,
            destructor = disposeFunc
        }

        setmetatable(enum, entityEnumerator)
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end
