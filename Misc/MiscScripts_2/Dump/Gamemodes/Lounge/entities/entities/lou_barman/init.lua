AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

local schdBarman = ai_schedule.New("LoungeBarman")
	schdBarman:EngTask("TASK_FACE_PLAYER", 0)
	schdBarman:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 400)
	schdBarman:EngTask("TASK_WALK_PATH", 0)
	schdBarman:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schdBarman:EngTask("TASK_FACE_PLAYER", 0)
	schdBarman:EngTask("TASK_WAIT_RANDOM", 20)

function ENT:Initialize()
	self:HoverInfo({icon = 'drink', info = 'James', colourr = 200, colourg = 0, colourb = 0, coloura = 255})
	self.Entity:SetUseType(SIMPLE_USE)
	self:SetModel("models/Humans/Group01/male_02.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	
	self:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_OPEN_DOORS | CAP_ANIMATEDFACE | CAP_TURN_HEAD | CAP_USE_SHOT_REGULATOR | CAP_AIM_GUN )
 
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)
	self:SetSchedule(SCHED_SCRIPTED_FACE)
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() then
		GAMEMODE:BarmanSpeak("Hey, what can I getcha?")
		umsg.Start("lou_barman_menu", activator)
		umsg.End()
		//INVENTORY:SpawnItem(activator, "explosive_canister")
	end
end

function ENT:SelectSchedule()
	self:StartSchedule(schdBarman)
end

function ENT:Think()
	
end
