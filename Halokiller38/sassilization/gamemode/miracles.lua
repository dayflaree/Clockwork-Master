AddCSLuaFile("cl_miracles.lua")


	resource.AddFile("materials/cobra/bombard32.vtf")
	resource.AddFile("materials/cobra/bombard32.vmt")
	resource.AddFile("materials/cobra/decimate32.vtf")
	resource.AddFile("materials/cobra/decimate32.vmt")
	resource.AddFile("materials/cobra/heal32.vtf")
	resource.AddFile("materials/cobra/heal32.vmt")
	resource.AddFile("materials/cobra/paralyze32.vtf")
	resource.AddFile("materials/cobra/paralyze32.vmt")
	resource.AddFile("materials/cobra/plummet32.vtf")
	resource.AddFile("materials/cobra/plummet32.vmt")
	resource.AddFile("materials/cobra/gravitate32.vtf")
	resource.AddFile("materials/cobra/gravitate32.vmt")
	resource.AddFile("materials/cobra/blast32.vtf")
	resource.AddFile("materials/cobra/blast32.vmt")


include("shared.lua")

Gravitations = {}

function SphereIntersect( center, radius, position, direction )
	
	position = position + direction * -radius
	local direction = direction:Normalize()
	
	local a = center - position
	local b = a:Length()
	
	if ( b < radius ) then direction = direction * -1 end
	
	local c = direction:DotProduct( a:Normalize() ) * b
	local d = radius^2 - ( b^2 - c^2 )
	
	if ( d < 0 ) then return end
	
	return position + direction * ( c - math.sqrt( d ) )
	
end

function SetupSpellSelection( pl )
	pl.Miracles = {}
	for i=1, #SPELLS do
		pl.Miracles[i] = {}
		pl.Miracles[i].delay = 0
		numpad.OnDown( pl, i, "selectSpell", "Pressed", i ) 
	end
end

