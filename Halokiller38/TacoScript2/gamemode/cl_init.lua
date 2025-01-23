DeriveGamemode( "Gear" );
DeriveGamemode( "sandbox" );

include( "shared.lua" );
include( "sh_animation_tables.lua" );
include( "sh_animations.lua" );
include( "cl_hud.lua" );
include( "cl_chat.lua" );
include( "player_shared.lua" );
include( "player_variables.lua" );
include( "cl_playermenu.lua" );
include( "cl_charactermenu.lua" );
include( "cl_inventory.lua" );
include( "cl_dev.lua" );
include( "cl_weaponselect.lua" );
include( "entity_shared.lua" );
include( "cl_storage.lua" );
include( "cl_help.lua" );
include( "cl_update.lua" );
include( "cl_umsg.lua" );
include( "cl_acccreation.lua" );
include( "cl_scoreboard.lua" );
include( "cl_itemspawning.lua" );
include( "cl_animcmds.lua" );
include( "cl_radiomenu.lua" );

TS.StartTime = CurTime();
TS.FancyGayIntro = true;
TS.HighestHealth = 100;
gui.EnableScreenClicker( false );
TS.HorseyMapView = true;

TS.MOTD = "DEVELOPMENT STAGE - HL2 RP\n" ..
"---------\nwww.taconbanana.com\n---------\n\n" ..
"Please note a few things about our current beta:\n" ..
"F1 opens the help menu,\n" .. 
"F3 opens the player menu (char selection (flagging up); char creation; everything else),\n" .. 
"/sd to set a description for props or doors";

TS.SpawnableItems = { }
TS.ChatLines = { }

---------------------------------------
-- CLIENT HOOKS
---------------------------------------

function GM:Think()

	if( LocalPlayer():Alive() and ClientVars["Conscious"] ) then

		for k, v in pairs( TS.ChatLines ) do

			if( CurTime() - v.start > 10 ) then
		
				v.a = math.Clamp( v.a - 200 * FrameTime(), 0, 255 );
		
			end
		
			if( v.a <= 0 ) then
		
				TS.ChatLines[k] = nil;

			elseif( v.y <= 30 ) then
			
				TS.ChatLines[k] = nil;
		
			end
	
		end
		
	end

	if( LocalPlayer():Health() > TS.HighestHealth ) then
	
		TS.HighestHealth = LocalPlayer():Health();
	
	end

	if( not ClientVars["FreezeHead"] ) then
		FreezeHeadViewAngle = nil;
		FreezeHeadStartAngle = nil;   
	end

	if( PlayerMenuVisible ) then
		PlayerMenuThink();
	end

	FillWeaponTabs();
	
	local weap = LocalPlayer():GetActiveWeapon();
	
	if( weap:IsValid() and weap and weap.Primary ) then
	
		if( not ClientVars["Holstered"] and weap.Primary.IronSightPos ) then
		
			if( LocalPlayer():KeyDown( IN_ATTACK2 ) ) then
				
				weap.Primary.PositionMode = 1;
				weap.Primary.PositionMul = math.Clamp( weap.Primary.PositionMul + ( 1 / weap.Primary.PositionTime ) * FrameTime(), 0, 1 );

			elseif( weap.Primary.PositionMode == 1 ) then
				
				weap.Primary.PositionMul = math.Clamp( weap.Primary.PositionMul - ( 1 / weap.Primary.PositionTime ) * FrameTime(), 0, 1 );		
				weap.Primary.PositionOffsetSet = false;
				
				if( weap.Primary.PositionMul == 0 ) then
					weap.Primary.PositionMode = 0;
				end
				
			end
			
		end
		
		--While we're unholstering it
		if( weap.Primary.PositionMode == 2 ) then
		
			if( weap.Primary.HolsteredPos ) then
	
				weap.Primary.PositionMul = math.Clamp( weap.Primary.PositionMul - ( 1 / weap.Primary.PositionTime ) * FrameTime(), 0, 1 );		
			
				if( weap.Primary.PositionMul == 0 ) then
					weap.Primary.PositionMode = 0;
				end
	
			end
			
		end
		
		--While we're holstering it
		if( weap.Primary.PositionMode == 3 ) then
		
			if( weap.Primary.HolsteredPos ) then
		
				weap.Primary.PositionMul = math.Clamp( weap.Primary.PositionMul + ( 1 / weap.Primary.PositionTime ) * FrameTime(), 0, 1 );		
	
			end
			
		end

	end
	
