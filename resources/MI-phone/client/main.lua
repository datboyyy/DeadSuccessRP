ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharAVACedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    
    
    ESX.PlayerData = ESX.GetPlayerData()
    TriggerServerEvent('MI-phone:onPlayerLoaded', GetPlayerServerId(PlayerId()))
    Wait(200)
    
    LoadPhone()
end)



-- Code
local PlayerJob = {}
local phoneModel = `prop_npc_phone_02`

phoneProp = 0

PhoneData = {
    MetaData = {},
    isOpen = false,
    PlayerData = nil,
    Contacts = {},
    Tweets = {},
    MentionedTweets = {},
    Hashtags = {},
    Chats = {},
    Invoices = {},
    CallData = {},
    RecentCalls = {},
    Garage = {},
    SelfTweets = {},
    Mails = {},
    Adverts = {},
    id = 1,
    GarageVehicles = {},
    AnimationData = {
        lib = nil,
        anim = nil,
    },
    SuggestedContacts = {},
    CryptoTransactions = {},
}



RegisterNetEvent('MI-phone:client:RaceNotify')
AddEventHandler('MI-phone:client:RaceNotify', function(message)
    if PhoneData.isOpen then
        
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = 'Racing',
                text = message,
                icon = "fas fa-flag-checkered",
                color = "#353b48",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = 'Racing',
                content = message,
                icon = "fas fa-flag-checkered",
                timeout = 3500,
                color = "#353b48",
            },
        })
    end
end)

RegisterNetEvent('MI-phone:client:AddRecentCall')
AddEventHandler('MI-phone:client:AddRecentCall', function(data, time, type)
    table.insert(PhoneData.RecentCalls, {
        name = IsNumberInContacts(data.number),
        time = time,
        type = type,
        number = data.number,
        anonymous = data.anonymous
    })
    TriggerServerEvent('MI-phone:server:SetPhoneAlerts', "phone")
    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    SendNUIMessage({
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(JobInfo)
    if ESX.PlayerData.job.name == "police" then
        SendNUIMessage({
            action = "UpdateApplications",
            JobData = JobInfo,
            applications = Config.PhoneApplications
        })
    elseif ESX.PlayerData.job.name == "police" and ESX.PlayerData.job.name == "unemployed" then
        SendNUIMessage({
            action = "UpdateApplications",
            JobData = JobInfo,
            applications = Config.PhoneApplications
        })
    end
    
    PlayerJob = JobInfo
end)

RegisterNUICallback('ClearRecentAlerts', function(data, cb)
    TriggerServerEvent('MI-phone:server:SetPhoneAlerts', "phone", 0)
    Config.PhoneApplications["phone"].Alerts = 0
    SendNUIMessage({action = "RefreshAppAlerts", AppData = Config.PhoneApplications})
end)

RegisterNUICallback('SetBackground', function(data)
    local background = data.background
    
    TriggerServerEvent('MI-phone:server:SaveMetaData', 'background', background)
end)

RegisterNUICallback('GetMissedCalls', function(data, cb)
    cb(PhoneData.RecentCalls)
end)

RegisterNUICallback('GetSuggestedContacts', function(data, cb)
    cb(PhoneData.SuggestedContacts)
end)

function IsNumberInContacts(num)
    local retval = num
    for _, v in pairs(PhoneData.Contacts) do
        if num == v.number then
            retval = v.name
        end
    end
    return retval
end

local isLoggedIn = false


RegisterKeyMapping('phone', '[Phone] Open Phone', 'keyboard', 'F1')
RegisterCommand("phone", function()
    OpenPhone()
    newPhoneProp()
--TriggerEvent("8bit_MI-phone:client:UpdateAll")
end)

function CalculateTimeToDisplay()
    hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}
    
    if minute <= 9 then
        minute = "0" .. minute
    end
    
    obj.hour = hour
    obj.minute = minute
    
    return obj
end

Citizen.CreateThread(function()
    while true do
        if PhoneData.isOpen then
            SendNUIMessage({
                action = "UpdateTime",
                InGameTime = CalculateTimeToDisplay(),
            })
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        
        if isLoggedIn then
            ESX.TriggerServerCallback('MI-phone:server:GetPhoneData', function(pData)
                if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then
                    PhoneData.Contacts = pData.PlayerContacts
                end
                
                SendNUIMessage({
                    action = "RefreshContacts",
                    Contacts = PhoneData.Contacts
                })
            end)
        end
    end
end)

function LoadPhone()
    Citizen.Wait(100)
    isLoggedIn = true
    ESX.TriggerServerCallback('MI-phone:server:GetPhoneData', function(pData)
        PlayerJob = ESX.GetPlayerData().job
        PhoneData.PlayerData = ESX.GetPlayerData()
        PhoneData.MetaData = {}
        PhoneData.PlayerData.charinfo = pData.charinfo ~= nil and pData.charinfo or {}
        PhoneData.PlayerData.identifier = pData.charinfo ~= nil and pData.charinfo.identifier or ""
        
        if PhoneData.PlayerData.charinfo.profilepicture == nil then
            PhoneData.MetaData.profilepicture = "default"
        else
            PhoneData.MetaData.profilepicture = PhoneData.PlayerData.charinfo.profilepicture
        end
        
        if PhoneData.PlayerData.charinfo.background ~= nil then
            PhoneData.MetaData.background = PhoneData.PlayerData.charinfo.background
        end
        
        if pData.Applications ~= nil and next(pData.Applications) ~= nil then
            for k, v in pairs(pData.Applications) do
                Config.PhoneApplications[k].Alerts = v
            end
        end
        
        if pData.MentionedTweets ~= nil and next(pData.MentionedTweets) ~= nil then
            PhoneData.MentionedTweets = pData.MentionedTweets
        end
        
        if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then
            PhoneData.Contacts = pData.PlayerContacts
        end
        
        if pData.Chats ~= nil and next(pData.Chats) ~= nil then
            local Chats = {}
            for k, v in pairs(pData.Chats) do
                Chats[v.number] = {
                    name = IsNumberInContacts(v.number),
                    number = v.number,
                    messages = json.decode(v.messages)
                }
            end
            
            PhoneData.Chats = Chats
        end
        
        if pData.Invoices ~= nil and next(pData.Invoices) ~= nil then
            for _, invoice in pairs(pData.Invoices) do
                invoice.name = IsNumberInContacts(invoice.number)
            end
            PhoneData.Invoices = pData.Invoices
        end
        
        if pData.Hashtags ~= nil and next(pData.Hashtags) ~= nil then
            PhoneData.Hashtags = pData.Hashtags
        end
        
        if pData.Tweets ~= nil then
            PhoneData.Tweets = pData.Tweets
            PhoneData.id = pData.Tweets[#pData.Tweets].id + 1
        end
        
        if pData.Mails ~= nil and next(pData.Mails) ~= nil then
            PhoneData.Mails = pData.Mails
        end
        
        if pData.Adverts ~= nil and next(pData.Adverts) ~= nil then
            PhoneData.Adverts = pData.Adverts
        end
        
        if pData.CryptoTransactions ~= nil and next(pData.CryptoTransactions) ~= nil then
            PhoneData.CryptoTransactions = pData.CryptoTransactions
        end
        
        Citizen.Wait(300)
        
        SendNUIMessage({
            action = "LoadPhoneData",
            PhoneData = PhoneData,
            PlayerData = PhoneData.PlayerData,
            PlayerJob = PhoneData.PlayerData.job,
            applications = Config.PhoneApplications
        })
    end)
end

RegisterNUICallback('HasPhone', function(data, cb)
        -- ESX.TriggerServerCallback('MI-phone:server:HasPhone', function(HasPhoLoadPhoneDatane)
        --  cb(HasPhone)
        cb(true)
--end)
end)

RegisterCommand('qbphone', function()
    OpenPhone()
end, false)

RegisterCommand('qbphoneclose', function()
    ClosePhone()
end, false)

function ClosePhone()
    DoPhoneAnimation('cellphone_text_out')
    StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
    deletePhone()
    PhoneData.AnimationData.lib = nil
    PhoneData.AnimationData.anim = nil
    PhoneData.AnimationData.lib = nil
    PhoneData.AnimationData.anim = nil
    DoPhoneAnimation('cellphone_text_to_call')
    SetNuiFocus(false, false)
    PhoneData.isOpen = false
end

function OpenPhone()
    local HasPhone = true
--    local HasPhone = exports["dsrp-inventory"]:hasEnoughOfItem("mobilephone", 1, false)
    ESX.TriggerServerCallback('MI-phone:server:GetCharacterData', function(chardata)
        if HasPhone then
            PhoneData.PlayerData = ESX.GetPlayerData()
            PhoneData.PlayerData.charinfo = chardata ~= nil and chardata or {}
            PhoneData.PlayerData.identifier = chardata ~= nil and chardata.identifier or {}
            
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "open",
                Tweets = PhoneData.Tweets,
                AppData = Config.PhoneApplications,
                CallData = PhoneData.CallData,
                PlayerData = PhoneData.PlayerData,
            })
            PhoneData.isOpen = true
            
            if not PhoneData.CallData.InCall then
                DoPhoneAnimation('cellphone_text_in')
            else
                DoPhoneAnimation('cellphone_call_to_text')
            end
            
            SetTimeout(250, function()
                newPhoneProp()
            end)
            
            ESX.TriggerServerCallback('MI-phone:server:GetGarageVehicles', function(vehicles)
                if vehicles ~= nil then
                    for k, v in pairs(vehicles) do
                        vehicles[k].fullname = v.model
                        if GetVehicleClassFromName(v.model) == 0 then
                            vehicles[k].model = 'Compact'
                        elseif GetVehicleClassFromName(v.model) == 1 then
                            vehicles[k].model = 'Sedan'
                        elseif GetVehicleClassFromName(v.model) == 2 then
                            vehicles[k].model = 'SUVs'
                        elseif GetVehicleClassFromName(v.model) == 3 then
                            vehicles[k].model = 'Coupes'
                        elseif GetVehicleClassFromName(v.model) == 4 then
                            vehicles[k].model = 'Muscle'
                        elseif GetVehicleClassFromName(v.model) == 5 then
                            vehicles[k].model = 'Sports Classics'
                        elseif GetVehicleClassFromName(v.model) == 6 then
                            vehicles[k].model = 'Sports'
                        elseif GetVehicleClassFromName(v.model) == 7 then
                            vehicles[k].model = 'Super'
                        elseif GetVehicleClassFromName(v.model) == 8 then
                            vehicles[k].model = 'Motorcycles  '
                        elseif GetVehicleClassFromName(v.model) == 9 then
                            vehicles[k].model = 'Offroad'
                        elseif GetVehicleClassFromName(v.model) == 10 then
                            vehicles[k].model = 'Industrial'
                        elseif GetVehicleClassFromName(v.model) == 11 then
                            vehicles[k].model = 'Utility'
                        elseif GetVehicleClassFromName(v.model) == 12 then
                            vehicles[k].model = 'Vans'
                        elseif GetVehicleClassFromName(v.model) == 13 then
                            vehicles[k].model = 'Cycle'
                        elseif GetVehicleClassFromName(v.model) == 14 then
                            vehicles[k].model = 'Boat'
                        elseif GetVehicleClassFromName(v.model) == 15 then
                            vehicles[k].model = 'Helicopters'
                        elseif GetVehicleClassFromName(v.model) == 16 then
                            vehicles[k].model = 'Planes'
                        elseif GetVehicleClassFromName(v.model) == 17 then
                            vehicles[k].model = 'Service'
                        elseif GetVehicleClassFromName(v.model) == 18 then
                            vehicles[k].model = 'Emergency'
                        elseif GetVehicleClassFromName(v.model) == 19 then
                            vehicles[k].model = 'Military'
                        elseif GetVehicleClassFromName(v.model) == 20 then
                            vehicles[k].model = 'Commercial'
                        end
                    end
                    
                    PhoneData.GarageVehicles = vehicles
                else
                    PhoneData.GarageVehicles = {}
                end
            end)
        else
            TriggerEvent('notification', Lang("PHONE_DONT_HAVE"), 2)
        end
    end)
