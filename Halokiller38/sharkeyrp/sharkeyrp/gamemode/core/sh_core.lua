RP.Name = "DarkRP Remastered";
RP.Author = "Spencer Sharkey";

//Called when the GM Starts
function RP:InitCore()
	return;
end;

//Called to get the core folder of the gamemode
function RP:CoreFolder(fromBase)
	if (!fromBase) then
		return "../"..self.Folder.."/gamemode/core/";
	end;

	return self.Folder.."/gamemode/core/";
end;

//Called when a player tries to noclip
function RP:PlayerNoclip(player)
	return player:IsAdmin();
	
	if (SERVER) then
		if (!player.isNoclip) then
			player.isNoclip = true;
			player:GodEnable(true);
			player:SetColor(Color(255, 255, 255, 0));
			player:DrawShadow(false);
		else
			player.isNoclip = false;
			player:GodEnable(false);
			player:SetColor(Color(255, 255, 255, 255));
			player:DrawShadow(true);
		end;
	end;
end;

//If you can see them, return true :D
function RP:CanSee(entity, target, iAllowance, tIgnoreEnts)
	local trace = {};
	trace.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER;
	trace.start = entity:LocalToWorld(entity:OBBCenter());
	trace.endpos = target:LocalToWorld(target:OBBCenter());
	trace.filter = {entity, target};
	
	if (tIgnoreEnts) then
		if (type(tIgnoreEnts) == "table") then
			table.Add(trace.filter, tIgnoreEnts);
		else
			table.Add(trace.filter, ents.GetAll());
		end;
	end;
	
	trace = util.TraceLine(trace);
	
	if (trace.Fraction >= (iAllowance or 0.75)) then
		return true;
	end;
end;