end

UnconsciousFov = 90;
UnconsciousFovPing = false;
UnconsciousFovVel = -30;

DeathAngle = 0;

local function AddAlcoholMod( view )

	local mul = ClientVars["DrunkMul"];
	
	--We dont start caring until the multiplier hits a third of the way
	if( mul > .3 ) then
	
		mul = mul - .3;

		AlcoholBlur.HeadBobCosine = AlcoholBlur.HeadBobCosine + 120 * FrameTime();
		
		if( AlcoholBlur.HeadBobCosine > 360 ) then
		
			AlcoholBlur.HeadBobCosine = AlcoholBlur.HeadBobCosine - 360;
			AlcoholBlur.ShiftedPitchYaw = false;

		end
		
		if( AlcoholBlur.HeadBobCosine > 90 and not AlcoholBlur.ShiftedPitchYaw ) then
		
			AlcoholBlur.HeadBobYawMul = math.Rand( -1, 1 );
			AlcoholBlur.ShiftedPitchYaw = true;
			AlcoholBlur.HeadBobCosine = 90;

		end
		
		local bobdist = math.cos( 3.14159265 * ( AlcoholBlur.HeadBobCosine / 180 ) );
		
		view.angles.pitch = view.angles.pitch + ( bobdist * ( 8 * mul * AlcoholBlur.HeadBobPitchMul ) );
		view.angles.yaw = view.angles.yaw + ( bobdist * ( 6 * mul * AlcoholBlur.HeadBobYawMul ) );

	end

	return view;

end
 
function GM:CalcView( ply, origin, angles, fov )
	
	if( not LocalPlayer():Alive() and ply:GetRagdollEntity() and ply:GetRagdollEntity():IsValid() ) then
	
		local trace = { }
		trace.start = ply:GetRagdollEntity():GetAttachment( ply:GetRagdollEntity():LookupAttachment( "eyes" ) ).Pos;
		trace.endpos = trace.start + Vector( 0, 0, 60 );
		trace.filter = LocalPlayer();
		
		local tr = util.TraceLine( trace );
		
		local view = { }
		
		view.origin = tr.HitPos;
		view.angles = Angle( 90, DeathAngle, 0 );
		view.fov = 70;
		
		DeathAngle = DeathAngle + 7 * FrameTime();
		
		if( DeathAngle > 360 ) then
		
			DeathAngle = DeathAngle - 360;
		
		end
		
		return view;
	
	end
	
	if( not ClientVars["Conscious"] or ( not LocalPlayer():Alive() and not ply:GetRagdollEntity() ) ) then
		
		local view = {}
	 	view.origin 	= UnconsciousViewPos or origin 
	 	view.fov =		UnconsciousFov;
	 	view.angles = UnconsciousViewAng or angles;
	 	
	 	if( CurTime() - UnconsciousTime >= 2 ) then
	 	
	 		if( not UnconsciousViewPos ) then
	 		
	 			UnconsciousViewPos = origin;
	 			UnconsciousViewAng = angles;
	 		
	 		end
	 	
	 	end
	 	
	 	UnconsciousFov = UnconsciousFov + UnconsciousFovVel * FrameTime();

	 	if( UnconsciousFov < 60 ) then
	 	
	 		UnconsciousFovVel = math.Clamp( UnconsciousFovVel + 40 * FrameTime(), -1000, 0 );
	 	
	 	end

	 	return view;
	 	
	end
	
	if( ClientVars["FreezeHead"] ) then
		local view = {}
	 	view.origin 	= origin 
	 	view.fov 		= fov 
	 	
	 	if( FreezeHeadViewAngle ) then
	
	 		view.angles = FreezeHeadViewAngle;
	 		
	 		view = AddAlcoholMod( view );
	 		
	 		return view;
	 		
	 	end
	
	end
	
	local wep = ply:GetActiveWeapon();
	local view = { } 
 	view.origin 	= origin; 
 	view.angles		= angles; 
 	view.fov 		= fov; 
	
	if ( ValidEntity( wep ) ) then 
 	 
 		local func = wep.GetViewModelPosition;
		
 		if ( func ) then 
 			view.vm_origin,  view.vm_angles = func( wep, origin*1, angles*1 );
 		end 
 		
 		local func = wep.CalcView;
		
 		if ( func ) then 
 			view.origin, view.angles, view.fov = func( wep, ply, origin*1, angles*1, fov );
 		end 
		
	end
	
	view = AddAlcoholMod( view );
	
	return view;

