
LastHeldWeapon = "";

WeaponNotice = 
{

	Str = "",
	Alpha = 0,
	FadeTime = 0,
	PlayerDead = false,

};

DeathTimerEnd = 0;

DEATH_TIMER_PAUSE = 5;

--Occurs every loop
function GM:Think()
	
	if( not LocalPlayer():Alive() ) then
	
		LastHeldWeapon = "";
		WeaponNotice.PlayerDead = true;
		HeartBeat.SimulatedCalmness = 100;
		
		if( DeathTimerEnd == 0 ) then
		
			DeathTimerEnd = CurTime() + DEATH_TIMER_PAUSE;
		
		end
	
	else
	
		DeathTimerEnd = 0;
		
		HandleHeartBeatRate();
		
	end
	
	local weap = LocalPlayer():GetActiveWeapon();
	
	if( weap:IsValid() ) then

		if( LocalPlayer():KeyDown( IN_RELOAD ) ) then
			
			CreateAmmoMenu();
		
		elseif( AmmoMenu ) then
		
			DestroyAmmoMenu();
		
		end

		if( weap:GetClass() ~= LastHeldWeapon ) then

			LastHeldWeapon = weap:GetClass();

			if( weap:GetTable() and weap:GetTable().Primary and weap:GetTable().Primary.HolsteredAtStart ~= nil ) then

				SetWeaponHolster( weap:GetTable().Primary.HolsteredAtStart );

			end
			
			if( not WeaponNotice.PlayerDead ) then
			
				WeaponNotice.Str = weap:GetPrintName();
				WeaponNotice.Alpha = 255;
				WeaponNotice.FadeTime = CurTime() + .5;
		
			else
			
				WeaponNotice.PlayerDead = false;
			
			end
		
		end

		if( weap:GetTable() and weap:GetTable().Primary and weap:GetTable().Primary.PositionMode and !LocalPlayer():GetNWBool( "Holstered", true ) ) then
	
			if( LocalPlayer():KeyDown( IN_ATTACK2 ) and not weap:GetNetworkedBool( "reloading", false ) ) then
			
				if( weap:GetTable().Primary.PositionMode ~= 1 ) then
			
					weap:GetTable().Primary.PositionMode = 1;
					weap:GetTable().Primary.PositionMul = 0;
					
					if( weap:GetTable().Melee ) then
					
						if( not weap:GetTable().Charging ) then
						
							weap:GetTable().ChargeTimeStart = CurTime();
							weap:GetTable().ChargeTimeMax = CurTime() + 1;
						
						end
						
						weap:GetTable().Charging = true;
						
					end
					
				end
				
			elseif( weap:GetTable().Primary.PositionMode == 1 ) then
			
				weap:GetTable().Primary.GoToOriginalPosition = true;
				weap:GetTable().Primary.NextPositionMode = 0;
				weap:GetTable().Charging = false;
				weap:GetTable().ChargeTimeStart = 0;
				weap:GetTable().ChargeTimeMax = 0;
				
				if( weap:GetTable().Primary.PositionMul == 1 ) then
				
					if( ScopeOn ) then
					
						ScopeMode( false );
		
					end
				
				end
			
			end
			
		end
	
	elseif( AmmoMenu ) then
		
		DestroyAmmoMenu();
		
	end
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:GetNWEntity( "ActiveCig", v ) != v ) then
			
			local cig = v:GetNWEntity( "ActiveCig" );
			
			if( !v.NextCigSmoke ) then
				
				v.NextCigSmoke = 0;
				
			end
			
			if( CurTime() > v.NextCigSmoke ) then
				
				v.NextCigSmoke = CurTime() + 10;
				local fx = table.Random( SMOKE_EFFECTS );
				
				PrecacheParticleSystem( fx );
				ParticleEffectAttach( fx, PATTACH_ABSORIGIN_FOLLOW, cig, 0 );
				
			end
			
		end
		
	end
	
end

