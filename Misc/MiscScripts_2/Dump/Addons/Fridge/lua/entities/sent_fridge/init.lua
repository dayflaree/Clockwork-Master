AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	if ents.FindByClass("sent_fridge")[1] then return end
	if not tr.Hit then return end
	
	local SpawnPos = tr.HitPos + Vector(0, 0, 40)
	local ent = ents.Create("sent_fridge")
	ent:SetPos(SpawnPos)
	ent:SetVar("Owner", ply)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self:SetModel("models/props_wasteland/kitchen_fridge001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator, caller)
	activator:ConCommand("fridgeMenu")
	activator:SendLua('chat.AddText(Color(15, 248, 5, 255), "You open the Fridge...")')
end

function fridgeItem(ply, cmd, args)
	local ent = ents.Create("fridge_item")
	local ITEM = Items[args[1]]
	if ITEM.StockLevel < 1 then
		ply:SendLua('chat.AddText(Color(15, 248, 5, 255), "None of this item left!")')
		return
	end
	ent:SetModel(ITEM.Model)
	ent:SetPos(ply:GetPos() + (ply:GetForward() * 10) + (ply:GetUp() * 10))
	ent:Spawn()
	ent:SetNWString("owner", ply:Nick())
	ent:SetNWString("fridge_title", ITEM.PrintName)
	undo.Create("prop")
        undo.AddEntity(ent)
        undo.SetPlayer(ply)
    undo.Finish()
	ent.Use = function(act, call)
		ITEM.Use(ply, ent)
	end
	ITEM.StockLevel = ITEM.StockLevel - 1
end
concommand.Add("fridgeitem", fridgeItem)

function fridgeFill(ply, cmd, args)
	//if ply:IsAdmin() then
		Restock()
		for k, v in pairs(player.GetAll()) do
			v:SendLua("Restock()")
		end
	//end
end
concommand.Add("fridgefill", fridgeFill)