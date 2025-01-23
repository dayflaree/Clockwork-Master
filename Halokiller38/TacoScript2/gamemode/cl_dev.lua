
itemviewerrows = 32;
itemviewercols = 32;

if( itemviewer ) then

	if( itemviewer.RemoveTitleBar ) then
		itemviewer:RemoveTitleBar();
	end
	
	itemviewer:Remove();
	
end

itemviewer = nil;

function createItemViewer()

	itemviewer = CreateBPanel( "Icon Creator", 100, 100, 700, 600 );
	itemviewer.mode = 1;

	itemviewer.fov = 90;

	itemviewer.PaintHook = function()
	
		if( itemviewer.mode == 1 ) then
			draw.RoundedBox( 2, 10, 30, itemviewercols, itemviewerrows, Color( 0, 0, 200, 100 ) );
		elseif( itemviewer.mode == 2 ) then
			draw.RoundedBox( 2, 10, 30, 350, 190, Color( 0, 0, 200, 100 ) );
		else
			draw.RoundedBox( 2, 10, 30, 200, 200, Color( 0, 0, 200, 100 ) );
		end
		
	end
	
	itemviewer.modelpath = vgui.Create( "DTextEntry", itemviewer );
	itemviewer.modelpath:SetPos( 580, 440 );
	itemviewer.modelpath:SetSize( 200, 16 );
	itemviewer.modelpath:SetEnterAllowed( true );
	itemviewer.modelpath:MakePopup();
	
	itemviewer.modelpath.OnEnter = function( self )
	
		if( string.gsub( self:GetValue(), " ", "" ) == "" ) then return; end 
	
		if( itemviewer.model ) then
			itemviewer.model:Remove();
		end
	
		local x, y = itemviewer:GetPos();
	
		itemviewer.model = vgui.Create( "DModelPanel", itemviewer );
		itemviewer.model:SetPos( x + 10, y + 30 );
		
		if( itemviewer.mode == 1 ) then
			itemviewer.model:SetSize( itemviewercols, itemviewerrows );
		elseif( itemviewer.mode == 2 ) then
			itemviewer.model:SetSize( 350, 190 );
		else
			itemviewer.model:SetSize( 200, 200 );
		end
	
		itemviewer.model:SetModel( self:GetValue() );
		itemviewer.model:SetAnimated( false );
		itemviewer.model:SetAmbientLight( Color( 255, 255, 255 ) );
		itemviewer.model:SetCamPos( Vector( 50, 50, 50 ) )
	 	itemviewer.model:SetLookAt( Vector( 0, 0, 40 ) )
		itemviewer.model:SetFOV( 90 );
		itemviewer.model:SetMouseInputEnabled( false );
		itemviewer.model:MakePopup();
		
		itemviewer.model.LayoutEntity = function( self, ent )
		
			ent:SetAngles( Angle( 0, 0, 0 ) );
		
		end
	
	end
	
	itemviewer:AddLabel( "Height", "Default", 570, 380, Color( 255, 255, 255, 255 ) );
	
	itemviewer.Rows = vgui.Create( "DTextEntry", itemviewer );
	itemviewer.Rows:SetPos( 730, 500 ); --270, 100
	itemviewer.Rows:SetSize( 48, 16 );
	itemviewer.Rows:SetText( 32 );
	itemviewer.Rows:MakePopup();
	
	itemviewer.Rows.OnEnter = function( self )
	
		itemviewerrows = tonumber( self:GetValue() );
		
		if( not itemviewerrows ) then
			itemviewerrows = 0;
		end
		
		if( itemviewer.model ) then
			itemviewer.model:SetSize( itemviewercols, itemviewerrows );
			itemviewer.model:MakePopup();
		end
		
	end
	
	itemviewer:AddLabel( "Width", "Default", 570, 360, Color( 255, 255, 255, 255 ) );

	itemviewer.Cols = vgui.Create( "DTextEntry", itemviewer );
	itemviewer.Cols:SetPos( 730, 480 );
	itemviewer.Cols:SetSize( 48, 16 );
	itemviewer.Cols:SetText( 32 );
	itemviewer.Cols:MakePopup();
	itemviewer.Cols.OnEnter = function( self )
	
		itemviewercols = tonumber( self:GetValue() );
		
		if( not itemviewercols ) then
			itemviewercols = 0;
		end
		
		if( itemviewer.model ) then
			itemviewer.model:SetSize( itemviewercols, itemviewerrows );
			itemviewer.model:MakePopup();
		end
		
		
	end
	
	local name = { }
	name[1] = "x";
	name[2] = "y";
	name[3] = "z";
	
	itemviewer.ObjectPos = { }
	
	for j = 1, 3 do
	
		itemviewer.ObjectPos[j] = vgui.Create( "DNumSlider", itemviewer );
		itemviewer.ObjectPos[j]:SetPos( 480, 400 + 16 * j );
		itemviewer.ObjectPos[j]:SetSize( 200, 16 );
		itemviewer.ObjectPos[j]:SetText( "Camera Position - " .. name[j] );
		itemviewer.ObjectPos[j]:SetMin( -200 );
		itemviewer.ObjectPos[j]:SetMax( 200 );
		itemviewer.ObjectPos[j]:SetDecimals( 0 );
		itemviewer.ObjectPos[j]:SetValue( 50 );
		itemviewer.ObjectPos[j].ValueChanged = function( self )
			
			itemviewer.model:SetCamPos( Vector( itemviewer.ObjectPos[1]:GetValue(),
											 	itemviewer.ObjectPos[2]:GetValue(),
											 	itemviewer.ObjectPos[3]:GetValue() ) )
			
			itemviewer.model:MakePopup();
			
		end
		
		itemviewer.ObjectPos[j].id = j;
	
	end
	
	itemviewer.CamPos = { }
	
	for j = 1, 3 do
	
		itemviewer.CamPos[j] = vgui.Create( "DNumSlider", itemviewer );
		itemviewer.CamPos[j]:SetPos( 480, 460 + 16 * j );
		itemviewer.CamPos[j]:SetSize( 200, 16 );
		itemviewer.CamPos[j]:SetText( "Look at Position - " .. name[j] );
		itemviewer.CamPos[j]:SetMin( -200 );
		itemviewer.CamPos[j]:SetMax( 200 );
		itemviewer.CamPos[j]:SetDecimals( 0 );
		itemviewer.CamPos[j]:SetValue( 0 );
		
		if( j == 3 ) then
			itemviewer.CamPos[j]:SetValue( 40 );
		end
		
		itemviewer.CamPos[j].ValueChanged = function( self )
			
			itemviewer.model:SetLookAt( Vector( itemviewer.CamPos[1]:GetValue(),
											 	itemviewer.CamPos[2]:GetValue(),
											 	itemviewer.CamPos[3]:GetValue() ) )
			
			itemviewer.model:MakePopup();
			
		end
		
		itemviewer.CamPos[j].id = j;
	
	end
	
	itemviewer.Fov = vgui.Create( "DNumSlider", itemviewer );
	itemviewer.Fov:SetPos( 480, 530 );
	itemviewer.Fov:SetSize( 200, 16 );
	itemviewer.Fov:SetText( "FOV" );
	itemviewer.Fov:SetMin( 1 );
	itemviewer.Fov:SetMax( 200 );
	itemviewer.Fov:SetDecimals( 0 );
	itemviewer.Fov:SetValue( 90 );
	itemviewer.Fov.ValueChanged = function( self )
		itemviewer.fov = self:GetValue();
		itemviewer.model:SetFOV( itemviewer.fov );
		itemviewer.model:MakePopup();
	end
	
	local function output()
		
		Msg( "Model = \"" .. itemviewer.modelpath:GetValue() .. "\"\n" );
		Msg( "CamPos = ( " ..  itemviewer.ObjectPos[1]:GetValue() .. ", " .. itemviewer.ObjectPos[2]:GetValue() .. ", " .. itemviewer.ObjectPos[3]:GetValue() .. " ) \n" );
		Msg( "LookAt = ( " ..  itemviewer.CamPos[1]:GetValue() .. ", " .. itemviewer.CamPos[2]:GetValue() .. ", " .. itemviewer.CamPos[3]:GetValue() .. " ) \n" );
		Msg( "FOV = " .. itemviewer.Fov:GetValue() .. "\n" );
		
	end
	
	itemviewer:AddButton( "Output Icon Info", 480, 560, output );
	
