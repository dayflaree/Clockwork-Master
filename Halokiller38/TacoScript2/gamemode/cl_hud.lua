surface.CreateFont( "coolvetica", 18, 500, true, false, "PlInfoFont" );
surface.CreateFont( "akbar", 20, 200, true, false, "LetterFont" );
surface.CreateFont( "TargetID", 48, 200, true, false, "GiantDanceTargetID" );

surface.CreateFont( "Verdana", 10, 400, true, false, "font_esp" );
surface.CreateFont( "Courier New", 8, 400, true, false, "font_esp_status" );

LastHealthUpdate = 0;
LastSprintUpdate = 0;
LastHealth = 0;
LastSprint = 0;
HealthAlpha = 255;
SprintAlpha = 255;
SprintWidth = ScrW() * .3 - 2;

ShowCharInfo = true;

local hudtype = CreateClientConVar( "rp_cl_ts1hud", "0", true, false );
local colortype = CreateClientConVar( "rp_cl_sadcolors", "0", true, false );

OverWatchLines = { }
LastOWLine = 0;
OWLineDelay = 0;
OWLastHealthWarn = 0;
OWLastHealth = -1;
OWLines = 
{

	"Parsing Nexus protocal message......",
	"Sensoring......",
	"Trasmitting REC_SELF_POS vector......",
	"Updating life signal......",
	"Modulating......",
	"Idle......",
	"Parsing view port......",
	"Translating message......",
	"Updating class callback......",

}

