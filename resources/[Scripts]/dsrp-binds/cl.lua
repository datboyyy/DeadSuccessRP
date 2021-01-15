local shouldBeExecuted = true
AddEventHandler('dsrp-binds:should-execute', function(shouldExecute)
	shouldBeExecuted = shouldExecute
end)

exports('registerKeyMapping', function(category, description, onKeyDownCommand, onKeyUpCommand, default, type)
	if not default then default = "" end
	if not type then type = "keyboard" end
	if not category then 
		print('no category provided for keymap')
		return
	end
	if not description then
		print('no description provided cancelling')
		return
	end
	local desc = "(" .. category .. ")" .. " " .. description
	cmdStringDown = "+cmd_wrapper_" .. onKeyDownCommand
	cmdStringUp = "-cmd_wrapper_" ..onKeyUpCommand
	RegisterCommand(cmdStringDown, function()
		if not shouldBeExecuted then return end
		ExecuteCommand(onKeyDownCommand)
	end, false)
	RegisterCommand(cmdStringUp, function()
		if not shouldBeExecuted then return end
		ExecuteCommand(onKeyUpCommand)
	end, false)
	RegisterKeyMapping(cmdStringDown, desc, type, default)
end) 






-------------------------RegisterKeyMappings-----------------------
exports['dsrp-binds']:registerKeyMapping('[Inventory]', 'Bind 1', 'invbind1', 'keyboard', '1')
exports['dsrp-binds']:registerKeyMapping('[Inventory]', 'Bind 2', 'invbind2', 'keyboard', '2')
exports['dsrp-binds']:registerKeyMapping('[Inventory]', 'Bind 3', 'invbind3', 'keyboard', '3')
exports['dsrp-binds']:registerKeyMapping('[Inventory]', 'Bind 4', 'invbind4', 'keyboard', '4')
exports['dsrp-binds']:registerKeyMapping('[Misc]', 'Sell Drugs to NPC', 'drug:sell', 'keyboard', 'H')
exports['dsrp-binds']:registerKeyMapping('[Misc]', 'Toggle Crouch', 'crouch', 'keyboard', 'LCONTROL')
exports['dsrp-binds']:registerKeyMapping('[Phone]', 'Open Phone', 'phone', 'keyboard', 'F1')
exports['dsrp-binds']:registerKeyMapping('[Vehicle]', 'Vehicle lock', 'key:togglevehlock', 'keyboard', 'L')
exports['dsrp-binds']:registerKeyMapping('[Doorlock]', 'Toggle Door', 'toggledoorstate', 'keyboard', 'E')