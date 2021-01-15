RegisterKeyMapping('+handsup', '[Misc] Hands Up/Down', 'keyboard', 'X')

RegisterCommand('+handsup', function()
	local dict = "random@mugging3"
	RequestAnimDict(dict)
	TaskPlayAnim(PlayerPedId(), dict, "handsup_standing_base", 8.0, 8.0, -1, 50, 0, false, false, false)
end, false)

RegisterCommand('-handsup', function()
ClearPedTasks(PlayerPedId())
end, false)