

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

// animation states
ANIM_IDLE		=	1;
ANIM_RUN		=	2;
ANIM_JUMP		=	3;
ANIM_ATTACK		=	4;

function ENT:SetOverlayText( text )
	self:SetNWString( "GModOverlayText", text )
end

function ENT:GetOverlayText()

	local txt = self.Entity:GetNetworkedString( "GModOverlayText" )
	
	if ( txt == "" ) then
		return ""
	end
	
	if ( SinglePlayer() ) then
		return txt
	end

	local PlayerName = self:GetPlayerName()

	return txt .. "\n(" .. PlayerName .. ")"
	
end

function ENT:SetPlayer( ply )

	self.Entity:SetVar( "Founder", ply )
	self.Entity:SetVar( "FounderIndex", ply:UniqueID() )
	
	self.Entity:SetNetworkedString( "FounderName", ply:Nick() )
	
end

function ENT:GetPlayer()

	return self.Entity:GetVar( "Founder", NULL )
	
end

function ENT:GetPlayerIndex()

	return self.Entity:GetVar( "FounderIndex", 0 )
	
end

function ENT:GetPlayerName()

	local ply = self:GetPlayer()
	if ( ply != NULL ) then
		return ply:Nick()
	end

	return self.Entity:GetNetworkedString( "FounderName" )
	
end

function ENT:SetAnim( seq )
	
	self.anims = self.anims or {}
	if !self.anims[ seq ] then self.anims[ seq ] = self:LookupSequence( seq ) end
	
	self:ResetSequence( self.anims[ seq ] )
	
end