function DrawOverWatchDisplay()

	if( OWLastHealth <= 0 ) then
		OWLastHealth = LocalPlayer():Health();
	end

	local healthperc = 1;
	
	if( TS.HighestHealth ~= 0 ) then
		healthperc = LocalPlayer():Health() / TS.HighestHealth; 
	end
	
	draw.RoundedBox( 0, 10, 20, ScrW() * .4, 15, Color( 255, 255, 255, 50 ) );
	
	if( healthperc > 0 ) then
		draw.RoundedBox( 0, 12, 22, ( ScrW() * .4 - 4 ) * healthperc, 11, Color( 0, 255, 0, 100 ) );
	end
	
	if( OWSight ) then
	
		draw.DrawText( "Color Focalization ENABLED", "BudgetLabel", 10, 5, Color( 200, 200, 200, 255 ) );
	
	end
	
	draw.DrawText( "Power Consumption: " .. 100 - math.ceil( ClientVars["Sprint"] ) .. "%", "BudgetLabel", 10, 35, Color( 200, 200, 200, 255 ) );
	
	local offset = 15;
	
	if( LastSprint ~= ClientVars["Sprint"] ) then
	
		if( LastSprint > 0 and ClientVars["Sprint"] <= 0 ) then
		
			table.insert( OverWatchLines, { Line = "WARNING!! REACHED MAX POWER CONSUMPTION......",  TimeDone = CurTime() + 3 } );
		
		elseif( LastSprint > 35 and ClientVars["Sprint"] <= 35 ) then
		
			table.insert( OverWatchLines, { Line = "WARNING!! POWER CONSUMPTION HIGH......",  TimeDone = CurTime() + 3 } );
		
		end
	
		LastSprint = ClientVars["Sprint"];
		LastSprintUpdate = CurTime();
	
	end


	if( OWLastHealth > LocalPlayer():Health() and CurTime() - OWLastHealthWarn > .5 ) then
		
		table.insert( OverWatchLines, { Line = "WARNING!! DETECTING TRAUMA......",  TimeDone = CurTime() + 3 } );
		OWLastHealthWarn = CurTime();
		OWLastHealth = LocalPlayer():Health();
	
	end
	
	for k, v in pairs( OverWatchLines ) do
	
		draw.DrawText( v.Line, "BudgetLabel", 10, 35 + offset, Color( 200, 200, 200, 255 ) );
		offset = offset + 15;

		if( v.TimeDone < CurTime() ) then
			OverWatchLines[k] = nil;
		end
	
	end
	
	if( CurTime() - LastOWLine > OWLineDelay ) then
	
		local line = ""
		local m = math.random( 1, #OWLines );
		
		line = OWLines[m] or "";

		table.insert( OverWatchLines, { Line = line,  TimeDone = CurTime() + math.random( 2, 5 ) } );
		LastOWLine = CurTime();
		OWLineDelay = math.random( 1, 2 );
		
	end

end

LastBleedHUD = 0;
BleedHUDAlpha = 0;

LastCantSprintHUD = 0;
CantSprintHUDAlpha = 0;

local function DrawDisplay()

	if( not LocalPlayer():Alive() ) then return; end
	if( DontDrawDisplay ) then return; end

	if( LocalPlayer():IsOWElite() ) then
		DrawOverWatchDisplay();
		return;
	end
	
	local healthperc = 1;
	
	if( TS.HighestHealth ~= 0 ) then
		healthperc = LocalPlayer():Health() / TS.HighestHealth; 
	end
	
	local sprintperc = ClientVars["Sprint"] / 100;

	local yoffset = 0;

	if( hudtype:GetInt() == 1 ) then
	
		yoffset = -ScrH() + 20;
		HealthAlpha = 255;
		SprintAlpha = 255;
	
	end

	draw.RoundedBox( 2, 5, ScrH() - 15 + yoffset, ScrW() * .3, 8, Color( 0, 0, 0, HealthAlpha ) );
	
	if( LocalPlayer():Health() > 0 ) then
	
		if( ClientVars["Bleeding"] ) then

			if( CurTime() - LastBleedHUD > 2 ) then
			
				LastBleedHUD = CurTime();
				BleedHUDAlpha = 0;
				
			else
			
				if( CurTime() - LastBleedHUD < 1 ) then
				
					BleedHUDAlpha = math.Clamp( BleedHUDAlpha + 255 * FrameTime(), 0, 150 );
				
				else
				
					BleedHUDAlpha = math.Clamp( BleedHUDAlpha - 255 * FrameTime(), 0, 150 );
				
				end
				
			end

			draw.RoundedBox( 2, 6, ScrH() - 14 + yoffset, ( ScrW() * .3 - 2 ) * healthperc, 6, Color( 210, 80, 80, HealthAlpha ) );
			draw.RoundedBox( 2, 6, ScrH() - 14 + yoffset, ( ScrW() * .3 - 2 ) * healthperc, 3, Color( 255, 110, 110, HealthAlpha ) );
			draw.RoundedBox( 2, 6, ScrH() - 14 + yoffset, ( ScrW() * .3 - 2 ) * healthperc, 6, Color( 255, 255, 255, BleedHUDAlpha ) );
			
		else
	
			draw.RoundedBox( 2, 6, ScrH() - 14 + yoffset, ( ScrW() * .3 - 2 ) * healthperc, 6, Color( 34, 139, 34, HealthAlpha ) );
			draw.RoundedBox( 2, 6, ScrH() - 14 + yoffset, ( ScrW() * .3 - 2 ) * healthperc, 3, Color( 50, 205, 50, HealthAlpha ) );

		end
		
	end
	
	if( hudtype:GetInt() == 1 ) then
	
		yoffset = yoffset + 20;
		
	end

	draw.RoundedBox( 2, 5, ScrH() - 25 + yoffset, ScrW() * .3, 8, Color( 0, 0, 0, SprintAlpha ) );
	
	if( sprintperc > 0 ) then

		if( ClientVars["CanSprint"] ) then

			draw.RoundedBox( 2, 6, ScrH() - 24 + yoffset, SprintWidth, 6, Color( 39, 64, 139, SprintAlpha ) );
			draw.RoundedBox( 2, 6, ScrH() - 24 + yoffset, SprintWidth, 3, Color( 58, 95, 205, SprintAlpha ) );

		else

			if( CurTime() - LastCantSprintHUD > 2 ) then
			
				LastCantSprintHUD = CurTime();
				CantSprintHUDAlpha = 0;
				
			else
			
				if( CurTime() - LastCantSprintHUD < 1 ) then
				
					CantSprintHUDAlpha = math.Clamp( CantSprintHUDAlpha + 255 * FrameTime(), 0, 150 );
				
				else
				
					CantSprintHUDAlpha = math.Clamp( CantSprintHUDAlpha - 255 * FrameTime(), 0, 150 );
				
				end
		
			end
			
			draw.RoundedBox( 2, 6, ScrH() - 24 + yoffset, SprintWidth, 6, Color( 39, 64, 139, SprintAlpha ) );
			draw.RoundedBox( 2, 6, ScrH() - 24 + yoffset, SprintWidth, 3, Color( 58, 95, 205, SprintAlpha ) );
			draw.RoundedBox( 2, 6, ScrH() - 24 + yoffset, SprintWidth, 6, Color( 255, 255, 255, CantSprintHUDAlpha ) );
		
		end

	end
	
	local newsprintwidth = ( ScrW() * .3 - 2 ) * sprintperc;
	
	if( SprintWidth > newsprintwidth ) then
	
		SprintWidth = SprintWidth - ( ScrW() * .3 - 2 ) * FrameTime() * .4;
		
		if( SprintWidth < newsprintwidth ) then
			SprintWidth = newsprintwidth;
		end
	
	elseif( SprintWidth < newsprintwidth ) then
	
		SprintWidth = SprintWidth + ( ScrW() * .3 - 2 ) * FrameTime() * .4;
		
		if( SprintWidth > newsprintwidth ) then
			SprintWidth = newsprintwidth;
		end
	
	end
	
	if( LastHealth ~= LocalPlayer():Health() ) then
	
		LastHealth = LocalPlayer():Health();
		LastHealthUpdate = CurTime();
		HealthAlpha = 255;
	
	end
	
	if( LastSprint ~= ClientVars["Sprint"] ) then
	
		LastSprint = ClientVars["Sprint"];
		LastSprintUpdate = CurTime();
		SprintAlpha = 255;
	
	end

	if( CurTime() - LastHealthUpdate > 3 ) then
		
		HealthAlpha = math.Clamp( HealthAlpha - 180 * FrameTime(), 0, 255 );
	
	end
	
	if( CurTime() - LastSprintUpdate > 3 ) then
	
		SprintAlpha = math.Clamp( SprintAlpha - 180 * FrameTime(), 0, 255 );
	
	end
	

	if( hudtype:GetInt() == 1 and ShowCharInfo ) then
	
		local rely = 50;
	
		local cidtext = "";
	
		local tokentext = "";
	
		if not LocalPlayer():IsCP() and not LocalPlayer():IsOW() and not LocalPlayer():IsCA() and not LocalPlayer():IsVort() then
			cidtext = "CID: " .. CID .. "\n";
			tokentext = Tokens .. " token";
			if Tokens ~= 1 then
				tokentext = tokentext .. "s"
			end
			tokentext = tokentext .. "\n"
			rely = 72;
		end
		
		local CharInfo = tokentext ..  cidtext ..  ClientVars["Title"] .. "\n" .. ClientVars["Title2"];
		
		surface.SetFont("NewChatFont");
		local x, y = surface.GetTextSize( CharInfo );
		
		if x < 160 then
			width = 160;
		else
			width = x;
		end
		
		draw.RoundedBox( 4, 15, ScrH() - rely - 5, width + 20, y + 10, Color( 0, 0, 0, 80 ) );
		
		draw.DrawText( CharInfo, "NewChatFont", 25, ScrH() - rely, Color( 255, 255, 255, 255 ) );
		
	end

end

IntroFade = 255;
IntroBlackFade = 255;
FlashWhiteFade = 255;

surface.CreateFont( "TargetID", 48, 800, true, false, "GiantTargetID" );
surface.CreateFont( "TargetID", 26, 800, true, false, "BigTargetID" );

function DrawFancyGayIntro()

	draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, IntroBlackFade ) );
	
	draw.DrawTextGlowing( "Half-Life 2 Roleplay", "GiantTargetID", ScrW() / 2, ScrH() * .1, Color( 255, 255, 255, 255 - IntroFade ), 1, nil, 6, Color( 255, 255, 255, 255 - IntroFade ) );
	draw.DrawText( "Half-Life 2 Roleplay", "GiantTargetID", ScrW() / 2, ScrH() * .1, Color( 0, 0, 0, 255 - IntroFade ), 1 );
	
	if( CurTime() - TS.StartTime > 1 ) then
		IntroFade = math.Clamp( IntroFade - 80 * FrameTime(), 0, 255 );
	end
	
	if( CurTime() - TS.StartTime > 2.5 ) then
		IntroBlackFade = math.Clamp( IntroBlackFade - 80 * FrameTime(), 0, 255 );
	end
	