end

RegisterNUICallback('SetupGarageVehicles', function(data, cb)
    cb(PhoneData.GarageVehicles)
end)

RegisterNUICallback('Close', function()
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetNuiFocus(false, false)
    SetTimeout(1000, function()
        PhoneData.isOpen = false
    end)
end)

RegisterNUICallback('RemoveMail', function(data, cb)
    local MailId = data.mailId
    
    TriggerServerEvent('MI-phone:server:RemoveMail', MailId)
    cb('ok')
end)

RegisterNetEvent('MI-phone:client:UpdateMails')
AddEventHandler('MI-phone:client:UpdateMails', function(NewMails)
    SendNUIMessage({
        action = "UpdateMails",
        Mails = NewMails
    })
    PhoneData.Mails = NewMails
end)

RegisterNUICallback('AcceptMailButton', function(data)
    TriggerEvent(data.buttonEvent, data.buttonData)
    TriggerServerEvent('MI-phone:server:ClearButtonData', data.mailId)
end)

RegisterNUICallback('AddNewContact', function(data, cb)
    table.insert(PhoneData.Contacts, {
        name = data.ContactName,
        number = data.ContactNumber,
        iban = data.ContactIban
    })
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[data.ContactNumber] ~= nil and next(PhoneData.Chats[data.ContactNumber]) ~= nil then
        PhoneData.Chats[data.ContactNumber].name = data.ContactName
    end
    TriggerServerEvent('MI-phone:server:AddNewContact', data.ContactName, data.ContactNumber, data.ContactIban)
end)

RegisterNUICallback('GetMails', function(data, cb)
    cb(PhoneData.Mails)
end)

RegisterNUICallback('GetWhatsappChat', function(data, cb)
    if PhoneData.Chats[data.phone] ~= nil then
        cb(PhoneData.Chats[data.phone])
    else
        cb(false)
    end
end)

RegisterNUICallback('GetProfilePicture', function(data, cb)
    local number = data.number
    
    ESX.TriggerServerCallback('MI-phone:server:GetPicture', function(picture)
        cb(picture)
    end, number)
end)

RegisterNUICallback('GetBankContacts', function(data, cb)
    cb(PhoneData.Contacts)
end)

RegisterNUICallback('GetBankData', function(data, cb)
    ESX.TriggerServerCallback('MI-phone:server:GetBankData', cb)
end)

