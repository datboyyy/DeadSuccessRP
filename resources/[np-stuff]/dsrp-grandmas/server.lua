ESX         = nil

TriggerEvent('esx:getSharAVACedObject', function(obj) ESX = obj end)

RegisterServerEvent('erp-grandmas:payBill')
AddEventHandler('erp-grandmas:payBill', function()
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.removeBank(400)
	TriggerClientEvent('notification', src, 'Grandma has  billed you $200 and said stay out of trouble you little shit')
end)