local PLUGIN = PLUGIN;
local COMMAND = Clockwork.command:New("Grapple");
COMMAND.tip = "Attempts to latch a grappling hook onto the ledge you're aiming at.";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);

function COMMAND:OnRun(player, arguments)
	if (PLUGIN:HasEquipment(player)) then
		if (PLUGIN:CanGrapple(player)) then
			PLUGIN:BeginRappel(player, player:GetEyeTraceNoCursor().HitPos, player:GetEyeTraceNoCursor().HitNormal);

			if (!player.grappleSound) then
				player.grappleSound = CreateSound(player, "weapons/tripwire/ropeshoot.wav");
			end;

			player.grappleSound:Stop();
			player.grappleSound:Play();
			player.grappleSound:ChangeVolume(0.4, 0);
			timer.Simple(0.6, function()
				if (player.grappleSound) then
					player.grappleSound:FadeOut(0.5);
				end;
			end);
		else
			Clockwork.player:Notify(player, "Unable to find a suitable ledge to grapple!");
		end;
	else
		Clockwork.player:Notify(player, "You do not have the required equipment for that!");
	end;
end;

COMMAND:Register();