end

--Horsey's fixed map view >.>
local function CalcViewMap( pl, origin, angles, fov )
   
	if( TS.HorseyMapView ) then
	
		if( TS.MapViews[game.GetMap()] ) then
			
			local mapview =	
			{
				
				origin = TS.MapViews[game.GetMap()].pos,
				angles = TS.MapViews[game.GetMap()].ang,
			
			}
	
			return mapview;
			
		end
	
	end

end
hook.Add( "CalcView", "NewMapView", CalcViewMap );

FreezeHeadViewAngle = nil;
FreezeHeadStartAngle = nil;
FreezeHeadStartYaw = 0;
FreezeHeadViewYaw = 0;
FreezeHeadStartPitch = 0;

function GM:CreateMove( cmd )

	if( ClientVars["FreezeHead"] ) then

		if( not FreezeHeadViewAngle or not FreezeHeadStartAngle ) then
		
			FreezeHeadViewAngle = cmd:GetViewAngles();
			FreezeHeadStartAngle = cmd:GetViewAngles();
			FreezeHeadStartYaw = FreezeHeadViewAngle.yaw;
			FreezeHeadStartPitch = FreezeHeadViewAngle.pitch;
			FreezeHeadViewYaw = FreezeHeadStartYaw;
		
		else
		
			local origyaw = FreezeHeadViewAngle.yaw;
			local origpitch = FreezeHeadViewAngle.pitch;
			
			FreezeHeadViewAngle.pitch = FreezeHeadViewAngle.pitch + ( cmd:GetViewAngles().pitch - FreezeHeadStartAngle.pitch );

			local cmdyaw = 0;
			
			if( origyaw < -170 ) then
				
				if( cmd:GetViewAngles().yaw > 0 and FreezeHeadStartAngle.yaw < 0 ) then
					cmdyaw = cmd:GetViewAngles().yaw - 360;
				else
					cmdyaw = cmd:GetViewAngles().yaw;
				end
			
			else
			
				cmdyaw = cmd:GetViewAngles().yaw;
			
			end
			
			local offset = ( cmdyaw - FreezeHeadStartAngle.yaw );
			
			FreezeHeadViewAngle.yaw = FreezeHeadViewAngle.yaw + offset;
			FreezeHeadViewAngle.roll = FreezeHeadViewAngle.roll + ( cmd:GetViewAngles().roll - FreezeHeadStartAngle.roll );
			
			if( FreezeHeadViewAngle.yaw > FreezeHeadStartYaw + 90 or FreezeHeadViewAngle.yaw < FreezeHeadStartYaw - 90 ) then
				FreezeHeadViewAngle.yaw = origyaw;
			end

			if( FreezeHeadViewAngle.pitch < FreezeHeadStartPitch - 70 ) then
				FreezeHeadViewAngle.pitch = origpitch;
			end

			if( FreezeHeadViewAngle.pitch > FreezeHeadStartPitch + 70 ) then
				FreezeHeadViewAngle.pitch = origpitch;
			end
	
			FreezeHeadStartAngle.pitch = FreezeHeadViewAngle.pitch;
	
			cmd:SetViewAngles( FreezeHeadStartAngle );
			
		end
		
	end