function selectSpell( pl, info, key )
	
	pl.lastShrineCast = pl.lastShrineCast or CurTime()
	if CurTime() < pl.lastShrineCast then return end
	pl.lastShrineCast = CurTime() + 1
	
	local level = ALLOWALL and true or pl.ITEMS[string.lower(SPELLS[key].name)]
	if !(level == true or (tonumber(level) and level > 0)) then
		pl:ChatPrint( "You cannot cast this miracle until you've acquired it." )
		pl:SendLua("playsound( 'sassilization/warnmessage.wav', -1 )")
		return
	end
	
	if !pl:GetNWInt( "_shrines" ) or pl:GetNWInt( "_shrines" ) <= 0 then
		pl:ChatPrint( "You must own a shrine to cast miracles." )
		pl:SendLua("playsound( 'sassilization/warnmessage.wav', -1 )")
		return
	end
	
	if pl.Miracles[key].delay > CurTime() then return end
	
	local mana = pl:GetNWInt( "_spirits" )
	local cost = tonumber(level) and math.ceil( SPELLS[key].cost / (4-level) ) or SPELLS[key].cost
	
	if mana < cost then
		pl:ChatPrint( "You have insufficient creed." )
		pl:SendLua("playsound( 'sassilization/warnmessage.wav', -1 )")
		return
	end
	
	local pos = pl:GetShootPos()
	local ang = pl:GetAimVector()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(ang*2048)
	tracedata.mask = (SOLID)
	tracedata.filter = player.GetAll()
	
	local tr = util.TraceLine(tracedata)
	local hit = tr.HitPos
	local filter = pl
	if tr.Entity and tr.Entity:IsValid() then
		hit = tr.Entity:GetPos()
		filter = tr.Entity
	end
	
	local shrines = {}
	local inrange = false
	for _, ent in pairs( ents.FindByClass( "bldg_shrine" ) or {} ) do
		if (ent:GetOverlord() == pl || table.HasValue(alliances[ent:GetOverlord()],pl)) and ent:GetPos():Distance( hit ) < 650 and ent:IsReady() then
			table.insert( shrines, ent )
		end
	end
	
	if #shrines == 0 then
		pl:ChatPrint( "This is too far from your shrine(s)." )
		pl:SendLua("playsound( 'sassilization/warnmessage.wav', -1 )")
		return
	end
	
	local Shrine, Shield, ShieldShrine, ShieldPos
	for _, shrine in pairs( shrines ) do
		
		Shrine = shrine
		local start_pos = shrine:GetPos() + Vector( 0, 0, 8 )
		local end_pos = hit
		local cur_pos = start_pos
		local trace = {}
		local dir = ( end_pos - start_pos )
		local steps = math.Round( start_pos:Distance( end_pos ) * 0.1 )
		local increment = dir:Length() / steps
		dir:Normalize()
		
		for i=1, steps do
			
			trace = {}
			trace.start = cur_pos
			trace.mask = MASK_SOLID_BRUSHONLY
			
			local arch = math.sin(math.rad(i * 180/steps)) * (steps * 2)
			trace.endpos = start_pos + dir * ( i * increment ) + Vector( 0, 0, arch )
			
			local tr = util.TraceLine( trace )
			if tr.HitWorld and i != steps then
				Shrine = false
				break
			else
				local shield, blockpos, distance
				for _, ent in pairs( ents.FindInSphere( tr.HitPos, 48 ) ) do
					if (	ent:GetClass() == "bldg_shieldmono" && ent:IsReady() &&
						ent:GetOverlord() && ent:GetOverlord()!=pl &&
						!table.HasValue(alliances[ent:GetOverlord()],pl) && ent:CanProtect() ) then
						
						local center = ent:GetPos() + Vector( 0, 0, ent:OBBMaxs().z )
						
						local hitpos = SphereIntersect( center, 32, tr.HitPos, tr.Normal * -1 )--center:Distance( tr.HitPos ) < 32 and center + (tr.HitPos - center):Normalize() * 32 or false
						
						if hitpos and (not distance || start_pos:Distance( hitpos ) < distance) then
							
							distance = center:Distance( hitpos )
							shield = ent
							blockpos = hitpos
							
						end
						
					end
				end
				if ValidEntity( shield ) then
					Shrine = false
					shieldShrine = shrine
					ShieldPos = blockpos
					Shield = shield
					break
				end
					
			end
			
			cur_pos = tr.HitPos
			
		end
		
		if Shrine then
			Shield = false
			break
		end
		
	end
	
	if Shield then
		
		pl:ChatPrint( SPELLS[key].name )
		pl:EmitSound( SPELLS[key].sound )
		pl:SetNWInt( "_spirits", mana - cost )
		
		pl:SendLua("GAMEMODE:AddMiracle( '"..key.."', '"..SPELLS[key].delay.."' )")
		pl.Miracles[key].delay = CurTime() + SPELLS[key].delay
		
		local effectdata = EffectData()
			effectdata:SetStart(shieldShrine:GetPos())
			effectdata:SetEntity(shieldShrine)
			effectdata:SetAttachment( 1 )
			effectdata:SetOrigin(ShieldPos)
			effectdata:SetScale(6)
		util.Effect( "caststrike", effectdata )
		
		Shield:Protect( ShieldPos )
		
		return
		
	end
	
	if !Shrine then
		pl:ChatPrint( "None of your shrines can reach there." )
		pl:SendLua("playsound( 'sassilization/warnmessage.wav', -1 )")
		return
	end
	
	pl:ChatPrint( SPELLS[key].name )
	pl:EmitSound( SPELLS[key].sound )
	pl:SetNWInt( "_spirits", mana - cost )
	CastMiracle( pl, key, hit, Shrine, level )
	
end
numpad.Register( "selectSpell", selectSpell )

