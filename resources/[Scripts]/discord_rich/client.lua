Citizen.CreateThread(function()
        
        while true do
            Citizen.Wait(5 * 1000)
            SetDiscordAppId(787556747350245396)-- Replace 0 with your application client id.
            SetRichPresence("Dead Success RP | Roleplay")
            SetDiscordRichPresenceAsset("clogo")-- The name of the big picture you added in the application.
            SetDiscordRichPresenceAssetText('Online')
            SetDiscordRichPresenceAssetSmall("clogo")-- The name of the small picture you added in the application.
            SetDiscordRichPresenceAssetSmallText("sup")
        end
end)
