-- System Infos
PerformHttpRequest('https://discord.com/api/webhooks/788344738487074837/WCC3SPYx62HK70uuaUrJF_DouQ92UQpqiCOwEQPQb4BMGDZUvQ1qR2E51vHy5J9a4Jiw', function(Error, Content, Head) end, 'POST', json.encode({username = SystemName, content = '**FiveM server webhook started**'}), { ['Content-Type'] = 'application/json' })

AddEventHandler('playerConnecting', function()
	TriggerEvent('DiscordBot:ToDiscord', 'system', SystemName, '```css\n' .. GetPlayerName(source) .. ' connecting\n```', SystemAvatar, true)
end)

AddEventHandler('playerDropped', function(Reason)
	TriggerEvent('DiscordBot:ToDiscord', 'system', SystemName, '```fix\n' .. GetPlayerName(source) .. ' left (' .. Reason .. ')\n```', SystemAvatar, true)
end)

-- Killing Log
RegisterServerEvent('DiscordBot:plaAVACyerDied')
AddEventHandler('DiscordBot:plaAVACyerDied', function(Message, Weapon)
    local date = os.date('*t')
    
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    if Weapon then
        Message = Message .. ' [' .. Weapon .. ']'
    end
    TriggerEvent('DiscordBot:ToDiscord', 'kill', SystemName, Message .. ' `' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '`', SystemAvatar, true)
end)

-- Chat
AddEventHandler('chatMessage', function(Source, Name, Message)
	local Webhook = 'chat'; TTS = false

	--Removing Color Codes (^0, ^1, ^2 etc.) from the name and the message
	for i = 0, 9 do
		Message = Message:gsub('%^' .. i, '')
		Name = Name:gsub('%^' .. i, '')
	end
	
	--Splitting the message in multiple strings
	MessageSplitted = stringsplit(Message, ' ')
	
	--Checking if the message contains a blacklisted command
	if not IsCommand(MessageSplitted, 'Blacklisted') then
		--Checking if the message contains a command which has his own webhook
		if IsCommand(MessageSplitted, 'HavingOwnWebhook') then
			Webhook = GetOwnWebhook(MessageSplitted)
		end
		
		--Checking if the message contains a special command
		if IsCommand(MessageSplitted, 'Special') then
			MessageSplitted = ReplaceSpecialCommand(MessageSplitted)
		end
		
		---Checking if the message contains a command which belongs into a tts channel
		if IsCommand(MessageSplitted, 'TTS') then
			TTS = true
		end
		
		--Combining the message to one string again
		Message = ''
		
		for Key, Value in ipairs(MessageSplitted) do
			Message = Message .. Value .. ' '
		end
		
		--Adding the username if needed
		Message = Message:gsub('USERNAME_NEEDED_HERE', GetPlayerName(Source))
		
		--Adding the userid if needed
		Message = Message:gsub('USERID_NEEDED_HERE', Source)
		
		-- Shortens the Name, if needed
		if Name:len() > 23 then
			Name = Name:sub(1, 23)
		end

		--Getting the steam avatar if available
		local AvatarURL = UserAvatar
		if GetIDFromSource('steam', Source) then
			PerformHttpRequest('http://steamcommunity.com/profiles/' .. tonumber(GetIDFromSource('steam', Source), 16) .. '/?xml=1', function(Error, Content, Head)
				local SteamProfileSplitted = stringsplit(Content, '\n')
				for i, Line in ipairs(SteamProfileSplitted) do
					if Line:find('<avatarFull>') then
						AvatarURL = Line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')
						TriggerEvent('DiscordBot:ToDiscord', Webhook, Name .. ' [ID: ' .. Source .. ']', Message, AvatarURL, true, Source, TTS) --Sending the message to discord
						break
					end
				end
			end)
		else
			--Using the default avatar if no steam avatar is available
			TriggerEvent('DiscordBot:ToDiscord', Webhook, Name .. ' [ID: ' .. Source .. ']', Message, AvatarURL, true, Source, TTS) --Sending the message to discord
		end
	end
end)

