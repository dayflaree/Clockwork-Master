
-----------------------------------------------------
local PLUGIN = PLUGIN;

 -- Called when an entity's target ID HUD should be painted. *THANK YOU NIGHTANGEL <3*
function PLUGIN:HUDPaintEntityTargetID(entity, info)
local colorTargetID = Clockwork.option:GetColor("target_id");
local colorWhite = Clockwork.option:GetColor("white");

if (entity:GetClass() == "cw_keycardlock") then
local lockLevel = tostring(entity:GetDTInt(0));

if (lockLevel != "") then
info.y = Clockwork.kernel:DrawInfo("Level "..lockLevel.." lock", info.x, info.y, colorWhite, info.alpha);
end;
end;
end;