RegisterNUICallback('GetInvoices', function(data, cb)
    if PhoneData.Invoices ~= nil and next(PhoneData.Invoices) ~= nil then
        cb(PhoneData.Invoices)
    else
        cb(nil)
    end
end)


















function GetKeyByDate(Number, Date)
    local retval = nil
    if PhoneData.Chats[Number] ~= nil then
        if PhoneData.Chats[Number].messages ~= nil then
            for key, chat in pairs(PhoneData.Chats[Number].messages) do
                if chat.date == Date then
                    retval = key
                    break
                end
            end
        end
    end
    return retval
end

function GetKeyByNumber(Number)
    local retval = nil
    if PhoneData.Chats then
        for k, v in pairs(PhoneData.Chats) do
            if v.number == Number then
                retval = k
            end
        end
    end
    return retval
end

function ReorganizeChats(key)
    local ReorganizedChats = {}
    ReorganizedChats[1] = PhoneData.Chats[key]
    for k, chat in pairs(PhoneData.Chats) do
        if k ~= key then
            table.insert(ReorganizedChats, chat)
        end
    end
    PhoneData.Chats = ReorganizedChats
end

RegisterNUICallback('SendMessage', function(data, cb)
    local ChatMessage = data.ChatMessage
    local ChatDate = data.ChatDate
    local ChatNumber = data.ChatNumber
    local ChatTime = data.ChatTime
    local ChatType = data.ChatType

    local Ped = GetPlayerPed(-1)
    local Pos = GetEntityCoords(Ped)
    local NumberKey = GetKeyByNumber(ChatNumber)
    local ChatKey = GetKeyByDate(NumberKey, ChatDate)

    if PhoneData.Chats[NumberKey] ~= nil then
        if PhoneData.Chats[NumberKey].messages[ChatKey] ~= nil then
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = Lang("WHATSAPP_SHARED_LOCATION"),
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })
            end
            TriggerServerEvent('MI-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, false)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        else
            table.insert(PhoneData.Chats[NumberKey].messages, {
                date = ChatDate,
                messages = {},
            })
            ChatKey = GetKeyByDate(NumberKey, ChatDate)
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatDate].messages, {
                    message = Lang("WHATSAPP_SHARED_LOCATION"),
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })
            end
            TriggerServerEvent('MI-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        end
    else
        table.insert(PhoneData.Chats, {
            name = IsNumberInContacts(ChatNumber),
            number = ChatNumber,
            messages = {},
        })
        NumberKey = GetKeyByNumber(ChatNumber)
        table.insert(PhoneData.Chats[NumberKey].messages, {
            date = ChatDate,
            messages = {},
        })
        ChatKey = GetKeyByDate(NumberKey, ChatDate)
        if ChatType == "message" then
            table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                message = ChatMessage,
                time = ChatTime,
                sender = PhoneData.PlayerData.identifier,
                type = ChatType,
                data = {},
            })
        elseif ChatType == "location" then
            table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                message = Lang("WHATSAPP_SHARED_LOCATION"),
                time = ChatTime,
                sender = PhoneData.PlayerData.identifier,
                type = ChatType,
                data = {
                    x = Pos.x,
                    y = Pos.y,
                },
            })
        end
        TriggerServerEvent('MI-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
        NumberKey = GetKeyByNumber(ChatNumber)
        ReorganizeChats(NumberKey)
    end

    ESX.TriggerServerCallback('MI-phone:server:GetContactPicture', function(Chat)
        SendNUIMessage({
            action = "UpdateChat",
            chatData = Chat,
            chatNumber = ChatNumber,
        })
    end,  PhoneData.Chats[GetKeyByNumber(ChatNumber)])
end)


RegisterNUICallback('SharedLocation', function(data)
    local x = data.coords.x
    local y = data.coords.y
    
    SetNewWaypoint(x, y)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = Lang("WHATSAPP_TITLE"),
            text = Lang("WHATSAPP_LOCATION_SET"),
            icon = "fa fa-comment",
            color = "#25D366",
            timeout = 1500,
        },
    })
end)


RegisterNetEvent('MI-phone:client:UpdateMessages')
AddEventHandler('MI-phone:client:UpdateMessages', function(ChatMessages, SenderNumber, New)
    local Sender = IsNumberInContacts(SenderNumber)

    local NumberKey = GetKeyByNumber(SenderNumber)

    print("Received message from ", SenderNumber, New, json.encode(ChatMessages))

    if New then
        
        if NumberKey == nil then 
            NumberKey = SenderNumber
        end
        PhoneData.Chats[NumberKey] = {
            name = Sender,
            number = SenderNumber,
            messages = ChatMessages
        }

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone_number then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = Lang("WHATSAPP_TITLE"),
                        text = Lang("WHATSAPP_NEW_MESSAGE") .. " "..IsNumberInContacts(SenderNumber).."!",
                        icon = "fa fa-comment",
                        color = "#25D366",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = Lang("WHATSAPP_TITLE"),
                        text = Lang("WHATSAPP_MESSAGE_TOYOU"),
                        icon = "fa fa-comment",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Wait(100)
            ESX.TriggerServerCallback('MI-phone:server:GetContactPictures', function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        else
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = Lang("TWITTER_TITLE"), 
                    content = Lang("WHATSAPP_NEW_MESSAGE") .. " "..IsNumberInContacts(SenderNumber).."!", 
                    icon = "fa fa-comment", 
                    timeout = 3500, 
                    color = "#25D366",
                },
            })
            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('MI-phone:server:SetPhoneAlerts', "whatsapp")
        end
    else
        PhoneData.Chats[NumberKey].messages = ChatMessages

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone_number then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = Lang("WHATSAPP_TITLE"),
                        text = Lang("WHATSAPP_NEW_MESSAGE") .. " " ..IsNumberInContacts(SenderNumber).."!",
                        icon = "fa fa-comment",
                        color = "#25D366",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = Lang("WHATSAPP_TITLE"),
                        text = Lang("WHATSAPP_MESSAGE_TOYOU"),
                        icon = "fa fa-comment",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)
            
            Wait(100)
            ESX.TriggerServerCallback('MI-phone:server:GetContactPictures', function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        else
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = "iMessage",
                    content = Lang("WHATSAPP_NEW_MESSAGE") .. " "..IsNumberInContacts(SenderNumber).."!", 
                    icon = "fa fa-comment", 
                    timeout = 3500, 
                    color = "#25D366",
                },
            })

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('MI-phone:server:SetPhoneAlerts', "whatsapp")
        end
    end
end)



















RegisterNetEvent("MI-Phone:client:BankNotify")
AddEventHandler("MI-Phone:client:BankNotify", function(text)
    print('wow')
    SendNUIMessage({
        action = "Notification",
        NotifyData = {
            title = Lang("BANK_TITLE"), 
            content = text, 
            icon = "fas fa-university", 
            timeout = 3500, 
            color = "#ff002f",
        },
    })
end)

Citizen.CreateThread(function()
    while true do
        if PhoneData.isOpen then
            SendNUIMessage({
                action = "updateTweets",
                tweets = PhoneData.Tweets,
                selfTweets = PhoneData.SelfTweets,
            })
        end
        Citizen.Wait(2000)
    end
end)

