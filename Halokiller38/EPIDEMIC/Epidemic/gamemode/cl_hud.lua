
surface.CreateFont( "Type-Ra", 24, 400, true, false, "PlayerDisp" );
surface.CreateFont( "Default", 12, 200, true, false, "LimbDisp" );

--[[
--======================================--
-- LIFELINE HUD CODE                    --
--======================================--
]]--

local LifeLineStep = 1;
local LifeLineNextUpdate = CurTime();

--[[

local LifeLineOrigX = 20;
local LifeLineOrigY = ScrH() - 50;
local LifeLineCurX = LifeLineOrigX;
local LifeLineCurY = LifeLineOrigY;
local LifeLineEndX = 0;
local LifeLineEndY = 0;
local LifeLineDist = 0;
local LifeLinePoints = { }
local LifeLineParts = { }
local LifeLinePhase = 0;
local LifeLineNextUpdate = 0;
local LifeLineIndex = 1;
local LifeLineNewPhase = true;
local LifeLineIndexCount = 0;
local function GetNextLifeLinePoints()

	if(	LocalPlayer():Alive() ) then
	
		local healthperc = LocalPlayer():Health() / 100;
	
		local rise = LifeLineEndY - LifeLineOrigY;
		local newrise = rise * healthperc;
		LifeLineEndY = LifeLineOrigY + newrise;

	else
	
		LifeLineEndY = LifeLineOrigY;
	
	end

	local xdiff = LifeLineEndX - LifeLineCurX;
	local ydiff = LifeLineEndY - LifeLineCurY;
	local xabs = math.abs( xdiff );
	local yabs = math.abs( ydiff );
	
	local len = math.sqrt( ( xdiff * xdiff ) + ( ydiff * ydiff ) );
	
	local steps = len / 2;
	local xsteps = xdiff / steps;
	local ysteps = ydiff / steps;
	
	LifeLinePoints = { }
	
	for n = 1, math.ceil( steps ) do
	
		local x = LifeLineCurX + xsteps * n;
		local y = LifeLineCurY + ysteps * n;
		
		LifeLinePoints[n] = { x = x, y = y };
	
	end
	
	LifeLineIndexCount = math.ceil( steps );

end

local function GoToNextPoint()

	local healthperc = LocalPlayer():Health() / 100;

	LifeLineCurX = LifeLinePoints[LifeLineIndex].x;
	LifeLineCurY = LifeLinePoints[LifeLineIndex].y;

	local p = { 
	
		x = LifeLinePoints[LifeLineIndex].x,
		y = LifeLinePoints[LifeLineIndex].y,
		color = Color( 255 - ( healthperc * 255 ), ( 255 * healthperc ), 0, 128 ), 
		
	}
	
	table.insert( LifeLineParts, p );
	
	LifeLineIndex = LifeLineIndex + 1;
	
	if( LifeLineIndex > LifeLineIndexCount ) then
	
		LifeLineIndex = 1;
		LifeLineNewPhase = true;
		
		if( LifeLinePhase == 7 ) then
			LifeLinePhase = 0;
		end
	
	end

end

local function UpdatePhases()

	if( LifeLinePhase == 0 and LifeLineNewPhase ) then
	
		LifeLineCurX = LifeLineOrigX;
		LifeLineCurY = LifeLineOrigY;
		
		LifeLineEndX = LifeLineCurX + 30;
		LifeLineEndY = LifeLineCurY;
	
		GetNextLifeLinePoints();
		LifeLinePhase = 1;
		LifeLineNewPhase = false;
	
	end
	
	if( LifeLinePhase == 1 and LifeLineNewPhase ) then
	
		LifeLineEndX = LifeLineCurX + 10;
		LifeLineEndY = LifeLineCurY + 15;
	
		GetNextLifeLinePoints();
		LifeLinePhase = 2;
		LifeLineNewPhase = false;		
	
	end
	
	if( LifeLinePhase == 2 and LifeLineNewPhase ) then
	
		LifeLineEndX = LifeLineCurX + 10;
		LifeLineEndY = LifeLineCurY - 30;
	
		GetNextLifeLinePoints();
		LifeLinePhase = 3;
		LifeLineNewPhase = false;		
	
	end
	
	if( LifeLinePhase == 3 and LifeLineNewPhase ) then
	
		LifeLineEndX = LifeLineCurX + 10;
		LifeLineEndY = LifeLineCurY + 25;
	
		GetNextLifeLinePoints();
		LifeLinePhase = 4;
		LifeLineNewPhase = false;		
	
	end
	
	if( LifeLinePhase == 4 and LifeLineNewPhase ) then
	
		LifeLineEndX = LifeLineCurX + 5;
		LifeLineEndY = LifeLineCurY - 15;
	
		GetNextLifeLinePoints();
		LifeLinePhase = 5;
		LifeLineNewPhase = false;		
	
	end
	
	if( LifeLinePhase == 5 and LifeLineNewPhase ) then
	
		LifeLineEndX = LifeLineCurX + 10;
		LifeLineEndY = LifeLineOrigY;
	
		GetNextLifeLinePoints();
		LifeLinePhase = 6;
		LifeLineNewPhase = false;		
	
	end
	
	if( LifeLinePhase == 6 and LifeLineNewPhase ) then
	
		LifeLineEndX = LifeLineCurX + 20;
		LifeLineEndY = LifeLineOrigY;
	
		GetNextLifeLinePoints();
		LifeLinePhase = 7;
		LifeLineNewPhase = false;		
	
	end
	

end

function DoNextPointCalc()

	local delay = .03 - ( .03 * ( LocalPlayer():Health() / 100 ) );

	LifeLineNextUpdate = ( CurTime() + .03 + delay ) - ( .1 * HeartBeat.RateMul );

	if(	LocalPlayer():Alive() and LifeLinePhase > 1 and LifeLinePhase < 7 ) then
	
		for n = 1, 10 do
			
			if( LifeLinePhase < 7 ) then
			
				GoToNextPoint();
				UpdatePhases();
				
			else
		
				break;
				
			end
			
		end	

	else
	
		GoToNextPoint();
	
	end

end

function CreateNextPoint()

	UpdatePhases();

	if( LifeLineNextUpdate < CurTime() ) then
	
		DoNextPointCalc();
		
	end

end


local NextLifeLinePart = 0;
local LifeLinePartX = 0;
local LifeLinePartYVel = 0;
local LifeLinePhase = 0;
local LifeLineXOffset = 20;
local LifeLinePartOffset = 0;
local LifeLineLastX = 0;
local LifeLineLastY = 0;
--This code looks crude as fuck.  I should redo this later. 
--NOW DEFUNCT
local function CreateNextPoint()
		
	local x = LifeLinePartX + LifeLineXOffset;
	LifeLinePartX = LifeLinePartX + 30 * FrameTime();
	
	local healthperc = LocalPlayer():Health() / 100;
	
	if( LocalPlayer():Alive() ) then
	
		local yvelmul = 1;
		
		local hp = healthperc;
		hp = .2 - ( hp * .2 );
		
		yvelmul = yvelmul - hp;
		
		if( x > 35 + LifeLineXOffset and LifeLinePhase == 0 ) then
		
			LifeLinePartYVel = 40;
			LifeLinePhase = 1;
		
		elseif( x > 40 + LifeLineXOffset and LifeLinePhase == 1 ) then
		
			LifeLinePartYVel = -40;
			LifeLinePhase = 2;
		
		elseif( x > 50 + LifeLineXOffset and LifeLinePhase == 2 ) then
		
			LifeLinePartYVel = 40;
			LifeLinePhase = 3;
		
		elseif( x > 57 + LifeLineXOffset and LifeLinePhase == 3 ) then
		
			LifeLinePartYVel = -40;
			LifeLinePhase = 4;
		
		elseif( x > 63 + LifeLineXOffset and LifeLinePhase == 4 ) then
		
			LifeLinePartYVel = 40;
			LifeLinePhase = 5;
		
		end
		
		if( LifeLinePartOffset > 0 and LifeLinePhase == 5 ) then
		
			LifeLinePartOffset = 0;
			LifeLinePartYVel = 0;
			LifeLinePhase = 6;
		
		end
		
		LifeLinePartYVel = LifeLinePartYVel * yvelmul;
		
		LifeLinePartOffset = LifeLinePartOffset + LifeLinePartYVel * FrameTime();
		
	else
	
		LifeLinePartOffset = 0;
		LifeLinePhase = 0;
	
	end
	
	local y = ScrH() - 50 + LifeLinePartOffset;

	local p = { 
	
		x = x,
		y = y,
		color = Color( 255 - ( healthperc * 255 ), ( 255 * healthperc ), 0, 128 ), 
		
	}
	
	table.insert( lifelineparts, p );
	
	LifeLineLastX = x;
	LifeLineLastY = y;
		
end
]]--