end

function DrawFlashEffect()
	draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color(255, 255, 255, FlashWhiteFade));
	
	if (CurTime() - TS.FlashStartTime > 1) then
			FlashWhiteFade = math.Clamp(FlashWhiteFade - 80 * FrameTime(), 0, 255 );
		end
	
	if (CurTime() - TS.FlashStartTime > 2.5) then
		FlashWhiteFade = math.Clamp(FlashWhiteFade - 80 * FrameTime(), 0, 255 );
	end
end

TargetInfo = { }

LastTargetIDUpdate = 0;

function UpdateTargetID( ent )

	if( CurTime() - LastTargetIDUpdate < 2 ) then
		return;
	end
	
	if( ent:IsPlayer() ) then
	
		RunConsoleCommand( "eng_uti", tostring(ent:EntIndex()), ( ent.PlayerTitle or "" ), ( ent.PlayerTitle2 or "" ) );

	elseif( ent:IsProp() ) then
	
		RunConsoleCommand( "eng_uti", tostring(ent:EntIndex()), ( ent.Desc or "" ) );
		
	elseif( ent:IsDoor() ) then
		local owned
		if ent.Owned == true then
			owned = "1"
		else
			owned = "0"
		end
		RunConsoleCommand("eng_uti", tostring(ent:EntIndex()), ( ent.PropertyName or "" ), ( ent.DoorName or "" ), owned, tostring(ent.DoorPrice or 0), ( ent.DoorDesc or "" ) );	
	end
	
	LastTargetIDUpdate = CurTime();
end