RegisterNetEvent('MI-phone:client:NewMailNotify')
AddEventHandler('MI-phone:client:NewMailNotify', function(mailData)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("MAIL_TITLE"),
                text = Lang("MAIL_NEW") .. " " .. mailData.sender,
                icon = "fas fa-envelope",
                color = "#ff002f",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("MAIL_TITLE"), 
                content = Lang("MAIL_NEW") .. " " .. mailData.sender, 
                icon = "fas fa-envelope", 
                timeout = 3500, 
                color = "#ff002f",
            },
        })
    end
    Config.PhoneApplications['mail'].Alerts = Config.PhoneApplications['mail'].Alerts + 1
    TriggerServerEvent('MI-Phone:server:SetPhoneAlerts', "mail")
end)

RegisterNUICallback('PostAdvert', function(data)
    TriggerServerEvent('MI-phone:server:AddAdvert', data.message)
end)

RegisterNetEvent('MI-phone:client:UpdateAdverts')
AddEventHandler('MI-phone:client:UpdateAdverts', function(Adverts, LastAd)
    PhoneData.Adverts = Adverts
    
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("ADVERTISEMENT_TITLE"),
                text = Lang("ADVERTISEMENT_NEW") .. " " .. LastAd,
                icon = "fas fa-ad",
                color = "#ff8f1a",
                timeout = 2500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("ADVERTISEMENT_TITLE"),
                content = Lang("ADVERTISEMENT_NEW") .. " " .. LastAd,
                icon = "fas fa-ad",
                timeout = 2500,
                color = "#ff8f1a",
            },
        })
    end
    
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('LoadAdverts', function()
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('ClearAlerts', function(data, cb)
    local chat = data.number
    local ChatKey = GetKeyByNumber(chat)
    
    if PhoneData.Chats[ChatKey].Unread ~= nil then
        local newAlerts = (Config.PhoneApplications['whatsapp'].Alerts - PhoneData.Chats[ChatKey].Unread)
        Config.PhoneApplications['whatsapp'].Alerts = newAlerts
        TriggerServerEvent('MI-phone:server:SetPhoneAlerts', "whatsapp", newAlerts)
        
        PhoneData.Chats[ChatKey].Unread = 0
        
        SendNUIMessage({
            action = "RefreshWhatsappAlerts",
            Chats = PhoneData.Chats,
        })
        SendNUIMessage({action = "RefreshAppAlerts", AppData = Config.PhoneApplications})
    end
end)

RegisterNUICallback('PayInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId
    
    ESX.TriggerServerCallback('MI-phone:server:CanPayInvoice', function(CanPay)
        if CanPay then
            PayInvoice(cb, invoiceId)
        else
            cb(false)
        end
    end, amount)
end)

function PayInvoice(cb, invoiceId)
    cb(true)
    ESX.TriggerServerCallback('esx_billing:payBill', function()
        ESX.TriggerServerCallback('MI-phone:server:GetInvoices', function(Invoices)
            PhoneData.Invoices = Invoices
        end)
    end, invoiceId)
end

RegisterNUICallback('DeclineInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId
    
    ESX.TriggerServerCallback('MI-phone:server:DeclineInvoice', function(CanPay, Invoices)
        PhoneData.Invoices = Invoices
        cb('ok')
    end, sender, amount, invoiceId)
end)

RegisterNUICallback('EditContact', function(data, cb)
    local NewName = data.CurrentContactName
    local NewNumber = data.CurrentContactNumber
    local NewIban = data.CurrentContactIban
    local OldName = data.OldContactName
    local OldNumber = data.OldContactNumber
    local OldIban = data.OldContactIban
    
    for k, v in pairs(PhoneData.Contacts) do
        if v.name == OldName and v.number == OldNumber then
            v.name = NewName
            v.number = NewNumber
            v.iban = NewIban
        end
    end
    if PhoneData.Chats[NewNumber] ~= nil and next(PhoneData.Chats[NewNumber]) ~= nil then
        PhoneData.Chats[NewNumber].name = NewName
    end
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    TriggerServerEvent('MI-phone:server:EditContact', NewName, NewNumber, NewIban, OldName, OldNumber, OldIban)
end)

function GenerateTweetId()
    local tweetId = "TWEET-" .. math.random(11111111, 99999999)
    return tweetId
end

RegisterNetEvent('MI-phone:client:UpdateHashtags')
AddEventHandler('MI-phone:client:UpdateHashtags', function(Handle, msgData)
    if PhoneData.Hashtags[Handle] ~= nil then
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    else
        PhoneData.Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    end
    
    SendNUIMessage({
        action = "UpdateHashtags",
        Hashtags = PhoneData.Hashtags,
    })
end)

RegisterNUICallback('GetHashtagMessages', function(data, cb)
    if PhoneData.Hashtags[data.hashtag] ~= nil and next(PhoneData.Hashtags[data.hashtag]) ~= nil then
        cb(PhoneData.Hashtags[data.hashtag])
    else
        cb(nil)
    end
end)

RegisterNUICallback('GetTweets', function(data, cb)
    cb(PhoneData.Tweets)
end)

RegisterNUICallback('UpdateProfilePicture', function(data)
    local pf = data.profilepicture
    
    TriggerServerEvent('MI-phone:server:SaveMetaData', 'profilepicture', pf)
end)

local patt = "[?!@#]"

RegisterNUICallback('PostNewTweet', function(data, cb)

    local TweetMessage = {
        firstName = PhoneData.PlayerData.charinfo.firstname,
        lastName = PhoneData.PlayerData.charinfo.lastname,
        message = data.Message,
        url = data.url,
        time = data.Date,
        id =  PhoneData.id,
        picture = data.Picture
    }
    test = ""
    TriggerServerEvent("lucid_phone:saveTwitterToDatabase", TweetMessage.firstName, TweetMessage.lastName, TweetMessage.message, TweetMessage.url, TweetMessage.time, TweetMessage.picture)
   TriggerServerEvent("lucid_phone:server:updateidForEveryone")
    local TwitterMessage = data.Message
    local MentionTag = TwitterMessage:split("@")
    local Hashtag = TwitterMessage:split("#")
print(json.encode(TweetMessage))
    for i = 2, #Hashtag, 1 do
        local Handle = Hashtag[i]:split(" ")[1]
        if Handle ~= nil or Handle ~= "" then
            local InvalidSymbol = string.match(Handle, patt)
            if InvalidSymbol then
                Handle = Handle:gsub("%"..InvalidSymbol, "")
            end
            TriggerServerEvent('MI-Phone:server:UpdateHashtags', Handle, TweetMessage)
        end
    end

    for i = 2, #MentionTag, 1 do
        local Handle = MentionTag[i]:split(" ")[1]
        if Handle ~= nil or Handle ~= "" then
            local Fullname = Handle:split("_")
            local Firstname = Fullname[1]
            table.remove(Fullname, 1)
            local Lastname = table.concat(Fullname, " ")

            if (Firstname ~= nil and Firstname ~= "") and (Lastname ~= nil and Lastname ~= "") then
                if Firstname ~= PhoneData.PlayerData.charinfo.firstname and Lastname ~= PhoneData.PlayerData.charinfo.lastname then
                    TriggerServerEvent('MI-Phone:server:MentionedPlayer', Firstname, Lastname, TweetMessage)
                else
                    SetTimeout(2500, function()
                        SendNUIMessage({
                            action = "PhoneNotification",
                            PhoneNotify = {
                                title = Lang("TWITTER_TITLE"), 
                                text = Lang("MENTION_YOURSELF"), 
                                icon = "fab fa-twitter",
                                color = "#1DA1F2",
                            },
                        })
                    end)
                end
            end
        end
    end
    Citizen.Wait(1000)


    table.insert(PhoneData.Tweets, TweetMessage)
    table.insert(PhoneData.SelfTweets, TweetMessage)
    TriggerServerEvent('lucid_phone:server:updateForEveryone', PhoneData.Tweets)
    cb(PhoneData.Tweets)
    TriggerServerEvent('MI-Phone:server:UpdateTweets', TweetMessage)
    SendNUIMessage({
        action= "updateTest",
        selftTweets= PhoneData.SelfTweets
    })
end)



RegisterNUICallback('GetSelfTweets', function(data, cb)
    cb(PhoneData.SelfTweets)
end)


local function getIndex(tab, val)
    local index = nil
    for i, v in ipairs (tab) do 
        if (v.id == val) then
          index = i 
        end
    end
    return index
end

Citizen.CreateThread(function()
    while true do
        if PhoneData.isOpen then
            SendNUIMessage({
                action = "updateTweets",
                tweets = PhoneData.Tweets,
                selfTweets = PhoneData.SelfTweets,
            })
        end
        Citizen.Wait(2000)
    end
end)

RegisterNetEvent("lucid_phone:updateForEveryone")
AddEventHandler("lucid_phone:updateForEveryone", function(newTweet)
    PhoneData.Tweets = newTweet
end)

RegisterNetEvent("lucid_phone:updateidForEveryone")
AddEventHandler("lucid_phone:updateidForEveryone", function()
    PhoneData.id  = PhoneData.id + 1
end)

RegisterNetEvent('MI-phone:client:TransferMoney')
AddEventHandler('MI-phone:client:TransferMoney', function(amount, newmoney)
    if PhoneData.isOpen then
        SendNUIMessage({action = "PhoneNotification", PhoneNotify = {title = "bank", text = "There is $" .. amount .. " credited!", icon = "fas fa-university", color = "#8c7ae6", }, })
        SendNUIMessage({action = "UpdateBank", NewBalance = newmoney})
    else
        SendNUIMessage({action = "Notification", NotifyData = {title = "bank", content = "There is $" .. amount .. " credited!", icon = "fas fa-university", timeout = 2500, color = nil, }, })
    end
end)

RegisterNetEvent('MI-phone:client:UpdateTweets')
AddEventHandler('MI-phone:client:UpdateTweets', function(src, Tweets, NewTweetData)
    PhoneData.Tweets = Tweets
    local MyPlayerId = PhoneData.PlayerData.source
    
    if src ~= MyPlayerId then
        if not PhoneData.isOpen then
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = Lang("TWITTER_NEW") .. " (@" .. NewTweetData.firstName .. " " .. NewTweetData.lastName .. ")",
                    content = NewTweetData.message,
                    icon = "fab fa-twitter",
                    timeout = 3500,
                    color = nil,
                },
            })
        else
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = Lang("TWITTER_NEW") .. " (@" .. NewTweetData.firstName .. " " .. NewTweetData.lastName .. ")",
                    text = NewTweetData.message,
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                },
            })
        end
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("TWITTER_TITLE"),
                text = Lang("TWITTER_POSTED"),
                icon = "fab fa-twitter",
                color = "#1DA1F2",
                timeout = 1000,
            },
        })
    end
