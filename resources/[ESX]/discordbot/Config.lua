SystemAvatar = 'https://i.imgur.com/LRoLTlK.jpeg'

UserAvatar = 'https://i.imgur.com/LRoLTlK.jpeg'

SystemName = 'Sway System'


--[[ Special Commands formatting
		 *YOUR_TEXT*			--> Make Text Italics in Discord
		**YOUR_TEXT**			--> Make Text Bold in Discord
	   ***YOUR_TEXT***			--> Make Text Italics & Bold in Discord
		__YOUR_TEXT__			--> Underline Text in Discord
	   __*YOUR_TEXT*__			--> Underline Text and make it Italics in Discord
	  __**YOUR_TEXT**__			--> Underline Text and make it Bold in Discord
	 __***YOUR_TEXT***__		--> Underline Text and make it Italics & Bold in Discord
		~~YOUR_TEXT~~			--> Strikethrough Text in Discord
]]
-- Use 'USERNAME_NEEDED_HERE' without the quotes if you need a Users Name in a special command
-- Use 'USERID_NEEDED_HERE' without the quotes if you need a Users ID in a special command


-- These special commands will be printed differently in discord, depending on what you set it to
SpecialCommands = {
				   {'/ooc', '**[OOC]:**'},
				   {'/giveitem', '**(Admin: [ USERNAME_NEEDED_HERE ])** giveitem'},
				   {'/heal', '**(Admin: [ USERNAME_NEEDED_HERE ])** *healed* '},
				   {'/dv', '**(Admin: [ USERNAME_NEEDED_HERE ])** *Deleted vehicle*'},
				   {'/revive', '**(Admin: [ USERNAME_NEEDED_HERE ])** *Revived* '},
				   {'/giveweapon', '**(Admin: [ USERNAME_NEEDED_HERE ])** giveweapon'},
				   {'/car', '**(Admin: [ USERNAME_NEEDED_HERE ])** *spawned the vehicle:* '},
				   {'/fixveh', '**(Admin: [ USERNAME_NEEDED_HERE ])** *Repaired vehicle*'},
				   {'/kick', '**(Admin: [ USERNAME_NEEDED_HERE ])** <<You should not be using the kick command, use the M menu>> *kick*'},
				   {'/ban', '**(Admin: [ USERNAME_NEEDED_HERE ])** <<You should not be using the ban command, use the M menu>> *ban*'},
				   {'/giveaccountmoney', '**(Admin: [ USERNAME_NEEDED_HERE ])** giveaccountmoney'},
				   {'/logout', '**(Admin: [ USERNAME_NEEDED_HERE ])** *logged out/in* '},
				   {'/announce', '**(Admin: [ USERNAME_NEEDED_HERE ])** *announced '},
				  }

						
-- These blacklisted commands will not be printed in discord
BlacklistedCommands = {
					   '/AnyCommand',
					   '/AnyCommand2',
					  }

-- These Commands will use their own webhook
OwnWebhookCommands = {
					  {'/me', 'https://discord.com/api/webhooks/788347543993843733/FxlPWjjMPhZNNYgfUkQLeF1H2UdFVPWdxsfzy4kCo0MFmpa2wxjqHx1BYOqu65lr-nrp'},
					  {'/AnotherCommand2', 'WEBHOOK_LINK_HERE'},
					 }

-- These Commands will be sent as TTS messages
TTSCommands = {
			   '/report'
			  }