function DrawPlayerInfo()

	local trace = { }
	trace.start = LocalPlayer():EyePos();
	trace.endpos = trace.start + LocalPlayer():GetAimVector() * 200;
	trace.filter = LocalPlayer();
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() and LocalPlayer():KeyDown( IN_USE ) ) then
	
		if( not tr.Entity.CS ) then
		
			RunConsoleCommand( "eng_ucs", tr.Entity:EntIndex() );
			return;
		
		end
	
		local pos = tr.HitPos:ToScreen();
		local auth = tr.Entity.CS or "";
		
		draw.DrawText( auth .. " created this", "NewChatFont", pos.x, pos.y, Color( 255, 255, 255, 200 ) ); 
		
	end
	
	if( tr.Entity and tr.Entity:IsValid() and ( tr.Entity:IsPlayer() or tr.Entity.ItemName or tr.Entity:IsProp() or tr.Entity:IsDoor() ) ) then
	
		UpdateTargetID( tr.Entity );
	
		if( not TargetInfo[tr.Entity] ) then
		
			TargetInfo[tr.Entity] = { } 
			
			TargetInfo[tr.Entity].StartTime = CurTime();
			TargetInfo[tr.Entity].Fade = 0;
			
			if( tr.Entity:IsPlayer() ) then
			
				TargetInfo[tr.Entity].Text = tr.Entity:GetRPName();
				TargetInfo[tr.Entity].TextColor = Color( 200, 200, 200, 255 );
			
			elseif( tr.Entity.ItemName ) then
			
				TargetInfo[tr.Entity].Text = tr.Entity.ItemName;
				TargetInfo[tr.Entity].TextColor = Color( 200, 200, 200, 255 );
				
			elseif( tr.Entity:IsProp() ) then
			
				TargetInfo[tr.Entity].Text = tr.Entity.Desc;
				TargetInfo[tr.Entity].TextColor = Color( 200, 200, 200, 255 );	
			
			elseif( tr.Entity:IsDoor() ) then
				TargetInfo[tr.Entity].Text = "";
				TargetInfo[tr.Entity].TextColor = Color( 200, 200, 200, 255 );
				if not tr.Entity.Owned and not tr.Entity.OwnedByCombine then
					TargetInfo[tr.Entity].TextColor = Color( 200, 40, 40, 255 );
				elseif tr.Entity.NexusDoor then
					TargetInfo[tr.Entity].TextColor = Color( 38, 107, 255, 255 );
				end
			end
			
		else
			
			if( tr.Entity:IsDoor() ) then
				if( tr.Entity.PropertyName and tr.Entity.DoorName ) then
					TargetInfo[tr.Entity].Fade = math.Clamp( TargetInfo[tr.Entity].Fade + 300 * FrameTime(), 0, 255 );
				end
			else
				TargetInfo[tr.Entity].Fade = math.Clamp( TargetInfo[tr.Entity].Fade + 300 * FrameTime(), 0, 255 );
			end
			
		end
		
	end
	
	for k, v in pairs( TargetInfo ) do
	
		if( k:IsValid() and k:IsPlayer() ) then
		
			local pos = k:EyePos() + Vector( 0, 0, 11 );
			local scrpos = pos:ToScreen();
		
			if( v.Text ~= k:GetRPName() ) then
			
				TargetInfo[k].Text = k:GetRPName();
				
			end

			local typing = "";
			
			if( k:GetNWBool( "IsTyping" ) ) then
			
				typing = "\n(Typing)";
			
			end
			
			local title = "";
			local title2 = "";
			
			if( k.PlayerTitle ) then
			
				title = "\n" .. k.PlayerTitle;
			
			end
			
			if( k.PlayerTitle2 ) then
			
				title2 = "\n" .. k.PlayerTitle2;
			
			end
			
			local tcolor = { };
			tcolor = team.GetColor( k:Team() );
			
			draw.DrawTextOutlined( v.Text, "GiantChatFont", scrpos.x, scrpos.y - 15, Color( tcolor.r, tcolor.g, tcolor.b, v.Fade ), 1, nil, 1, Color( 0, 0, 0, v.Fade ) );
			draw.DrawTextOutlined( title .. title2 .. typing, "NewChatFont", scrpos.x, scrpos.y, Color( 255, 255, 255, v.Fade ), 1, nil, 1, Color( 0, 0, 0, v.Fade ) );
		
		
		end
		
		if( k:IsValid() and k:IsDoor() ) then
		
			local pos = k:EyePos() + Vector( 0, 0, 5 ) - k:GetAngles():Right() * 25;
			
			if( string.find( k:GetModel(), "*" ) ) then
			
				local trace = { }
				trace.start = LocalPlayer():EyePos();
				trace.endpos = trace.start + LocalPlayer():GetAimVector() * 150;
				trace.filter = LocalPlayer();
				
				local tr = util.TraceLine( trace );
			
				pos = tr.HitPos;
				
				if( tr.Entity == k ) then
				
					k.Pos = pos;
			
				else
				
					pos = k.Pos or pos;
				
				end
			
			end
			
			local scrpos = pos:ToScreen();
			
			if( MEPropertiesWindow and MEPropertiesWindow:IsValid() ) then
				draw.DrawTextOutlined( ( k.DoorName or "" ) .. "\n" .. ( k.DoorPrice or "" ) .. "\n" .. ( k.DoorFlags or "" ) .. "\n".. ( k.DoorFamily or "" ), "NewChatFont", scrpos.x, scrpos.y, Color( v.TextColor.r, v.TextColor.g, v.TextColor.b, v.Fade ), 1, nil, 1, Color( 0, 0, 0, v.Fade ) );
				v.Fade = 255;
			elseif( k.PropertyName and k.DoorName ) then
				draw.DrawTextOutlined( k.PropertyName, "GiantChatFont", ScrW()/2, ScrH()/2, Color( v.TextColor.r, v.TextColor.g, v.TextColor.b, v.Fade ), 1, nil, 1, Color( 30, 30, 30, v.Fade ) );
				draw.DrawTextOutlined( k.DoorName, "NewChatFont", ScrW()/2, ScrH()/2 + 30, Color( v.TextColor.r, v.TextColor.g, v.TextColor.b, v.Fade ), 1, nil, 1, Color( 30, 30, 30, v.Fade ) );
				if ( not k.Owned and not k.OwnedByCombine ) then
					draw.DrawTextOutlined( k.DoorPrice .. " tokens", "NewChatFont", ScrW()/2, ScrH()/2 + 45, Color( v.TextColor.r, v.TextColor.g, v.TextColor.b, v.Fade ), 1, nil, 1, Color( 30, 30, 30, v.Fade ) );
				elseif not k.OwnedByCombine then
					draw.DrawTextOutlined( k.DoorDesc, "NewChatFont", ScrW()/2, ScrH()/2 + 45, Color( v.TextColor.r, v.TextColor.g, v.TextColor.b, v.Fade ), 1, nil, 1, Color( 30, 30, 30, v.Fade ) );
				end
			end				
		
		end

		if( k:IsValid() and k.ItemName ) then
		
			local pos = k:EyePos() + Vector( 0, 0, 5 );
			local scrpos = pos:ToScreen();
		
			if( v.Text ~= k.ItemName ) then
			
				TargetInfo[k].Text = k.ItemName;
			
			end

			draw.DrawTextOutlined( v.Text, "NewChatFont", scrpos.x, scrpos.y, Color( v.TextColor.r, v.TextColor.g, v.TextColor.b, v.Fade ), 1, nil, 1, Color( 0, 0, 0, v.Fade ) );
			
		end
		
		if( k:IsValid() and k.Desc ) then
		
			local pos = k:EyePos() + Vector( 0, 0, 5 );
			local scrpos = pos:ToScreen();
		
			if( v.Text ~= k.Desc ) then
			
				TargetInfo[k].Text = k.Desc;
			
			end

			draw.DrawTextOutlined( v.Text, "NewChatFont", scrpos.x, scrpos.y, Color( v.TextColor.r, v.TextColor.g, v.TextColor.b, v.Fade ), 1, nil, 1, Color( 0, 0, 0, v.Fade ) );
		
		end
		
		
		if( k:IsValid() and k ~= tr.Entity ) then
		
			TargetInfo[k].Fade = math.Clamp( TargetInfo[k].Fade - 300 * FrameTime(), 0, 255 );
		
			if( TargetInfo[k].Fade == 0 ) then
			
				TargetInfo[k] = nil;
			
			end
		
		end
		
		if( not k:IsValid() ) then
		
			TargetInfo[k] = nil;
		
		end
		
	end

end

ActionMenuFade = 1;