end)

RegisterNUICallback('GetMentionedTweets', function(data, cb)
    cb(PhoneData.MentionedTweets)
end)

RegisterNUICallback('GetHashtags', function(data, cb)
    if PhoneData.Hashtags ~= nil and next(PhoneData.Hashtags) ~= nil then
        cb(PhoneData.Hashtags)
    else
        cb(nil)
    end
end)

RegisterNetEvent('MI-phone:client:GetMentioned')
AddEventHandler('MI-phone:client:GetMentioned', function(TweetMessage, AppAlerts)
    Config.PhoneApplications["twitter"].Alerts = AppAlerts
    if not PhoneData.isOpen then
        SendNUIMessage({action = "Notification", NotifyData = {title = Lang("TWITTER_GETMENTIONED"), content = TweetMessage.message, icon = "fab fa-twitter", timeout = 3500, color = nil, }, })
    else
        SendNUIMessage({action = "PhoneNotification", PhoneNotify = {title = Lang("TWITTER_GETMENTIONED"), text = TweetMessage.message, icon = "fab fa-twitter", color = "#1DA1F2", }, })
    end
    local TweetMessage = {firstName = TweetMessage.firstName, lastName = TweetMessage.lastName, message = TweetMessage.message, time = TweetMessage.time, picture = TweetMessage.picture}
    table.insert(PhoneData.MentionedTweets, TweetMessage)
    SendNUIMessage({action = "RefreshAppAlerts", AppData = Config.PhoneApplications})
    SendNUIMessage({action = "UpdateMentionedTweets", Tweets = PhoneData.MentionedTweets})
end)

RegisterNUICallback('ClearMentions', function()
    Config.PhoneApplications["twitter"].Alerts = 0
    SendNUIMessage({
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
    TriggerServerEvent('MI-phone:server:SetPhoneAlerts', "twitter", 0)
    SendNUIMessage({action = "RefreshAppAlerts", AppData = Config.PhoneApplications})
end)

RegisterNUICallback('ClearGeneralAlerts', function(data)
    SetTimeout(400, function()
        Config.PhoneApplications[data.app].Alerts = 0
        SendNUIMessage({
            action = "RefreshAppAlerts",
            AppData = Config.PhoneApplications
        })
        TriggerServerEvent('MI-phone:server:SetPhoneAlerts', data.app, 0)
        SendNUIMessage({action = "RefreshAppAlerts", AppData = Config.PhoneApplications})
    end)
end)

function string:split(delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(self, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(self, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from)
    end
    table.insert(result, string.sub(self, from))
    return result
end

RegisterNUICallback('TransferMoney', function(data, callback)
    local cb = callback
    local amount = tonumber(data.amount)
    
    ESX.TriggerServerCallback('MI-phone:server:GetBankData', function(bankdata)
        if tonumber(bankdata.bank) >= amount then
            local amaountata = tonumber(bankdata.bank) - amount
            TriggerServerEvent('MI-phone:server:TransferMoney', data.iban, amount)
            local cbdata = {
                CanTransfer = true,
                NewAmount = amaountata
            }
            cb(cbdata)
        else
            local cbdata = {
                CanTransfer = false,
                NewAmount = nil,
            }
            cb(cbdata)
        end
    end)
end)


RegisterNUICallback('DeleteTweet', function(data, cb)
    TriggerServerEvent("lucid_phone:deleteTweet", data.id)
    local idx = getIndex(PhoneData.SelfTweets, data.id)
    local idx2 = getIndex(PhoneData.Tweets, data.id)

    table.remove(PhoneData.SelfTweets,idx)
    table.remove(PhoneData.Tweets,idx2)
    TriggerServerEvent('lucid_phone:server:updateForEveryone', PhoneData.Tweets)
end)

RegisterNUICallback('GetWhatsappChats', function(data, cb)
    ESX.TriggerServerCallback('MI-phone:server:GetContactPictures', function(Chats)
        cb(Chats)
    end, PhoneData.Chats)
end)

RegisterNUICallback('CallContact', function(data, cb)
    ESX.TriggerServerCallback('MI-phone:server:GetCallState', function(CanCall, IsOnline)
        print("PENIS FUCKER FUCK FUCK")
        print(CanCall, IsOnline)
        local status = {
            CanCall = CanCall,
            IsOnline = IsOnline,
            InCall = PhoneData.CallData.InCall,
        }
        cb(status)
        if CanCall and not status.InCall and (data.ContactData.number ~= PhoneData.PlayerData.charinfo.phone) then
            CallContact(data.ContactData, data.Anonymous)
        end
    end, data.ContactData)
end)

function GenerateCallId(caller, target)
    local CallId = math.ceil(((tonumber(caller) + tonumber(target)) / 100 * 1))
    return CallId
end

CallContact = function(CallData, AnonymousCall)
    local RepeatCount = 0
    PhoneData.CallData.CallType = "outgoing"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.CallId = GenerateCallId(PhoneData.PlayerData.charinfo.phone, CallData.number)
    
    print(AnonymousCall)
    
    TriggerServerEvent('MI-phone:server:CallContact', PhoneData.CallData.TargetData, PhoneData.CallData.CallId, AnonymousCall)
    TriggerServerEvent('MI-phone:server:SetCallState', true)
    
    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.1)
                else
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                CancelCall()
                break
            end
        else
            break
        end
    end
end

CancelCall = function()
    TriggerServerEvent('MI-phone:server:CancelCall', PhoneData.CallData)
    if PhoneData.CallData.CallType == "ongoing" then
        -- exports.tokovoip_script:removePlayerFromRadio(PhoneData.CallData.CallId)
        exports["mumble-voip"]:SetCallChannel(0)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}
    PhoneData.CallData.CallId = nil
    
    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end
    
    TriggerServerEvent('MI-phone:server:SetCallState', false)
    
    if not PhoneData.isOpen then
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("PHONE_TITLE"),
                content = Lang("PHONE_CALL_END"),
                icon = "fas fa-phone",
                timeout = 3500,
                color = "#e84118",
            },
        })
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("PHONE_TITLE"),
                text = Lang("PHONE_CALL_END"),
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })
        
        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })
        
        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end

