--=============
--	Head Bob
--============
local PLUGIN = PLUGIN;

local bMZoomed=false
local lastzoomed=0
local pressrmb=false
local lastw

local view={}
local viewAng
local oldAng
local lastpos=Vector(0, 0, 0)

local oldZoom 		=0
local OldAng 			=Angle(0,0,0)
local blackscreend		=false
local VMPosAdd=Vector(0,0,0)

local viewtime=0
local f_smZ=0
local f_smHs=0
local f_smGr=0
local v_smSpd=Vector(0,0,0)
local v_smWall=Vector(0,0,0)
local a_smAng={p=0,y=0,r=0}
local a_smAngAdd=Angle(0,0,0)

local f_smZol=0
local f_smSpr =0
local v_smSway=Vector(0,0,0)
local zoomrmb=false
local lastzoom=0

function PLUGIN:Zoomed(w)
	return false;
end

function PLUGIN:CheckAllow(weapon, p)
	if !p:Alive() or p:InVehicle() or GetViewEntity() != p then return false; end;
	
	return true;
end;

function PLUGIN:CheckSwep(weapon)
	if ValidEntity(weapon) and !weapon.wac_swep_alt and !weapon.NDS_Allocated then
		weapon.NDS_Allocated=true
		weapon.Holstered=function() end
		weapon.VMPosMax		= Vector(3, 0, 5)
		weapon.VMPosM		= Vector(0.08, 0.05, 0.05)*0.35
		weapon.VMPosMz		= Vector(0.08, 0.05, 0.05)*0.2
		weapon.VMPosOffset	= Vector(0,0,0)
		weapon.VMPosD		= Vector(0.15, 0.15, 0.15)
		weapon.VMPosDz		= Vector(0.16, 0.16, 0.16)*2
		weapon.VMPosMaxz		= Vector(4, 0, 4)
		weapon.VMAngM		= Vector(0.4, 0.4, 0)*0
		weapon.VMAngMax		= Vector(0, 0, 0)
		weapon.VMPosAdd 		= Vector(0,0,0)
		weapon.VMAngAdd 		= Angle(0,0,0)
		weapon.VMAngAddO	= Angle(0,0,0)
		weapon.DrawCrosshair	= false
		weapon.Sway		=0.1
		weapon.AngM		=.01
		weapon.AngMax		=50
		weapon.AngMz		=0.001
		weapon.AngMaxz	=5
		weapon.zoomAdd=0
		weapon.zoomStart=0
		weapon.SwayScale 	= 0
		weapon.BobScale 	= 0
		local weaponData = self:GetWeaponInfo(weapon:GetClass());
		if (weaponData) then
			weapon.AimPos = weaponData.aimPos;
			weapon.RunPos = weaponData.runPos;
			weapon.AimAng = weaponData.aimAng;
			weapon.RunAng = weaponData.runAng;
		else
			local p=weapon.IronSightsPos
			weapon.AimPos=weapon.IronSightsPos
			if weapon.AimPos then
				weapon.VMPosMz=weapon.VMPosMz*(1-weapon.AimPos.y/4)
				weapon.VMPosMaxz=weapon.VMPosMaxz*(1-weapon.AimPos.y/4)
			else
				weapon.AimPos=Vector(0,0,0)
			end
			local a=weapon.IronSightsAng
			weapon.AimAng=(a and Angle(a.x,a.y,a.z)*(weapon.ViewModelFlip and -1 or 1) or Angle(0,0,0))
			a=weapon.RunArmAngle
			weapon.RunAng=(a and Angle(-a.x,-a.y,-a.z) or Angle(15, 0, 0))
			weapon.RunPos=(weapon.RunArmOffset or Vector(-5,-2,2))
			if !weapon.ViewModelFlip and weapon.RunPos then
				weapon.RunPos.x=weapon.RunPos.x*-1
			elseif weapon.ViewModelFlip and weapon.RunAng and weapon.AimAng then
				weapon.RunAng.y=weapon.RunAng.y*-1
				weapon.AimAng.y=weapon.AimAng.y*-1
			end		
		end
		weapon.zmFull=false
		return true
	end
	return false