function DrawActionMenu()

	local pos = ( ActionMenuPos + Vector( 0, 0, 10 ) );
	pos = pos:ToScreen();
	
	local selected = false;
	
	draw.DrawTextOutlined( ActionMenuTitle, "NewChatFont", pos.x + ActionMenuLongest / 2, pos.y, Color( 255, 255, 255, math.Clamp( 255 * ActionMenuFade, 0, 255 ) ), 1, nil, 1, Color( 0, 0, 0, math.Clamp( 255 * ActionMenuFade, 0, 255 ) ) );
	
	local y = pos.y + 18;
	
	for n = 1, #ActionMenuOptions do
	
		local w = ActionMenuLongest;
		
		local color = Color( 60, 60, 60, math.Clamp( ActionMenuFade * 140, 0, 255 ) );
		
		if( ActionMenuCursorIsOn( pos.x, y - 10, w, 20 ) ) then
			color = Color( 60, 60, 180, math.Clamp( ActionMenuFade * 140, 0, 255 ) );
			ActionMenuChoice = n;
			selected = true;
			
			if( input.IsMouseDown( MOUSE_LEFT ) ) then
			
				RunConsoleCommand( ActionMenuOptions[n].Command, ActionMenuOptions[n].ID );
				ActionMenuOn = false;
			
			end
			
		end
	
		draw.RoundedBox( 2, pos.x, y, w, 20, Color( 0, 0, 0, math.Clamp( ActionMenuFade * 220, 0, 255 ) ) );
		draw.RoundedBox( 2, pos.x + 1, y + 1, w - 2, 18, color );
		draw.RoundedBox( 4, pos.x + 1, y + 1, w - 2, 9, Color( 200, 200, 200, math.Clamp( ActionMenuFade * 90, 0, 255 ) ) );
		draw.DrawText( ActionMenuOptions[n].Name, "NewChatFont", pos.x + w / 2, y + 2, Color( 255, 255, 255, math.Clamp( ActionMenuFade * 255, 0, 255 ) ), 1 );
		
		y = y + 21;
		
	end
	
	draw.DrawTextOutlined( "o", "NewChatFont", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, math.Clamp( 255 * ActionMenuFade, 0, 255 ) ), 1, 1, 1, Color( 0, 0, 0, math.Clamp( ActionMenuFade * 255, 0, 255 ) ) );
	
	if( math.abs( ( ScrW() / 2 ) - pos.x ) > 100 or
		math.abs( ( ScrH() / 2 ) - pos.y ) > 100 ) then
	
		ActionMenuFade = math.Clamp( ActionMenuFade - .7 * FrameTime(), 0, 1 );
	
		if( ActionMenuFade == 0 ) then
		
			ActionMenuOn = false;
		
		end
	
	else
	
		ActionMenuFade = 1;
	
	end
	
	if( not selected and input.IsMouseDown( MOUSE_LEFT ) ) then
	
		ActionMenuOn = false;
	
	end

end

function DrawProcessBars()

	local yoffset = 0;

	for k, v in pairs( ProcessBars ) do
	
		local perc = ( math.Clamp( ( CurTime() - v.StartTime ) / v.Time, 0, 1 ) );
	
		draw.RoundedBox( 4, ScrW() / 2 - 160, ScrH() * .2 - 20 + yoffset, 320, 40, Color( 0, 0, 0, 220 ) );
		draw.DrawText( v.Title, "NewChatFont", ScrW() / 2, ScrH() * .2 - 17 + yoffset, Color( 255, 255, 255, 255 ), 1 );
		draw.RoundedBox( 2, ScrW() / 2 - 150, ScrH() * .2 + yoffset, 300, 12, Color( 0, 0, 0, 255 ) );
		
		if( perc > 0 ) then
		
			draw.RoundedBox( 2, ScrW() / 2 - 149, ScrH() * .2 + 1 + yoffset, 298 * perc, 10, v.Color );
			draw.RoundedBox( 2, ScrW() / 2 - 149, ScrH() * .2 + 1 + yoffset, 298 * perc, 4, Color( 200, 200, 200, 50 ) );
		
		end
		
		yoffset = yoffset + 42;
		
	end

end

function DrawWeaponSelect()

	local perc = WeaponsMenuFadeAlpha / 255;

	local color = {
		Color( 100, 100, 100, 120 * perc ),
		Color( 100, 100, 100, 120 * perc ),
		Color( 100, 100, 100, 120 * perc  )
	}

	color[SelectedTab] = Color( 255, 255, 255, 200 * perc  );

	draw.RoundedBox( 4, ScrW() / 2 - 290, 10, 160, 30, Color( 0, 0, 0, 220 * perc  ) );
	draw.RoundedBox( 4, ScrW() / 2 - 289, 11, 158, 28, Color( 100, 100, 100, 80 * perc  ) );
	draw.DrawTextOutlined( "Hands", "NewChatFont", ScrW() / 2 - 175, 18, color[1], nil, nil, 1, Color( 0, 0, 0, 255 * perc  ) );
	
	draw.RoundedBox( 4, ScrW() / 2 - 125, 10, 160, 30, Color( 0, 0, 0, 220 * perc  ) );
	draw.RoundedBox( 4, ScrW() / 2 - 124, 11, 158, 28, Color( 100, 100, 100, 80 * perc  ) );
	draw.DrawTextOutlined( "Weapons", "NewChatFont", ScrW() / 2 - 32, 18, color[2], nil, nil, 1, Color( 0, 0, 0, 255 * perc  ) );

	draw.RoundedBox( 4, ScrW() / 2 + 40, 10, 160, 30, Color( 0, 0, 0, 220 * perc  ) );
	draw.RoundedBox( 4, ScrW() / 2 + 41, 11, 158, 28, Color( 100, 100, 100, 80 * perc  ) );
	draw.DrawTextOutlined( "Misc", "NewChatFont", ScrW() / 2 + 164, 18, color[3], nil, nil, 1, Color( 0, 0, 0, 255 * perc  ) );

	local x = ScrW() / 2 - 290;
	
	if( SelectedTab == 2 ) then
	
		x = ScrW() / 2 - 125;
	
	elseif( SelectedTab == 3 ) then
	
		x = ScrW() / 2 + 40;
	
	end
	
	surface.SetFont( "NewChatFont" );
	
	local yoffset = 0;
	
	local count = 1;

	for k, v in pairs( WeaponsTabs[SelectedTab] ) do
		
		local xoffset = 0;
		
		local w = surface.GetTextSize( WeaponsTabs[SelectedTab][k].PrintName );
		
		if( w > 160 ) then
		
			xoffset = w - 150;
		
		end
		
		local dh = 0;
		
		local color = Color( 100, 100, 100, 120 * perc  );
		
		if( k == SelectedSlot ) then
		
			color = Color( 100, 100, 255, 120 * perc  );
		
			if( WeaponsTabs[SelectedTab][k].Desc ) then
			
				local dw;
				
				dw, dh = surface.GetTextSize( WeaponsTabs[SelectedTab][k].Desc );
				
				if( dw > w ) then
				
					xoffset = dw - 150;
				
				end
				
			end
			
		end
	
		draw.RoundedBox( 4, x - xoffset, 22 + count * 21 + yoffset, 160 + xoffset, 20 + dh, Color( 0, 0, 0, 220 * perc  ) );
		draw.RoundedBox( 4, x + 1 - xoffset, 23 + count * 21 + yoffset, 158 + xoffset, 18 + dh, color );
		draw.DrawTextOutlined( WeaponsTabs[SelectedTab][k].PrintName, "NewChatFont", x + 155, 25 + count * 21 + yoffset, Color( 255, 255, 255, 200 * perc  ), 2, nil, 1, Color( 0, 0, 0, 255 * perc  ) );
		
		if( k == SelectedSlot and WeaponsTabs[SelectedTab][k].Desc ) then
		
			draw.DrawText( WeaponsTabs[SelectedTab][k].Desc, "NewChatFont", x + 155, 40 + count * 21 + yoffset, Color( 255, 255, 255, 200 * perc  ), 2 );

		end
		
		yoffset = yoffset + dh;
		
		count = count + 1;
		
	end
	
	if( CurTime() >= WeaponsMenuFadeTime ) then
	
		WeaponsMenuFadeAlpha = WeaponsMenuFadeAlpha - 128 * FrameTime();
		
		if( WeaponsMenuFadeAlpha <= 0 ) then
		
			WeaponsMenuVisible = false;
		
		end
	
	end

