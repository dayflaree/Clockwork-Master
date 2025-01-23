--[[
Name: "cl_auto.lua".
Product: "Starship Troopers".
--]]

NEXUS:IncludePrefixed("sh_auto.lua");

surface.CreateFont("Tahoma", ScaleToWideScreen(18), 600, true, false, "sstrp_TextSmall");
surface.CreateFont("Tahoma", ScaleToWideScreen(24), 600, true, false, "sstrp_TargetIDText");
surface.CreateFont("Tahoma", ScaleToWideScreen(14), 600, true, false, "sstrp_ChatBoxText");

-- Called when the progress bar info is needed.
function SCHEMA:GetProgressBarInfo()
	local action, percentage = nexus.player.GetAction(g_LocalPlayer, true);
	
	if (!g_LocalPlayer:Alive() and action == "spawn") then
		return {text = "You are being spawned. Either wait for a medic or type /acd to respawn instantly.", percentage = percentage, flash = percentage < 10};
	end;
	
	if ( !g_LocalPlayer:IsRagdolled() ) then
		if (action == "lock") then
			return {text = "The entity is being locked.", percentage = percentage, flash = percentage < 10};
		elseif (action == "unlock") then
			return {text = "The entity is being unlocked.", percentage = percentage, flash = percentage < 10};
		end;
	elseif (action == "unragdoll") then
		if (g_LocalPlayer:GetRagdollState() == RAGDOLL_FALLENOVER) then
			return {text = "You are regaining stability.", percentage = percentage, flash = percentage < 10};
		else
			return {text = "You are regaining conciousness.", percentage = percentage, flash = percentage < 10};
		end;
	elseif (g_LocalPlayer:GetRagdollState() == RAGDOLL_FALLENOVER) then
		local fallenOver = g_LocalPlayer:GetSharedVar("sh_FallenOver");
		
		if ( fallenOver and nexus.mount.Call("PlayerCanGetUp") ) then
			return {text = "Press 'jump' to get up.", percentage = 100};
		end;
	end;
end;