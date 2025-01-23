--KICK
function ASSChat_Kick( ply, text, toall )
	if (string.sub(text, 1, 5) == "!kick") then
		TheText = string.Explode(" ", text);
		if(TheText[3] == null) then
			ply:ConCommand("ASS_KickPlayer "..TheText[2].." ".."Kicked by Admin");
		else
			ply:ConCommand("ASS_KickPlayer "..TheText[2].." "..TheText[3]);
		end
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_Kick", ASSChat_Kick );



--KILL/SLAY
function ASSChat_Kill( ply, text, toall )
	if (string.sub(text, 1, 5) == "!slay") then
		ply:ConCommand("ASS_KillPlayer"..string.sub(text, 6));
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_Kill", ASSChat_Kill );



--GOD
function ASSChat_GodOn( ply, text, toall )
	if (string.sub(text, 1, 4) == "!god") then
		ply:ConCommand("ASS_God"..string.sub(text, 5).." 1");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_GodOn", ASSChat_GodOn );

function ASSChat_GodOff( ply, text, toall )
	if (string.sub(text, 1, 6) == "!ungod") then
		ply:ConCommand("ASS_God"..string.sub(text, 7).." 0");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_GodOff", ASSChat_GodOff );



--BURN
function ASSChat_BurnOn( ply, text, toall )
	if (string.sub(text, 1, 7) == "!ignite") then
		ply:ConCommand("ASS_Burn"..string.sub(text, 8).." 1");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_BurnOn", ASSChat_BurnOn );

function ASSChat_BurnOff( ply, text, toall )
	if (string.sub(text, 1, 9) == "!unignite") then
		ply:ConCommand("ASS_Burn"..string.sub(text, 10).." 0");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_BurnOff", ASSChat_BurnOff );



--SPEED
function ASSChat_SpeedOn( ply, text, toall )
	if (string.sub(text, 1, 6) == "!speed") then
		ply:ConCommand("ASS_Speed"..string.sub(text, 7).." 1");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_SpeedOn", ASSChat_SpeedOn );

function ASSChat_SpeedOff( ply, text, toall )
	if (string.sub(text, 1, 8) == "!unspeed") then
		ply:ConCommand("ASS_Speed"..string.sub(text, 9).." 0");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_SpeedOff", ASSChat_SpeedOff );



--RAGDOLL
function ASSChat_RagdollOn( ply, text, toall )
	if (string.sub(text, 1, 8) == "!ragdoll") then
		ply:ConCommand("ASS_Ragdoll"..string.sub(text, 9).." 1");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_RagdollOn", ASSChat_RagdollOn );

function ASSChat_RagdollOff( ply, text, toall )
	if (string.sub(text, 1, 10) == "!unragdoll") then
		ply:ConCommand("ASS_Ragdoll"..string.sub(text, 11).." 0");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_RagdollOff", ASSChat_RagdollOff );



--MUTE
function ASSChat_MuteOn( ply, text, toall )
	if (string.sub(text, 1, 5) == "!mute") then
		ply:ConCommand("ASS_Mute"..string.sub(text, 6).." 1");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_MuteOn", ASSChat_MuteOn );

function ASSChat_MuteOff( ply, text, toall )
	if (string.sub(text, 1, 7) == "!unmute") then
		ply:ConCommand("ASS_Mute"..string.sub(text, 8).." 0");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_MuteOff", ASSChat_MuteOff );



--JAIL
function ASSChat_JailOn( ply, text, toall )
	if (string.sub(text, 1, 5) == "!jail") then
		ply:ConCommand("ASS_JailPlayer"..string.sub(text, 6).." 1");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_JailOn", ASSChat_JailOn );

function ASSChat_JailOff( ply, text, toall )
	if (string.sub(text, 1, 7) == "!unjail") then
		ply:ConCommand("ASS_JailPlayer"..string.sub(text, 8).." 0");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_JailOff", ASSChat_JailOff );



--GIMP
function ASSChat_GimpOn( ply, text, toall )
	if (string.sub(text, 1, 5) == "!gimp") then
		ply:ConCommand("ASS_Gimp"..string.sub(text, 6).." 1");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_GimpOn", ASSChat_GimpOn );

function ASSChat_GimpOff( ply, text, toall )
	if (string.sub(text, 1, 7) == "!ungimp") then
		ply:ConCommand("ASS_Gimp"..string.sub(text, 8).." 0");
		return "";
	end
end
hook.Add( "PlayerSay", "ASSChat_GimpOff", ASSChat_GimpOff );