end

function DrawPreviewLetter()

	if( WritingVGUI and WritingVGUI.TextEntry ) then
	
		local y = 0;
	
		if( ScrH() > 600 ) then
			y = 100;
		end
		
		draw.RoundedBox( 0, ScrW() / 2 - 300, y, 600, 600, Color( 255, 255, 255, 200 ) );
		draw.DrawText( LetterContent, "LetterFont", ScrW() / 2 - 295, y + 5, Color( 0, 0, 0, 255 ) );
	
	end

end

function DrawChatBoxTimeNotice()

	if( ChatBoxVisible ) then

		if( CurTime() < NextTimeCanChat or CurTime() < NextTimeCanChatOOC ) then
		
			local amt = math.floor( ( NextTimeCanChatOOC - CurTime() ) );
			
			if( NextTimeCanChatOOC < NextTimeCanChat ) then
				amt = math.floor( ( NextTimeCanChat - CurTime() ) );
			end
			
			local str = "Wait " .. amt .. " second";
			
			if( amt ~= 1 ) then
			
				str = str .. "s";
			
			end
			
			str = str .. " to chat";
			
			if( NextTimeCanChatOOC > NextTimeCanChat ) then
				str = str .. " in OOC";
			end
			
			surface.SetFont( "NewChatFont" );
			local w = surface.GetTextSize( str );
			
			draw.RoundedBox( 0, 5, ScrH() - 370, w + 10, 19, Color( 0, 0, 0, 255 ) );
			draw.RoundedBox( 0, 7, ScrH() - 368, w + 6, 15, Color( 60, 60, 60, 220 ) );
			draw.DrawText( str, "NewChatFont", 12, ScrH() - 368, Color( 200, 200, 200, 255 ) );			
		
		end
	
	end

end


function DrawFIFO()

	if( CurTime() > FadeStart and CurTime() < FadeEnd ) then
		FIFOAlpha = math.Clamp( FIFOAlpha + ( 600 * FrameTime() ), 0, 255 );
	end
	
	if( CurTime() > FadeStart and CurTime() > FadeEnd and FadeStart > 0 ) then
		FIFOAlpha = math.Clamp( FIFOAlpha - ( 150 * FrameTime() ), 0, 255 );
	end
	
	draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, FIFOAlpha ) );

	draw.DrawText( "The Future; 2018", "GiantTargetID", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, FIFOAlpha ), 1, 1 );
	--draw.DrawText( "WHAT. THE. FUCK?!?", "BigTargetID", ScrW() / 2, ScrH() / 2 + 40, Color( 255, 255, 255, FIFOAlpha ), 1, 1 );
	
end

--copy pasta
function DrawColorMod()

	if( not LocalPlayer():Alive() ) then return; end

 	local tab = {} 
 	
 	tab[ "$pp_colour_addr" ] 		= 0;
 	tab[ "$pp_colour_addg" ] 		= 0;
 	tab[ "$pp_colour_addb" ] 		= 0;
 	tab[ "$pp_colour_brightness" ] 	= -.04;
 	tab[ "$pp_colour_contrast" ] 	= 1.68;
 	tab[ "$pp_colour_colour" ] 		= .35;
 	tab[ "$pp_colour_mulr" ] 		= 0;
 	tab[ "$pp_colour_mulg" ] 		= 0; 
 	tab[ "$pp_colour_mulb" ] 		= 0;
 	
 	DrawColorModify( tab ); 

end

function DrawNormalOWSoldierSight()

	if( not LocalPlayer():Alive() ) then return; end

 	local tab = {} 
 	 
 	tab[ "$pp_colour_addr" ] 		= .08;
 	tab[ "$pp_colour_addg" ] 		= .12;
 	tab[ "$pp_colour_addb" ] 		= .2;
 	tab[ "$pp_colour_brightness" ] 	= .07;
 	tab[ "$pp_colour_contrast" ] 	= 1;
 	tab[ "$pp_colour_colour" ] 		= 1;
 	tab[ "$pp_colour_mulr" ] 		= 0;
 	tab[ "$pp_colour_mulg" ] 		= 0; 
 	tab[ "$pp_colour_mulb" ] 		= 0;
 	 
 	DrawColorModify( tab ); 


end

function DrawNormalOWSight()

	if( not LocalPlayer():Alive() ) then return; end

 	local tab = {} 
 	 
 	tab[ "$pp_colour_addr" ] 		= .06;
 	tab[ "$pp_colour_addg" ] 		= 0;
 	tab[ "$pp_colour_addb" ] 		= 0;
 	tab[ "$pp_colour_brightness" ] 	= 0;
 	tab[ "$pp_colour_contrast" ] 	= 1.68;
 	tab[ "$pp_colour_colour" ] 		= 1.71;
 	tab[ "$pp_colour_mulr" ] 		= 0;
 	tab[ "$pp_colour_mulg" ] 		= 0; 
 	tab[ "$pp_colour_mulb" ] 		= 0;
 	 
 	DrawColorModify( tab ); 


