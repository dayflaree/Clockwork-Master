SearchTable = { }

function StartSearch( name, ent )
if( SearchFrame != nil ) then
SearchFrame:Remove();
SearchFrame = nil;
end

  SearchFrame = vgui.Create("DFrame")
  SearchFrame:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
  SearchFrame:SetSize(400, 400)
  SearchFrame:SetTitle( name .."'s Inventory" )
  SearchFrame:SetVisible( true )
  SearchFrame:SetBackgroundBlur( true );
  SearchFrame:MakePopup()
  
  	SearchPropertySheet = vgui.Create( "DPropertySheet" )
	SearchPropertySheet:SetParent(SearchFrame)
	SearchPropertySheet:SetPos( 2, 30 )
	SearchPropertySheet:SetSize( 396, 368 )
   
    Items = vgui.Create( "DPanelList" )
	Items:SetParent( SearchFrame )
	Items:SetSize( 280, 240 )
	Items:SetPadding(20);
	Items:SetSpacing(20);
	Items:EnableHorizontal(true);
	Items:EnableVerticalScrollbar(true);
	
	for k,v in pairs( SearchTable ) do

	local ItemIcon = vgui.Create( "DModelPanel" )
	ItemIcon:SetSize( 128, 128 )
	ItemIcon:SetModel( v.Model )
	ItemIcon:SetAnimSpeed( 0.0 )
	ItemIcon:SetAnimated( false )
	ItemIcon:SetAmbientLight( Color( 50, 50, 50 ) )
	ItemIcon:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	ItemIcon:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	ItemIcon:SetCamPos( Vector( 0, 0, 45 ) )
	ItemIcon:SetLookAt( Vector( 0, 0, 45 ) )
	ItemIcon:SetFOV( 70 )
	ItemIcon:SetToolTip("Item");
	ItemIcon.Name = v.Name;
	ItemIcon.Class = v.Class;
	ItemIcon.Description = v.Description;
	ItemIcon.Model = v.Model;
	ItemIcon.ID = ent;
	Items:AddItem(ItemIcon);
	
	local function DeleteItem()

	ItemIcon:SetVisible( false );
	
	end

	function ItemIcon:OnMousePressed()

	if( v.Takeable == true ) then

			local ContextMenu = DermaMenu()
			ContextMenu:AddOption("Take", function() LocalPlayer():ConCommand("container_takeitem ".. v.Entity:EntIndex() .. " " .. v.Class); DeleteItem(); end);
			ContextMenu:Open();

	end
	
	end
	
	ItemIcon.LayoutEntity = function( self, ent )
		
			ent:SetAngles( Angle( 0, 90, 100 ) );
		
	end

	end
	
	
	
	Backpack = vgui.Create( "DPanelList" )
	Backpack:SetPadding(20);
	Backpack:SetSpacing(20);
	Backpack:EnableHorizontal(true);
	Backpack:EnableVerticalScrollbar(true);
	
	for k, v in pairs(InventoryTable) do

	local InvIcon = vgui.Create( "DModelPanel" )
	InvIcon:SetSize( 128, 128 );
	InvIcon:SetModel( v.Model )
	InvIcon:SetAnimSpeed( 0.0 )
	InvIcon:SetAnimated( false )
	InvIcon:SetAmbientLight( Color( 50, 50, 50 ) )
	InvIcon:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	InvIcon:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	InvIcon:SetCamPos( Vector( 0, 0, 45 ) )
	InvIcon:SetLookAt( Vector( 0, 0, 45 ) )
	InvIcon:SetFOV( 70 )
	InvIcon.ID = ent;
	InvIcon:SetToolTip(v.Description)
		
		local function DeleteMyself()

			InvIcon:SetVisible( false );

		end
		
		InvIcon.DoClick = function ( btn )
		
			local ContextMenu = DermaMenu()
			ContextMenu:AddOption("Put into ".. name, function() LocalPlayer():ConCommand("container_putitem ".. ent:EntIndex() .. " " .. v.Class); DeleteMyself(); end);
			ContextMenu:AddOption("Use", function() LocalPlayer():ConCommand("rp_useinvitem ".. v.Class); DeleteMyself(); end);
			ContextMenu:Open();
			
		end
		
		InvIcon.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5);
			surface.DrawText(v.Name)
		end
		
		InvIcon.PaintOverHovered = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5);
			surface.DrawText(v.Name)
		end
		
	InvIcon.LayoutEntity = function( self, ent )
		
			ent:SetAngles( Angle( 0, 90, 100 ) );
		
	end
		
		Backpack:AddItem(InvIcon);
	end

		SearchPropertySheet:AddSheet( name, Items, "gui/silkicons/box", false, false, "View contents of ".. name)
		SearchPropertySheet:AddSheet( "Backpack", Backpack, "gui/silkicons/box", false, false, "View your inventory.")
end

function ClearSearchGUI()

SearchTable = { }

end
usermessage.Hook( "clearsearchgui", ClearSearchGUI );

function UpdateSearchGUI()

for k,v in pairs( SearchTable ) do

	local ItemIcon = vgui.Create( "DModelPanel" )
	ItemIcon:SetSize( 128, 128 )
	ItemIcon:SetModel( v.Model )
	ItemIcon:SetAnimSpeed( 0.0 )
	ItemIcon:SetAnimated( false )
	ItemIcon:SetAmbientLight( Color( 50, 50, 50 ) )
	ItemIcon:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	ItemIcon:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	ItemIcon:SetCamPos( Vector( 0, 0, 45 ) )
	ItemIcon:SetLookAt( Vector( 0, 0, 45 ) )
	ItemIcon:SetFOV( 70 )
	ItemIcon:SetToolTip("Item");
	Items:AddItem(ItemIcon);

end

end
usermessage.Hook( "updatesearchgui", UpdateSearchGUI );

function msgStartSearch( data )

StartSearch( data:ReadString(), data:ReadEntity() );

end
usermessage.Hook( "startsearch", msgStartSearch );

function GetData( data )

	local itemdata = {}
	itemdata.Model = data:ReadString();
    itemdata.Takeable = data:ReadBool();
	itemdata.Class = data:ReadString();
	itemdata.Entity = data:ReadEntity();
	itemdata.Name = data:ReadString();
	itemdata.Description = data:ReadString();

	table.insert(SearchTable, itemdata);

end
usermessage.Hook("addsearchitem", GetData);


