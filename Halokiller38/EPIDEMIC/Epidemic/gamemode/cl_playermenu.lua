

function event.TogglePM()

	PlayerMenuPanel:SetVisible( !PlayerMenuPanel:IsVisible() );
	
	InvActionMenu = nil;
	
	for k, v in pairs( InventoryWindows ) do
	
		if( v:IsValid() ) then
			v.TitleBar:SetVisible( PlayerMenuPanel:IsVisible() );
			v:SetVisible( PlayerMenuPanel:IsVisible() );
		end
		
	end
	
	UpdateWeaponIcons();
	
	if( PlayerMenuPanel:IsVisible() ) then
	
		gui.EnableScreenClicker( true );
	
	else
		
		HideMouse();
	
	end

end

function CreatePlayerMenuModelDisp()
	
	local modelpnl = vgui.Create( "DModelPanel" );
	modelpnl:SetParent( PlayerMenuPanel );
	
	modelpnl:SetPos( ScrW() * .5 - 200, 200 );
	modelpnl:SetSize( 400, 400 );
	
	modelpnl:SetModel( "models/rusty/Survivors/Msurvivor1.mdl" );
	modelpnl.Model = "models/rusty/Survivors/Msurvivor1.mdl";
	modelpnl.Skin = 0;

	modelpnl.Think = function()
	
		if( modelpnl.Model ~= LocalPlayer():GetModel() or modelpnl.Skin ~= LocalPlayer():GetSkin() ) then
		
			modelpnl:SetModel( LocalPlayer():GetModel() );
			modelpnl.Model = LocalPlayer():GetModel();
			modelpnl.Entity:SetSkin( LocalPlayer():GetSkin() );
			modelpnl.Skin = LocalPlayer():GetSkin();
			
			local seq = modelpnl.Entity:SelectWeightedSequence( 1 );
			modelpnl.Entity:ResetSequence( seq );
			
		end
	
	end

	modelpnl:SetCamPos( Vector( 62, 1, 43 ) );
	modelpnl:SetLookAt( Vector( -23, -2, 37 ) );
	modelpnl:SetFOV( 86 );

	modelpnl.LayoutEntity = function( self ) 
	
		if( self.Entity:GetSequence() <= 0 ) then
	
			local seq = modelpnl.Entity:SelectWeightedSequence( 1 );
			modelpnl.Entity:ResetSequence( seq );
			
		end
	
		modelpnl:RunAnimation();
	
	end

	modelpnl.Entity:ResetSequence( -1 );

end

FormattedPhysDesc = "";

local function DrawLimbHealth()

	if( ClientVars["Class"] == "Infected" ) then return; end

	local function DrawBar( x, y, perc )
		
		draw.RoundedBox( 0, x, y, 8, 100, Color( 255, 255, 255, 150 ) );
		draw.RoundedBox( 0, x + 1, y + 1 + ( 98 * ( 1 - perc ) ), 6, 98 * perc, Color( 150, 0, 0, 255 ) );
		draw.RoundedBox( 0, x + 1, y + 1 + ( 98 * ( 1 - perc ) ), 3, 98 * perc, Color( 255, 255, 255, 20 ) );
		
	end
	
	DrawBar( ScrW() * .5 - 200, 280, ClientVars["RArmHP"] / 100 );
	DrawBar( ScrW() * .5 - 200, 440, ClientVars["RLegHP"] / 100 );

	DrawBar( ScrW() * .5 + 200, 280, ClientVars["LArmHP"] / 100 );
	DrawBar( ScrW() * .5 + 200, 440, ClientVars["LLegHP"] / 100 );

end


local function DrawArmor()

	if( ClientVars["Class"] == "Infected" ) then return; end
	
	if( ClientVars["Armor"] > 0 ) then

		draw.RoundedBox( 0, ScrW() * .5 - 40, 600, 100, 8, Color( 255, 255, 255, 150 ) );
		
		if( ClientVars["Armor"] > 3 ) then
		
			local perc = ClientVars["Armor"] / 100;
		
			draw.RoundedBox( 0, ScrW() * .5 - 39, 601, 98 * perc, 6, Color( 0, 0, 150, 255 ) );
			draw.RoundedBox( 0, ScrW() * .5 - 39, 601, 98 * perc, 3, Color( 255, 255, 255, 20 ) );
		
		end

	end

end

local function DrawBlood()

	if( ClientVars["Class"] == "Infected" ) then return; end

	if( ClientVars["Blood"] > 0 ) then

		draw.RoundedBox( 0, ScrW() * .5 - 40, 615, 100, 12, Color( 255, 255, 255, 150 ) );
		
		if( ClientVars["Blood"] > 3 ) then
		
			local perc = ClientVars["Blood"] / 100;
		
			draw.RoundedBox( 0, ScrW() * .5 - 39, 616, 98 * perc, 10, Color( 130, 40, 40, 255 ) );
			draw.RoundedBox( 0, ScrW() * .5 - 39, 616, 98 * perc, 6, Color( 255, 255, 255, 20 ) );
		
		end

	end	