ForcedMovement = false;
CrouchedToggled = false;
StayCrouching = false;
InjuredLegHeadBobCosine = 0;

DesiredScopeZoom = 50;

DuckToggle = CreateClientConVar( "ep_ducktoggle", 1, true, false );

function GM:PlayerBindPress( ply, bind, pressed )

	if( not LocalPlayer():Alive() ) then

		if( DeathTimerEnd == 0 or CurTime() < DeathTimerEnd ) then
		
			return true;

		end

	end
	
	if( ply:GetActiveWeapon() and ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon().VariableZoom and ScopeOn ) then
		
		if( bind == "invnext" ) then -- out
			
			DesiredScopeZoom = math.Clamp( DesiredScopeZoom + 3, 10, 50 );
			
		elseif( bind == "invprev" ) then
			
			DesiredScopeZoom = math.Clamp( DesiredScopeZoom - 3, 10, 50 );
			
		end
		
	end

	if( bind == "+duck" and GetConVarNumber( "ep_ducktoggle" ) == 1 and !LocalPlayer():InVehicle() ) then
	
		if( StayCrouching ) then
		
			StayCrouching = false;
			return true;
		
		end
	
		if( CrouchedToggle ) then
		
			CrouchedToggle = !CrouchedToggle;
			StayCrouching = true;
			RunConsoleCommand( "-duck", "" );
			return true;
		
		end
	

		CrouchedToggle = !CrouchedToggle;
		StayCrouching = true;
		RunConsoleCommand( "+duck", "" );
		
		return true;
		
	end

	if( bind == "slot1" ) then
	
		RunConsoleCommand( "eng_gotohands", "1" );
		return true;
	
	end
	
	if( bind == "slot2" ) then
	
		RunConsoleCommand( "eng_gotolight", "1" );
		return true;
	
	end

	if( bind == "slot3" ) then
	
		RunConsoleCommand( "eng_gotoheavy", "1" );
		return true;
	
	end
	
	if( bind == "slot4" ) then
	
		RunConsoleCommand( "eng_gototool", "1" );
		return true;
	
	end
	
	if( bind == "slot5" ) then
	
		RunConsoleCommand( "eng_gotophys", "1" );
		return true;
	
	end
	
	if( bind == "+use" ) then
	
		if( ActionMenu ) then
		
			SimulatedMouseClick = true;
		
		end
	
	end

	if( bind == "+attack" or
		bind == "+attack2" ) then
		
		if( OpeningScreen.HUDOverride or CharacterCreate.HUDOverride ) then
		
			return true;
		
		end
		
		if( ActionMenu ) then
		
			return true;
		
		end
		
	end

	if( bind == "+walk" and not ply:KeyDown( IN_SPEED ) ) then
	
		if( ForcedMovement ) then
		
			LocalPlayer():ConCommand( "-forward" );
			LocalPlayer():ConCommand( "-back" );
			LocalPlayer():ConCommand( "-moveright" );
			LocalPlayer():ConCommand( "-moveleft" );
			
			ForcedMovement = false;
		
		else
		
			if( ply:KeyDown( IN_FORWARD ) ) then
			
				ForcedMovement = true;
				LocalPlayer():ConCommand( "+forward" );
			
			end
			
			if( ply:KeyDown( IN_BACK ) ) then
			
				ForcedMovement = true;
				LocalPlayer():ConCommand( "+back" );
			
			end
			
			if( ply:KeyDown( IN_MOVELEFT ) ) then
			
				ForcedMovement = true;
				LocalPlayer():ConCommand( "+moveleft" );
			
			end
			
			if( ply:KeyDown( IN_MOVERIGHT ) ) then
			
				ForcedMovement = true;
				LocalPlayer():ConCommand( "+moveright" );
			
			end
		
		end
	
	end

end

--Handles various things from weapon view model camera calculation to headbobbing.
local HeadBob = {

	Dir = 1,
	Pitch = 0,
	Roll = 0,
	RollDesp = 0,
	NewRoll = true,

}

IntroViewHook = false;

