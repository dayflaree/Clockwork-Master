local COMMAND = Clockwork.command:New("KickDoor");
COMMAND.tip = "Attempt to kick in the door you are looking at.";
COMMAND.flags = CMD_DEFAULT;

local blockedDoors = {
	[ "rp_city45_2013" ] = {
		438,
		439,
		440,
		441,
		1493,
		1494,
		1308,
		1309,
		1321,
		1322,
		1499,
		1500
	}
}

function COMMAND:OnRun( player )
	if (player:GetFaction() == FACTION_OTA or player:GetFaction() == FACTION_MPF) then
		if (!player:GetSharedVar("KickingDoor")) then
			local ent = player:GetEyeTraceNoCursor().Entity;

			if (IsValid(ent) and ent:GetClass() == "prop_door_rotating") then
				local dist = ent:GetPos():Distance(player:GetPos());

				if (dist > 45 and dist < 80) then
					local blocked = blockedDoors[game.GetMap()];

					if (!blocked or !table.HasValue( blocked, ent:EntIndex() )) then
						player:KickDoor(ent);
					else
						Clockwork.player:Notify( player, "This door can not be kicked in!" );
					end;
				end;
			end;
		end;
	else
		Clockwork.player:Notify( player, "You are too weak to kick this door in!" );

		return;
	end;
end;

COMMAND:Register();