--[[resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

files {
  'vehiclelayouts.meta',
  'vehicles.meta',
  'carvariations.meta',
  'carcols.meta',
  'handling.meta',
  'vehiclelayouts2.meta',
  'vehicles2.meta',
  'carvariations2.meta',
  'carcols2.meta',
  'handling2.meta',

  'vehiclelayouts3.meta',
  'vehicles3.meta',
  'carvariations3.meta',
  'carcols3.meta',
  'handling3.meta',
}

data_file 'VEHICLE_LAYOUTS_FILE' 'vehiclelayouts.meta'
data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'

data_file 'VEHICLE_LAYOUTS_FILE' 'vehiclelayouts2.meta'
data_file 'HANDLING_FILE' 'handling2.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles2.meta'
data_file 'CARCOLS_FILE' 'carcols2.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations2.meta'

data_file 'VEHICLE_LAYOUTS_FILE' 'vehiclelayouts3.meta'
data_file 'HANDLING_FILE' 'handling3.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles3.meta'
data_file 'CARCOLS_FILE' 'carcols3.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations3.meta'

client_script {
    'vehicle_names.lua'
}

]]--

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

files {
  '*.meta',
}

data_file 'VEHICLE_LAYOUTS_FILE' '*.meta'
data_file 'HANDLING_FILE' '*.meta'
data_file 'VEHICLE_METADATA_FILE' '*.meta'
data_file 'CARCOLS_FILE' '*.meta'
data_file 'VEHICLE_VARIATION_FILE' '*.meta'

client_script {
    'vehicle_names.lua'
}
