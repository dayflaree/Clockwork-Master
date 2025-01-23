-- Written by Team Ulysses, http://ulyssesmod.net/
module( "Uclip", package.seeall )
if not SERVER then return end

function noclip( ply )
	if ply:GetMoveType() == MOVETYPE_NOCLIP then
		local pos = ply:GetPos()
		timer.Simple( FrameTime() * 0.5, function() 
			ply:SetPos( pos )
		end )
	end
end
hook.Add( "PlayerNoClip", "UclipNoclip", noclip )