end

function GM:PlayerBindPress( ply, bind, down )

	--Chat window
	if( string.find( bind, "messagemode" ) ) then
	
		RunConsoleCommand( "eng_istyping", "" );
		OpenChatBox();
		return true;
	
	end
	
	if( bind == "+jump" ) then
	
		if( ClientVars["Sprint"] < 15 or not ClientVars["CanSprint"] ) then
			return true;
		end
	
	end
	
	--Attack binds
	if( bind == "+attack" ) then
	
		if( ActionMenuOn ) then 
		
			return true;
		
		end
	
		if( WeaponsMenuVisible ) then
		
			if(  WeaponsTabs[SelectedTab] and WeaponsTabs[SelectedTab][SelectedSlot] ) then
				RunConsoleCommand( "rp_selectweapon", WeaponsTabs[SelectedTab][SelectedSlot].Class );
			end
			
			WeaponsMenuVisible = false;
			return true;
			
		end
	
	end
	
	if( HorseyMapView ) then return; end
	
	--Weapon selection shit--
	if( string.sub( bind, 1, 4 ) == "slot" ) then
	
		local id = tonumber( string.sub( bind, 5 ) );
		
		if( id > 0 and id < 4 ) then
		
			WeaponsMenuFadeTime = CurTime() + 3;
			WeaponsMenuFadeAlpha = 255;
			
			if( SelectedTab == id and WeaponsMenuVisible ) then
			
				SelectedSlot = SelectedSlot + 1;
				
				if( SelectedSlot > GetMaxWeaponSlotIndex( SelectedTab ) ) then 
					SelectedSlot = 1;
				end
			
				if( GetWeaponSlotCount( SelectedTab ) > 0 ) then
			
					while( not WeaponsTabs[SelectedTab][SelectedSlot] ) do
				
						SelectedSlot = SelectedSlot + 1;
						
						if( SelectedSlot > GetMaxWeaponSlotIndex( SelectedTab ) ) then 
							SelectedSlot = 1;
						end
						
					end
					
				end
				
			else
			
				SelectedTab = id;
				SelectedSlot = 1;
				WeaponsMenuVisible = true;
				
				if( GetWeaponSlotCount( SelectedTab ) > 0 ) then
				
					while( not WeaponsTabs[SelectedTab][SelectedSlot] ) do
				
						SelectedSlot = SelectedSlot + 1;
						
					end
					
				end
				
			end
		
		end
	
	end
	
	if( not LocalPlayer():KeyDown( IN_ATTACK ) and bind == "invprev" ) then
	
		if( WeaponsMenuVisible ) then
		
			SelectedSlot = SelectedSlot - 1;
			
			if( SelectedSlot < 1 ) then
			
				SelectedTab = SelectedTab - 1;
				
				if( SelectedTab < 1 ) then
				
					SelectedTab = 3;
				
				end
				
				SelectedSlot = GetMaxWeaponSlotIndex( SelectedTab );
			
			end
			
			--Infinited loop error?
			-- Affirmative. Happens when no weapons exist.
			while( not WeaponsTabs[SelectedTab][SelectedSlot] ) do
			
				SelectedSlot = SelectedSlot - 1;
				
				if( SelectedSlot < 1 ) then
			
					SelectedTab = SelectedTab - 1;
					
					if( SelectedTab < 1 ) then
					
						SelectedTab = 3;
					
					end
					
					SelectedSlot = GetMaxWeaponSlotIndex( SelectedTab );
				
				end
				
			end
			
			WeaponsMenuFadeTime = CurTime() + 3;
			WeaponsMenuFadeAlpha = 255;
			
		
		else
		
			WeaponsMenuVisible = true;
			WeaponsMenuFadeTime = CurTime() + 3;
			WeaponsMenuFadeAlpha = 255;
			
		end
	
	end
	
	if( not LocalPlayer():KeyDown( IN_ATTACK ) and bind == "invnext" ) then
	
		if( WeaponsMenuVisible ) then
		
			SelectedSlot = SelectedSlot + 1;
			WeaponsMenuFadeAlpha = 255;
			
			WeaponsMenuFadeTime = CurTime() + 3;
			
			if( SelectedSlot > GetMaxWeaponSlotIndex( SelectedTab ) ) then
			
				SelectedTab = SelectedTab + 1;
				SelectedSlot = 1;
			
				if( SelectedTab > 3 ) then
				
					SelectedTab = 1;
				
				end
			
			end
			
			while( not WeaponsTabs[SelectedTab][SelectedSlot] ) do
			
				SelectedSlot = SelectedSlot + 1;
			
				if( SelectedSlot > GetMaxWeaponSlotIndex( SelectedTab ) ) then
				
					SelectedTab = SelectedTab + 1;
					SelectedSlot = 1;
					
					if( SelectedTab > 3 ) then
					
						SelectedTab = 1;
					
					end
				
				end
			
			end
		
		else
		
			WeaponsMenuVisible = true;
			WeaponsMenuFadeTime = CurTime() + 3;
			WeaponsMenuFadeAlpha = 255;
	
		end
	
	end
	--End weapon selection shit--