RegisterNetEvent('MI-phone:client:CancelCall')
AddEventHandler('MI-phone:client:CancelCall', function()
    if PhoneData.CallData.CallType == "ongoing" then
        SendNUIMessage({
            action = "CancelOngoingCall"
        })
        --exports.tokovoip_script:removePlayerFromRadio(PhoneData.CallData.CallId)
        exports["mumble-voip"]:SetCallChannel(0)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}
    
    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end
    
    TriggerServerEvent('MI-phone:server:SetCallState', false)
    
    if not PhoneData.isOpen then
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("PHONE_TITLE"),
                content = Lang("PHONE_CALL_END"),
                icon = "fas fa-phone",
                timeout = 3500,
                color = "#e84118",
            },
        })
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("PHONE_TITLE"),
                text = Lang("PHONE_CALL_END"),
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })
        
        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })
        
        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end)

RegisterNetEvent('MI-phone:client:GetCalled')
AddEventHandler('MI-phone:client:GetCalled', function(CallerNumber, CallId, AnonymousCall)
    local RepeatCount = 0
    local CallData = {
        number = CallerNumber,
        name = IsNumberInContacts(CallerNumber),
        anonymous = AnonymousCall
    }
    
    print(AnonymousCall)
    
    if AnonymousCall then
        CallData.name = "Unknown Caller"
    end
    
    PhoneData.CallData.CallType = "incoming"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.CallId = CallId
    
    TriggerServerEvent('MI-phone:server:SetCallState', true)
    
    SendNUIMessage({
        action = "SetupHomeCall",
        CallData = PhoneData.CallData,
    })
    
    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "ringing", 0.2)
                    
                    if not PhoneData.isOpen then
                        SendNUIMessage({
                            action = "IncomingCallAlert",
                            CallData = PhoneData.CallData.TargetData,
                            Canceled = false,
                            AnonymousCall = AnonymousCall,
                        })
                    end
                else
                    SendNUIMessage({
                        action = "IncomingCallAlert",
                        CallData = PhoneData.CallData.TargetData,
                        Canceled = true,
                        AnonymousCall = AnonymousCall,
                    })
                    TriggerServerEvent('MI-phone:server:AddRecentCall', "missed", CallData)
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                SendNUIMessage({
                    action = "IncomingCallAlert",
                    CallData = PhoneData.CallData.TargetData,
                    Canceled = true,
                    AnonymousCall = AnonymousCall,
                })
                TriggerServerEvent('MI-phone:server:AddRecentCall', "missed", CallData)
                break
            end
        else
            TriggerServerEvent('MI-phone:server:AddRecentCall', "missed", CallData)
            break
        end
    end
end)

RegisterNUICallback('CancelOutgoingCall', function()
    CancelCall()
end)

RegisterNUICallback('DenyIncomingCall', function()
    CancelCall()
end)

RegisterNUICallback('CancelOngoingCall', function()
    CancelCall()
end)

RegisterNUICallback('AnswerCall', function()
    AnswerCall()
end)

function AnswerCall()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0
        
        SendNUIMessage({action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({action = "SetupHomeCall", CallData = PhoneData.CallData})
        
        TriggerServerEvent('MI-phone:server:SetCallState', true)
        
        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end
        
        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end
                
                Citizen.Wait(1000)
            end
        end)
        
        TriggerServerEvent('MI-phone:server:AnswerCall', PhoneData.CallData)
        
        -- exports.tokovoip_script:addPlayerToRadio(PhoneData.CallData.CallId, 'Phone')
        exports["mumble-voip"]:SetCallChannel(PhoneData.CallData.CallId)
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false
        
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("PHONE_TITLE"),
                text = Lang("PHONE_NOINCOMING"),
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })
    end
end

RegisterNetEvent('MI-phone:client:AnswerCall')
AddEventHandler('MI-phone:client:AnswerCall', function()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0
        
        SendNUIMessage({action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({action = "SetupHomeCall", CallData = PhoneData.CallData})
        
        TriggerServerEvent('MI-phone:server:SetCallState', true)
        
        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end
        
        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end
                
                Citizen.Wait(1000)
            end
        end)
        
        --exports.tokovoip_script:addPlayerToRadio(PhoneData.CallData.CallId, 'Phone')
        exports["mumble-voip"]:SetCallChannel(PhoneData.CallData.CallId)
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false
        
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("PHONE_TITLE"),
                text = Lang("PHONE_NOINCOMING"),
                icon = "fas fa-phone",
                color = "#e84118",
            },
        })
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)