end

function PLUGIN:Sprinting(p)
	if p and ValidEntity(p) then
		if (p:GetActiveWeapon():GetClass() == "weapon_physgun" and p:KeyDown(IN_ATTACK)) then
			return false;
		end;
		
		local b=p:KeyDown(IN_SPEED);
		
		if b then
			p:ConCommand("-attack")
			p:ConCommand("-attack2")
		end
		
		return b
	end
end

function PLUGIN:SmoothApproach(x,y,s,c)
	local FrT = math.Clamp(FrameTime(), 0.001, 0.035)*0.3
	c = (c and c*FrT) or (99999)
	
	return x-math.Clamp((x-y)*s*FrT,-c,c);
end;

function PLUGIN:SmoothApproachVector(Vec1, Vec2, s, c)
	local dir=(Vec1-Vec2):Normalize()
	local dist=Vec1:Distance(Vec2)
	local var= self:SmoothApproach(0,dist,s,c)
	local v=Vec1-dir*var
	
	Vec1.x=v.x
	Vec1.y=v.y
	Vec1.z=v.z

	return Vec1
end

function PLUGIN:SmoothVars(lvel, weapon, FrT, crt, tr, pvel, vang, ang, flp, del)
	viewtime  =  viewtime+math.Clamp(lvel/150,0.1,2)*FrT+0.0001
	
	f_smZ = self:SmoothApproach(f_smZ,(self:Zoomed(weapon))and(1)or(0),60,20)
	f_smHs = self:SmoothApproach(f_smHs,(weapon.Holstered(weapon))and(1)or(0),50,5)
	f_smSpr = self:SmoothApproach(f_smSpr,(self:Sprinting(weapon.Owner))and(1)or(0),50,15)
	f_smZol = self:SmoothApproach(f_smZol, weapon.zoomAdd,30)
	f_smGr = self:SmoothApproach(f_smGr, (weapon.Owner:OnGround())and(1)or(0), 50, 15)
	
	a_smAng.p = self:SmoothApproach(a_smAng.p, weapon.VMAngAdd.p, 150, 200)
	a_smAng.y = self:SmoothApproach(a_smAng.y, weapon.VMAngAdd.y, 150, 200)
	a_smAng.r = self:SmoothApproach(a_smAng.r, weapon.VMAngAdd.r, 150, 200)
	
	self:SmoothApproachVector(v_smWall, tr.StartPos+tr.Normal*23-tr.HitPos, 25)
	self:SmoothApproachVector(v_smSpd, pvel*0.6, 25)
	
	v_smSpd.x = math.Clamp(v_smSpd.x,-700,700)
	v_smSpd.y = math.Clamp(v_smSpd.y,-700,700)
	v_smSpd.z = math.Clamp(v_smSpd.z,-700,700)
	
	a_smAngAdd.p = self:SmoothApproach(a_smAngAdd.p, math.AngleDifference(vang.p,ang.p), 50)
	a_smAngAdd.y = self:SmoothApproach(a_smAngAdd.y, math.AngleDifference(vang.y,ang.y)*flp, 50)
end

