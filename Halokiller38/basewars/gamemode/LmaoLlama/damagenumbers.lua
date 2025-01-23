if SERVER then
	AddCSLuaFile("damagenumbers.lua")
	umsg.PoolString( "FloatingDmgText" )
	
	local function EntityTakeDamage( ent, inf, atk, amt, info )
		if ent:IsPlayer() or ent:IsNPC() then
			local tVec = ent:GetPos()
			tVec.z = ent:LocalToWorld(ent:OBBMaxs()).z
			umsg.Start( "FloatingDmgText" )
				umsg.Vector( tVec + Vector(math.random(-10,10), 0, math.random(-15,15)))
				umsg.Float( amt )
				umsg.Long( info:GetDamageType( ) )
				umsg.Short( CurTime() + 3 )
			umsg.End( )
		end
	end
	
	hook.Add( "EntityTakeDamage", "DNumUmsgSend", EntityTakeDamage )
end
if CLIENT then	
	local lbls = { }	
	
	local redText = 	{DMG_BLAST 	, DMG_BLAST_SURFACE , DMG_SLOWBURN 	, DMG_BURN}
	local blueText = 	{DMG_SONIC 	, DMG_DROWNRECOVER 	, DMG_PLASMA 	, DMG_DISSOLVE}
	local yellowText = 	{DMG_SHOCK 	, DMG_SONIC 		, DMG_ENERGYBEAM, DMG_PHYSGUN}
	local greenText = 	{DMG_PARALYZE, DMG_POISON 		, DMG_NERVEGAS  , DMG_RADIATION}
	local whiteText = 	{DMG_GENERIC , DMG_CRUSH 		, DMG_SLASH 	, DMG_VEHICLE 	,
						DMG_FALL 	, DMG_CLUB 			, DMG_PREVENT_PHYSICS_FORCE   	, 
						DMG_NEVERGIB, DMG_ALWAYSGIB 	, DMG_REMOVENORAGDOLL 		  	,
						DMG_DIRECT 	, DMG_BUCKSHOT}
	local drawIt = true
	local function umGetDamage( um )
		local t = { }
		t.Pos = um:ReadVector( )
		t.Text = tostring( math.Round( um:ReadFloat( ) ) )
		t.DamageType = um:ReadLong( )
		t.DieTime = um:ReadShort()
		if table.HasValue(redText, t.DamageType) then
			t.color = Color( 250, 000, 000, 255 ) --Red
		elseif table.HasValue(greenText, t.DamageType) then
			t.color = Color( 000, 255, 000, 255 ) --Green
		elseif table.HasValue(blueText, t.DamageType) then
			t.color = Color( 000, 000, 255, 255 ) --Blue
		elseif table.HasValue(yellowText, t.DamageType) then
			t.color = Color( 255, 255, 000, 255 ) --Yellow
		elseif table.HasValue(whiteText, t.DamageType) then
			t.color = Color( 255, 255, 255, 255 ) --White
		else
			t.color = Color( 255, 255, 255, 255 ) --White
		end
		table.insert( lbls, t )
	end
	local function ToggleDisplay(ply, cmd, args)
		if not args[1] then
			print("Enabled: 1\nDisabled: 0")
		end
		drawIt = tobool(args[1])
	end
	concommand.Add("DrawFCT", ToggleDisplay, function(cmd, args) return {0, 1} end)
	surface.CreateFont("coolvetica", 30, 800, true, false, "DamFont", false, true)
	local function DrawDamage( )
		if not drawIt then return end
		local c, o
		for k, v in pairs( lbls ) do
			if v.DieTime < CurTime( ) then
				lbls[ k ] = nil
			end
			local ang = LocalPlayer():EyeAngles()
			local pos = v.Pos
			pos.z = pos.z + RealFrameTime() * 50
			pos = pos + ang:Up()
		
			ang:RotateAroundAxis( ang:Forward(), 90 )
			ang:RotateAroundAxis( ang:Right(), 90 )
			v.color.a = math.Clamp(v.color.a - RealFrameTime() * 150, 0 , 255)
			cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.5 )
				local w,h = surface.GetTextSize(v.Text)
				for i = #v.Text, 1, -1 do
					c = v.Text:sub(i, i)
					if i % 2 == 0 then o = 2 else o = 0 end
					draw.SimpleTextOutlined( c, "DamFont", (12 * i) - w /2, o, v.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, Color(0,0,0,v.color.a) )
					
				end
			cam.End3D2D()
		end
	end
	usermessage.Hook( "FloatingDmgText", umGetDamage )
	hook.Add( "PostDrawOpaqueRenderables", "DmgNumShowText", DrawDamage )
end