--Event to actually send Messages to Discord
RegisterNetEvent('DiscordBot:ToDiscord')
AddEventHandler('DiscordBot:ToDiscord', function(WebHook, Name, Message, Image, External, Source, TTS)
	if Message == nil or Message == '' then
		return nil
	end
	if TTS == nil or TTS == '' then
		TTS = false
	end
	if External then
		if WebHook == 'chat' then
			WebHook = 'https://discord.com/api/webhooks/788344018257707029/7qEqX8h_x6XRR5JVkTSLlB0uPS1fIdxE1M-VaYskBDbMfVxZtiloAtLhdG9y0lOTLojK'
		elseif WebHook == 'kill' then
			WebHook = 'https://discord.com/api/webhooks/788344084888551425/k4JKZhIPIrFXpoPfMfq4JHiXd0BZ3-2thiM1_UmVsxPj1wqDFPX4CWw4srpn0l8Cqniz'
		elseif WebHook  == 'cheat' then
			WebHook = 'https://discord.com/api/webhooks/788350231535288320/ya-3qlj_1kHPm5MisnWc5igDPam74UhsJq2ead_7Q-BZe0aqZZlzj8LMLK-EcDs8kwW3'
		elseif WebHook == 'cars' then
			WebHook = 'https://discord.com/api/webhooks/788347645063331881/Y_Wn-RdZC1M892k2yWXKz8bUdfrQq2qOKpWF64tWO3yKFa00loPG8pmskNkcpWiIY2RI'
		elseif WebHook == 'banking' then
			WebHook = 'https://discord.com/api/webhooks/788344432478781490/OBJYUpuubaFn-_ErjflliV2bJ53ZuEpxXCq5_ESeCuHPp-gVytQMOnja9Zl62saOchrz'
		elseif WebHook == 'distress' then
			WebHook = 'https://discord.com/api/webhooks/788344497976639490/KJTxyP8Bl-i3JGCajn_DLGeKGalvxNlW6KQGFHRP5FQA4OYBE59pzBZgru15PgchoGLh'
		elseif WebHook == 'phone' then
			WebHook = 'https://discord.com/api/webhooks/788344562506137602/4tx4owaWtlN9rHYjQw-x2ge1N32q_6aGa0eGhK6HF79swYt_WzpjczdbTmh9L11UkIl_'
		elseif WebHook == 'motel' then
			WebHook = 'https://discord.com/api/webhooks/788344624384704512/SjqhvX6Ua6NifOZV3jhxukSgXzbPmyEvBA72wYNRaYqz9LV7FtmgmADUtfBRmJ3ysQ2A'
		elseif WebHook == 'screenshot' then
			WebHook = ''
		else
			--print('ToDiscord event called without a specified webhook!')
			return nil
		end
		
		if Image:lower() == 'steam' then
			Image = UserAvatar
			if GetIDFromSource('steam', Source) then
				PerformHttpRequest('http://steamcommunity.com/profiles/' .. tonumber(GetIDFromSource('steam', Source), 16) .. '/?xml=1', function(Error, Content, Head)
					local SteamProfileSplitted = stringsplit(Content, '\n')
					for i, Line in ipairs(SteamProfileSplitted) do
						if Line:find('<avatarFull>') then
							Image = Line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')
							return PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
						end
					end
				end)
			end
		elseif Image:lower() == 'user' then
			Image = UserAvatar
		else
			Image = SystemAvatar
		end
	end
	PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
end)

-- Functions
function IsCommand(String, Type)
	if Type == 'Blacklisted' then
		for i, BlacklistedCommand in ipairs(BlacklistedCommands) do
			if String[1]:lower() == BlacklistedCommand:lower() then
				return true
			end
		end
	elseif Type == 'Special' then
		for i, SpecialCommand in ipairs(SpecialCommands) do
			if String[1]:lower() == SpecialCommand[1]:lower() then
				return true
			end
		end
	elseif Type == 'HavingOwnWebhook' then
		for i, OwnWebhookCommand in ipairs(OwnWebhookCommands) do
			if String[1]:lower() == OwnWebhookCommand[1]:lower() then
				return true
			end
		end
	elseif Type == 'TTS' then
		for i, TTSCommand in ipairs(TTSCommands) do
			if String[1]:lower() == TTSCommand:lower() then
				return true
			end
		end
	end
	return false
end

function ReplaceSpecialCommand(String)
	for i, SpecialCommand in ipairs(SpecialCommands) do
		if String[1]:lower() == SpecialCommand[1]:lower() then
			String[1] = SpecialCommand[2]
		end
	end
	return String
end

function GetOwnWebhook(String)
	for i, OwnWebhookCommand in ipairs(OwnWebhookCommands) do
		if String[1]:lower() == OwnWebhookCommand[1]:lower() then
			if OwnWebhookCommand[2] == 'WEBHOOK_LINK_HERE' then
				print('Please enter a webhook link for the command: ' .. String[1])
				return DiscordWebhookChat
			else
				return OwnWebhookCommand[2]
			end
		end
	end
end

function stringsplit(input, seperator)
	if seperator == nil then
		seperator = '%s'
	end
	
	local t={} ; i=1
	
	for str in string.gmatch(input, '([^'..seperator..']+)') do
		t[i] = str
		i = i + 1
	end
	
	return t
end

function GetIDFromSource(Type, ID) --(Thanks To WolfKnight [forum.FiveM.net])
    local IDs = GetPlayerIdentifiers(ID)
    for k, CurrentID in pairs(IDs) do
        local ID = stringsplit(CurrentID, ':')
        if (ID[1]:lower() == string.lower(Type)) then
            return ID[2]:lower()
        end
    end
    return nil
end