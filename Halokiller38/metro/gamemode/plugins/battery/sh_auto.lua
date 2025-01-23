--[[
	Name: sh_auto.lua.
	Author: TJjokerR.
--]]

local PLUGIN = PLUGIN;

openAura.player:RegisterSharedVar("sh_Battery", NWTYPE_NUMBER, true);

openAura:IncludePrefixed("sv_hooks.lua");
openAura:IncludePrefixed("cl_hooks.lua");