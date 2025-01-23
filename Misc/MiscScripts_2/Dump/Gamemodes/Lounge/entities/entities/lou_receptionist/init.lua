AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

local schdReceptionist = ai_schedule.New("LobbyReceptionist")
	schdReceptionist:EngTask("TASK_FACE_PLAYER", 0)
	schdReceptionist:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 300)
	schdReceptionist:EngTask("TASK_WALK_PATH", 0)
	schdReceptionist:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schdReceptionist:EngTask("TASK_FACE_PLAYER", 0)
	schdReceptionist:EngTask("TASK_WAIT_RANDOM", 20)

function ENT:Initialize()
	self:HoverInfo({icon = 'help', info = 'Mindy', colourr = 255, colourg = 0, colourb = 149, coloura = 255})
	self.Entity:SetUseType(SIMPLE_USE)
	self:SetModel("models/Humans/Group01/Female_01.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	
	self:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_OPEN_DOORS | CAP_ANIMATEDFACE | CAP_TURN_HEAD | CAP_USE_SHOT_REGULATOR | CAP_AIM_GUN )
 
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)
	self:SetSchedule(SCHED_SCRIPTED_FACE)
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() then
		GAMEMODE:ReceptionistSpeak("How can I help?")
		umsg.Start("lou_receptionist_menu", activator)
		umsg.End()
	end
end

function ENT:SelectSchedule()
	self:StartSchedule(schdReceptionist)
end

function ENT:Think()
	
end