end

OWSight = false;

function DrawOWSight()

	if( not LocalPlayer():Alive() ) then return; end

 	local tab = {} 
 	 
 	tab[ "$pp_colour_addr" ] 		= 0;
 	tab[ "$pp_colour_addg" ] 		= 0;
 	tab[ "$pp_colour_addb" ] 		= 0;
 	tab[ "$pp_colour_brightness" ] 	= 0;
 	tab[ "$pp_colour_contrast" ] 	= 3.79;
 	tab[ "$pp_colour_colour" ] 		= .44;
 	tab[ "$pp_colour_mulr" ] 		= 0;
 	tab[ "$pp_colour_mulg" ] 		= 0; 
 	tab[ "$pp_colour_mulb" ] 		= 0;
 	 
 	DrawColorModify( tab ); 

end

function DrawConsciousEffects()

	if( not LocalPlayer():Alive() ) then return; end
	
	if( CurTime() < 10 ) then return; end
	
	local c = ClientVars["Consciousness"];

	if( c <= 50 ) then
	
		local alpha = 5 * ( ClientVars["Consciousness"] / 50 );
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, alpha ) );
	
	end
	
	if( c <= 30 ) then
		DrawMotionBlur( .17, .99, 0.05 );
	elseif( c <= 35 ) then
		DrawMotionBlur( .33, .99, 0.02 );
	elseif( c <= 40 ) then
		DrawMotionBlur( .41, .99, 0 );
	elseif( c <= 45 ) then
		DrawMotionBlur( .61, .99, 0 );
	elseif( c <= 50 ) then
		DrawMotionBlur( .71, .99, 0 );
	end
	
end

function DrawSeeAll()

	if( AdminSeeAll and LocalPlayer():IsAdmin() ) then
		
		for k, v in pairs( player.GetAll() ) do
		
			if( v ~= LocalPlayer() )then
		
				local pos = v:EyePos() + Vector( 0, 0, 11 );
				local scrpos = pos:ToScreen();
		
				draw.DrawTextOutlined( v:GetRPName() .. " (" .. v:Name() .. ")", "NewChatFont", scrpos.x, scrpos.y, Color( 200, 0, 0, 255 ), 1, nil, 1, Color( 0, 0, 0, 255 ) );
			
			end
		
		end
	
	end

end

UnconsciousTextAlpha = 0;

function DrawUnconscious()

	if( not ClientVars["Conscious"] and LocalPlayer():Alive() ) then
	
		UnconsciousTextAlpha = math.Clamp( UnconsciousTextAlpha + 100 * FrameTime(), 0, 255 );
	
	else
	
		if( UnconsciousTextAlpha > 0 ) then
		
			UnconsciousTextAlpha = math.Clamp( UnconsciousTextAlpha - 100 * FrameTime(), 0, 255 );
		
		end
	
	end
	
	draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, math.Clamp( UnconsciousTextAlpha, 0, 210 ) ) );
	draw.DrawText( "You are unconscious", "BigTargetID", ScrW() / 2, 50, Color( 255, 255, 255, UnconsciousTextAlpha ), 1, 0 );

	draw.RoundedBox( 2, ScrW() / 2 - 100, ScrH() / 2 - 16, 200, 20, Color( 0, 0, 0, UnconsciousTextAlpha ) );
	
	if( ClientVars["Consciousness"] > 0 ) then
	
		draw.RoundedBox( 2, ScrW() / 2 - 98, ScrH() / 2 - 14, 196 * math.Clamp( ClientVars["Consciousness"] / 45, 0, 1 ), 16, Color( 40, 40, 40, UnconsciousTextAlpha ) );
		draw.RoundedBox( 4, ScrW() / 2 - 98, ScrH() / 2 - 14, 196 * math.Clamp( ClientVars["Consciousness"] / 45, 0, 1 ), 5, Color( 50, 50, 50, UnconsciousTextAlpha ) );
	
	end
	
	if( ClientVars["Consciousness"] >= 45 ) then
	
		draw.DrawText( "You can now get back up with /getup", "BigTargetID", ScrW() / 2, ScrH() - 80, Color( 255, 255, 255, UnconsciousTextAlpha ), 1, 0 );
	
	end
	
	local healthperc = 1;
	
	if( TS.HighestHealth ~= 0 ) then
		healthperc = LocalPlayer():Health() / TS.HighestHealth; 
	end
	
	draw.RoundedBox( 0, ScrW() / 2 - 100, ScrH() / 2 + 14, 200, 12, Color( 0, 0, 0, UnconsciousTextAlpha ) );
	
	if( healthperc > 0 ) then
		draw.RoundedBox( 0, ScrW() / 2 - 98, ScrH() / 2 + 16, 196 * healthperc, 8, Color( 140, 0, 0, UnconsciousTextAlpha ) );
		draw.RoundedBox( 2, ScrW() / 2 - 98, ScrH() / 2 + 16, 196 * healthperc, 4, Color( 140, 50, 50, UnconsciousTextAlpha ) );
	end
	
end

function DrawWaterBlur()

	if( WaterBlur.Draw > 0 ) then
	
		DrawMotionBlur( WaterBlur.Add, WaterBlur.Draw, WaterBlur.Delay );
		
		if( CurTime() - WaterBlur.LastUpdate > 45 ) then
		
			WaterBlur.Add = math.Clamp( WaterBlur.Add - WaterBlur.MaxAdd * .14, 0, WaterBlur.MaxAdd );
			WaterBlur.Draw = math.Clamp( WaterBlur.Draw - WaterBlur.MaxDraw * .14, 0, WaterBlur.MaxDraw );
			WaterBlur.Delay = math.Clamp( WaterBlur.Delay - WaterBlur.MaxDelay * .14, 0, WaterBlur.MaxDelay );
			WaterBlur.LastUpdate = CurTime();
			
		end
		
	end

