require("datastream")
include('shared.lua')
include('cl_hoverinfo.lua')
include('cl_scoreboard.lua')
include('cl_inventory.lua')
include('sh_inventory.lua')

function GM:HUDPaint()
	self:PaintHoverInfo()
	self.BaseClass:HUDPaint()
end

function GM:SpawnMenuOpen()
	return LocalPlayer():Team() == TEAM_BUILD
end

function GM:HUDDrawTargetID()
	return false
end

function lob_playerinitialspawn_hook(um)
	bgsound = "lounge/bg.mp3"
	//LocalPlayer():EmitSound(Sound(bgsound))
	//timer.Create("bgsound_loop", SoundDuration(bgsound), 0, function() LocalPlayer():EmitSound(Sound(bgsound)) end)
end
usermessage.Hook("lob_playerinitialspawn", lob_playerinitialspawn_hook)

hook.Add("StartChat", "lou_startchat", function() RunConsoleCommand("lou_startchat") end)
hook.Add("FinishChat", "lou_finishchat", function() RunConsoleCommand("lou_finishchat") end)
