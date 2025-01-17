local chatInputActive = false
local chatInputActivating = false
local chatHidden = true
local chatLoaded = false
local chatVisibilityToggle = false

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addMessageOOC')
RegisterNetEvent('chat:addMessages')
RegisterNetEvent('chat:addMessageHack')
RegisterNetEvent('chat:addMessageUpdate')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:client:ClearChat')
RegisterNetEvent('chat:toggleChat')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('chat:addMessage')

--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text)
  local args = { text }
  if author ~= "" then
    table.insert(args, 1, author)
  end
  if(not chatVisibilityToggle)then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = {
        color = color,
        multiline = true,
        args = args
      }
    })
  end
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
  print(msg)
  if(not chatVisibilityToggle)then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = {
        color = { 0, 0, 0 },
        multiline = true,
        args = { msg }
      }
    })
  end
end)

AddEventHandler('chat:addMessage', function(message)
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = message
  })
end)

AddEventHandler('chat:addMessageOOC', function(message)
  if(not chatVisibilityToggle)then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = message
    })
  end
end)

AddEventHandler('chat:addMessages', function(message)
  PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
  --TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'bassdrop', 0.1)
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = message
  })
end)

AddEventHandler('chat:addMessageHack', function(message)
  PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = message
  })
end)

AddEventHandler('chat:addMessageUpdate', function(message)
  PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", 0)
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = message
  })
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
  SendNUIMessage({
    type = 'ON_SUGGESTION_ADD',
    suggestion = {
      name = name,
      help = help,
      params = params or nil
    }
  })
end)

AddEventHandler('chat:addSuggestions', function(suggestions)
  for _, suggestion in ipairs(suggestions) do
    SendNUIMessage({
      type = 'ON_SUGGESTION_ADD',
      suggestion = suggestion
    })
  end
end)

AddEventHandler('chat:removeSuggestion', function(name)
  SendNUIMessage({
    type = 'ON_SUGGESTION_REMOVE',
    name = name
  })
end)

RegisterNetEvent('chat:resetSuggestions')
AddEventHandler('chat:resetSuggestions', function()
  SendNUIMessage({
    type = 'ON_COMMANDS_RESET'
  })
end)

AddEventHandler('chat:addTemplate', function(id, html)
  SendNUIMessage({
    type = 'ON_TEMPLATE_ADD',
    template = {
      id = id,
      html = html
    }
  })
end)

AddEventHandler('chat:client:ClearChat', function(name)
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
  TriggerEvent("chatMessage", "Console:", 3, "Chat Cleared")
end)

AddEventHandler('chat:toggleChat',function()
  chatVisibilityToggle = not chatVisibilityToggle
  local state = (chatVisibilityToggle == true) and "^1Off" or "^2On"

  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
        color = {255,255,255},
        multiline = true,
        template = '<div class="chat-message"><b>Chat</b> {0}</div>',
        args = { state }
      }
    })
end)

-- RegisterCommand("chat",function()
--   TriggerEvent('chat:toggleChat')
--   TriggerEvent('chat:addSuggestion', 'chat', 'OOC Chati aktif eder/kapatır')
-- end)

RegisterNUICallback('chatResult', function(data, cb)
  chatInputActive = false
  SetNuiFocus(false)

  if not data.canceled then
    local id = PlayerId()

    --deprecated
    local r, g, b = 0, 0x99, 255

    if data.message:sub(1, 1) == '/' then
      ExecuteCommand(data.message:sub(2))
    else
      TriggerServerEvent('chat:addMessage', GetPlayerName(id), { r, g, b }, data.message)
    end
  end

  cb('ok')
end)

local function refreshCommands()
  if GetRegisteredCommands then
    local registeredCommands = GetRegisteredCommands()

    local suggestions = {}

    for _, command in ipairs(registeredCommands) do
        if IsAceAllowed(('command.%s'):format(command.name)) then
            table.insert(suggestions, {
                name = '/' .. command.name,
                help = ''
            })
        end
    end

    TriggerEvent('chat:addSuggestions', suggestions)
  end
