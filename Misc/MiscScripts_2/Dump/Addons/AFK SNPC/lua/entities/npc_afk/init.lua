AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include('shared.lua')
 
ENT.schdIdle = ai_schedule.New("IdleSchedule")
ENT.schdIdle:AddTask("PlaySequence", {Name = "idle_angry"})

function ENT:Initialize()
	self:SetModel("models/Humans/Group01/Male_07.mdl")
 
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
 
	self:SetSolid(SOLID_BBOX) 
	self:SetMoveType(MOVETYPE_STEP)
 
	self:CapabilitiesAdd(CAP_MOVE_GROUND | CAP_OPEN_DOORS | CAP_ANIMATEDFACE | CAP_TURN_HEAD | CAP_USE_SHOT_REGULATOR | CAP_AIM_GUN)
	self:SetHealth(100)
	
	self:SetSchedule(SCHED_SCRIPTED_FACE)
	
	local schdIdle = ai_schedule.New("IdleSchedule")
	-- schdIdle:AddTask("PlaySequence", {Name = "idle_to_sit_ground"})
	schdIdle:AddTask("PlaySequence", {Name = "sit_ground"})
end

function ENT:SetAnimationSequence(name)
	self.schdIdle = ai_schedule.New("IdleSchedule")
	self.schdIdle:AddTask("PlaySequence", {Name = name})
end
 
function ENT:OnTakeDamage(dmg)
	
end 
 
function ENT:SelectSchedule()
	self:StartSchedule(self.schdIdle)
end