end
concommand.Add( "itemviewer", createItemViewer );

if( animviewer ) then

	if( animviewer.RemoveTitleBar ) then
		animviewer:RemoveTitleBar();
	end
	
	animviewer:Remove();
	animviewer = nil;
	
end

function createAnimationViewer()

	gui.EnableScreenClicker( true );

	animviewer = CreateBPanel( "Animation Viewer", 100, 100, 300, 400 );
	animviewer.ModelPanel = vgui.Create( "DModelPanel", animviewer );
	
	animviewer.CurrentAnimation = 1;
	
	local doitonce = false;

	local animlist = { }
	
	animviewer.ModelPanel:SetModel( "models/Humans/Group01/Male_01.mdl" );
	animviewer.ModelPanel:SetCamPos( Vector( 50, -31, 44 ) );
	animviewer.ModelPanel:SetLookAt( Vector( 0, 4, 37 ) ); 
	animviewer.ModelPanel:SetFOV( 90 );
	animviewer.ModelPanel:SetPos( 50, 5 );
	animviewer.ModelPanel:SetSize( 200, 200 );
	animviewer.ModelPanel.LayoutEntity = function( self, ent )
	
		ent:SetAngles( Angle( 0, 0, 0 ) );

		ent:ResetSequence( ent:SelectWeightedSequence( animviewer.CurrentAnimation ) );

		self:SetAnimSpeed( 1.0 );
		self:RunAnimation();

		if( not doitonce and ent and ent:IsValid() ) then
		
			animlist = { }
		
			for n = 1, 3000 do
			
				if( ent:SelectWeightedSequence( n ) ~= -1 ) then
				
					table.insert( animlist, n );
				
				end
			
			end
			
			doitonce = true;
			
		end
	
	end
	
	local animviewermodels =
	{
	
		"models/Humans/Group01/Male_01.mdl",
		"models/Humans/Group01/Female_01.mdl",
		"models/police.mdl",
		"models/combine_soldier.mdl",
		"models/Combine_Scanner.mdl",
		"models/Combine_Strider.mdl",
		"models/gunship.mdl"
	}
	
	animviewer.ModelSelect = vgui.Create( "DMultiChoice", animviewer );
	animviewer.ModelSelect:SetPos( 20, 210 );
	animviewer.ModelSelect:SetSize( 250, 16 );
	
	for n = 1, #animviewermodels do
	
		animviewer.ModelSelect:AddChoice( animviewermodels[n] );
	
	end	
	
	animviewer.ModelSelect:ChooseOptionID( 1 );
	
	animviewer.ModelSelect.OnSelect = function( self, index, value, data )
	
		animviewer.ModelPanel:SetModel( value );
		
		doitonce = false;
	
	end

	animviewer.CurrentAnim = vgui.Create( "DTextEntry", animviewer );
	animviewer.CurrentAnim:MakePopup();
	animviewer.CurrentAnim:SetPos( 60, 350 );
	animviewer.CurrentAnim:SetSize( 150, 16 );
	animviewer.CurrentAnim:SetText( animviewer.CurrentAnimation );
	animviewer.CurrentAnim:SetKeyboardInputEnabled( true );
	animviewer.CurrentAnim:SetText( animviewer.CurrentAnimation );
	
	animviewer.CurrentAnim.Think = function()
		local x, y = animviewer:GetPos();
		animviewer.CurrentAnim:SetPos( 70 + x, 230 + y );
	end
	
	animviewer.CurrentAnim.OnEnter = function( self )
	
		local newanim = tonumber( animviewer.CurrentAnim:GetValue() ) or 1;
		
		if( newanim < 0 ) then 
			newanim = 1;
		end
		
		animviewer.CurrentAnimation = newanim;
	
	end
	
	local ACT_LIST = {}
	
	for i, v in pairs(_G) do
		if string.find(i, "ACT_") then
			ACT_LIST[v] = i
		end
	end
	
	local function LookupAnimationName(id)
		if ACT_LIST[id] then
			return ACT_LIST[id]
		else
			return id
		end
	end
	
	local function SearchAnim(ply, cmd, str)
		if type(str) == "table" then
			str = str[1]
		end
		for i, v in pairs(ACT_LIST) do
			if string.find(v, str) then
				print(i, ": ", v)
			end
		end
	end
	concommand.Add("dev_sa", SearchAnim)
	
	local function GoRight()
	
		animviewer.CurrentAnimation = animviewer.CurrentAnimation + 1;
	
		while( not table.HasValue( animlist, animviewer.CurrentAnimation ) ) do
		
			animviewer.CurrentAnimation = animviewer.CurrentAnimation + 1;
			
			if( animviewer.CurrentAnimation > 3000 ) then
			
				animviewer.CurrentAnimation = 1;
			
			end
		
		end
	
		animviewer.CurrentAnim:SetText(LookupAnimationName(animviewer.CurrentAnimation));
		LocalPlayer().ForcedAnimation = animviewer.CurrentAnimation
	end
	
	local function GoLeft()
	
		animviewer.CurrentAnimation = animviewer.CurrentAnimation - 1;
	
		while( not table.HasValue( animlist, animviewer.CurrentAnimation ) ) do
		
			animviewer.CurrentAnimation = animviewer.CurrentAnimation - 1;
			
			if( animviewer.CurrentAnimation < 1 ) then
			
				animviewer.CurrentAnimation = animlist[#animlist];
			
			end
		
		end

		animviewer.CurrentAnim:SetText(LookupAnimationName(animviewer.CurrentAnimation));
		LocalPlayer().ForcedAnimation = animviewer.CurrentAnimation
	end
	
	animviewer.Left = animviewer:AddButton( "<", 45, 227, GoLeft );
	animviewer.Right = animviewer:AddButton( ">", 225, 227, GoRight );

end
concommand.Add( "animviewer", createAnimationViewer );


local function CalcAngles()

	local function f(val)
		return tostring(math.Round(val));
	end

	local pos = LocalPlayer():GetPos();
	local ang = LocalPlayer():GetAngles();
	
	Msg( "TS.MapViews[\"" .. game.GetMap() .. "\"] =\n" );
	Msg( "{\n");
	Msg( "\tpos = Vector( " .. f(pos.x) .. ", " .. f(pos.y) .. ", " .. f(pos.z) .. " );\n" );
	Msg( "\tang = Angle( " .. f(ang.p) .. ", " .. f(ang.y) .. ", " .. f(ang.r) .. " );\n" );
	Msg( "}\n");
	
end
concommand.Add( "ca", CalcAngles );

local function CalcPosition()

	local trace = {};
	trace.start = LocalPlayer():EyePos();
	trace.endpos = trace.start + LocalPlayer():GetAimVector() * 2000;
	trace.filter = LocalPlayer();
	
	local tr = util.TraceLine( trace );
	
	if tr.HitWorld then
		Msg( "TS.Spawns[\"" .. game.GetMap() .. "\"] =\n" );
		Msg( "{\n" );
		Msg( "\tx = " .. math.Round(tr.HitPos.x) .. ";\n\ty = " .. math.Round(tr.HitPos.y) .. ";\n\tz = " .. math.Round(tr.HitPos.z)  .. ";\n" );
		Msg( "}\n" );
	else
		Msg( "Must hit world" );
	end

end
concommand.Add( "cp", CalcPosition );

if( MEPropertiesWindow ) then
	if( MEPropertiesWindow.TitleBar ) then
		MEPropertiesWindow.TitleBar:Remove();
	end
	MEPropertiesWindow:Remove();
end
MEPropertiesWindow = nil;

function MapEditorMode( msg )

	MEPropertiesWindow = CreateBPanel( "Properties List", 10, 10, 200, 250 );
	MEPropertiesWindow:SetVisible( PlayerMenuVisible );
	MEPropertiesWindow:EnableScrolling( true );
	MEPropertiesWindow.TitleBar:SetVisible( PlayerMenuVisible );
	
	MEPropertiesWindow.OnClose = function()
	
		MEPropertiesWindow.Menu:Remove();
	
	end
	
	MEPropertiesWindow.Properties = { }
	
	MEPropertiesWindow:AddButton( "New Property", 5, 5, function()
	
		local newproperty = CreateBPanel( "New Property", ScrW() / 2, ScrH() / 2, 150, 80 );
		newproperty:AddLabel( "Name? ", "NewChatFont", 10, 3 );
		
		local x, y = newproperty:GetPos();
		
		local entry = vgui.Create( "DTextEntry", newproperty );
		entry:SetPos( x + 7, y + 20 );
		entry:SetSize( 130, 16 );
		entry:MakePopup();
		
		newproperty:AddButton( "Ok", 65, 40, function() RunConsoleCommand( "rpa_me_newproperty", entry:GetValue() ); newproperty.TitleBar:Remove(); newproperty:Remove(); end );
		newproperty:AddButton( "Cancel", 95, 40, function() newproperty.TitleBar:Remove(); newproperty:Remove(); end );
		
	end );
	
	MEPropertiesWindow.Menu = CreateBPanel( "Map Editor Menu", 10, 300, 200, 200 );
	MEPropertiesWindow.Menu:SetVisible( PlayerMenuVisible );
	MEPropertiesWindow.Menu.TitleBar:SetVisible( PlayerMenuVisible );
	MEPropertiesWindow.Menu:CanClose( false );
	
	MEPropertiesWindow.Menu:AddButton( "Save map data", 10, 10, function() RunConsoleCommand( "rpa_me_savemap", "" ); end );
	
end
usermessage.Hook( "MEM", MapEditorMode );

function GetProperty( id )

	for k, v in pairs( MEPropertiesWindow.Properties ) do
		
		if( v.id == id ) then
			return MEPropertiesWindow.Properties[k];
		end
	
	end

end

CurrentDoorTarget = nil;

function DrawMapEditorShit()

	if( CurrentDoorTarget and CurrentDoorTarget:IsValid() ) then
	
		local pos = CurrentDoorTarget:GetPos():ToScreen();
		
		draw.DrawText( "Target", "GiantChatFont", pos.x, pos.y, Color( 200, 200, 200, 120 ) );
	
	end

end

function UpdateDoor( msg )

	local door = msg:ReadEntity();
	local name = msg:ReadString();
	local price = msg:ReadShort();
	local flags = msg:ReadString();
	local family = msg:ReadString();
	local w = msg:ReadShort();
	local h = msg:ReadShort();
	
	door.DoorName = name;
	door.DoorPrice = price;
	door.DoorFlags = flags;
	door.DoorFamily = family;
	door.StorageWidth = w;
	door.StorageHeight = h;
	
end
usermessage.Hook( "MEUD", UpdateDoor );

function DoorEditor( msg )
			
	local door = msg:ReadEntity();
	local name = msg:ReadString();
	local price = msg:ReadShort();
	local flags = msg:ReadString();
	local family = msg:ReadString();
	local width = msg:ReadShort();
	local height = msg:ReadShort();
	
	CurrentDoorTarget = door;
	
	door.DoorName = name;
	door.DoorPrice = price;
	door.DoorFlags = flags;
	door.DoorFamily = family;
	door.StorageWidth = w;
	door.StorageHeight = h;
	
	property = CreateBPanel( "Door Editor", 5, 20, 190, 260 );
	property:SetParent( property );
	
	local parent = "";
	local child = "";
	
	if( string.find( family, ":" ) ) then
	
		parent = string.sub( family, 1, string.find( family, ":" ) - 1 );
		child = string.sub( family, string.find( family, ":" ) + 1 );
	
	end
	
	local parententry = vgui.Create( "DTextEntry", property );
	parententry:SetSize( 40, 16 );
	parententry:MakePopup();
	parententry.Think = function()
	
		local x, y = property:GetPos();
		parententry:SetPos( x + 145, y + 153 );
		
	end
	parententry:SetValue( parent );
	
	local childentry = vgui.Create( "DTextEntry", property );
	childentry:SetSize( 40, 16 );
	childentry:MakePopup();
	childentry.Think = function()
	
		local x, y = property:GetPos();
		childentry:SetPos( x + 145, y + 173 );
		
	end
	childentry:SetValue( child );
	
	local nameentry = vgui.Create( "DTextEntry", property );
	nameentry:SetSize( 40, 16 );
	nameentry:MakePopup();
	nameentry.Think = function()
	
		local x, y = property:GetPos();
		nameentry:SetPos( x + 145, y + 193 );
		
	end
	nameentry:SetValue( name );
	
	local priceentry = vgui.Create( "DTextEntry", property );
	priceentry:SetSize( 40, 16 );
	priceentry:MakePopup();
	priceentry.Think = function()
	
		local x, y = property:GetPos();
		priceentry:SetPos( x + 145, y + 213 );
		
	end
	priceentry:SetValue( price );
	
	local wentry = vgui.Create( "DTextEntry", property );
	wentry:SetSize( 40, 16 );
	wentry:MakePopup();
	wentry.Think = function()
	
		local x, y = property:GetPos();
		wentry:SetPos( x + 145, y + 113 );
		
	end
	wentry:SetValue( width );
	
	local hentry = vgui.Create( "DTextEntry", property );
	hentry:SetSize( 40, 16 );
	hentry:MakePopup();
	hentry.Think = function()
	
		local x, y = property:GetPos();
		hentry:SetPos( x + 145, y + 133 );
		
	end
	hentry:SetValue( height );
	
	property.PaintHook = function()
	
		draw.DrawText( "Citizen-Ownable?", "NewChatFont", 165, 7, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Combine-Ownable?", "NewChatFont", 165, 24, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Starts locked?", "NewChatFont", 165, 41, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Owned by Combine?", "NewChatFont", 165, 58, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Special Nexus door?", "NewChatFont", 165, 75, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Is Storage?", "NewChatFont", 165, 92, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Storage-Width: ", "NewChatFont", 142, 112, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Storage-Height: ", "NewChatFont", 142, 132, Color( 255, 255, 255, 255 ), 2 );
		
		draw.DrawText( "Parent Property: ", "NewChatFont", 142, 152, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Child Property: ", "NewChatFont", 142, 172, Color( 255, 255, 255, 255 ), 2 );	
	
		draw.DrawText( "Door Name: ", "NewChatFont", 142, 192, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Door Price: ", "NewChatFont", 142, 212, Color( 255, 255, 255, 255 ), 2 );	
	
	
	end
	
	property.CitizenOwnable = vgui.Create( "DCheckBox", property );
	property.CitizenOwnable:SetPos( 170, 5 );
	property.CitizenOwnable:SetSize( 16, 16 );
	
	if( string.find( flags, "c" ) ) then
	
		property.CitizenOwnable:SetValue( true );
	
	end
	
	property.CombineOwnable = vgui.Create( "DCheckBox", property );
	property.CombineOwnable:SetPos( 170, 22 );
	property.CombineOwnable:SetSize( 16, 16 );
	
	if( string.find( flags, "C" ) ) then
	
		property.CombineOwnable:SetValue( true );
	
	end
	
	property.StartsLocked = vgui.Create( "DCheckBox", property );
	property.StartsLocked:SetPos( 170, 39 );
	property.StartsLocked:SetSize( 16, 16 );
	
	if( string.find( flags, "l" ) ) then
	
		property.StartsLocked:SetValue( true );
	
	end
	
	
	property.OwnedByCombine = vgui.Create( "DCheckBox", property );
	property.OwnedByCombine:SetPos( 170, 56 );
	property.OwnedByCombine:SetSize( 16, 16 );
	
	if( string.find( flags, "o" ) ) then
	
		property.OwnedByCombine:SetValue( true );
	
	end
	
	property.SpecialNexusDoor = vgui.Create( "DCheckBox", property );
	property.SpecialNexusDoor:SetPos( 170, 73 );
	property.SpecialNexusDoor:SetSize( 16, 16 );
	
	if( string.find( flags, "n" ) ) then
	
		property.SpecialNexusDoor:SetValue( true );
	
	end
	
	property.IsStorage = vgui.Create( "DCheckBox", property );
	property.IsStorage:SetPos( 170, 91 );
	property.IsStorage:SetSize( 16, 16 );
	
	if( string.find( flags, "s" ) ) then
	
		property.IsStorage:SetValue( true );
	
	end
	
	local function ApplyDoorSettings()
	
		local flags = "";
		
		if( property.CitizenOwnable:GetChecked() ) then
			flags = "c";
		end
		
		if( property.CombineOwnable:GetChecked() ) then
			flags = flags .. "C";
		end
		
		if( property.StartsLocked:GetChecked() ) then
			flags = flags .. "l";
		end
	
		if( property.OwnedByCombine:GetChecked() ) then
			flags = flags .. "o";
		end
		
		if( property.SpecialNexusDoor:GetChecked() ) then
		
			flags = flags .. "n";
		
		end
		
		if( property.IsStorage:GetChecked() ) then
		
			flags = flags .. "s";
		
		end
	
		RunConsoleCommand( "rpa_me_setdoorsettings", door:EntIndex(), nameentry:GetValue(), priceentry:GetValue(), flags, parententry:GetValue() .. ":" .. childentry:GetValue(), wentry:GetValue(), hentry:GetValue()  );
	
	end
	
	property:AddButton( "Apply settings", 40, 235, ApplyDoorSettings );

end
usermessage.Hook( "MEED", DoorEditor );

function BringUpPropertyEditor( id )

	local propertyinfo = GetProperty( id );

	local property = CreateBPanel( propertyinfo.Name .. " Property View", ScrW() / 2, 10, 200, 200 );
	property:SetParent( MEPropertiesWindow );
	property:MakePopup();
	
	property.PaintHook = function()
		
		draw.DrawText( "ID: " .. propertyinfo.id, "NewChatFont", 195, 5, Color( 255, 255, 255, 255 ), 2 );
	
	end
	
	property.AllDoorPanel = CreateBPanel( nil, 5, 20, 190, 155 );
	property.AllDoorPanel:SetParent( property );

	
	local entry = vgui.Create( "DTextEntry", property.AllDoorPanel );
	entry:SetSize( 40, 16 );
	entry:MakePopup();
	entry.Think = function()
	
		local x, y = property:GetPos();
		entry:SetPos( x + 150, y + 130 );
		
	end
	
	local entry = vgui.Create( "DTextEntry", property.AllDoorPanel );
	entry:SetSize( 40, 16 );
	entry:MakePopup();
	entry.Think = function()
	
		local x, y = property:GetPos();
		entry:SetPos( x + 150, y + 150 );
		
	end
	
	property.AllDoorPanel.PaintHook = function()
	
		draw.DrawText( "Citizen-Ownable?", "NewChatFont", 165, 7, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Combine-Ownable?", "NewChatFont", 165, 24, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Starts locked?", "NewChatFont", 165, 41, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Owned by Combine?", "NewChatFont", 165, 58, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Special Nexus door?", "NewChatFont", 165, 75, Color( 255, 255, 255, 255 ), 2 );
		
		draw.DrawText( "Parent Property: ", "NewChatFont", 142, 92, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( "Child Property: ", "NewChatFont", 142, 112, Color( 255, 255, 255, 255 ), 2 );	
	
	end
	
	property.AllDoorPanel.CitizenOwnable = vgui.Create( "DCheckBox", property.AllDoorPanel );
	property.AllDoorPanel.CitizenOwnable:SetPos( 170, 5 );
	property.AllDoorPanel.CitizenOwnable:SetSize( 16, 16 );
	
	property.AllDoorPanel.CombineOwnable = vgui.Create( "DCheckBox", property.AllDoorPanel );
	property.AllDoorPanel.CombineOwnable:SetPos( 170, 22 );
	property.AllDoorPanel.CombineOwnable:SetSize( 16, 16 );
	
	property.AllDoorPanel.StartsLocked = vgui.Create( "DCheckBox", property.AllDoorPanel );
	property.AllDoorPanel.StartsLocked:SetPos( 170, 39 );
	property.AllDoorPanel.StartsLocked:SetSize( 16, 16 );
	
	property.AllDoorPanel.OwnedByCombine = vgui.Create( "DCheckBox", property.AllDoorPanel );
	property.AllDoorPanel.OwnedByCombine:SetPos( 170, 56 );
	property.AllDoorPanel.OwnedByCombine:SetSize( 16, 16 );
	
	property.AllDoorPanel.SpecialNexusDoor = vgui.Create( "DCheckBox", property.AllDoorPanel );
	property.AllDoorPanel.SpecialNexusDoor:SetPos( 170, 73 );
	property.AllDoorPanel.SpecialNexusDoor:SetSize( 16, 16 );
	
	property.AllDoorPanel:AddButton( "Apply to all property doors", 10, 130 );
	
end

function MapEditorAddProperty( msg )

	if( MEPropertiesWindow ) then
	
		local id = msg:ReadShort();
		local name = msg:ReadString();
		
		MEPropertiesWindow:AddLink( name .. " - " .. id, "NewChatFont", 5, 30 + 16 * #MEPropertiesWindow.Properties, Color( 100, 100, 255, 255 ), function()  end );
		
		local newproperty = { }
		
		newproperty.Name = name;
		newproperty.id = id;
		newproperty.Doors = { }
		
		table.insert( MEPropertiesWindow.Properties, newproperty );
	
	end

end
usermessage.Hook( "MEAP", MapEditorAddProperty );
