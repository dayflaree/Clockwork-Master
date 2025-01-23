require("datastream")
AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_hoverinfo.lua')
AddCSLuaFile('cl_scoreboard.lua')
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('cl_inventory.lua')
AddCSLuaFile('sh_inventory.lua')
include('shared.lua')
include('entity_extension.lua')
include("sh_inventory.lua")
include('sv_inventory.lua')

for _, f in pairs(file.Find("../materials/gui/silkicons/*")) do
	resource.AddFile("materials/gui/silkicons/"..f)
end
resource.AddFile("sound/lounge/bg.mp3")

function GM:Initialize()
	
end

function GM:ShowTeam(ply)
	ply:ConCommand("ShowInventory")
end

function GM:OnEntityCreated(ent)
	if ValidEntity(ent) and ent:GetClass() == "prop_door_rotating" then
		ent:HoverInfo({icon = 'door_open', info = 'Unlocked Door'})
	end
end

function GM:PlayerNoClip(ply)
	return ply:Team() == TEAM_BUILD
end

function GM:PlayerLoadout(ply)
	return true
end

function GM:InitPostEntity()
	for _, ent in pairs(ents.FindByName('lou_chair')) do
		ent:SetColor(0, 0, 0, 0)
		ent:SetCollisionGroup(COLLISION_GROUP_NONE)
		ent.CollisionGroup = COLLISION_GROUP_NONE
		ent:SetMoveType(MOVETYPE_NONE)
		ent:SetPos(ent:GetPos() + Vector(0, 0, 12.5))
		//ent:SetAngles(ent:GetAngles() + Angle(0, -90, 0))
		ent.HandleAnimation = function(veh, ply)
			return ply:SelectWeightedSequence(ACT_GMOD_SIT_ROLLERCOASTER)
		end
	end
end

function GM:SetPlayer(ply, TEAM)
	if TEAM == TEAM_DM then
		GAMEMODE:ReceptionistSpeak("You are now in Deathmatch Mode!", ply)
		ply:SetTeam(TEAM_BUILD)
		ply:Give("weapon_smg1")
		ply:GiveAmmo("smg1", 200)
		ply:GiveAmmo("smg1_grenade", 4)
		ply:SetModel("models/player/kleiner.mdl")
		ply:SetMoveType(MOVETYPE_WALK)
		ply:CrosshairEnable()
	elseif TEAM == TEAM_BUILD then
		GAMEMODE:ReceptionistSpeak("You are now in Build Mode!", ply)
		ply:SetTeam(TEAM_BUILD)
		ply:StripWeapons()
		ply:Give("weapon_physgun")
		ply:Give("weapon_physcannon")
		ply:Give("gmod_tool")
		ply:Give("gmod_camera")
		ply:SetModel("models/player/barney.mdl")
		ply:CrosshairEnable()
	else
		GAMEMODE:ReceptionistSpeak("You are now in Roleplay Mode!", ply)
		ply:SetTeam(TEAM_RP)
		ply:StripWeapons()
		ply:SetModel("models/player/kleiner.mdl")
		ply:SetMoveType(MOVETYPE_WALK)
		ply:CrosshairDisable()
	end
end

function cmdSetPlayer(ply, cmd, args)
	GAMEMODE:SetPlayer(ply, TEAM_BUILD)
end
concommand.Add("SetPlayer", cmdSetPlayer)

function GM:CanPlayerSuicide(ply)
	GAMEMODE:ReceptionistSpeak("Need some counselling?", ply)
	return false
end

function GM:PlayerSpawn(ply)
	GAMEMODE:SetPlayer(ply, TEAM_RP)
end

function GM:PlayerInitialSpawn(ply)
	timer.Simple(1, function()
		GAMEMODE:ReceptionistSpeak("Welcome to the Lounge "..ply:Nick().."!", ply)
		umsg.Start("lob_playerinitialspawn", ply)
		umsg.End()
	end)
	ply:HoverInfo({icon = "user", info = ply:Nick()})
	GAMEMODE:ResetAFKTimer(ply)
end

function GM:Think()
	for k, ent in pairs(ents.GetAll()) do
		if ValidEntity(ent) and ent:GetClass() == "prop_door_rotating" then
			if ent:GetNWInt('Locked') == 1 then
				ent:HoverInfo({icon = 'door', info = 'Locked Door'})
			else
				ent:HoverInfo({icon = 'door_open', info = 'Unlocked Door'})
			end
		end
	end
end

function GM:ShouldCollide(entity, otherentity)
	return true
end

function GM:KeyPress(ply, key)
	if key == 32 then
		local Trace = ply:GetEyeTrace()
		if not string.match(Trace.Entity:GetClass(), "lou_") then return end
		if ValidEntity(Trace.Entity) and Trace.StartPos:Distance(Trace.HitPos) < 100 then
			Trace.Entity:Use(ply)
		end
	end
	GAMEMODE:ResetAFKTimer(ply)
end

function GM:AcceptStream(pl, handler, id)
	return true
end

function GM:ReceptionistSpeak(text, ply)
	mindy = ents.FindByClass("lou_receptionist")[1]
	if ply then
		RF = ply
	else
		RF = RecipientFilter()
		for k, v in pairs(player.GetAll()) do
			if mindy:GetPos():Distance(v:GetPos()) < 200 then
				RF:AddPlayer(v)
			end
		end
	end
	umsg.Start("lou_receptionist_speak", RF)
		umsg.String("Mindy")
		umsg.String(text)
	umsg.End()
	timer.Simple(0.5, function() mindy:EmitSound("vo/npc/female01/answer"..math.random(10, 40)..".wav", 1, math.random(80, 120)) end)
end

function GM:BarmanSpeak(text, ply)
	barman = ents.FindByClass("lou_barman")[1]
	if ply then
		RF = ply
	else
		RF = RecipientFilter()
		for k, v in pairs(player.GetAll()) do
			if barman:GetPos():Distance(v:GetPos()) < 200 then
				RF:AddPlayer(v)
			end
		end
	end
	umsg.Start("lou_barman_speak", RF)
		umsg.String("James")
		umsg.String(text)
	umsg.End()
	timer.Simple(0.5, function() barman:EmitSound("vo/npc/female01/answer"..math.random(10, 40)..".wav", 1, math.random(80, 120)) end)
end

function GM:ResetAFKTimer(ply)
	function SetAFK(ply)
		if ply:IsValid() then
			ply:SetNWBool('afk', true)
			ply:HoverInfo({info = ply:Nick()..' (AFK)'})
		end
	end
	timer.Create(ply:Nick(), 60, 0, SetAFK, ply)
	ply:SetNWBool('afk', false)
	ply:HoverInfo({info = ply:Nick()})
end
 
function lou_receptionist_speak_hook(pl, handler, id, encoded, decoded)
	GAMEMODE:ReceptionistSpeak(decoded[1])
end
datastream.Hook("lou_receptionist_speak", lou_receptionist_speak_hook)

concommand.Add("lou_startchat", function(ply, cmd, args)
	if not ply:IsValid() then return end
	ply:SetNWBool("typing", true)
end)
concommand.Add("lou_finishchat", function(ply, cmd, args)
	if not ply:IsValid() then return end
	ply:SetNWBool("typing", false)
end)