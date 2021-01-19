Config = {}

Config.version = "1.1.0"

------- Modules -------
Config.enableDebug = false
Config.enableGrids = true
Config.enableRadio = true
Config.enablePhone = true
Config.enableToko = true
Config.enableSpeaker = true
Config.enableSubmixes = true
Config.enableFilters = {
  phone = true,
  radio = true
}

------- Default Settings -------

Config.settings = {
    ["releaseDelay"] = 200,
    ["stereoAudio"] = true,
    ["localClickOn"] = true,
    ["localClickOff"] = true,
    ["remoteClickOn"] = true,
    ["remoteClickOff"] = true,
    ["clickVolume"] = 0.8,
    ["radioVolume"] = 0.8,
    ["phoneVolume"] = 0.8
}

------- Voice Proximity -------

Config.voiceRanges = {
    { name = "whisper", range = 4.0 },
    { name = "normal", range = 8.0 },
    { name = "shout", range = 16.0 }
}

------- Hotkeys Config -------

Config.cycleProximityHotkey = "z"
Config.cycleRadioChannelHotkey = "i"
Config.transmitToRadioHotkey = "capital"
Config.phoneLoudSpeaker = "plus"

------- Modules Config -------

-- Speaker Module
Config.speakerDistance = 2.0
Config.radioSpeaker = true
Config.phoneSpeaker = true

-- Radio Module
Config.enableMultiFrequency = false

-- Grid Module
Config.gridSize = 512
Config.gridEdge = 256
Config.gridMinX = -4600
Config.gridMaxX = 4600
Config.gridMaxY = 9200
