// Base pickup

ENT.Type = "anim"
ENT.Base = "base_anim"

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	
	function ENT:Initialize()
		self:SetModel( self.Model )
		
		self:SetSolid( SOLID_BBOX )
		self:SetTrigger( true )
		self:SetNotSolid( true )
		
		self:ResetSequence( self:LookupSequence( "rotate" ) )
	end
	
	function ENT:StartTouch( ent )
		if ( ent:IsPlayer() ) then	
			if ( self:PlayerPickup( ent ) ) then
				self:Hide()	
			end
		end
	end
	
	function ENT:Think()
		if ( self.NextRespawn and CurTime() > self.NextRespawn ) then
			self:Show()
		end
	end
	
	function ENT:Show()
		self:SetTrigger( true )
		self:SetNoDraw( false )
		self:DrawShadow( true )
		
		self:SetModel( self.Model )
		
		self.NextRespawn = nil
	end
	
	function ENT:Hide()
		self:SetTrigger( false )
		self:SetNoDraw( true )
		self:DrawShadow( false )
		
		self:SetModel( "models/parrot.mdl" ) // Different model so that particles are shown again later
		self:StopParticles()
		
		self.NextRespawn = CurTime() + 30
	end
else
	ENT.RenderGroup = RENDERGROUP_OPAQUE
	
	function ENT:Draw()
		if ( self.LastDrawn ) then
			self:FrameAdvance( CurTime() - self.LastDrawn )
		end
		self.LastDrawn = CurTime()
		
		self:DrawModel()
	end
end