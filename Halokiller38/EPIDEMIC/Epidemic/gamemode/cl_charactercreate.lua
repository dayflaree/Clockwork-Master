
surface.CreateFont( "Bebas", 26, 400, true, false, "CharCreateField" );
surface.CreateFont( "Type-Ra", 22, 400, true, false, "CharCreateEntry" );

CharacterCreate = {

	HUDOverride = false,
	Alpha = 0,
	FinishEffect = false,
	FinishAlpha = 0,
	FinishBrightness = .3,
	FinishContrast = 4.86,
	FinishColorMod = 0,
	WarningMsg = "",
	DevNoteAlpha = 0,
	
}

function event.CancelCharacterCreate()

	event.KillCharacterCreate();
	event.DoOpenSceneNoFade();

end

function event.KillCharacterCreate()

	if( CharacterCreate.HUDOverride ) then
	
		CharacterCreate.GoLink:Remove();
		CharacterCreate.CancelLink:Remove();
		
		for k, v in pairs( CharacterCreate.FieldLink ) do
		
			v:Remove();
			CharacterCreate.FieldLink[k] = nil;
		
		end
	
		if( CharacterCreate.TextEntry ) then
			
			CharacterCreate.TextEntry:Remove();
			CharacterCreate.TextEntry = nil;
		
		end
		
		if( CharacterCreate.ModelsMenu ) then
		
			CharacterCreate.ModelsMenu:Remove();
			CharacterCreate.ModelsMenu = nil;
		
		end
		
		if( CharacterCreate.Model ) then
		
			CharacterCreate.Model:Remove();
			CharacterCreate.Model = nil;
	
		end
		
	end

	CharacterCreate.HUDOverride = false;
	CharacterCreate.NoHUD = true;
	IntroViewHook = false;

end

function event.CharacterCreateFinish()

	local name = CharacterCreate.FieldInfo[1];
	local age = CharacterCreate.FieldInfo[2];
	local desc = CharacterCreate.FieldInfo[3];
	local modeltab = CharacterCreate.FieldInfo[4];
	
	--This function is located in shared.lua
	local succ, msg = CharacterCreateValidFields( LocalPlayer(), name, age, desc, modeltab );
	
	if( not succ ) then
	
		CharacterCreate.WarningMsg = msg;
		return;
	
	end
	
	RunConsoleCommand( "eng_cc", CharacterCreate.Class, name, age, desc, modeltab );

	CharacterCreate.FinishEffect = true;
	CharacterCreate.FinishAlpha = 0;
	CharacterCreate.FinishStart = CurTime();
	
end

