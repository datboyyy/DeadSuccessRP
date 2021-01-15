resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script "@errorlog/client/cl_errorlog.lua"


files {
	"meta/interiorproxies.meta",
	'xml/gabz_timecycle_mods_1.xml',
	'xml/gabz_mrpd_timecycle.xml',
	'xml/bs_timecycmod.xml',
	'shellpropv2s.ytyp',
	'xml/iv_int_1_timecycle_mods_1.xml',
	'audio/ivbsoverride_game.dat151.rel'
}

data_file 'TIMECYCLEMOD_FILE' 'gabz_timecycle_mods_1.xml'
data_file 'TIMECYCLEMOD_FILE' 'gabz_mrpd_timecycle.xml'
data_file "INTERIOR_PROXY_ORDER_FILE" "meta/interiorproxies.meta"
data_file('DLC_ITYP_REQUEST')('stream/prison_props.ytyp')
data_file 'TIMECYCLEMOD_FILE' 'iv_int_1_timecycle_mods_1.xml'
data_file 'AUDIO_GAMEDATA' 'audio/ivbsoverride_game.dat'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'
data_file 'SCALEFORM_DLC_FILE' 'stream/minimap/int2056887296.gfx'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv2.ytyp'


client_scripts {

	'client.lua',
}






this_is_a_map 'yes'