function PLUGIN:CalcView(ply, pos, ang, fov)
	if LocalPlayer():InVehicle() or !LocalPlayer():Alive() then return end
	
	local weapon = ply:GetActiveWeapon()
	
	if !ValidEntity( weapon ) then return end
	
	if !self:CheckAllow( weapon, LocalPlayer() ) then
		viewAng = ang
		oldAng = ang
		viewAng.r = 0
		oldAng.r = 0
		return
	end
	
	if self:CheckSwep( weapon ) then return end
	
	local velocity = LocalPlayer():GetVelocity()
	local lengthVelocity = velocity:Length()
	local frameTime = FrameTime()
	local curTime = CurTime()
	
	viewAng = viewAng or ang
	oldAng = oldAng or ang
	
	local pitchDiff = math.AngleDifference( viewAng.p, ang.p )
	local yawDiff = math.AngleDifference( viewAng.y, ang.y )
	local aPDiff = math.AngleDifference( oldAng.p, ang.p )
	local aYDiff = math.AngleDifference( oldAng.y, ang.y )
	
	viewAng.p = viewAng.p - ( ( pitchDiff * math.Clamp( math.abs( pitchDiff ), weapon.AngM, weapon.AngMax ) * 0.01 ) * ( 1 - f_smZ ) + ( pitchDiff * math.Clamp( math.abs( pitchDiff ), weapon.AngMz, weapon.AngMaxz ) * 0.1 ) * f_smZ )
	viewAng.y = viewAng.y - ( ( yawDiff * math.Clamp( math.abs( yawDiff ), weapon.AngM, weapon.AngMax ) * 0.01 ) * ( 1 - f_smZ ) + ( yawDiff * math.Clamp( math.abs( yawDiff ), weapon.AngMz, weapon.AngMaxz ) * 0.1 ) * f_smZ )
	viewAng.r = 0
	
	VMPosAdd.x = math.Clamp( VMPosAdd.x - ( 1 - math.abs( VMPosAdd.x )/weapon.VMPosMax.x ) * aYDiff * ( weapon.VMPosM.x * ( 1 - f_smZ ) + weapon.VMPosMz.x * f_smZ ) * math.Clamp( 70 - math.abs( ang.p ), - 30, 30 )/30 - VMPosAdd.x * ( weapon.VMPosD.x * ( 1 - f_smZ ) + weapon.VMPosDz.x * f_smZ ),  - ( weapon.VMPosMax.x * ( 1 - f_smZ ) + weapon.VMPosMaxz.x * f_smZ ), weapon.VMPosMax.x * ( 1 - f_smZ ) + weapon.VMPosMaxz.x * f_smZ )
	VMPosAdd.z = math.Clamp( VMPosAdd.z - ( 1 - math.abs( VMPosAdd.z )/weapon.VMPosMax.z ) * aPDiff * ( weapon.VMPosM.z * ( 1 - f_smZ ) + weapon.VMPosMz.z * f_smZ ) * math.Clamp( 70 - math.abs( ang.p ), - 30, 30 )/30 - VMPosAdd.z * ( weapon.VMPosD.z * ( 1 - f_smZ ) + weapon.VMPosDz.z * f_smZ ),  - ( weapon.VMPosMax.z * ( 1 - f_smZ ) + weapon.VMPosMaxz.z * f_smZ ), weapon.VMPosMax.z * ( 1 - f_smZ ) + weapon.VMPosMaxz.z * f_smZ )
	
	if ( f_smZ >= 0.9 and self:Zoomed( weapon ) and weapon.ZoomOverlay and !weapon.zmFull ) then
		weapon.zmFull = true
		weapon.zoomBlack = 255
		LocalPlayer():GetViewModel( ):SetNoDraw( true )
	elseif weapon.zmFull and f_smZ < 0.9 then
		weapon.zmFull = false
		LocalPlayer():GetViewModel( ):SetNoDraw( false )
	end
	
	local ri = viewAng:Right()
	local up = viewAng:Up()
	local fwd = viewAng:Forward()
	local VMFlip = ( weapon.ViewModelFlip )and( - 1 )or( 1 )
	local VMFlop = 0 - VMFlip
	local pvel = LocalPlayer():WorldToLocal( LocalPlayer():GetPos() + ( pos - lastpos ) * 100 )
	
	lastpos = pos
	
	local runsinx = math.sin( viewtime * 14 ) * f_smGr
	local runsiny = math.sin( viewtime * 7 ) * f_smGr
	local tr = util.QuickTrace( pos, ang:Forward() * 23, weapon.Owner )
	
	self:SmoothVars( lengthVelocity, weapon, frameTime, curTime, tr, pvel, viewAng, ang, VMFlip, lastdelta )
	
	fwd.z = math.Clamp( fwd.z, - 1, ( 1 - f_smSpr ) )
	
	local m = ( 0.1 * math.Clamp( 1 - f_smZ, 0.01, 1 ) * ( ply:KeyDown( IN_DUCK ) and 0.1 or 1 ) )
	
	pos = pos + runsinx * up * 3 * math.Clamp( lengthVelocity * lengthVelocity * 0.00001, m, 10 ) * 1 + ri * runsiny * 3 * math.Clamp( lengthVelocity * lengthVelocity * 0.00001, m, 10 ) * 1
	
	view.origin = pos
	view.fov = math.Clamp( fov - ( weapon.zoomStart + ( ( f_smZol + 20 + ( fov - 90 ) ) * ( ( f_smZ >= 0.9 and weapon.zoomEnd ) and 1 or 0 ) ) ) * f_smZ, 1.5, 100 )
	
	local vmang = viewAng - a_smAngAdd * 0.7 + Angle( weapon.RunAng.p * f_smSpr, weapon.RunAng.y * f_smSpr * VMFlop, weapon.RunAng.r * f_smSpr ) * ( 1 - f_smHs )
	vmang = vmang + Angle( ( a_smAng.p + weapon.AimAng.p * f_smZ ) * ( 1 - f_smSpr ), ( a_smAng.y + weapon.AimAng.y * f_smZ ) * VMFlip * ( 1 - f_smSpr ), weapon.AimAng.r * f_smZ * ( 1 - f_smSpr ) ) * ( 1 - f_smHs ) + Angle( f_smHs * 90, ( f_smHs * - 90 + runsiny * 2 * f_smSpr ) * VMFlip + runsiny * 5 * f_smSpr * VMFlop, 0 )
	
	pos = pos + ri * ( runsiny * - m * VMFlip + runsiny * lengthVelocity * 0.001 + weapon.VMPosOffset.x * ( 1 - f_smSpr ) * ( 1 - f_smZ ) + math.Clamp( ang.p * 0.05 * f_smSpr, 0, 30 ) * VMFlip + v_smSpd.y * VMFlip * ( 1.5 - f_smZ ) * 0.004 + VMPosAdd.x * VMFlip + VMFlip * ( weapon.VMAngAdd.y ) * ( 1 - f_smZ ) * 0.1 + weapon.RunPos.x * f_smSpr * VMFlop + runsiny * f_smSpr + weapon.AimPos.x * f_smZ - runsiny * f_smSpr )
	pos = pos + fwd * ( 0 * ( 1 - f_smZ ) * ( 1 - f_smSpr ) + weapon.VMPosOffset.y * ( 1 - f_smSpr ) * ( 1 - f_smZ ) - v_smSpd.x * ( 1.5 - f_smZ ) * 0.004 - f_smHs * 10 + VMPosAdd.y + weapon.RunPos.y * f_smSpr + weapon.AimPos.y * f_smZ - runsiny * f_smSpr )
	pos = pos + up * ( runsinx * - m + runsinx * lengthVelocity * 0.001 + weapon.VMPosOffset.z * ( 1 - f_smSpr ) * ( 1 - f_smZ ) - math.Clamp( ang.p * 0.05 * f_smSpr, 0, 30 ) - v_smSpd.z * ( 2 - f_smZ ) * 0.004 + VMPosAdd.z - v_smSpd:Length() * 0.002 * ( 1 - f_smZ ) + ( weapon.VMAngAdd.p ) * ( 1 - f_smZ ) * 0.1 + weapon.RunPos.z * f_smSpr + runsinx * 0.5 * f_smSpr + weapon.AimPos.z * f_smZ )
	
	view.angles = viewAng + Angle( 0 + runsinx * 0, 0, v_smSpd.y * - 0.0125 ) * ( lengthVelocity/250 ) * f_smGr * 1
	view.vm_angles = vmang
	view.vm_origin = pos - v_smWall * ( 1 - f_smZ )
	view.znear = 1
	
	return view
end;
