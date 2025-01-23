
function DescProp()

	if( DescPropPanel and DescPropPanel:IsValid() ) then
	
		DescPropPanel:Remove();
	
	end

	DescPropPanel = CreateBPanel( "Set  Description", ScrW() * .5 - 200, ScrH() * .5 - 52, 400, 105 ) ;
	DescPropPanel.TextEntry = vgui.Create( "DTextEntry" );
	DescPropPanel.TextEntry:SetParent( DescPropPanel );
	DescPropPanel.TextEntry:SetPos( 5, 25 );
	DescPropPanel.TextEntry:SetSize( 390, 17 );
	DescPropPanel.TextEntry:MakePopup();
	
	DescPropPanel.Error = "";
	
	DescPropPanel.PaintHook = function()

		local color = Color( 255, 255, 255, 255 );
		local len = string.len( DescPropPanel.TextEntry:GetValue() );
	
		if( len > 120 ) then
		
			color = Color( 255, 0, 0, 255 );
		
		end
	
		draw.DrawText( len .. "/120  characters", "OpeningEpidemicLinks", 345, 61, color, 2 );
	
	end
	
	DescPropPanel.Think = function()
	
		local x, y = DescPropPanel:GetPos();
	
		DescPropPanel.TextEntry:SetPos( x + 5, y + 32 );
	
	end	
	
	local function ok()
	
		local desc = DescPropPanel.TextEntry:GetValue();
		DescPropPanel.Error = "";
		
		if( string.len( desc ) > 120 ) then
		
			return;
		
		end
		
		RunConsoleCommand( "eng_setpropdesc", desc );
		DescPropPanel:Remove();
	
	end
	
	DescPropPanel:AddButton( "OK", 350, 61, ok ).Outline = 2;
	
	gui.EnableScreenClicker( true );
		
end

function AddPropAdmin()
	
	AddPropAdminPanel = CreateBPanel( "Add  Prop  Admin", ScrW() * .5 - 100, ScrH() * .5 - 40, 225, 60 ) ;
	AddPropAdminPanel.TextEntry = vgui.Create( "DTextEntry" );
	AddPropAdminPanel.TextEntry:SetParent( AddPropAdminPanel );
	AddPropAdminPanel.TextEntry:SetPos( 5, 29 );
	AddPropAdminPanel.TextEntry:SetSize( 180, 17 );
	AddPropAdminPanel.TextEntry:MakePopup();
	
	AddPropAdminPanel.Error = "";
	
	AddPropAdminPanel.PaintHook = function()
	
		draw.DrawText( string.gsub( AddPropAdminPanel.Error, " ", "   " ), "OpeningEpidemicLinks", 220, 5, Color( 160, 0, 0, 255 ), 2 );
	
	end
	
	AddPropAdminPanel.Think = function()
	
		local x, y = AddPropAdminPanel:GetPos();
	
		AddPropAdminPanel.TextEntry:SetPos( x + 5, y + 29 );
	
	end	
	
	local function ok()
	
		local name = AddPropAdminPanel.TextEntry:GetValue();
		RunConsoleCommand( "eng_addpropadmin", name );
	
	end
	
	AddPropAdminPanel:AddButton( "OK", 195, 25, ok ).Outline = 2;

	gui.EnableScreenClicker( true );

end

function event.PAD()

	AddPropAdminPanel:Remove();

end

function msgs.PASP( msg )

	AddPropAdminPanel.Error = msg:ReadString();

end