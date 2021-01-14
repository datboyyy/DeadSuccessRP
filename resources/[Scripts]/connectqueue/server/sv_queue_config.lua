Config = {}

-- priority list can be any identifier. (hex steamid, steamid32, ip) Integer = power over other people with priority
-- a lot of the steamid converting websites are broken rn and give you the wrong steamid. I use https://steamid.xyz/ with no problems.
-- you can also give priority through the API, read the examples/readme.
Config.Priority = {
    ["steam:1100001113b37ba"] = 9999999999,--- sway
    --[[ ["steam:11000010c43618b"] = 0,--- amora 
    ["steam:11000010a772d2e"] = 0,--- juju
    ["steam:1100001010c544e"] = 0,--- daps
    ["steam:11000011a22cec2"] = 0,--- Marco
    ["steam:11000011aa67ef9"] = 0,--- Guilty
    ["steam:1100001406e6119"] = 0,--- Kimmie Jordana 
    ["steam:1100001046af84c"] = 0,--- JDM_Juice
    ["steam:11000013696f316"] = 0,--- Wunna
    ["steam:11000013f0d6364"] = 0,--- MD BALLA
    ["steam:110000109b80146"] = 0,--- Sdawg
    ["steam:11000013d7a7930"] = 0,--- CallMeChealseaa
    ["steam:110000136f1e9de"] = 0,--- Bradley6
    ["steam:110000141403fc5"] = 0,--- Allah#8323
    ["steam:110000112b7630b"] = 0,--- Jeff Jefferey
    ["steam:11000010e5703fe"] = 0,--- Wuggly
    ["steam:110000116085694"] = 0,--- Chime
    ["steam:11000011c18d2b8"] = 0,--- FlipCobain
    ["steam:11000011a07317b"] = 0,--- Edo
    ["steam:11000011c310645"] = 0,--- Tae
    ["steam:110000141927117"] = 0,--- Glo
   -- ["steam:11000014001ccf8"] = 0,--- Josue
    ["steam:1100001413cb186"] = 0,--- LLB Mika Snow
    ["steam:110000136e92c0c"] = 0,--- Ben
    ["steam:11000013f54083a"] = 0,--- Dylon/DC
    ["steam:11000013d2d72cc"] = 0,--- iтƶ. хιyaн
    ["steam:11000011af29bae"] = 0,--- youngpunk
    ["steam:11000010c5cc0cc"] = 0,--- Reapa#1253
    ["steam:110000118170505"] = 0,--- Kuro#7386
    ["steam:11000010c7e0c3e"] = 0,--- entanglement#4566/terry
    ["steam:110000141c765ce"] = 0,--- Jamila#9293
    ["steam:11000010c836ae1"] = 0,--- Buskee#8285
    ["steam:11000013eb1a119"] = 0,--- Fionn_murray50#5857 / Finn
    ["steam:110000141a4fc67"] = 0,--- Thunder
    ["steam:11000013c2a4504"] = 0,--- Mori
    ["steam:11000011aebe00d"] = 0,--- AlexisGaia#2970
    ["steam:11000013edfb6da"] = 0,--- BIG DEE#9009
    ["steam:1100001413f6f46"] = 0,--- Novaaa/Remiiii#5821
    ["steam:11000013e2e15d9"] = 0,--- Raikagejade/Nene
    ["steam:11000014116e9d3"] = 0,--- Pluginn#6323 
    ["steam:110000114b3552a"] = 0,--- Rupert 
    ["steam:110000115e9386b"] = 0,--- Christian/glock45 
    ["steam:110000108205eba"] = 0,--- SQ#1733 
    ["steam:110000135080b7c"] = 0,--- Shayy/hennessy
    ["steam:11000013d3e021e"] = 0,--- IWantABucketOfCodeine#1201
    ["steam:11000010f47a85d"] = 0,--- Levi#0732
    ["steam:11000010da3d08b"] = 0,--- Keke/GamingMamaYT
    ["steam:11000013c13b5c3"] = 0,--- NunForYou
    --["steam:1100001146d012a"] = 0,--- BoBo#0546
    ["steam:110000140275b31"] = 0,--- TeeTakes/Tavi
    ["steam:110000108160ee9"] = 0,--- Kray
    ["steam:110000114bcb9f6"] = 0,--- DeeSimsYT
    ["steam:11000013524406f"] = 0,--- Syn
    ["steam:110000140d281eb"] = 0,--- GhostNamedGreg
    ["steam:11000013b120337"] = 0,--- Glytch
    ["steam:11000011c37763f"] = 0,--- Mikey
    ["steam:11000011745d118"] = 0,--- LethalGamezz
    ["steam:110000140cc1fc5"] = 0,--- Devyn
    ["steam:11000013fca2320"] = 0,--- Young Chappa
    ["steam:110000136538C06"] = 0,--- Rugby Santana
    ["steam:11000010580b9c0"] = 0,--- DivineChaos
    ["steam:11000010c99b372"] = 0,--- bebir333
    
    ["steam:1100001413bf1fe"] = 0,--- TheGodly_ 
    ["steam:110000107b70dd6"] = 0,--- BouJeeva
    ["steam:110000104bd01fc"] = 0,--- mriamfamous
    ["steam:11000013e778ef7"] = 0,--- Yaw1234
    ["steam:1100001406cd587"] = 0,--- Cape
    ["steam:11000013e93963e"] = 0,--- Sosavagegaming
    ["steam:11000014134f2ec"] = 0,--- XclusiveMal
    ["steam:11000013ee5f70c"] = 0,--- ADtheGreat
    ["steam:11000013667afa6"] = 0,--- Joe Gallo
    ["steam:11000011a82dd64"] = 0,--- Chief Keef
    ["steam:1100001368f8e21"] = 0,--- Kantrel
    ["steam:11000013f4359ae"] = 0,--- Lxgiv
    ["steam:11000013a53d4ba"] = 0,--- Gaddafi
    ["steam:11000013c986a2a"] = 0,--- .alex
    ["steam:11000010c781f96"] = 0,--- Lelaini / SukiTheInSlghtBunny
    ["steam:11000011574e46f"] = 0,--- SnowRella
    ["steam:1100001162380f8"] = 0,--- Windex
    ["steam:11000013ec83061"] = 0,--- Molly
    ["steam:1100001117c5dc0"] = 0,--- AKMOMO /Officer Pigg
    ["steam:110000141d20c7a"] = 0,--- shiestychris 
    ["steam:11000013f7f0484"] = 0,--- Truly0Ace 
    ["steam:11000011771767f"] = 0,--- Jimbo 
    ["steam:11000013fcb446c"] = 0,--- resteasyjah 
    ["steam:11000014059569d"] = 0,--- Northwest 
    ["steam:1100001179e25d3"] = 0,--- solfire 
    ["steam:110000116497caa"] = 0,--- Servv 
    ["steam:1100001417f771c"] = 0,--- Indica 
    ["steam:11000013fe0815d"] = 0,--- RomeoSantos
    ["steam:11000010f6807f4"] = 0,--- Tokyo
    ["steam:11000013affe985"] = 0,--- Dinero
    ["steam:11000011418b975"] = 0,--- Frmrocxs 
    ["steam:110000111492c10"] = 0,--- grandpa woo
    ["steam:1100001188366e0"] = 0,--- Killem
    ["steam:110000115668bae"] = 0,--- YBN BABY GOON
    ["steam:1100001162e9eb7"] = 0,--- Covid
   -- ["steam:11000013fd10974"] = 0,--- awleks the gay mex   
    ["steam:110000141d20c7a"] = 0,--- ShiestyChris
    ["steam:11000013f67ce2d"] = 0,--- DaWheelChairBull
    ["steam:11000010db01951"] = 0,--- Judge
    ["steam:11000010ED7783B"] = 0,--- morningstar
    ["steam:110000134b22e14"] = 0,--- justshiii
    ["steam:110000116a28fd1"] = 0,--- joshtheplug 
    ["steam:110000110bdae5e"] = 0,--- 𝓚𝖊𝖎𝖙𝖍  keith
    ["steam:11000014167e632"] = 0,--- walle 
    ["steam:110000111e86c9d"] = 0,--- Salty
    ["steam:11000013813e580"] = 0,--- averidanielle
    ["steam:110000119c1a597"] = 0,--- ShelbyChantill
    ["steam:110000109bcdedf"] = 0,--- Marksmann1
    ["steam:110000140535631"] = 0,--- Laniee
    ["steam:1100001406a589b"] = 0,--- Cocobite27
    ["steam:11000013c8ee91a"] = 0,--- taylea
    ["steam:1100001400430cf"] = 0,--- ymilli
    ["steam:11000011c37763f"] = 0,--- Birches
    ["steam:11000013cea8a41"] = 0,--- Ttb Khalifa
    ["steam:1100001398f8a3e"] = 0,--- Ttb MOSSB
    ["steam:1100001193717b6"] = 0,--- Soldat
    ["steam:11000013eb7a289"] = 0,--- Jake Lopez
    ["steam:110000141098181"] = 0,--- xQuayy
    ["steam:11000013ca33346"] = 0,--- ad 
    ["steam:11000013bd1c0c4"] = 0,--- Rico Armani
    ["steam:11000011b2426a6"] = 0,--- Fizzy--]]

}               
-- require people to run steam
Config.RequireSteam = true

