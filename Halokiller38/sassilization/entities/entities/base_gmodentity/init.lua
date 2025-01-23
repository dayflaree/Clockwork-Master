AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:GetClamp( r, g, b )
	local function winner( n, m )
		if m > n then
			return m
		else
			return n
		end
	end
	local small = winner( r, g )
	small = winner( small, b )
	local clamp = 255 - small
	self.clamp = clamp
end

function ENT:IsReady()
	if self.Dead then
		return false
	elseif self.Spawning then
		return false
	else
		return true
	end
end

function IsAttackable( entity )
	local class = entity:GetClass()
	if table.HasValue( ATTACKABLES, class ) then
		return true
	elseif entity:IsUnit() then
		return true
	else
		return false
	end
end