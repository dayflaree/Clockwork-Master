local COMMAND = Clockwork.command:New("SpawnAPC");
COMMAND.tip = "Creates an APC at your crosshair.";
COMMAND.access = "a";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);

function COMMAND:OnRun(player, arguments)
	if (Schema:PlayerIsCombine(player) and player:GetFaction() == FACTION_OVERWATCH) then
		if (CurTime() > (player.nextAPC or 0)) then
			local apc = ents.Create("prop_vehicle_zapc");
			apc:SetPos(player:GetEyeTraceNoCursor().HitPos);
			apc:Spawn();
			apc:Activate();

			player.nextAPC = CurTime() + 2;

			Clockwork.player:Notify(player, "Successfully created an APC at your crosshair.");
		else
			Clockwork.player:Notify(player, "You cannot create another APC so soon!");
		end;
	else
		Clockwork.player:Notify(player, "You do not have access to this command!");
	end;
end;

COMMAND:Register();