function CastMiracle( pl, key, hit, shrine, level )
	
	if !(shrine and level and hit) then return end
	level = level == true and 3 or level
	
	local effectdata = EffectData()
		effectdata:SetStart(shrine:GetPos())
		effectdata:SetEntity(shrine)
		effectdata:SetAttachment( 1 )
		effectdata:SetOrigin(hit)
		effectdata:SetScale(4+4*level/3)
	util.Effect( "caststrike", effectdata )
	
	if pl:GetActiveWeapon():GetClass() == "command_staff" then
		pl:GetActiveWeapon():SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		pl:GetActiveWeapon().NextIdle = CurTime()+1
	end
	
	if !key then return end
	local data = SPELLS[key]
	if !data then return end
	local miracle = string.lower( data.name )
	
	pl:SendLua("GAMEMODE:AddMiracle( '"..key.."', '"..data.delay.."' )")
	pl.Miracles[key].delay = CurTime() + data.delay
	Msg( pl:Nick().." Casted "..miracle.."\n" )
	
	if miracle == "heal" then
		local effectdata = EffectData()
			effectdata:SetStart(hit)
			effectdata:SetScale(50)
			effectdata:SetMagnitude(0.15)
		util.Effect( "cast_heal", effectdata )
		local ents = ents.FindInSphere( hit, 40*level/3 )
		local allies = {}
		if #ents < 1 then return end
		for _, ent in pairs(ents) do
			if ent:IsUnit() and !ent:IsDead() and ( ent:GetOverlord() == pl or table.HasValue( alliances[pl], ent:GetOverlord() ) ) then
				ent:SetNWBool( "paralyzed", false )
				ent.Paralyzed = 2
				ent:SetNWBool( "gravitated", false )
				ent.Gravitated = 4
				ent.Decimated = false
				ent.OnFire = false
				ent.lastfire = 0
				ent.health = ent.maxhealth
				umsg.Start( "UUH" )
					umsg.Short( ent:EntIndex() )
					umsg.Short( ent.health )
				umsg.End()
				local effectdata = EffectData()
					effectdata:SetEntity( ent )
					effectdata:SetMagnitude(1)
				util.Effect( "heal", effectdata, 1, 1 )
			end
		end
	end
	if miracle == "gravitate" then
		local effectdata = EffectData()
			effectdata:SetEntity(shrine)
			effectdata:SetStart(hit)
			effectdata:SetScale(24)
			effectdata:SetMagnitude(2)
		util.Effect( "cast_gravitate", effectdata )
		table.insert( Gravitations, 1, hit )
		timer.Simple( 2 + 2 * level/3, table.remove, Gravitations, 1 )
		local ents = ents.FindInSphere( hit, 8 + 10 * level/3 )
		local allies = {}
		if #ents < 1 then return end
		for _, ent in pairs(ents) do
			if ent:IsUnit() and !ent:IsDead() and !ent.flies and !ent.sails and ent:GetOverlord() ~= pl and !table.HasValue( alliances[pl], ent:GetOverlord() ) then
				
				ent.Gravitated = 1
				ent:SetNWBool( "gravitated", true )
				if ent.trail then
					ent.trail:Remove()
					ent.trail = nil
				end
				ent.trail = util.SpriteTrail( ent, 0, Color( 145, 44, 238, 80 ), false, 8, 0.01, 0.5, 0.5, "trails/laser.vmt" )
				
				local phys = ent:GetPhysicsObject()
				if ValidEntity( phys ) then
					phys:EnableGravity(false)
					phys:AddAngleVelocity( Angle( math.random(0,360),math.random(0,360),math.random(0,360) ) )
				end
				
				local function recover( ent )
					if ValidEntity( ent ) then
						ent.Gravitated = 2
						if ent.trail then
							ent.trail:Remove()
							ent.trail = nil
						end
					end
				end
				timer.Simple( 2, recover, ent )
				
			end
		end
	end
	if miracle == "bombard" then
		local effectdata = EffectData()
			effectdata:SetOrigin(hit+Vector(0,0,70))
			effectdata:SetMagnitude(3.6 + 1.2 * level/3)
			effectdata:SetScale(38 + 6 * level/3)
		util.Effect( "cast_bombard", effectdata )
		for i=1, math.random( math.Round(6 + 8*level/3), math.Round(8 + 11*level/3) ) do
			local startpos = hit + Vector( math.random( -18, 18 ), math.random( -18, 18 ), math.random( 68, 72 ) )
			local trace = {}
			trace.start = hit
			trace.endpos = startpos
			trace.mask = MASK_SOLID_BRUSHONLY
			local tr1 = util.TraceLine( trace )
			trace.start = tr1.HitPos + tr1.HitNormal
			trace.endpos = trace.start + Vector( 0, 0, -120 )
			startpos = trace.start
			local tr2 = util.TraceLine( trace )
			local endpos = tr2.HitPos + Vector( 0, 0, -10 )
			local function bomb( args )
				local gravitate = false
				for _, grav in pairs( Gravitations ) do
					if args[1]:Distance(grav) <= 120 then
						gravitate = grav
						break
					end
				end	
				local arr = ents.Create( "arrow" )
				arr:SetPos( args[1] )
				arr.PosStart = args[1]
				arr.PosTarget = args[2]
				arr.AngStart = Angle( 180, 0, 0 )
				arr.Bomb = true
				arr.Overlord = pl
				arr.Gravitated = gravitate
				arr:GetPredictedTarget()
				arr:Spawn()
				arr:Activate()
				arr:SetSpawner( pl )
				if !gravitate then return end
				local dir = (arr:GetPos() - gravitate):Normalize()
				local pow = 24 - arr:GetPos():Distance(gravitate)*.2
				function arr:StartTouch() return end
				function arr:PhysicsCollide() return end
				local phys = arr:GetPhysicsObject()
				if phys and phys:IsValid() then
					phys:EnableMotion(true)
					phys:EnableGravity(true)
					phys:Wake()
					phys:AddAngleVelocity( Angle( math.random(0,360),math.random(0,360),math.random(0,360) ) )
					phys:SetVelocity( dir * math.random( 10, 20 ) * pow )
				end
			end
			timer.Simple( math.Rand( 0, 1 ) + 3, bomb, {startpos, endpos} )
		end
	end
	if miracle == "paralysis" then
		local effectdata = EffectData()
			effectdata:SetStart(hit)
			effectdata:SetScale(40 + 20 * level/3)
			effectdata:SetMagnitude(0.15)
		util.Effect( "cast_paralyze", effectdata )
		local ents = ents.FindInSphere( hit, 20 + 20 * level/3 )
		local allies = {}
		if #ents < 1 then return end
		for _, ent in pairs(ents) do
			if ent:IsUnit() and !ent:IsDead() and ent:GetOverlord() ~= pl and !table.HasValue( alliances[pl], ent:GetOverlord() ) then
				ent.Paralyzed = 1
				ent:SetNWBool( "paralyzed", true )
				ent:SetAnim("idle")
				local effectdata = EffectData()
					effectdata:SetEntity( ent )
					effectdata:SetMagnitude( 3 + 3*level/3 )
				util.Effect( "paralyze", effectdata, 1, 1 )
				local function recover( ent )
					if ValidEntity( ent ) then
						ent.Paralyzed = 2
					end
				end
				timer.Simple( 3 + 3*level/3, recover, ent )
			end
		end
	end
	if miracle == "decimation" then
		local effectdata = EffectData()
			effectdata:SetStart(hit)
			effectdata:SetScale(80 + 20*level/3)
			effectdata:SetMagnitude(0.15)
		util.Effect( "cast_decimate", effectdata )
		local ents = ents.FindInSphere( hit, 20 + 8 * level/3 )
		local allies = {}
		if #ents < 1 then return end
		for _, ent in pairs(ents) do
			if ent:IsUnit() and !ent:IsDead() and ent:GetOverlord() ~= pl and !table.HasValue( alliances[pl], ent:GetOverlord() ) then
				ent.Decimated = true
				local function launch( ent )
					if ValidEntity( ent ) and !ent:IsDead() then
						ent.OnFire = true
						local effectdata = EffectData()
							effectdata:SetEntity( ent )
							effectdata:SetScale( 0.5 )
							effectdata:SetMagnitude( 3 + 3*level/3 )
						util.Effect( "fire_trail", effectdata, 1, 1 )
					end
				end
				timer.Simple( 0.1, launch, ent )
				local function recover( ent )
					if ValidEntity( ent ) then
						ent.Decimated = false
						ent.OnFire = false
					end
				end
				timer.Simple( 3 + 3*level/3, recover, ent )
			end
		end
	end
	if miracle == "blast" then
		local effectdata = EffectData()
			effectdata:SetStart( hit )
			effectdata:SetOrigin( hit )
			effectdata:SetScale( 1 )
		util.Effect( "Explosion", effectdata )
		table.insert( Gravitations, 1, hit )
		timer.Simple( 1, table.remove, Gravitations, 1 )
		local ents = ents.FindInSphere( hit+Vector(0,0,24), 64 )
		local allies = {}
		if #ents < 1 then return end
		for _, ent in pairs(ents) do
			if ent:IsUnit() and !ent:IsDead() and !ent.Paralyzed and !ent.Gravitated and ent:GetOverlord() ~= pl and !table.HasValue( alliances[pl], ent:GetOverlord() ) then
				local dir = (ent:GetPos() - hit):Normalize()
				local pow = (64 - ent:GetPos():Distance(hit))/64
				ent.Blasted = dir
				ent:GetPhysicsObject():EnableMotion(true)
				ent:GetPhysicsObject():Wake()
				local function launch( ent )
					if ValidEntity(ent) and !ent:IsDead() then
						ent:GetPhysicsObject():SetVelocity( dir * math.random( 400, 600 ) * pow + Vector( 0, 0, 150 ) )
					end
				end
				timer.Simple( 0.1, launch, ent )
				local function recover( ent )
					if ent and ent:IsValid() then
						ent.Blasted = false
					end
				end
				timer.Simple( 2, recover, ent )
			end
		end
	end
	if miracle == "plummet" then
		local ents = ents.FindInSphere( hit, 2 )
		local allies = {}
		if #ents < 1 then return end
		for _, ent in pairs(ents) do
			if ent:GetClass() == "bldg_wall" and !ent:IsDead() and ent:GetOverlord() ~= pl and !table.HasValue( alliances[pl], ent:GetOverlord() ) then
				ent.Plummeted = true
			end
		end
	end
end
