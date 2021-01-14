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