RegisterNUICallback('FetchSearchResults', function(data, cb)
    ESX.TriggerServerCallback('MI-phone:server:FetchResult', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleResults', function(data, cb)
    ESX.TriggerServerCallback('MI-phone:server:GetVehicleSearchResults', function(result)
        if result ~= nil then
            for k, v in pairs(result) do
                result[k].isFlagged = false
            end
        end
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleScan', function(data, cb)
    local vehicle = ESX.Game.GetClosestVehicle()
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetEntityModel(vehicle)
    ESX.TriggerServerCallback('MI-phone:server:ScanPlate', function(result)
        local vehname = result.vehiclename
        result.isFlagged = false
        result.label = vehname
        cb(result)
    end, plate)
end)

RegisterNetEvent('MI-phone:client:addPoliceAlert')
AddEventHandler('MI-phone:client:addPoliceAlert', function(alertData)
    if PlayerJob.name == 'police' then
        SendNUIMessage({
            action = "AddPoliceAlert",
            alert = alertData,
        })
    end
end)

RegisterNUICallback('SetAlertWaypoint', function(data)
    local coords = data.alert.coords
    
    TriggerEvent('notification', Lang("GPS_SET") .. data.alert.title)
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterNUICallback('RemoveSuggestion', function(data, cb)
    local data = data.data
    
    if PhoneData.SuggestedContacts ~= nil and next(PhoneData.SuggestedContacts) ~= nil then
        for k, v in pairs(PhoneData.SuggestedContacts) do
            if (data.name[1] == v.name[1] and data.name[2] == v.name[2]) and data.number == v.number and data.bank == v.bank then
                table.remove(PhoneData.SuggestedContacts, k)
            end
        end
    end
end)



RegisterNetEvent('MI-phone:client:GiveContactDetails')
AddEventHandler('MI-phone:client:GiveContactDetails', function()
    local ped = GetPlayerPed(-1)
    
    local player, distance = ESX.Game.GetClosestPlayer()
    if player ~= -1 and distance < 3.5 then
        local PlayerId = GetPlayerServerId(player)
        TriggerServerEvent('MI-phone:server:GiveContactDetails', PlayerId)
    else
        TriggerEvent('notification', Lang("NO_ONE"), 2)
    end
end)

RegisterNUICallback('DeleteContact', function(data, cb)
    local Name = data.CurrentContactName
    local Number = data.CurrentContactNumber
    local Account = data.CurrentContactIban
    
    for k, v in pairs(PhoneData.Contacts) do
        if v.name == Name and v.number == Number then
            table.remove(PhoneData.Contacts, k)
            if PhoneData.isOpen then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = Lang("PHONE_TITLE"),
                        text = Lang("CONTACTS_REMOVED"),
                        icon = "fa fa-phone-alt",
                        color = "#04b543",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "Notification",
                    NotifyData = {
                        title = Lang("PHONE_TITLE"),
                        content = Lang("CONTACTS_REMOVED"),
                        icon = "fa fa-phone-alt",
                        timeout = 3500,
                        color = "#04b543",
                    },
                })
            end
            break
        end
    end
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[Number] ~= nil and next(PhoneData.Chats[Number]) ~= nil then
        PhoneData.Chats[Number].name = Number
    end
    TriggerServerEvent('MI-phone:server:RemoveContact', Name, Number)
end)

RegisterNetEvent('MI-phone:client:AddNewSuggestion')
AddEventHandler('MI-phone:client:AddNewSuggestion', function(SuggestionData)
    table.insert(PhoneData.SuggestedContacts, SuggestionData)
    
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("PHONE_TITLE"),
                text = Lang("CONTACTS_NEWSUGGESTED"),
                icon = "fa fa-phone-alt",
                color = "#04b543",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("PHONE_TITLE"),
                content = Lang("CONTACTS_NEWSUGGESTED"),
                icon = "fa fa-phone-alt",
                timeout = 3500,
                color = "#04b543",
            },
        })
    end
    
    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    TriggerServerEvent('MI-phone:server:SetPhoneAlerts', "phone", Config.PhoneApplications["phone"].Alerts)
end)

RegisterNUICallback('GetCryptoData', function(data, cb)
    ESX.TriggerServerCallback('qb-crypto:server:GetCryptoData', function(CryptoData)
        print('GetCryptoData', json.encode(CryptoData))
        cb(CryptoData)
    end)
end)

RegisterNUICallback('BuyCrypto', function(data, cb)
    print('BuyCrypto', json.encode(data))
    ESX.TriggerServerCallback('qb-crypto:server:BuyCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNUICallback('SellCrypto', function(data, cb)
    print('SellCrypto', json.encode(data))
    ESX.TriggerServerCallback('qb-crypto:server:SellCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNUICallback('TransferCrypto', function(data, cb)
    print('TransferCrypto', json.encode(data))
    ESX.TriggerServerCallback('qb-crypto:server:TransferCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNetEvent('MI-phone:client:RemoveBankMoney')
AddEventHandler('MI-phone:client:RemoveBankMoney', function(amount)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("BANK_TITLE"),
                text = "There is €" .. amount .. " withdraw from your bank!",
                icon = "fas fa-university",
                color = "#ff002f",
                timeout = 3500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("BANK_TITLE"),
                content = "There is €" .. amount .. " withdraw from your bank!",
                icon = "fas fa-university",
                timeout = 3500,
                color = "#ff002f",
            },
        })
    end
end)
RegisterNetEvent('MI-phone:client:AddTransaction')
AddEventHandler('MI-phone:client:AddTransaction', function(SenderData, TransactionData, Message, Title)
    local Data = {
        TransactionTitle = Title,
        TransactionMessage = Message,
    }
    
    table.insert(PhoneData.CryptoTransactions, Data)
    
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("CRYPTO_TITLE"),
                text = Message,
                icon = "fas fa-chart-pie",
                color = "#04b543",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("CRYPTO_TITLE"),
                content = Message,
                icon = "fas fa-chart-pie",
                timeout = 3500,
                color = "#04b543",
            },
        })
    end
    
    SendNUIMessage({
        action = "UpdateTransactions",
        CryptoTransactions = PhoneData.CryptoTransactions
    })
    
    TriggerServerEvent('MI-phone:server:AddTransaction', Data)
end)


RegisterNUICallback('GetCryptoTransactions', function(data, cb)
  --  ESX.TriggerServerCallback('qb-crypto:server:GetCryptoTransactions', function(CryptoHistory)
        --cb(CryptoHistory)
    --end)
end)

