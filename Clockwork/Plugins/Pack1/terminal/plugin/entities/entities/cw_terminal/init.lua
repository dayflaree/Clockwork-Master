include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

	
	ENT.Type		= "anim"
	ENT.Base		= "base_anim"
	ENT.Author		= "Thermadyle and Blt950"
	
	AddCSLuaFile()
	
	function ENT:Initialize()
	
		self:SetModel( "models/props/vidphone01a.mdl" )
		
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		
		self:SetUseType( USE_TOGGLE )
		
	end
	
	function ENT:Use( pl )
		
		if not pl._nextComputerUse or pl._nextComputerUse < CurTime() then
		
			pl._inWebsitePanel = not pl._inWebsitePanel
			pl:DrawViewModel( not pl._inWebsitePanel )
			pl:SetMoveType( ( pl._inWebsitePanel and MOVETYPE_NONE ) or MOVETYPE_WALK )
			
			umsg.Start( "wp_screen", pl )
			umsg.Bool( pl._inWebsitePanel )
			umsg.Entity( self )
			umsg.End()
			
			pl._computer = self
			pl._nextComputerUse = CurTime() + 2
		
		end
		
	end
	
	local function ExitComputer( pl )
		
		if IsValid( pl._computer ) then
		
			pl._inWebsitePanel = false
			pl:DrawViewModel( true )
			pl:SetMoveType( MOVETYPE_WALK )
			
			umsg.Start( "wp_screen", pl )
			umsg.Bool( false )
			umsg.Entity( self )
			umsg.End()
			
			pl._computer = nil
			pl._nextComputerUse = CurTime() + 2
		
		end
		
	end
	concommand.Add( "wp_eject", ExitComputer )