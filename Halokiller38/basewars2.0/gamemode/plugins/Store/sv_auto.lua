--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;

function RP.Store:HideStore(player)
	RP:DataStream(player, "rpHideBuyMenu", {});
end;