end

function DrawAlcoholBlur()

	if( AlcoholBlur.Draw > 0 ) then
	
		DrawMotionBlur( AlcoholBlur.Add, AlcoholBlur.Draw, AlcoholBlur.Delay );
		
		if( CurTime() - AlcoholBlur.LastUpdate > 100 ) then
		
			AlcoholBlur.Add = math.Clamp( AlcoholBlur.Add - AlcoholBlur.MaxAdd * .11, 0, AlcoholBlur.MaxAdd );
			AlcoholBlur.Draw = math.Clamp( AlcoholBlur.Draw - AlcoholBlur.MaxDraw * .11, 0, AlcoholBlur.MaxDraw );
			AlcoholBlur.Delay = math.Clamp( AlcoholBlur.Delay - AlcoholBlur.MaxDelay * .11, 0, AlcoholBlur.MaxDelay );	
			AlcoholBlur.LastUpdate = CurTime();
			
		end
		
	end

end

function DrawDeadEffects()

	if( CharacterMenu ) then return; end
	if( LocalPlayer():Alive() ) then return; end
	
	local tab = { } 
 	
	tab[ "$pp_colour_addr" ] 		= 0;
	tab[ "$pp_colour_addg" ] 		= 0;
	tab[ "$pp_colour_addb" ] 		= 0;
	tab[ "$pp_colour_brightness" ] 	= -.02;
	tab[ "$pp_colour_contrast" ] 	= 3.46;
	tab[ "$pp_colour_colour" ] 		= 0;
	tab[ "$pp_colour_mulr" ] 		= 0;
	tab[ "$pp_colour_mulg" ] 		= 0; 
	tab[ "$pp_colour_mulb" ] 		= 0;
 
	DrawColorModify( tab ); 

end

function DrawChatLines()

	if( not LocalPlayer():Alive() or not ClientVars["Conscious"] ) then return; end

	for k, v in pairs( TS.ChatLines ) do

		draw.DrawText( v.text, "ChatFont", v.x, v.y, Color( v.r, v.g, v.b, v.a ) );
	
	end

end

function DrawBleedingBlur()

	if( not ClientVars["Bleeding"] ) then return; end
	if( not LocalPlayer():Alive() ) then return; end
	
	local h = LocalPlayer():Health();
	
	if( h <= 30 ) then
		DrawMotionBlur( .80, .99, 0.05 );
	elseif( h <= 35 ) then
		DrawMotionBlur( .70, .99, 0.02 );
	elseif( h <= 40 ) then
		DrawMotionBlur( .60, .99, 0 );
	elseif( h <= 45 ) then
		DrawMotionBlur( .55, .99, 0 );
	elseif( h <= 50 ) then
		DrawMotionBlur( .45, .99, 0 );
	end
	
end

function DrawCloakNotice()

	draw.DrawText( "You are cloaked", "BigTargetID", ScrW() / 2, 10, Color( 255, 255, 255, 255 ), 1, 0 );

end

function GM:HUDPaint()
	
	DrawConsciousEffects();
	
	if colortype:GetInt() == 1 then
	
		if( LocalPlayer():IsOWElite() ) then

			if( OWSight ) then
		
				DrawOWSight();
		
			end
		
			DrawNormalOWSight();
		
		elseif( LocalPlayer():IsOW() ) then
	
			DrawNormalOWSoldierSight();
		end
	end
	
	DrawWaterBlur();
	DrawAlcoholBlur();
	
	
	if( colortype:GetInt() == 1 ) then
		DrawColorMod();	
	end

	if( TS.FancyGayIntro ) then
	
		DrawFancyGayIntro();
		DrawFIFO();
		return;
	
	end
	
	if (TS.FlashEffect) then
		DrawFlashEffect()
		return
	end
	
	DrawPlayerInfo();
	
	DrawSeeAll();

	DrawDisplay();
	
	if( ActionMenuOn ) then
		DrawActionMenu();
	end

	if( PlayerMenuVisible ) then
	
		DrawPlayerMenu();
	
	end

	DrawProcessBars();
	
	if( WeaponsMenuVisible ) then
		DrawWeaponSelect();
	end
	
	if( PreviewLetterOn ) then
		DrawPreviewLetter();
	end
	
	DrawChatBoxTimeNotice();

	DrawFIFO();
	
	DrawUnconscious();
	
	DrawDeadEffects();
	
	DrawChatLines();
	
	DrawBleedingBlur();
	
	if( ClientVars["Cloaked"] ) then
	
		DrawCloakNotice();
		
	end
	
end

function GM:HUDShouldDraw( id )

	local nodraw = {

		"CHudHealth",
		"CHudAmmo",
		"CHudSecondaryAmmo",
		"CHudBattery",
		"CHudChat",
		"CHudWeaponSelection"
	
	}
	
	for k, v in pairs( nodraw ) do

		if( id == v ) then
		
			return false;
		
		end
	
	end
	
	return true;

end

--Copy pasta modification
function draw.DrawTextOutlined(text, font, x, y, colour, xalign, yalign, outlinewidth, outlinecolour) 

 	for _x=-1, 1 do 
 		for _y=-1, 1 do 
 			draw.DrawText(text, font, x + (_x*outlinewidth), y + (_y*outlinewidth), outlinecolour, xalign, yalign) 
 		end 
 	end 

 	draw.DrawText(text, font, x, y, colour, xalign, yalign) 
 	
end 

function draw.DrawTextGlowing(text, font, x, y, colour, xalign, yalign, passes, outlinecolour) 
   
 	for _x=-1, 1 do 
 		for _y=-1, 1 do 
 			for n = 1, passes do
 				draw.DrawText(text, font, x + (_x*(n/2)), y + (_y*(n/2)), Color( outlinecolour.r, outlinecolour.g, outlinecolour.b, math.Clamp( ( ( 1 / n ) * 255 ), 0, outlinecolour.a )), xalign, yalign) 
 			end
 		end 
 	end 
 	
 	draw.DrawText(text, font, x, y, colour, xalign, yalign) 
 	
end


