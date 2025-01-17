resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script "@errorlog/client/cl_errorlog.lua"

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
client_script "@errorlog/client/cl_errorlog.lua"


name 'Mythic Framework Progress Bar'
author 'Alzar - https://github.com/Alzar'
version 'v1.0.0'

ui_page('html/index.html') 

client_scripts {
    'client/main.lua'
}

files {
    'html/index.html',
    'html/css/style.css',
    'html/js/script.js',

    'html/css/bootstrap.min.css',
    'html/js/jquery.min.js',
}

exports {
    'Progress',
    'ProgressWithStartEvent',
    'ProgressWithTickEvent',
    'ProgressWithStartAndTick'
}


