AddEventHandler('esx:getSharAVACedObject', function(cb)
	cb(ESX)
end)

function getSharAVACedObject()
	return ESX
end