HUDAlpha = 0;

function DrawSprintBar()

	draw.RoundedBox( 2, 23, ScrH() - 64, 85, 8, Color( 0, 0, 0, math.Clamp( HUDAlpha, 0, 230 ) ) );

	if( ClientVars["Sprint"] > 3 ) then
	
		local diff = ( ClientVars["Sprint"] / 100 );

		draw.RoundedBox( 2, 24, ScrH() - 63, 83 * diff, 6, Color( 216, 130, 0, math.Clamp( HUDAlpha, 0, 230 ) ) );
		draw.RoundedBox( 2, 24, ScrH() - 63, 83 * diff, 2, Color( 255, 180, 0, math.Clamp( HUDAlpha, 0, 150 ) ) );
		
	end
	
end

function DrawLifeLine()

	draw.RoundedBox( 2, 23, ScrH() - 76, 85, 8, Color( 0, 0, 0, math.Clamp( HUDAlpha, 0, 230 ) ) );

	--Consciousness meter
	if( ClientVars["Conscious"] > 3 ) then
	
		local diff = ( ClientVars["Conscious"] / 100 );
		
		draw.RoundedBox( 2, 24, ScrH() - 75, 83 * diff, 6, Color( 70, 70, 70, math.Clamp( HUDAlpha, 0, 230 ) ) );
		draw.RoundedBox( 2, 24, ScrH() - 75, 83 * diff, 2, Color( 120, 120, 120, math.Clamp( HUDAlpha, 0, 150 ) ) );

	end

	--[[

	for k, v in pairs( LifeLineParts ) do
	
		if( v.color.a - 50 > 0 ) then
			draw.RoundedBox( 2, v.x - 1, v.y - 1, 4, 4, Color( v.color.r, v.color.g, v.color.b, v.color.a - 50 ) );
		end
		
		draw.RoundedBox( 2, v.x, v.y, 2, 2, v.color );
	
		v.color.a = v.color.a - FrameTime() * 230;

		if( v.color.a < 1 ) then
		
			LifeLineParts[k] = nil;
		
		end
	
	end
	
	CreateNextPoint();

	]]--

	local healthperc = math.Clamp( LocalPlayer():Health(), 0, 100 ) / 100;

	for n = 1, LifeLineStep do
	
		x = LifeLineTable[n].x;
		y = LifeLineTable[n].y;
		
		y = y - ( LifeLineTable[n].ydiff * ( 1 - healthperc ) );

		draw.RoundedBox( 0, x - 2, y - 2, 4, 4, Color( LifeLineTable[n].r, LifeLineTable[n].g, LifeLineTable[n].b, math.Clamp( LifeLineTable[n].alpha * .1, 0, HUDAlpha ) ) );
		draw.RoundedBox( 0, x - 1, y - 1, 2, 2, Color( LifeLineTable[n].r, LifeLineTable[n].g, LifeLineTable[n].b, math.Clamp( LifeLineTable[n].alpha * .4, 0, HUDAlpha ) ) );
		draw.RoundedBox( 0, x, y, 1, 1, Color( LifeLineTable[n].r, LifeLineTable[n].g, LifeLineTable[n].b, math.Clamp( LifeLineTable[n].alpha, 0, HUDAlpha ) ) );
	
		LifeLineTable[n].alpha = math.Clamp( LifeLineTable[n].alpha - 600 * FrameTime(), 0, 255 );
		
	end 
	
	if( CurTime() > LifeLineNextUpdate ) then
	
		if( LifeLineStep >= #LifeLineTable ) then
		
			LifeLineStep = 1;	
			
			LifeLineTable[1].r = 255 - ( healthperc * 255 );
			LifeLineTable[1].g = ( 255 * healthperc );
			LifeLineTable[1].b = 0;
			LifeLineTable[1].alpha = 255;
		
		end
		
		for n = LifeLineStep + 1, LifeLineStep + 4 do
			
			if( n <= #LifeLineTable ) then
			
				LifeLineTable[n].r = 255 - ( healthperc * 255 );
				LifeLineTable[n].g = ( 255 * healthperc );
				LifeLineTable[n].b = 0;
				LifeLineTable[n].alpha = 255;
			
			end

		end
	
		LifeLineStep = LifeLineStep + 4;
		
		if( LifeLineStep > #LifeLineTable ) then
		
			LifeLineStep = #LifeLineTable;
			local delay = 1 - ( .03 * ( LocalPlayer():Health() / 100 ) );
			LifeLineNextUpdate = ( CurTime() + .03 + delay ) - ( .07 * HeartBeat.RateMul );
		
		else
	
			LifeLineNextUpdate = LifeLineNextUpdate + .001;
	
		end
	
	end

end

--[[
--======================================--
-- END LIFELINE HUD CODE                    --
--======================================--
]]--





TargetDisplays = { }
TargetEnts = { }

TargetDisplayHitPos = Vector( 0, 0, 0 );

--Target display code.  Handles all the text you see when you look at something.
function DrawDisplay()

	local trace = { }
	trace.start = LocalPlayer():EyePos();
	trace.endpos = trace.start + LocalPlayer():GetAimVector() * 200;
	trace.filter = LocalPlayer();
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity:IsValid() and not TargetEnts[tr.Entity:EntIndex()] ) then
	
		local dist = ( LocalPlayer():EyePos() - tr.HitPos ):Length();
	
		local class = string.lower( tr.Entity:GetClass() );
		
		if( tr.Entity:IsPlayer() ) then
		
			if( tr.Entity:GetTable().Title and not tr.Entity:GetTable().ChangedTitleInfo ) then
				
				table.insert( TargetDisplays, { 
					Entity = tr.Entity,
					EntIndex = tr.Entity:EntIndex(),
					Text = string.gsub( tr.Entity:GetTable().Title, " ", "  " ),
					Font = "PlayerDisp",
					Color = Color( 255, 255, 255, 255 ),
					OutlineColor = Color( 0, 0, 0, 0 ),
					OutlineWidth = 1,
					Alpha = 0,
					MaxAlpha = 255,
					xOffset = 0,
					yOffset = 0,
					zOffset = 11,
					FadeInSpeed = 800,
					FadeOutSpeed = 600,
					FadeOutDelay = .1,
					LastLookedAt = CurTime(),
					EyePos = true,
				} );
				
			
				TargetEnts[tr.Entity:EntIndex()] = { }
			
			else
			
				RunConsoleCommand( "eng_recply", tr.Entity:EntIndex() );
				tr.Entity:GetTable().ChangedTitleInfo = false;
			
			end
		
		elseif( dist <= 70 and tr.Entity:GetTable().ItemName ) then
		
			table.insert( TargetDisplays, { 
				Entity = tr.Entity,
				EntIndex = tr.Entity:EntIndex(),
				Text = string.gsub( tr.Entity:GetTable().ItemName, " ", "  " ),
				Font = "VGUITitle",
				Color = Color( 255, 255, 255, 255 ),
				OutlineColor = Color( 0, 0, 0, 0 ),
				OutlineWidth = 1,
				Alpha = 0,
				MaxAlpha = 255,
				xOffset = 0,
				yOffset = -20,
				FadeInSpeed = 500,
				FadeOutSpeed = 300,
				FadeOutDelay = .5,
				LastLookedAt = CurTime(),
				EyePos = false,
			} );
			
			TargetEnts[tr.Entity:EntIndex()] = { }
		
		elseif( dist <= 150 and class == "prop_physics" ) then
		
			if( not tr.Entity:GetTable().PropDesc or tr.Entity:GetTable().UpdatePropDesc ) then
			
				RunConsoleCommand( "eng_recpd", tr.Entity:EntIndex() );
				tr.Entity:GetTable().UpdatePropDesc = false;
				
			elseif( tr.Entity:GetTable().PropDesc ) then
	
				table.insert( TargetDisplays, { 
					Entity = tr.Entity,
					EntIndex = tr.Entity:EntIndex(),
					Text = string.gsub( tr.Entity:GetTable().PropDesc, " ", "  " ),
					Font = "VGUITitle",
					Color = Color( 255, 255, 255, 255 ),
					OutlineColor = Color( 0, 0, 0, 0 ),
					OutlineWidth = 1,
					Alpha = 0,
					MaxAlpha = 255,
					xOffset = 0,
					yOffset = -20,
					FadeInSpeed = 500,
					FadeOutSpeed = 300,
					FadeOutDelay = .5,
					LastLookedAt = CurTime(),
					EyePos = false,
					HitPos = false,
					FadeOutFunc = function() tr.Entity:GetTable().UpdatePropDesc = true; end, 
				} );
				
				TargetEnts[tr.Entity:EntIndex()] = { }		
				
			end	
		
		end
	
	end
	
	for k, v in pairs( TargetDisplays ) do
	
		if( v.Entity and v.Entity:IsValid() ) then
		
			if( v.Entity:GetTable().ChangedTitleInfo ) then
		
				RunConsoleCommand( "eng_recply", v.Entity:EntIndex() );
				v.Entity:GetTable().ChangedTitleInfo = false;
			
			end
		
			local pos;
			
			if( v.EyePos ) then
			
				pos = v.Entity:EyePos();
			
			elseif( v.HitPos ) then
			
				local tr = LocalPlayer():GetEyeTrace();
				
				if( tr.Entity == v.Entity ) then
				
					TargetDisplayHitPos = tr.HitPos;
				
				end
			
				pos = TargetDisplayHitPos;
			
			else
			
				pos = v.Entity:GetPos();
			
			end
			
			if( v.zOffset ) then
			
				pos.z = pos.z + v.zOffset;
			
			end

			local text = v.Text;
			
			if( v.Entity:IsPlayer() ) then
			
				if( v.Entity:GetNWBool( "Typing" ) ) then
				
					text = text .. "\n- Typing -";
				
				end
				
				if( v.Entity:IsSpeaking() ) then
				
					text = text .. "\n- Voice -";
				
				end
			
			end
			
			surface.SetFont( v.Font );
			local _, h = surface.GetTextSize( text );
			
			local scrpos = pos:ToScreen();
			local color = v.Color;
			local outlinecolor = v.OutlineColor;
			
			color.a = v.Alpha;
			outlinecolor.a = v.Alpha;
	
			draw.DrawTextOutlined( text, v.Font, scrpos.x + v.xOffset, scrpos.y + v.yOffset - h, v.Color, 1, nil, v.OutlineWidth, outlinecolor );
	
			if( tr.Entity:EntIndex() == v.Entity:EntIndex() ) then
	
				v.LastLookedAt = CurTime();
				v.Alpha = v.Alpha + v.FadeInSpeed * FrameTime();
				
				if( v.Alpha > v.MaxAlpha ) then
					
					v.Alpha = v.MaxAlpha;
						
				end
			
			elseif( CurTime() - v.LastLookedAt > v.FadeOutDelay ) then
	
				v.Alpha = v.Alpha - v.FadeOutSpeed * FrameTime();
				
				if( v.Alpha < 0 ) then
					
					if( TargetDisplays[k].FadeOutFunc ) then
						TargetDisplays[k].FadeOutFunc();
					end
					
					v.Alpha = 0;
					TargetEnts[TargetDisplays[k].EntIndex] = nil;
					TargetDisplays[k] = nil;
						
				end			
			
			end
			
		else
		
			TargetEnts[TargetDisplays[k].EntIndex] = nil;
			TargetDisplays[k] = nil;			
		
		end
		
	end
	
	if( input.IsKeyDown( KEY_F4 ) ) then
	
		local tr = LocalPlayer():GetEyeTrace();
		
		if( tr.Entity and tr.Entity:IsValid() and tr.Entity:GetClass() == "prop_physics" ) then
		
			if( tr.Entity:GetTable().CreatorName ) then
			
				local pos = tr.HitPos:ToScreen();
			
				draw.DrawText( "Created by " .. tr.Entity:GetTable().CreatorName, "ChatFont", pos.x, pos.y, Color( 255, 0, 0, 255 ) );
			
			else
			
				RunConsoleCommand( "eng_recpo", tr.Entity:EntIndex() );
			
			end
		
		end
	
	end

end

function DrawActiveWeapInfo()

	local weap = LocalPlayer():GetActiveWeapon();
	
	if( weap and weap:IsValid() and weap:GetTable() and weap:GetTable().Primary ) then

		local ammostr = weap:GetTable().Primary.AmmoString;

		if( weap:GetTable().Primary.CurrentClip and ammostr ) then
			
			if( weap:GetTable().Primary.CurrentAmmo == 1 ) then
			
				ammostr = string.sub( weap:GetTable().Primary.AmmoString, 1, string.len( weap:GetTable().Primary.AmmoString ) - 1 );
			
			end
	
			draw.DrawText( weap:GetTable().Primary.CurrentClip .. "   " .. ammostr, "NoticeText", ScrW() - 10, ScrH() - 60, Color( 255, 255, 255, 255 ), 2 );
		
		end
		
		if( weap:GetTable().HealthAmt and weap:GetTable().Degrades ) then
		
			local perc = weap:GetTable().HealthAmt / 100;
		
			draw.RoundedBox( 0, ScrW() - 96, ScrH() - 70, 84, 9, Color( 0, 0, 0, 255 ) );
	
			if( weap:GetTable().HealthAmt > 3 ) then
				
				draw.RoundedBox( 0, ScrW() - 95, ScrH() - 69, 82 * perc, 7, Color( 0, 200, 0, 255 ) );
				draw.RoundedBox( 0, ScrW() - 95, ScrH() - 69, 82 * perc, 4, Color( 255, 255, 255, 50 ) );
			
			end
		
		end
		
		if( weap:GetTable().Jammed ) then
		
			draw.DrawText( "Weapon   jammed!", "NoticeText", ScrW() - 10, ScrH() - 90, Color( 255, 70, 70, 255 ), 2 );
		
		end
		
		if( weap:GetTable().Charging ) then
		
			local perc = weap:GetMeleePowerPerc();
			local h = 116 * perc;
			
			draw.RoundedBox( 0, ScrW() - 45, ScrH() - 198, 17, 124, Color( 255, 255, 255, 255 ) );
			draw.RoundedBox( 0, ScrW() - 43, ScrH() - 196, 13, 120, Color( 0, 0, 0, 255 ) );
			draw.RoundedBox( 0, ScrW() - 41, ScrH() - 78 - h, 9, h, Color( 255, 255 - perc * 255, 255 - perc * 255, 255 ) );
			
		end

	end
	
end

function DrawWeaponNotice()

	if( WeaponNotice.Alpha > 0 ) then
	
		local w = 0;
		local h = 22;
	
		surface.SetFont( "OpeningEpidemicLinks" );
		w = surface.GetTextSize( WeaponNotice.Str ) + 14;
	
		draw.RoundedBox( 0, ScrW() - w - 40, ScrH() - 200, w, h, Color( 255, 255, 255, WeaponNotice.Alpha ) );
		draw.RoundedBox( 0, ScrW() - w - 38, ScrH() - 198, w - 4, h - 4, Color( 0, 0, 0, WeaponNotice.Alpha ) );
		draw.DrawText( WeaponNotice.Str, "OpeningEpidemicLinks", ScrW() - w * .5 - 40, ScrH() - 199, Color( 255, 255, 255, WeaponNotice.Alpha ), 1 );
	
		if( CurTime() > WeaponNotice.FadeTime ) then
		
			WeaponNotice.Alpha = math.Clamp( WeaponNotice.Alpha - 600 * FrameTime(), 0, 255 );
		
		end
		
	end

end

ColorModColor = 0.5;

function GM:RenderScreenspaceEffects()
	
	if( BlackScreenOn or OpeningScreen.HUDOverride ) then
		
		tab = { }
			
		tab[ "$pp_colour_addr" ] 		= 0;
	 	tab[ "$pp_colour_addg" ] 		= 0;
	 	tab[ "$pp_colour_addb" ] 		= 0;
	 	tab[ "$pp_colour_brightness" ] 	= -.15;
	 	tab[ "$pp_colour_contrast" ] 	= 9.53;
	 	tab[ "$pp_colour_colour" ] 		= .02;
	 	tab[ "$pp_colour_mulr" ] 		= 0;
	 	tab[ "$pp_colour_mulg" ] 		= 0; 
	 	tab[ "$pp_colour_mulb" ] 		= 0;
	 	 
	 	DrawColorModify( tab );
		
	end
	
	if( CharacterCreate.HUDOverride ) then	
		
		if( not CharacterCreate.FadingEnd ) then
			
			tab = { }
				
			tab[ "$pp_colour_addr" ] 		= 0;
		 	tab[ "$pp_colour_addg" ] 		= 0;
		 	tab[ "$pp_colour_addb" ] 		= 0;
		 	tab[ "$pp_colour_brightness" ] 	= -.15;
		 	tab[ "$pp_colour_contrast" ] 	= 9.53;
		 	tab[ "$pp_colour_colour" ] 		= .02;
		 	tab[ "$pp_colour_mulr" ] 		= 0;
		 	tab[ "$pp_colour_mulg" ] 		= 0; 
		 	tab[ "$pp_colour_mulb" ] 		= 0;
		
		 	DrawColorModify( tab ); 
			
		end
		
	end
	
	if( CharacterCreate.FinishEffect ) then
		
		if( CurTime() - CharacterCreate.FinishStart > 4 ) then
			
			local tab = { }
		
			tab[ "$pp_colour_addr" ] 		= 0;
		 	tab[ "$pp_colour_addg" ] 		= 0;
		 	tab[ "$pp_colour_addb" ] 		= 0;
		 	tab[ "$pp_colour_brightness" ] 	= CharacterCreate.FinishBrightness;
		 	tab[ "$pp_colour_contrast" ] 	= CharacterCreate.FinishContrast;
		 	tab[ "$pp_colour_colour" ] 		= CharacterCreate.FinishColorMod;
		 	tab[ "$pp_colour_mulr" ] 		= 0;
		 	tab[ "$pp_colour_mulg" ] 		= 0; 
		 	tab[ "$pp_colour_mulb" ] 		= 0;
	
		 	DrawColorModify( tab ); 
		 	
			if( ClientVars["Class"] == "Infected" ) then
		 	
			  	local tab = {} 
			 	 
			 	tab[ "$pp_colour_addr" ] 		= 0.1;
			 	tab[ "$pp_colour_addg" ] 		= 0.05;
			 	tab[ "$pp_colour_addb" ] 		= 0;
			 	tab[ "$pp_colour_brightness" ] 	= 0;
			 	tab[ "$pp_colour_contrast" ] 	= 1;
			 	tab[ "$pp_colour_colour" ] 		= 1;
			 	tab[ "$pp_colour_mulr" ] 		= 0;
			 	tab[ "$pp_colour_mulg" ] 		= 0; 
			 	tab[ "$pp_colour_mulb" ] 		= 0; 
			 	 
			 	DrawColorModify( tab ); 		
		 	
		 	end
			
		end
		
	else
		
		local tab = {}
		
		tab[ "$pp_colour_addr" ] 		= 0;
		tab[ "$pp_colour_addg" ] 		= 0;
		tab[ "$pp_colour_addb" ] 		= 0;
		tab[ "$pp_colour_brightness" ] 	= -.03;
		tab[ "$pp_colour_contrast" ] 	= 1.3;
		tab[ "$pp_colour_colour" ] 		= ColorModColor;
		tab[ "$pp_colour_mulr" ] 		= 0;
		tab[ "$pp_colour_mulg" ] 		= 0; 
		tab[ "$pp_colour_mulb" ] 		= 0;
		
		DrawColorModify( tab ); 
		
		if( ClientVars["Class"] == "Infected" ) then
		
			local tab = {} 
			 
			tab[ "$pp_colour_addr" ] 		= 0.1;
			tab[ "$pp_colour_addg" ] 		= 0.05;
			tab[ "$pp_colour_addb" ] 		= 0;
			tab[ "$pp_colour_brightness" ] 	= 0;
			tab[ "$pp_colour_contrast" ] 	= 1;
			tab[ "$pp_colour_colour" ] 		= 1;
			tab[ "$pp_colour_mulr" ] 		= 0;
			tab[ "$pp_colour_mulg" ] 		= 0; 
			tab[ "$pp_colour_mulb" ] 		= 0; 
			
			DrawColorModify( tab );
		
		end
		
	end
	
	local conscious = ClientVars["Conscious"];

	if( ConsciousBlur.Levels[conscious] ) then

		DrawMotionBlur( ConsciousBlur.Levels[conscious].AddTransp, ConsciousBlur.Levels[conscious].DrawTransp, ConsciousBlur.Levels[conscious].FrameDelay );

	end
	
	if( DoMotionBlurHit ) then

		DrawMotionBlur( .2, .99, 0 );
	
		if( CurTime() > MotionBlurHitEnd ) then
		
			DoMotionBlurHit = false;
		
		end
	
	end

end

function DrawCinematicBars()


	draw.RoundedBox( 0, 0, 0, ScrW(), 25, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 0, 0, ScrH() - 25, ScrW(), 25, Color( 0, 0, 0, 255 ) );

	
end

ViewMost = false;
PViewMost = false;

function DrawViewMost()

	if( ViewMost ) then
	
		for k, v in pairs( player.GetAll() ) do
		
			local pos = v:EyePos() + Vector( 0, 0, 10 );
			pos = pos:ToScreen();
			
			draw.DrawText( v:Nick() .. " AKA " .. v:GetNWString( "RPName" ) .. "\nHP: " .. v:Health(), "ChatFont", pos.x, pos.y, Color( 255, 0, 0, 255 ), 1 );
		
		end
		
		local z = ents.FindByClass( "ep_commonzombie" );
		
		for k, v in pairs( z ) do
			
			local pos = v:EyePos() + Vector( 0, 0, 10 );
			pos = pos:ToScreen();
			
			draw.DrawText( "z", "ChatFont", pos.x, pos.y, Color( 0, 255, 0, 255 ), 1 );
			
		end
		
		local item = ents.FindByClass( "epd_item" );
		
		for _, v in pairs( item ) do
			
			v = v:GetPos():ToScreen();
			draw.DrawText( "x", "ChatFont", v.x, v.y, Color( 0, 0, 255, 255 ), 1 );
			
		end
		
		for _, v in pairs( ItemSpawnPoints ) do
			
			v = v:ToScreen();
			draw.DrawText( "x", "ChatFont", v.x, v.y, Color( 0, 255, 255, 255 ), 1 );
			
		end
	
	end

end

function event.TSA()

	ViewMost = !ViewMost;

end

LastRecordedBlood = 0;
BloodAlpha = 0;
BloodFadeTime = 0;
LosingBlood = false;

local function DrawBlood()

	if( ClientVars["Blood"] > 0 and BloodAlpha > 0 ) then

		draw.RoundedBox( 0, 20, 30, 130, 15, Color( 255, 255, 255, math.Clamp( BloodAlpha * .6, 0, 150 ) ) );
		
		if( ClientVars["Blood"] > 3 ) then
		
			draw.RoundedBox( 0, 21, 31, 128 * ( ClientVars["Blood"] / 100 ), 13, Color( 130, 40, 40, math.Clamp( BloodAlpha, 0, 255 ) ) );
			draw.RoundedBox( 0, 21, 31, 128 * ( ClientVars["Blood"] / 100 ), 5, Color( 255, 255, 255, math.Clamp( BloodAlpha * .25, 0, 40 ) ) );
		
		end
		
		if( LosingBlood ) then
		
			draw.DrawText( "Losing blood", "LimbDisp", 156, 30, Color( 255, 255, 255, BloodAlpha ) );
			
		end
		
	end

	if( LastRecordedBlood ~= ClientVars["Blood"] ) then

		if( ClientVars["Blood"] < 100 and ClientVars["Blood"] > 0 ) then
		
			BloodAlpha = 255;
			BloodFadeTime = CurTime() + 2;
		
		end
		
		if( ClientVars["Blood"] < LastRecordedBlood ) then
		
			LosingBlood = true;
			
		else
		
			LosingBlood = false;
		
		end
		
		LastRecordedBlood = ClientVars["Blood"];
		
	end
	
	if( CurTime() > BloodFadeTime ) then
	
		BloodAlpha = math.Clamp( BloodAlpha - 100 * FrameTime(), 0, 255 );
	
	end
	

end

LastRecordedArmor = 0;
ArmorAlpha = 0;
ArmorFadeTime = 0;

local function DrawArmor()

	if( ClientVars["Armor"] > 0 and ArmorAlpha > 0 ) then

		draw.RoundedBox( 0, 20, 50, 130, 15, Color( 255, 255, 255, math.Clamp( ArmorAlpha * .6, 0, 150 ) ) );
		
		if( ClientVars["Armor"] > 3 ) then
		
			draw.RoundedBox( 0, 21, 51, 128 * ( ClientVars["Armor"] / 100 ), 13, Color( 0, 0, 128, math.Clamp( ArmorAlpha, 0, 255 ) ) );
			draw.RoundedBox( 0, 21, 51, 128 * ( ClientVars["Armor"] / 100 ), 5, Color( 255, 255, 255, math.Clamp( ArmorAlpha * .25, 0, 40 ) ) );
		
		end
		
	end

	if( LastRecordedArmor ~= ClientVars["Armor"] ) then

		if( ClientVars["Armor"] < 100 and ClientVars["Armor"] > 0 ) then
		
			ArmorAlpha = 255;
			ArmorFadeTime = CurTime() + 2;
		
		end
		
		LastRecordedArmor = ClientVars["Armor"];
	
	end
	
	if( CurTime() > ArmorFadeTime ) then
	
		ArmorAlpha = math.Clamp( ArmorAlpha - 100 * FrameTime(), 0, 255 );
	
	end
	

end

local Limbs =
{

	{ Name = "R. Arm",  Var = "RArmHP" },
	{ Name = "L. Arm",  Var = "LArmHP" },
	{ Name = "R. Leg",  Var = "RLegHP" },
	{ Name = "L. Leg",  Var = "LLegHP" },

}

for k, v in pairs( Limbs ) do

	v.LastRecordedHP = 0;
	v.x = 20;
	v.y = 60 + k * 14;
	v.Alpha = 0;
	v.FadeTime = 0;

end

local function DrawLimbHealth()

	for k, v in pairs( Limbs ) do

		if( ClientVars[v.Var] > 0 and v.Alpha > 0 ) then
	
			draw.RoundedBox( 0, v.x, v.y, 130, 9, Color( 255, 255, 255, math.Clamp( v.Alpha * .6, 0, 150 ) ) );
			
			if( ClientVars[v.Var] > 3 ) then
			
				draw.RoundedBox( 0, v.x + 1, v.y + 1, 128 * ( ClientVars[v.Var] / 100 ), 7, Color( 150, 0, 0, math.Clamp( v.Alpha, 0, 255 ) ) );
				draw.RoundedBox( 0, v.x + 1, v.y + 1, 128 * ( ClientVars[v.Var] / 100 ), 3, Color( 255, 255, 255, math.Clamp( v.Alpha * .25, 0, 40 ) ) );
			
			end
			
			draw.DrawText( v.Name, "LimbDisp", v.x + 135, v.y - 2, Color( 255, 255, 255, v.Alpha ) );
			
		end
	
		if( v.LastRecordedHP ~= ClientVars[v.Var] ) then
	
			if( ClientVars[v.Var] < 100 and ClientVars[v.Var] > 0 ) then
			
				v.Alpha = 255;
				v.FadeTime = CurTime() + 2;
			
			end
			
			v.LastRecordedHP = ClientVars[v.Var];
		
		end
		
		if( CurTime() > v.FadeTime ) then
		
			v.Alpha = math.Clamp( v.Alpha - 100 * FrameTime(), 0, 255 );
		
		end
	
	end

end

function DrawChatOOCWarning()

	if( OOCDELAY > 0 and ChatBox and ChatBox:IsVisible() ) then
	
		local timepassed = CurTime() - ClientVars["LastOOC"];
		local timeleft = OOCDELAY - timepassed;
		
		if( timeleft > 0 ) then

			draw.DrawText( "Cannot  speak  in  OOC  for  another  " .. math.ceil( timeleft ) .. "  seconds", "OpeningEpidemicLinks", 5, ScrH() - 440, Color( 255, 255, 255, 255 ) );
			
		end
		
	end

end


DrawMainHUD = true;
FadeOutHUD = false;
DeathMessage = "";
DeathRIPAlpha = 0;
IncapTextAlpha = 0;
IncapBGAlpha = 180;
IncapBGFadeInTime = 0;

function GM:HUDPaint()

	DrawViewMost();
	
	DrawCinematicBars();
	
	--When the player first joins, there's a black screen.  Or whenever there's the opening screen.
	if( BlackScreenOn or OpeningScreen.HUDOverride ) then
		
		if( FirstBlackScreen and FirstBlackScreenAlpha > 130 ) then
		
			FirstBlackScreenAlpha = math.Clamp( FirstBlackScreenAlpha - 50 * FrameTime(), 130, 255 );
		
		end
		
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, FirstBlackScreenAlpha ) );
		
		if( OpeningScreen.HUDOverride ) then
		
			OpeningScreen.DrawHUD();
		
		end
		
		if( OpeningScreen.HUDPrevent ) then
		
			return;
			
		end
	
	end
	
	if( CharacterCreate.HUDOverride ) then	
		
		if( not CharacterCreate.FadingEnd ) then
		
			draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, FirstBlackScreenAlpha ) );
		 	
		 end
	
		CharacterCreate.DrawHUD();
		
		return;
	
	end
	
	if( FadeOutHUD ) then
		
		if( HUDAlpha > 0 ) then
		
			HUDAlpha = math.Clamp( HUDAlpha - 50 * FrameTime(), 0, 255 );
		
		end
		
	end
	
	if( DrawMainHUD ) then
	
		if( not LocalPlayer():Alive() ) then
		
			DeathRIPAlpha = math.Clamp( DeathRIPAlpha + 100 * FrameTime(), 0, 255 );
		
			draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 255 ) );
			draw.DrawText( "Rest   In   Peace.", "OpeningEpidemic", ScrW() * .4, ScrH() * .4, Color( 255, 255, 255, DeathRIPAlpha ), 1 );
			
			draw.DrawText( DeathMessage, "ActionMenuOption", ScrW() * .5, ScrH() * .4 + 70, Color( 255, 255, 255, DeathRIPAlpha ), 1 );
	
			local perc = 1 - ( math.Clamp( DeathTimerEnd - CurTime(), 0, DEATH_TIMER_PAUSE ) / DEATH_TIMER_PAUSE );
	
			draw.RoundedBox( 0, ScrW() * .5 - 75, ScrH() * .4 + 150, 150, 20, Color( 255, 255, 255, 255 ) );
			draw.RoundedBox( 0, ScrW() * .5 - 73, ScrH() * .4 + 152, 146, 16, Color( 0, 0, 0, 255 ) );
	
			if( perc > 0 ) then
			
				draw.RoundedBox( 0, ScrW() * .5 - 71, ScrH() * .4 + 154, 142 * perc, 12, Color( 255, 255, 255, 255 ) );
	
			end
			
			if( perc >= 1 ) then
			
				draw.DrawText( "You   can   spawn", "ActionMenuOption", ScrW() * .5, ScrH() * .4 + 152, Color( 0, 0, 0, 255 ), 1 );
			
			end
	
			return;
		
		elseif( DeathRIPAlpha > 0 ) then
		
			DeathRIPAlpha = 0;
		
		end
	
		if( ClientVars["Ragdolled"] ) then
		
			if( IncapBGFadeInTime == 0 ) then
			
				IncapBGFadeInTime = CurTime() + 1.4;
			
			end
			
			if( CurTime() > IncapBGFadeInTime ) then
		
				IncapBGAlpha = math.Clamp( IncapBGAlpha + 200 * FrameTime(), 0, 255 );
					
			end
		
			IncapTextAlpha = math.Clamp( IncapTextAlpha + 100 * FrameTime(), 0, 255 );
		
			draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, IncapBGAlpha ) );
			draw.DrawText( "Unconscious.", "OpeningEpidemic", ScrW() * .4, ScrH() * .4, Color( 255, 255, 255, IncapTextAlpha ), 1 );
			
			draw.DrawText( "Type   /getup   to   get   back   up.", "ActionMenuOption", ScrW() * .5, ScrH() * .4 + 70, Color( 255, 255, 255, IncapTextAlpha ), 1 );
	
			return;
		
		elseif( IncapTextAlpha > 0 ) then
		
			IncapTextAlpha = 0;
			IncapBGFadeInTime = 0;
			IncapBGAlpha = 180;
			
		end
	
		if( HUDAlpha < 255 and !FadeOutHUD ) then
		
			HUDAlpha = math.Clamp( HUDAlpha + 50 * FrameTime(), 0, 255 );
		
		end
		
		if( not PlayerMenuPanel:IsVisible() ) then
		
			if( ClientVars["Class"] == "Infected" ) then
				
				DrawLifeLine();	
				DrawNotices();
				DrawChatOOCWarning();				
			
			else
				
				DrawSprintBar();
				DrawLifeLine();	
				DrawActiveWeapInfo();
				DrawNotices();
				DrawArmor();
				DrawBlood();
				DrawLimbHealth();
				DrawWeaponNotice();
				DrawChatOOCWarning();
				
			end
		
		end
		
		DrawDisplay();
		
		DrawActionMenu();
		
		if( PlayerMenuPanel:IsVisible() ) then
		
			draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 200 ) );
			
			DrawSprintBar();
			DrawLifeLine();	
			DrawNotices();
			DrawChatOOCWarning();

		end
		
	end
		
