--[[
	© 2012 Slidefuse LLC
	This plugin is released under the MIT license. Do whatever!
--]]

local PLUGIN = PLUGIN

COMMAND = openAura.command:New()
COMMAND.tip = "Puts your character into a mood."
COMMAND.text = "<string moodType>"
COMMAND.flags = CMD_DEFAULT
COMMAND.arguments = 1

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
		


	if (table.HasValue(PLUGIN.PersonalityTypes, arguments[1])) then
		player:SetSharedVar("emoteMood", arguments[1])
	else
		openAura.player:Notify(player, "That is not a valid mood!")
	end

	//player:SetForcedAnimation("LineIdle02", 0, nil, nil)
end

openAura.command:Register(COMMAND, "SetMood")

if (CLIENT) then
	openAura.quickmenu:AddCommand("Set Mood", nil, "SetMood", PLUGIN.PersonalityTypes)
end