RegisterNUICallback('GetAvailableRaces', function(data, cb)
    ESX.TriggerServerCallback('qb-lapraces:server:GetRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('JoinRace', function(data)
    TriggerServerEvent('qb-lapraces:server:JoinRace', data.RaceData)
end)

RegisterNUICallback('LeaveRace', function(data)
    TriggerServerEvent('qb-lapraces:server:LeaveRace', data.RaceData)
end)

RegisterNUICallback('StartRace', function(data)
    TriggerServerEvent('qb-lapraces:server:StartRace', data.RaceData.RaceId)
end)

RegisterNetEvent('MI-phone:client:UpdateLapraces')
AddEventHandler('MI-phone:client:UpdateLapraces', function()
    SendNUIMessage({
        action = "UpdateRacingApp",
    })
end)

RegisterNUICallback('GetRaces', function(data, cb)
    ESX.TriggerServerCallback('qb-lapraces:server:GetListedRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('GetTrackData', function(data, cb)
    ESX.TriggerServerCallback('qb-lapraces:server:GetTrackData', function(TrackData, CreatorData)
        TrackData.CreatorData = CreatorData
        cb(TrackData)
    end, data.RaceId)
end)

RegisterNUICallback('SetupRace', function(data, cb)
    TriggerServerEvent('qb-lapraces:server:SetupRace', data.RaceId, tonumber(data.AmountOfLaps))
end)

RegisterNUICallback('HasCreatedRace', function(data, cb)
    ESX.TriggerServerCallback('qb-lapraces:server:HasCreatedRace', function(HasCreated)
        cb(HasCreated)
    end)
end)

RegisterNUICallback('IsInRace', function(data, cb)
    local InRace = exports['cyber-qb-lapraces']:IsInRace()
    print(InRace)
    cb(InRace)
end)

RegisterNUICallback('IsAuthorizedToCreateRaces', function(data, cb)
    ESX.TriggerServerCallback('qb-lapraces:server:IsAuthorizedToCreateRaces', function(NameAvailable)
        local data = {
            IsAuthorized = true,
            IsBusy = exports['cyber-qb-lapraces']:IsInEditor(),
            IsNameAvailable = NameAvailable,
        }
        cb(data)
    end, data.TrackName)
end)

RegisterNUICallback('StartTrackEditor', function(data, cb)
    TriggerServerEvent('qb-lapraces:server:CreateLapRace', data.TrackName)
end)

RegisterNUICallback('GetRacingLeaderboards', function(data, cb)
    ESX.TriggerServerCallback('qb-lapraces:server:GetRacingLeaderboards', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('RaceDistanceCheck', function(data, cb)
    ESX.TriggerServerCallback('qb-lapraces:server:GetRacingData', function(RaceData)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local checkpointcoords = RaceData.Checkpoints[1].coords
        local dist = GetDistanceBetweenCoords(coords, checkpointcoords.x, checkpointcoords.y, checkpointcoords.z, true)
        print(dist)
        if dist <= 115.0 then
            if data.Joined then
                TriggerEvent('qb-lapraces:client:WaitingDistanceCheck')
            end
            cb(true)
        else
            TriggerEvent('notification', 'You are too far from the race. Your navigation is set to the race.', 2)
            SetNewWaypoint(checkpointcoords.x, checkpointcoords.y)
            cb(false)
        end
    end, data.RaceId)
end)

RegisterNUICallback('IsBusyCheck', function(data, cb)
    if data.check == "editor" then
        cb(exports['cyber-qb-lapraces']:IsInEditor())
    else
        cb(exports['cyber-qb-lapraces']:IsInRace())
    end
end)

RegisterNUICallback('CanRaceSetup', function(data, cb)
    ESX.TriggerServerCallback('qb-lapraces:server:CanRaceSetup', function(CanSetup)
        cb(CanSetup)
    end)
end)

RegisterNUICallback('GetPlayerHouses', function(data, cb)
    ESX.TriggerServerCallback('cash-telephone:server:GetPlayerHouses', function(Houses)
        cb(Houses)
        print('encodeded retunr', json.encode(Houses))
    end)
end)

RegisterNUICallback('RemoveKeyholder', function(data)
    TriggerServerEvent('qb-houses:server:removeHouseKey', data.HouseData.name, {
        identifier = data.HolderData.identifier,
        firstname = data.HolderData.charinfo.firstname,
        lastname = data.HolderData.charinfo.lastname,
    })
end)

RegisterNUICallback('FetchPlayerHouses', function(data, cb)
    ESX.TriggerServerCallback('MI-phone:server:MeosGetPlayerHouses', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('SetGPSLocation', function(data, cb)
    local ped = GetPlayerPed(-1)
    
    SetNewWaypoint(data.coords.x, data.coords.y)
    TriggerEvent('notification', 'GPS is set!')
end)

RegisterNUICallback('SetApartmentLocation', function(data, cb)
    local ApartmentData = data.data.appartmentdata
    local TypeData = Apartments.Locations[ApartmentData.type]
    
    SetNewWaypoint(TypeData.coords.enter.x, TypeData.coords.enter.y)
    TriggerEvent('notification', 'GPS is set!')
end)

RegisterNUICallback('GetCurrentLawyers', function(data, cb)
    ESX.TriggerServerCallback('MI-phone:server:GetCurrentLawyers', function(lawyers)
        print('cb lawe', json.encode(lawyers))
        cb(lawyers)
    end)
end)

Lang = function(item)
    local lang = Config.Languages[Config.Language]
    
    if lang and lang[item] then
        return lang[item]
    end
    
    return item
end

RegisterNUICallback('GetLangData', function(data, cb)
    cb({table = Config.Languages, current = Config.Language})
end)





local takePhoto = false
RegisterNUICallback('PostNewImage', function(data, cb)
        
        SetNuiFocus(false, false)
        CreateMobilePhone(1)
        CellCamActivate(true, true)
        takePhoto = true
        
        
        
        while takePhoto do
            Citizen.Wait(0)
            
            if IsControlJustPressed(1, 27) then -- Toogle Mode
                frontCam = not frontCam
                CellFrontCamActivate(frontCam)
            
            else if IsControlJustPressed(1, 176) then
                exports['screenshot-basic']:requestScreenshotUpload('https://discord.com/api/webhooks/798134994286805002/hntgrjkXC0s3OkOjobdKpqMIgIel_0jZj1en9ltKgwUpdjICsFrYkepK09G0gP5yE7wr', 'files[]', function(data2)
                    DestroyMobilePhone()
                    CellCamActivate(false, false)
                    local resp = json.decode(data2)
                    test = resp.attachments[1].proxy_url
                    cb(resp.attachments[1].proxy_url)
                end)
                DestroyMobilePhone()
                takePhoto = false
            end
            end
        end
        OpenPhone()

end)

RegisterNUICallback('SetupStoreApps', function(data, cb)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local data = {
        StoreApps = Config.StoreApps,
        PhoneData = PlayerData.metadata["phonedata"]
    }
    cb(data)
end)

function GetFirstAvailableSlot()
    local retval = 0
    for k, v in pairs(Config.PhoneApplications) do
        retval = retval + 1
    end
    return (retval + 1)
end

local CanDownloadApps = false

RegisterNUICallback('InstallApplication', function(data, cb)
    local ApplicationData = Config.StoreApps[data.app]
    local NewSlot = GetFirstAvailableSlot()
    
    if not CanDownloadApps then
        return
    end
    
    if NewSlot <= Config.MaxSlots then
        TriggerServerEvent('qb-phone_new:server:InstallApplication', {
            app = data.app,
        })
        cb({
            app = data.app,
            data = ApplicationData
        })
    else
        cb(false)
    end
end)

RegisterNUICallback('RemoveApplication', function(data, cb)
    TriggerServerEvent('qb-phone_new:server:RemoveInstallation', data.app)
end)

RegisterNetEvent('qb-phone_new:RefreshPhone')
AddEventHandler('qb-phone_new:RefreshPhone', function()
    LoadPhone()
    SetTimeout(250, function()
        SendNUIMessage({
            action = "RefreshAlerts",
            AppData = Config.PhoneApplications,
        })
    end)
end)

RegisterNUICallback('GetTruckerData', function(data, cb)
    local TruckerMeta = QBCore.Functions.GetPlayerData().metadata["jobrep"]["trucker"]
    local TierData = exports['qb-trucker']:GetTier(TruckerMeta)
    cb(TierData)
end)


RegisterNUICallback('GiveClosestNumber', function(data, cb)
    ExecuteCommand('ph')
end)

RegisterCommand('ph', function()
    TriggerEvent('MI-phone:client:GiveContactDetails')
end, false)