function GM:CalcView( ply, origin, angles, fov )

	local view = CalcView( ply, origin, angles, fov );
	local speed = LocalPlayer():GetVelocity():Length();
	
	if( not view ) then
	
		view = { }
	
		view.origin = origin;
		view.angles = angles;
		view.fov = fov;
	
	end
	
	if( ScopeOn ) then
	
		local weap = LocalPlayer():GetActiveWeapon();
	
		if( weap and weap:IsValid() and weap:GetTable() ) then
			
			if( weap:GetTable().VariableZoom ) then
				
				view.fov = DesiredScopeZoom;
				
			else
				
				view.fov = weap:GetTable().Zoom;
				
			end
	
		end
	
	end
	
	--INTRO CAMERA CODE--
	if( IntroViewHook ) then
	
		local cam = FancyIntroPosChoice;
	
		if( cam ) then
		
			view.origin = cam.Pos;
			view.angles = cam.Ang;
			view.fov = 60;
			
			return view;
			
		end
	
	end
	
	if( ClientVars["Ragdolled"] ) then
	
		view.origin = view.origin;
		view.angles = view.angles + Angle( 45, 0, 0 );
		view.fov = 120;
		
		return view;
				
	
	end
	
	if( ClientVars["Class"] == "Infected" ) then 
	
		view.fov = 110;
	
	end
	
	--HEAD BOBBING CODE--
	--Different headbob code for walking, sprinting, jogging, etc..
	--Combined with consciousnes code
	if( speed > 40 and EyePos():Distance( LocalPlayer():EyePos() ) < 5 ) then
		
		local min = -.25;
		local max = .25;

		local hbspeed = 0;
		
		if( ply:KeyDown( IN_SPEED ) ) then
	
			if( ply:KeyDown( IN_WALK ) ) then
			
				--RUNNING--
				
				min = -1;
				max = 1;
		
				if( HeadBob.Dir > 0 ) then
				
					hbspeed = 15;
				
				else
				
					hbspeed = 7;
				
				end		
			
			else
	
				--JOGGING--
				
				min = -.5;
				max = .5;
		
				if( HeadBob.Dir > 0 ) then
				
					hbspeed = 7;
				
				else
				
					hbspeed = 3;
				
				end		
				
			end			
		
		else --WALKING--
		
			if( HeadBob.Dir > 0 ) then
			
				hbspeed = 3;
			
			else
			
				hbspeed = 1;
			
			end
			
		end
		
		HeadBob.Pitch = HeadBob.Pitch + hbspeed * FrameTime() * HeadBob.Dir;
		
		if( HeadBob.NewRoll ) then
		
			if( HeadBob.RollDesp > 0 ) then
			
				HeadBob.Roll = math.Clamp( HeadBob.Roll + 2 * FrameTime(), 0, HeadBob.RollDesp );
	
			
			else
			
				HeadBob.Roll = math.Clamp( HeadBob.Roll - 2 * FrameTime(), HeadBob.RollDesp, 10 );
			
			end
			
		else
		
			if( HeadBob.Roll > 0 ) then
			
				HeadBob.Roll = HeadBob.Roll - 2 * FrameTime();

				if( HeadBob.Roll < 0 ) then
				
					HeadBob.Roll = 0;
					HeadBob.NewRoll = true;
				
				end	
		
			else
			
				HeadBob.Roll = HeadBob.Roll + 2 * FrameTime();
				
				if( HeadBob.Roll > 0 ) then
				
					HeadBob.Roll = 0;
					HeadBob.NewRoll = true;
				
				end
			
			end
		
		end
		
		if( HeadBob.Pitch < min ) then
		
			HeadBob.Pitch = min;
			HeadBob.Dir = 1;
			HeadBob.RollDesp = math.Rand( -.3, .3 );
			HeadBob.NewRoll = false;
		
		end
		
		if( HeadBob.Pitch > max ) then
		
			HeadBob.Pitch = max;
			HeadBob.Dir = -1;
		
		end
		
		view.angles.pitch = view.angles.pitch + HeadBob.Pitch;
		view.angles.roll = view.angles.roll + HeadBob.Roll;

	end
	

	local conscious = ClientVars["Conscious"];
	local level = ConsciousBlur.Levels[conscious];

	if( conscious < 70 and level and EyePos():Distance( LocalPlayer():EyePos() ) < 5 ) then
		
		local speed = 12;
		
		if( ConsciousBlur.HeadBobDir > 0 ) then
		
			speed = 6;
		
		end
		
		if( ConsciousBlur.HeadBobNewRoll and not HeadBobRollToOrigin ) then
		
			ConsciousBlur.HeadBobRollDesp = math.Rand( -2, 2 );
			ConsciousBlur.HeadBobNewRoll = false;
			ConsciousBlur.HeadBobRollToOrigin = false;
		
		end
		
		local dest = 0;
		
		if( not HeadBobRollToOrigin ) then
		
			dest = ConsciousBlur.HeadBobRollDesp;
		
		end
			
		if( dest > ConsciousBlur.HeadBobRoll ) then
			
			ConsciousBlur.HeadBobRoll = ConsciousBlur.HeadBobRoll + 1 * FrameTime();
			
			if( dest < ConsciousBlur.HeadBobRoll ) then
			
				ConsciousBlur.HeadBobRoll = dest;
				HeadBobRollToOrigin = !HeadBobRollToOrigin;
				ConsciousBlur.HeadBobNewRoll = true;
			
			end
			
		elseif( dest <= ConsciousBlur.HeadBobRoll ) then
			
			ConsciousBlur.HeadBobRoll = ConsciousBlur.HeadBobRoll - 1 * FrameTime();
			
			if( dest > ConsciousBlur.HeadBobRoll ) then
			
				ConsciousBlur.HeadBobRoll = dest;
				HeadBobRollToOrigin = !HeadBobRollToOrigin;
				ConsciousBlur.HeadBobNewRoll = true;
			
			end
			
		end
			
			
		ConsciousBlur.HeadBob = ConsciousBlur.HeadBob + level.HeadBobAmount * FrameTime() * ConsciousBlur.HeadBobDir * speed;

		if( ConsciousBlur.HeadBob < level.HeadBobMin ) then
		
			ConsciousBlur.HeadBob = level.HeadBobMin;
			ConsciousBlur.HeadBobDir = 1;

		end
		
		if( ConsciousBlur.HeadBob > level.HeadBobMax ) then
		
			ConsciousBlur.HeadBob = level.HeadBobMax;
			ConsciousBlur.HeadBobDir = -1;
		
		end
		
		view.angles.pitch = view.angles.pitch + ConsciousBlur.HeadBob;
		view.angles.roll = view.angles.roll + ConsciousBlur.HeadBobRoll;
		
	end
	
	if( ( ClientVars["LLegHP"] < 60 or ClientVars["RLegHP"] < 60 ) and EyePos():Distance( LocalPlayer():EyePos() ) < 5 ) then
	
		local bobdist = math.cos( math.pi * ( InjuredLegHeadBobCosine / 180 ) );
	
		if( speed > 0 ) then
	
			if( InjuredLegHeadBobCosine < 180 ) then
				InjuredLegHeadBobCosine = InjuredLegHeadBobCosine + 160 * FrameTime();
			else
				InjuredLegHeadBobCosine = InjuredLegHeadBobCosine + 600 * FrameTime();
			end
			
		end
	
		view.angles.pitch = view.angles.pitch + ( bobdist * 4 );
	
		if( InjuredLegHeadBobCosine > 360 ) then
		
			InjuredLegHeadBobCosine = InjuredLegHeadBobCosine - 360;
	
		end
		
	end
	
	--END HEADBOB CODE--
	
	return view;

end

function GM:AdjustMouseSensitivity( def )
	
	if( ScopeOn ) then
		
		return def * 0.01;
		
	end
	
	return -1;
	
end