function CharacterCreateMenu( class )

	if( CharacterCreate.HUDOverride ) then return; end

	event.FadeOutOpeningScene();
	
	CharacterCreate.HUDOverride = true;
	CharacterCreate.NoHUD = false;
	CharacterCreate.FinishEffect = false;
	CharacterCreate.StartTime = CurTime();
	CharacterCreate.Class = class;
	CharacterCreate.ClassName = PlayerGroups[class].Name;
	CharacterCreate.CreatedModelsMenu = false;
	CharacterCreate.CreatedAgeSlider = false;
	CharacterCreate.FadingEnd = false;
	
	CharacterCreate.FinishBrightness = .3;
	CharacterCreate.FinishContrast = 4.86;
	CharacterCreate.FinishColorMod = 0;
	
	CharacterCreate.GoLink = vgui.CreateLink();
	CharacterCreate.GoLink:SetPos( ScrW() * .7, ScrH() * .15 );
	CharacterCreate.GoLink:SetText( "Ok, I'm ready", "CharCreateField" );
	CharacterCreate.GoLink:FadingIn( 50 );
	CharacterCreate.GoLink:FadeDelay( 1 );
	CharacterCreate.GoLink:SetNormalColor( Color( 0, 128, 0, 255 ) );
	CharacterCreate.GoLink:SetHighlightColor( Color( 0, 200, 0, 255 ) );
	CharacterCreate.GoLink.Action = function()
	
		event.CharacterCreateFinish();
		
	end
	
	CharacterCreate.CancelLink = vgui.CreateLink();
	CharacterCreate.CancelLink:SetPos( ScrW() * .7 + 140, ScrH() * .15 );
	CharacterCreate.CancelLink:SetText( "Cancel", "CharCreateField" );
	CharacterCreate.CancelLink:FadingIn( 50 );
	CharacterCreate.CancelLink:FadeDelay( 1 );
	CharacterCreate.CancelLink:SetNormalColor( Color( 100, 100, 100, 255 ) );
	CharacterCreate.CancelLink:SetHighlightColor( Color( 160, 160, 160, 255 ) );
	
	CharacterCreate.CancelLink.Action = function()
	
		event.CancelCharacterCreate();
	
	end
	
	CharacterCreate.Fields = { }
	
	CharacterCreate.FieldInfo = { }
	
	local fields = 
	{
	
		{ "Name", true, 300, "" },
		{ "Age", true, 55, "" },
		{ "Physical Description", true, 400, "" },
		{ "Body", false, nil, "" },
	
	}
	
	CharacterCreate.FieldLink = { }
	
	local yoffset = 0;
	local delay = 2.5;
	
	local parent = vgui.Create( "DPanel" );
	parent.Paint = function() end
	parent:SetMouseInputEnabled( false );
	
	for k, v in pairs( fields ) do
	
		CharacterCreate.FieldInfo[k] = v[4];
		
		CharacterCreate.FieldLink[k] = vgui.CreateLink();
		CharacterCreate.FieldLink[k]:FadingIn( 100 );
		CharacterCreate.FieldLink[k]:FadeDelay( delay );
		CharacterCreate.FieldLink[k]:SetPos( ScrW() * .25, ScrH() * .2 + 80 + yoffset );
		CharacterCreate.FieldLink[k]:SetText( v[1], "CharCreateField", 2 );
		
		if( v[2] ) then
		
			CharacterCreate.FieldLink[k].Action = function()
			
				local x, y = CharacterCreate.FieldLink[k]:GetPos();
			
				if( CharacterCreate.TextEntry ) then
				
					CharacterCreate.Fields[CharacterCreate.CurrentField] = { CharacterCreate.TextEntry:GetValue(), CharacterCreate.CurrentFieldX, CharacterCreate.CurrentFieldY };
					CharacterCreate.TextEntry:Remove();
					CharacterCreate.TextEntry = nil;
				
					if( CharacterCreate.CurrentField == k ) then
					
						return;
					
					end
					
				end

				CharacterCreate.CurrentField = k;
				CharacterCreate.CurrentFieldX = ScrW() * .25 + 15;
				CharacterCreate.CurrentFieldY = y;
				
				CharacterCreate.TextEntry = vgui.Create( "DTextEntry", parent );
				CharacterCreate.TextEntry:SetPos( ScrW() * .25 + 15, y );
				CharacterCreate.TextEntry:SetSize( v[3], 25 );
				CharacterCreate.TextEntry:SetMouseInputEnabled( false );
				CharacterCreate.TextEntry:SetKeyboardInputEnabled( true );
				
				CharacterCreate.FieldInfo[k] = "";
				
				CharacterCreate.TextEntry.OnTextChanged = function()
				
					CharacterCreate.FieldInfo[k] = CharacterCreate.TextEntry:GetValue();
				
				end
				
				if( CharacterCreate.Fields[CharacterCreate.CurrentField] ) then
				
					CharacterCreate.TextEntry:SetValue( CharacterCreate.Fields[CharacterCreate.CurrentField][1] );
				
				end
				
				CharacterCreate.TextEntry.Paint = function()
				
					draw.RoundedBox( 0, 0, 0, CharacterCreate.TextEntry:GetWide(), CharacterCreate.TextEntry:GetTall(), Color( 255, 255, 255, 255 ) );
					draw.DrawText( CharacterCreate.TextEntry:GetValue(), "CharCreateEntry", 3, 0, Color( 0, 0, 0, 255 ) );
				
				end
				CharacterCreate.TextEntry:MakePopup();
	
				table.insert( BananaVGUIList, CharacterCreate.TextEntry );
			
			end
			
		end
			
		CharacterCreate.FieldLink[k]:SetHighlightColor( Color( 120, 0, 0, 255 ) );

		yoffset = yoffset + 50;
		delay = delay + .6;

	end

end

