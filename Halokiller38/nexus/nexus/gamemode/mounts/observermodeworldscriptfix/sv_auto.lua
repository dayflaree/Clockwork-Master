--[[
Name: "sv_auto.lua"
Product: "WorldScript"
Property of Jake Wall
Copyright © 2012 ~ Do Not copy or redistribute!
--]]

local MOUNT = MOUNT;

function MOUNT:PlayerEnterObserverMode(player)
	player:SetMaterial("models/props_combine/portalball001_sheet")
end

function MOUNT:PlayerExitObserverMode(player)
	player:SetMaterial("")
end

--Thanks to Spencer Sharkey for the Material
--http://www.spencersharkey.com
--http://www.slidefuse.com
--http://www.slidefuse.net
--http://www.twitter.com/spencersharkey
--http://www.facebook.com/sassharkey