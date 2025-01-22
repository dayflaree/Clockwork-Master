ENT.Type = "anim"  
ENT.Base = "base_gmodentity"  
  
if SERVER then   
	AddCSLuaFile("shared.lua")

	function ENT:Initialize()   
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:SetCollisionGroup( COLLISION_GROUP_NONE )
		self:DrawShadow(false)
		self:SetModel("models/pg_props/pg_obj/pg_glow_stick.mdl")
		self:SetSkin(1);
	end;

	function ENT:Think()
		local player = self:GetOwner() 
		self:SetColor(player:GetColor())
		self:SetMaterial(player:GetMaterial())
	end;
end;

if CLIENT then
    function ENT:Initialize()
  		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local r, g, b, a = self:GetColor()
			dlight.Pos = self:GetPos()
			dlight.r = 0
			dlight.g = 255
			dlight.b = 0
			dlight.Brightness = 0
			dlight.Size = 512
			dlight.Decay = 0
			dlight.DieTime = CurTime() + 1
		end;
	end;
end;