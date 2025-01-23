-- Written by Team Ulysses, http://ulyssesmod.net/
AddCSLuaFile( "sh_uclip.lua" )

module( "Uclip", package.seeall )

maxrecurse = 4
maxloop = 50

function calcWallSlide( vel, normal )
	local toWall = normal * -1
	local velToWall = vel:Dot( toWall ) * toWall
	return vel - velToWall
end

function zeromove( move )
	move:SetVelocity( Vector( 0, 0, 0 ) )
	move:SetVelocity( Vector( 0, 0, 0 ) )
	move:SetForwardSpeed( 0 )
	move:SetSideSpeed( 0 )	
	move:SetUpSpeed( 0 )
end

function isStuck( ply, filter )
	local ang = ply:EyeAngles()
	local directions = {
		ang:Right(),
		ang:Right() * -1,
		ang:Forward(),		
		ang:Forward() * -1,
		ang:Up(),
		ang:Up() * -1,
	}
	local ents = {}
	
	local t = {}
	t.start = ply:GetPos()
	t.filter = filter
	
	for _, dir in ipairs( directions ) do
		t.endpos = ply:GetPos() + dir
		local tr = util.TraceEntity( t, ply )
		if tr.Entity:IsValid() and tr.HitPos == tr.StartPos then
			ents[ tr.Entity ] = ents[ tr.Entity ] or 0
			ents[ tr.Entity ] = ents[ tr.Entity ] + 1
		end
	end
	
	for ent, hits in pairs( ents ) do
		if hits >= 4 then
			return true, ent
		end
	end
	
	return false
end

function checkVel( ply, move, vel, recurse, hitnorms )
	if vel == Vector( 0, 0, 0 ) then return end -- No velocity, don't bother.
	
	local ft = FrameTime()
	local veln = vel:GetNormalized()
	hitnorms = hitnorms or {} -- This is used so we won't process the same normal more than once. (IE, we don't get a wedge where we have to process velocity to 0)
	
	recurse = recurse or 0 -- Keep track of how many recurses
	recurse = recurse + 1
	if recurse > maxrecurse and maxrecurse > 0 then -- Hard break
		zeromove( move )
		return
	end
	
	local t = {}
	t.start = ply:GetPos()
	t.endpos = ply:GetPos() + vel * ft + veln
	t.filter = { ply }
	t.mask = MASK_SOLID_BRUSHONLY
	local tr = util.TraceEntity( t, ply )

	local loops = 0
	while tr.Hit do
		loops = loops + 1
		if maxloop > 0 and loops > maxloop then 
			zeromove( move )			
			return
		end
		
		if tr.HitWorld or ( tr.Entity:IsValid() and (tr.Entity:GetClass() == "prop_dynamic" or (not checkOwnership( ply, tr.Entity ) and not isStuck( ply, t.filter ))) ) then -- If world or a prop they don't own that they're not stuck inside. Ignore prop_dynamic due to crash.
			local slide = calcWallSlide( vel, tr.HitNormal )
			move:SetVelocity( slide )			
			move:SetSideSpeed( 0 )
			move:SetForwardSpeed( 0 )
			move:SetUpSpeed( 0 )
			
			if table.HasValue( hitnorms, tr.HitNormal ) then -- We've already processed this normal. We can get this case when the player's noclipping into a wedge.
				zeromove( move )			
				return
			end
			table.insert( hitnorms, tr.HitNormal )					
			
			return checkVel( ply, move, slide, recurse, hitnorms ) -- Return now so this func isn't left on stack			
		end

		if tr.Entity and tr.Entity:IsValid() then -- Ent to add!
			table.insert( t.filter, tr.Entity )		
		end

		tr = util.TraceEntity( t, ply )
	end
end

function move( ply, move )
	if ply:GetMoveType() ~= MOVETYPE_NOCLIP then return end
	local ft = FrameTime()

	local vel = move:GetVelocity()
	vel = vel + ply:EyeAngles():Forward() * move:GetForwardSpeed() / 4 * ft
	vel = vel + ply:EyeAngles():Right() * move:GetSideSpeed() / 4 * ft
	vel = vel + ply:EyeAngles():Up() * move:GetUpSpeed() / 3 * ft
	
	checkVel( ply, move, vel )
end
hook.Add( "Move", "UclipMove", move )