end
 
function CCToggleHolster( ply, cmd, arg )

	local weap = ply:GetActiveWeapon();
	
	if( weap:IsValid() ) then
	
		local class = weap:GetClass();
		
		if( class == "weapon_physcannon" or
			class == "weapon_physgun" or
			class == "gmod_tool" or
			class == "ts2_zipties" or 
			class == "ts2_ziptiecutters" ) then 
			
			return; 
		
		end
	
		local holstered = !ClientVars["Holstered"];
		ClientVars["Holstered"] = holstered;
	
		if( not holstered ) then
	
			weap.Primary.PositionMode = 2;
			weap.Primary.PositionTime = .3;
			weap.Primary.PositionMul = 1;
			
		else

			weap.Primary.PositionMode = 3;
			weap.Primary.PositionTime = .3;
			weap.Primary.PositionMul = 0;
		
		end
	
		RunConsoleCommand( "eng_toggleholster", "" );
	
	end

end
concommand.Add( "rp_toggleholster", CCToggleHolster );

---------------------------------------
-- MISC CLIENT FUNCTIONS
---------------------------------------

function ApplyMaxCharacters( obj, len )

	obj.OnTextChanged = function() 
	
		if( string.len( obj:GetValue() ) == len ) then
			obj.MaxString = obj:GetValue();
		end
		
		if( string.len( obj:GetValue() ) > len ) then
			obj:SetText( obj.MaxString );
		end
		
	end

end

function ActionMenuCursorIsOn( x, y, w, h )

	local x2 = x + w;
	local y2 = y + h;
	
	local sx = ScrW() / 2;
	local sy = ScrH() / 2;
	
	if( sx >= x and sx <= x2 ) then
	
		if( sy >= y and sy <= y2 ) then
		
			return true;
		
		end
	
	end
	
	return false;

end

function MouseInArea( x, y, x2, y2 )

	local mx, my = gui.MousePos();
	
	if( mx >= x and mx <= x2 ) then

		if( my >= y and my <= y2 ) then
		
			return true;
			
		end
	
	end
	
	return false;

end

 --Unneeded Gear hooks.
hook.Remove( "PlayerBindPress", "GearPlayerBindPress" );
hook.Remove( "CalcView", "GearCalcView" );
hook.Remove( "Think", "GearThink" );
hook.Remove( "HUDShouldDraw", "GearHUDShouldDraw" );
 
PostClientsideLoad();