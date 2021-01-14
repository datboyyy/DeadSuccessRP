1. place "st-banking" into your resources folder
2. edit your server.cfg to include "start st-banking"


3. edit es_extended > server > classes > player.lua with the following. (Any issues, check the above image)
	line 272 - TriggerClientEvent('st-banking:updateBank', self.source, newMoney)
	line 291 - TriggerClientEvent('st-banking:addBank', self.source, money)
	line 292 - TriggerClientEvent('st-banking:updateBank', self.source, newMoney)
	line 311 - TriggerClientEvent('st-banking:removeBank', self.source, money)
	line 312 - TriggerClientEvent('st-banking:updateBank', self.source, newMoney)

4. Join FiveM Sales & Trading discord - http://discord.gg/5bskZZ7



Dependencies:
mythic_notify
mythic_progbar