end

local function refreshThemes()
  local themes = {}

  for resIdx = 0, GetNumResources() - 1 do
    local resource = GetResourceByFindIndex(resIdx)

    if GetResourceState(resource) == 'started' then
      local numThemes = GetNumResourceMetadata(resource, 'chat_theme')

      if numThemes > 0 then
        local themeName = GetResourceMetadata(resource, 'chat_theme')
        local themeData = json.decode(GetResourceMetadata(resource, 'chat_theme_extra') or 'null')

        if themeName and themeData then
          themeData.baseUrl = 'nui://' .. resource .. '/'
          themes[themeName] = themeData
        end
      end
    end
  end

  SendNUIMessage({
    type = 'ON_UPDATE_THEMES',
    themes = themes
  })
end

AddEventHandler('onClientResourceStart', function(resName)
  Wait(500)

  refreshCommands()
  refreshThemes()
end)

AddEventHandler('onClientResourceStop', function(resName)
  Wait(500)

  refreshCommands()
  refreshThemes()
end)

RegisterNUICallback('loaded', function(data, cb)
  TriggerServerEvent('chat:init');

  refreshCommands()
  refreshThemes()

  chatLoaded = true

  cb('ok')
end)


RegisterCommand('help', function(source, args, rawCommand)
  TriggerEvent('chat:addMessages', {
    template = '<div class="chat-message-system"><b>Server:</b> Join the discord if you need further assistance discord.gg/dsrp</div>',
    args = { msg }
})
end, false)




Citizen.CreateThread(function()
  SetTextChatEnabled(false)
  SetNuiFocus(false)

  while true do
    Wait(0)

    if not chatInputActive then
      if IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
        chatInputActive = true
        chatInputActivating = true

        SendNUIMessage({
          type = 'ON_OPEN'
        })
      end
    end

    if chatInputActivating then
      if not IsControlPressed(0, 245) then
        SetNuiFocus(true)

        chatInputActivating = false
      end
    end

    if chatLoaded then
      local shouldBeHidden = false

      if IsScreenFadedOut() or IsPauseMenuActive() then
        shouldBeHidden = true
      end

      if (shouldBeHidden and not chatHidden) or (not shouldBeHidden and chatHidden) then
        chatHidden = shouldBeHidden

        SendNUIMessage({
          type = 'ON_SCREEN_STATE_CHANGE',
          shouldHide = shouldBeHidden
        })
      end
    end
  end
end)

RegisterCommand('togglechat', function(source, args, rawCommand)
  if chatVisibilityToggle == false then
  TriggerEvent('chat:addMessages', {
    template = '<div class="chat-message server"><b>Server:</b> Chat disabled.</div>',
    args = { msg }
})
  chatVisibilityToggle = true
  Citizen.Wait(4000)
  TriggerEvent('chat:client:ClearChat')
  else
    chatVisibilityToggle = false
    TriggerEvent('chat:addMessages', {
      template = '<div class="chat-message server"><b>Server:</b> Chat enabled.</div>',
      args = { msg }
  })
end
end, false)

-- RegisterCommand('chat', function(source, args, rawCommand)
--   if chatVisibilityToggle == true then
--   TriggerEvent('chat:addMessages', {
--     template = '<div class="chat-message server"><b>Server:</b> Chat Enabled.</div>',
--     args = { msg }
-- })
--   chatVisibilityToggle = false
--   else
--     TriggerEvent('chat:addMessages', {
--       template = '<div class="chat-message server"><b>Server:</b> Chat is already enabled.</div>',
--       args = { msg }
--   })
-- end
-- end, false)

-- RegisterNetEvent('chat:toggle:false')
-- AddEventHandler('chat:toggle:false', function()
--   chatVisibilityToggle = false
-- end)

RegisterNetEvent('chat:svtocl')
AddEventHandler('chat:svtocl', function(title, color, message)
  TriggerEvent("chatMessage", title, color, message)
end)