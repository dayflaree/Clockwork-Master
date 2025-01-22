
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

--Called when a player uses a salesman
function PLUGIN:PlayerUseSalesman(player, entity)
	Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has accessed the '"..entity:GetDTString(0).."' salesman.");
end;

--Called when a player's cash needs to be changed
function PLUGIN:PlayerCashUpdated(player, amount, reason, bNoMsg)
	if (amount != 0) then
		local cashName = Clockwork.option:GetKey("name_cash");

		-- If was not gained by picking up cw_cash entity (there's already a log for that)
		if (reason != cashName) then
			Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().."'s "..cashName.." has changed by "..amount..".");
		end;
	end;
end;

-- Called when an entity's menu option should be handled.
function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	if (arguments == "cwContainerOpen") then
		local name = entity:GetNetworkedString("Name");
		if (name == "") then
			Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has accessed a container (ID: "..entity:EntIndex().."; model: "..entity:GetModel()..").");
		else
			Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has accessed the '"..name.."' container (ID: "..entity:EntIndex().."; model: "..entity:GetModel()..").");
		end;
	end;
end;

--Called when a player picks up an entity with a physgun
function PLUGIN:PhysgunPickup(player, entity)
	local target = Clockwork.entity:GetPlayer(entity);
	if (target) then
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has physgunned "..target:Name()..".");	
	end;
end;

--Called when a C menu property is used
function PLUGIN:CanProperty(player, property, entity)
	Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has used the '"..property.."' Context Menu option.");	
end;

function PLUGIN:CanTool(player, trace, tool)
	if(tool == "creator") then
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has spawned a '"..player:GetInfo("creator_name").."' Entity.");
	end;
end;

function PLUGIN:DoPlayerDeath(player, attacker, damageInfo)
	if(IsValid(player)) then
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." died at location: "..tostring(player:GetPos())..".");
	end;
end;