end

DeveloperString = "DEVELOPED   BY   RICK   DARK";
DeveloperText = { }
Developerxpos = 25;
DeveloperProcess = 1;
NextDevCharTime = 0;

local function NextDeveloperChar()

	local char = string.sub( DeveloperString, DeveloperProcess, DeveloperProcess );
	
	if( char == ' ' ) then
	
		 char = string.sub( DeveloperString, DeveloperProcess, DeveloperProcess + 1 );
		 DeveloperProcess = DeveloperProcess + 1;
		 
	end

	if( math.random( 1, 5 ) <= 2 ) then
	
		char = string.lower( char );
	
	end

	table.insert( DeveloperText, {
	
		Char = char,
		x = Developerxpos,
		y = ScrH() - 145 + math.random( -2, 2 ),
	
	} );
	
	surface.SetFont( "CharCreateEntry" );
	Developerxpos = Developerxpos + surface.GetTextSize( char );

	DeveloperProcess = DeveloperProcess + 1;

end

function DrawDebugLines()
	
	local vel_ang = LocalPlayer():GetVelocity():Angle();
	local for_ang = LocalPlayer():GetForward():Angle();
	
	local y1 = for_ang.y;
	
	if( y1 > 180 ) then
		
		y1 = y1 - 360;
		
	end
	
	if( y1 < -180 ) then
		
		y1 = y1 + 360;
		
	end
	
	local y2 = vel_ang.y;
	
	if( y2 > 180 ) then
		
		y2 = y2 - 360;
		
	end
	
	if( y2 < -180 ) then
		
		y2 = y2 + 360;
		
	end
	
	local ydiff = y1 - y2;
	
	if( ydiff < -180 ) then
		
		ydiff = ydiff + 360
		
	end
	
	if( ydiff > 180 ) then
		
		ydiff = ydiff - 360
		
	end
	
	ydiff = ydiff - 180
	ydiff = ydiff / -180
	
	if( ydiff > 1 ) then ydiff = ydiff - 1 end
	if( ydiff < -1 ) then ydiff = ydiff + 1 end
	
	ydiff = ydiff - 0.5;
	ydiff = ydiff * 2;
	
	if( ydiff < 0.01 ) then ydiff = 0 end
	
	local text = tostring( y1 ) .. "   |   " .. tostring( y2 );
	
	draw.DrawText( text, "ActionMenuOption", ScrW() * .5, ScrH() * .4 + 70, Color( 255, 255, 255, 255 ), 1 );
	draw.DrawText( tostring( ydiff ), "ActionMenuOption", ScrW() * .5, ScrH() * .4 + 90, Color( 255, 255, 255, 255 ), 1 );
	
