AddCSLuaFile("autorun/client/PreSpawnIntro.lua")

local Player = FindMetaTable("Player")

function Player:PreSpawnIntro(bool)
	if bool == true then
		self.PSI_Pos = self:GetPos()
		self:Freeze(true)
		self:Spectate(OBS_MODE_CHASE)
		self:StripWeapons()
		umsg.Start("PreSpawnIntro", self)
			umsg.Bool(bool)
		umsg.End()
	else
		self:Freeze(false)
		self:UnSpectate()
		self:Spawn()
		self:SetPos(self.PSI_Pos)
		umsg.Start("PreSpawnIntro", self)
			umsg.Bool(bool)
		umsg.End()
	end
end

hook.Add("PlayerInitialSpawn", "PreSpawnIntroSpawn", function(ply)
	timer.Simple(1, function()
		ply:PreSpawnIntro(true)
		ply:SetTeam(TEAM_CONNECTING)
	end)
end)

concommand.Add("ClosePreSpawnIntro", function(ply, cmd, args)
	ply:PreSpawnIntro(false)
end)

concommand.Add("afk_anim", function(ply, cmd, args)
	ply:SetPData("afk_anim", args[1])
	if ply.afk_npc and ply.afk_npc:IsValid() then
		ply.afk_npc:SetAnimationSequence(args[1])
	end
end)