local PLUGIN = PLUGIN;

--[[
Clockwork.datastream:Hook("DoorKick", function(data)
	local player	= data[1];
	local door		= data[2];
	local ang		= data[3];
	local animClass	= Clockwork.animation:GetModelClass(player:GetModel());

	if (IsValid(player)) then
		if (IsValid(player.doorKicker)) then
			player.doorKicker:Remove();
			player.doorKicker = nil;
		end;

		local animObj = ents.CreateClientProp();
		animObj:SetModel(player:GetModel());
		animObj:SetPos(player:GetPos());
		animObj:SetAngles(ang);
		animObj:Spawn();

		local sequence = "kickdoorbaton";

		if (animClass == "combineOverwatch") then
			sequence = "melee_gunhit";
		end;

		animObj:SetSequence

		pl._kickDoorAnimObj = animObj
		pl._kickAnimStartTime = CurTime()
		pl:SetNoDraw(true)
		pl:DrawViewModel(false)
	end;
end);
]]--