end

function CreatePlayerMenu()

	PlayerMenuPanel = CreateBPanel( nil, 0, 0, ScrW(), ScrH() );
	PlayerMenuPanel:SetMouseInputEnabled( true );
	PlayerMenuPanel.Paint = function() 
		
		InventoryPaint();
		
		draw.DrawText( PlayerGroups[ClientVars["Class"]].Name, "OpeningEpidemic", 20, 20, Color( 255, 255, 255, 255 ) );
		
		draw.DrawText( LocalPlayer():GetNWString( "RPName" ), "CharCreateEntry", 20, ScrH() - 180, Color( 255, 255, 255, 255 ) );
		draw.DrawText( ClientVars["Age"] .. " years old", "CharCreateEntry", 20, ScrH() - 160, Color( 255, 255, 255, 255 ) );
		draw.DrawText( FormattedPhysDesc, "CharCreateEntry", 20, ScrH() - 140, Color( 255, 255, 255, 255 ) );
		
		DrawLimbHealth();
		DrawArmor();
		DrawBlood();
		
	end

	CreatePlayerMenuModelDisp();
	
	local function OpenPhysDescPrompt()
	
		PlayerMenuPanel.PhysDescWindow = CreateBPanel( "Change   Physical   Description", ScrW() * .5 - 200, ScrH() * .5 - 40, 400, 80 ) ;
		PlayerMenuPanel.PhysDescWindow.TextEntry = vgui.Create( "DTextEntry" );
		PlayerMenuPanel.PhysDescWindow.TextEntry:SetParent( PlayerMenuPanel.PhysDescWindow );
		PlayerMenuPanel.PhysDescWindow.TextEntry:SetPos( 5, 5 );
		PlayerMenuPanel.PhysDescWindow.TextEntry:SetSize( 390, 17 );
		PlayerMenuPanel.PhysDescWindow.TextEntry:SetText( ClientVars["PhysDesc"] );
		PlayerMenuPanel.PhysDescWindow.TextEntry:MakePopup();
		
		PlayerMenuPanel.PhysDescWindow.Error = "";
		
		PlayerMenuPanel.PhysDescWindow.PaintHook = function()
		
			local color = Color( 255, 255, 255, 255 );
			local len = string.len( PlayerMenuPanel.PhysDescWindow.TextEntry:GetValue() );
		
			if( len < 10 or len > 120 ) then
			
				color = Color( 255, 0, 0, 255 );
			
			end
		
			draw.DrawText( len .. "/120  characters", "OpeningEpidemicLinks", 345, 41, color, 2 );
		
		end
		
		PlayerMenuPanel.PhysDescWindow.Think = function()
		
			local x, y = PlayerMenuPanel.PhysDescWindow:GetPos();
		
			PlayerMenuPanel.PhysDescWindow.TextEntry:SetPos( x + 5, y + 12 );
		
		end	
		
		local function ok()
		
			local desc = PlayerMenuPanel.PhysDescWindow.TextEntry:GetValue();
			PlayerMenuPanel.PhysDescWindow.Error = "";
		
			if( string.len( string.gsub( desc, " ", "" ) ) < 10 ) then
			
				return;
			
			end
			
			if( string.len( desc ) > 120 ) then
			
				return;
			
			end
			
			RunConsoleCommand( "eng_changephysdesc", desc );
			PlayerMenuPanel.PhysDescWindow:Remove();
		
		end
		
		PlayerMenuPanel.PhysDescWindow:AddButton( "OK", 350, 41, ok ).Outline = 2;
	
	end
	
	PlayerMenuPanel.Options = 
	{
	
		{ Text = "Create/Load Character", Cmd = "eng_opening" },
		{ Text = "Change Physical Description", Func = OpenPhysDescPrompt },
		{ Text = "Help", Cmd = "gm_showhelp" },
	
	};
	
	for k, v in pairs( PlayerMenuPanel.Options ) do
	
		local function c()
		
			if( v.Cmd ) then
		
				RunConsoleCommand( v.Cmd, "" );
		
			elseif( v.Func ) then
			
				v.Func();
				
			elseif( v.CVar ) then
				
				if( GetConVar( v.CVar ):GetInt() == 1 ) then
					
					RunConsoleCommand( v.CVar, "0" );
					
				else
					
					RunConsoleCommand( v.CVar, "1" );
					
				end
			
			end
		
		end
	
		PlayerMenuPanel:AddLink( string.gsub( v.Text, " ", "   " ), "OpeningEpidemicLinks", 10, 200 + ( k - 1 ) * 27,  Color( 100, 100, 100, 255 ), c,  Color( 255, 255, 255, 255 ) );
	
	end

	PlayerMenuPanel:SetVisible( false );

end

CreatePlayerMenu();