function CharacterCreate.CreateModelsMenu()

	local x, y = CharacterCreate.FieldLink[4]:GetPos();

	CharacterCreate.ModelsMenu = CreateBPanel( nil, ScrW() * .25 + 15, y - 20, 290, 200 )
	CharacterCreate.ModelsMenu:EnableScrolling( true );

	local xoffset = 10;
	local yoffset = 10;

	for k, v in pairs( PlayerGroups[CharacterCreate.Class].Models ) do
		
		local modeltab = string.Explode( "#", v );
		local model	= modeltab[1];
		local skin	= modeltab[2] or 0;
		
		local spawnicon = vgui.Create( "SpawnIcon", CharacterCreate.ModelsMenu );
		spawnicon:SetSize( 64, 64 );
		spawnicon:SetPos( xoffset, yoffset );
		CharacterCreate.ModelsMenu:AddObject( spawnicon );
		spawnicon:SetModel( model, tonumber( skin ) );
		spawnicon.OnCursorEntered = function() end
		spawnicon.OnMouseReleased = function()
		
			CharacterCreate.FieldInfo[4] = v;
		
			if( CharacterCreate.Model ) then
				
				CharacterCreate.Model:SetModel( model );
				CharacterCreate.Model.Entity:SetSkin( tonumber( skin ) );
				CharacterCreate.Model.Entity:ResetSequence( CharacterCreate.Model.Entity:SelectWeightedSequence( 1 ) );
				
				return;
			
			end
		
			CharacterCreate.Model = vgui.Create( "DModelPanel" );
			
			CharacterCreate.Model:SetPos( ScrW() * .5, ScrH() * .2 );
			CharacterCreate.Model:SetSize( 500, 500 );
			
			CharacterCreate.Model:SetModel( model );
			CharacterCreate.Model.Entity:SetSkin( tonumber( skin ) );
		
			CharacterCreate.Model:SetCamPos( Vector( 122, -40, 50 ) );
			CharacterCreate.Model:SetLookAt( Vector( 0, 0, 40 ) );
			CharacterCreate.Model:SetFOV( 55 );

			CharacterCreate.Model.LayoutEntity = function( self ) 

				CharacterCreate.Model:RunAnimation();
			
			end
			
			CharacterCreate.Model.Entity:ResetSequence( CharacterCreate.Model.Entity:SelectWeightedSequence( 1 ) );
			
			table.insert( BananaVGUIList, CharacterCreate.Model );
		
			CharacterCreate.ModelsMenu:MakePopup();
		
		end
		
				
		if( xoffset > 160 ) then
			
			xoffset = 10;
			yoffset = yoffset + 66;
	
		else
		
			xoffset = xoffset + 66;
		
		end
	
	end

end


function CharacterCreate.CreateAgeSlider()
	
	CharacterCreate.FieldLink[4].Action = function()
		
		local x, y = CharacterCreate.FieldLink[4]:GetPos();
	
		if( CharacterCreate.TextEntry ) then
		
			CharacterCreate.Fields[CharacterCreate.CurrentField] = { CharacterCreate.TextEntry:GetValue(), CharacterCreate.CurrentFieldX, CharacterCreate.CurrentFieldY };
			CharacterCreate.TextEntry:Remove();
			CharacterCreate.TextEntry = nil;
		
			if( CharacterCreate.CurrentField == 4 ) then
			
				return;
			
			end
			
		end

		CharacterCreate.CurrentField = 4;
		CharacterCreate.CurrentFieldX = ScrW() * .25 + 15;
		CharacterCreate.CurrentFieldY = y;
		
		CharacterCreate.TextEntry = vgui.CreateAgeSlider();
		CharacterCreate.TextEntry:SetPos( ScrW() * .25 + 15, y );
		CharacterCreate.TextEntry:SetSize( 200, 35 );
		
		CharacterCreate.TextEntry.OnValueChanged = function()
			
			CharacterCreate.FieldInfo[4] = CharacterCreate.TextEntry:GetValue();
			
			if( CharacterCreate.Model ) then
				
				local num = CharacterCreate.TextEntry:GetValue() / 72;
				CharacterCreate.Model.Entity:SetModelScale( Vector( num, num, num ) );
				
			end
		
		end
		
		if( CharacterCreate.Fields[CharacterCreate.CurrentField] ) then
		
			CharacterCreate.TextEntry:SetValue( CharacterCreate.Fields[CharacterCreate.CurrentField][1] );
		
		end
		
		CharacterCreate.TextEntry:MakePopup();

		table.insert( BananaVGUIList, CharacterCreate.TextEntry );
	
	end

end



function CharacterCreate.DrawHUD()

	if( CharacterCreate.NoHUD ) then return; end

	CharacterCreate.Alpha = math.Clamp( CharacterCreate.Alpha + 60 * FrameTime(), 0, 255 );

	draw.DrawText( CharacterCreate.ClassName, "OpeningEpidemic", ScrW() * .1, ScrH() * .2, Color( 255, 255, 255, CharacterCreate.Alpha ) );

	if( not CharacterCreate.CreatedModelsMenu and CurTime() - CharacterCreate.StartTime > 5 ) then
	
		CharacterCreate.CreatedModelsMenu = true;
		CharacterCreate.CreateModelsMenu();
	
	end
	
	if( not CharacterCreate.CreatedAgeSlider and CurTime() - CharacterCreate.StartTime > 5 ) then
	
		CharacterCreate.CreatedAgeSlider = true;
		CharacterCreate.CreateAgeSlider();
	
	end
	
	for k, v in pairs( CharacterCreate.Fields ) do
	
		draw.DrawText( v[1], "CharCreateEntry", v[2], v[3], Color( 255, 255, 255, 255 ) );
	
	end
	
	draw.DrawText( CharacterCreate.WarningMsg, "CharCreateField", ScrW() * .7 - 20, ScrH() * .15, Color( 150, 0, 0, 255 ), 2 );


end