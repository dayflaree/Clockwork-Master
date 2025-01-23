--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;

function RP.Cash:CreateCash(pos, angles, amount)
	local money = ents.Create("cash");
	money:SetPos(pos + Vector(0, 0, 10));
	money:SetAngles(angles);
	money:SetNWInt("amount", amount);
	money:Spawn();
	money:Activate();
end;