-- "whitelist" only server
Config.PriorityOnly = false

-- disables hardcap, should keep this true
Config.DisableHardCap = true

-- will remove players from connecting if they don't load within: __ seconds; May need to increase this if you have a lot of downloads.
-- i have yet to find an easy way to determine whether they are still connecting and downloading content or are hanging in the loadscreen.
-- This may cause session provider errors if it is too low because the removed player may still be connecting, and will let the next person through...
-- even if the server is full. 10 minutes should be enough
Config.ConnectTimeOut = 600

-- will remove players from queue if the server doesn't recieve a message from them within: __ seconds
Config.QueueTimeOut = 90

-- will give players temporary priority when they disconnect and when they start loading in
Config.EnableGrace = true

-- how much priority power grace time will give
Config.GracePower = 5

-- how long grace time lasts in seconds
Config.GraceTime = 480

-- on resource start, players can join the queue but will not let them join for __ milliseconds
-- this will let the queue settle and lets other resources finish initializing
Config.JoinDelay = 60000

-- will show how many people have temporary priority in the connection message
Config.ShowTemp = false

-- simple localization
Config.Language = {
    joining = "\xF0\x9F\x8E\x89Joining...",
    connecting = "\xE2\x8F\xB3Connecting...",
    idrr = "\xE2\x9D\x97[Queue] Error: Couldn't retrieve any of your id's, try restarting.",
    err = "\xE2\x9D\x97[Queue] There was an error",
    pos = "\xF0\x9F\x90\x8CYou are %d/%d in queue \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97[Queue] Error: Error adding you to connecting list",
    timedout = "\xE2\x9D\x97[Queue] Error: Timed out?",
    wlonly = "\xE2\x9D\x97[Queue] You must be whitelisted to join this server join discord.gg/dsrp for more info!",
    steam = "\xE2\x9D\x97 [Queue] Error: Steam must be running"
}