end
--hook.Add( "HUDPaint", "lol", DrawDebugLines );

function GM:PostRenderVGUI()
	
	DrawInventoryActionMenu();
	DrawProgressBars();
	
	if( CharacterCreate.FinishEffect ) then

		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 255, 255, 255, CharacterCreate.FinishAlpha ) );

		if( CharacterCreate.FinishAlpha >= 255 ) then
		
			IntroViewHook = false;
		
		end

		if( CurTime() - CharacterCreate.FinishStart > 4 ) then
	
			CharacterCreate.FadingEnd = true;
			CharacterCreate.FinishAlpha = 0;
			DrawMainHUD = false;
			IntroViewHook = false;
			
			OpeningScreen.Ambience:FadeOut( 4 );
			
			gui.EnableScreenClicker( false );
			
			if( not CharacterCreate.NoHUD ) then
	
				event.KillCharacterCreate();

			end
		
			--CharacterCreate.FinishAlpha = math.Clamp( CharacterCreate.FinishAlpha - 200 * FrameTime(), 0, 255 );
			
			CharacterCreate.DevNoteAlpha = math.Clamp( CharacterCreate.DevNoteAlpha - 100 * FrameTime(), 0, 255 );
		 	
			CharacterCreate.FinishBrightness = math.Clamp( CharacterCreate.FinishBrightness - 0.5 * FrameTime(), -0.03, math.huge );
			CharacterCreate.FinishContrast = math.Clamp( CharacterCreate.FinishContrast - 1.5 * FrameTime(), 1.3, math.huge );
		 	
		 	if( CurTime() - CharacterCreate.FinishStart > 6 ) then
				
				IntroViewHook = false;
				
				CharacterCreate.FinishColorMod = math.Clamp( CharacterCreate.FinishColorMod + .2 * FrameTime(), -math.huge, ColorModColor );
			
			end
			
			if( CurTime() - CharacterCreate.FinishStart > 8 ) then
	
				DrawMainHUD = true;
				CharacterCreate.FinishEffect = false;
				IntroViewHook = false;
				CharacterCreate.HUDOverride = false;
				HUDAlpha = 0;
			
			end
			
		else

			CharacterCreate.FinishAlpha = math.Clamp( CharacterCreate.FinishAlpha + 120 * FrameTime(), 0, 255 );
			CharacterCreate.DevNoteAlpha = CharacterCreate.FinishAlpha;
			
		end
		
		if( NextDevCharTime < CurTime() ) then
		
			NextDeveloperChar();
			NextDevCharTime = CurTime() + math.Rand( .1, .25 );
		
		end
		
		for k, v in pairs( DeveloperText ) do
			
			draw.DrawText( v.Char, "CharCreateEntry", v.x + math.random( -5, 5 ), v.y + math.random( -5, 5 ), Color( 150, 150, 150, CharacterCreate.DevNoteAlpha ) );
			draw.DrawText( v.Char, "CharCreateEntry", v.x, v.y, Color( 0, 0, 0, CharacterCreate.DevNoteAlpha ) );
			
		end
		
		DrawCinematicBars();	
		
	end
	
end


function event.SkipIntro()

	 DrawMainHUD = true;
	 BlackScreenOn = false;
	 FirstBlackScreen = false;

end

