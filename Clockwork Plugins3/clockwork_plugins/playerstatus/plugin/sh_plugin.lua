--[[
	� 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	https://creativecommons.org/licenses/by-nc-nd/3.0/legalcode
--]]

--[[
	You don't have to do this, but I think it's nicer.
	Alternatively, you can simply use the PLUGIN variable.
--]]


--[[ You don't have to do this either, but I prefer to seperate the functions. --]]

local PLUGIN = PLUGIN
local Clockwork = Clockwork


Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");

function PLUGIN:Initialize()
print("///////////////////////////")
print("//Player Status' Loaded.///")
print("// Created by Trurascalz //")
print("// Consider Donating to turascalz@gmail.com //")
print(":D")
print("///////////////////////////")
end
