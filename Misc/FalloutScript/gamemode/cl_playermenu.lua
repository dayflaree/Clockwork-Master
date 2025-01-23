
InventoryTable = {}

function AddItem(data)
	local itemdata = {}
	itemdata.Class = data:ReadString();
	itemdata.Name = data:ReadString();
	itemdata.Model = data:ReadString();
	itemdata.Description = data:ReadString();
	--itemdata.LongDescription = data:ReadString()
	itemdata.Weight = data:ReadString()
	itemdata.Dist = data:ReadFloat()
	itemdata.Damage = data:ReadString()
	itemdata.DamageType = data:ReadString()
	itemdata.AmmoType = data:ReadString()
	itemdata.AmmoCapacity = data:ReadString()
	itemdata.MinStrength = data:ReadString()
	
	table.insert(InventoryTable, itemdata);
end
usermessage.Hook("addinventory", AddItem);

function ClearItems()
	
	InventoryTable = {}
	
end
usermessage.Hook("clearinventory", ClearItems);

BusinessTable = {};

function AddBusinessItem(data)
	local itemdata = {}
	itemdata.Class = data:ReadString();
	itemdata.Name = data:ReadString();
	itemdata.Model = data:ReadString();
	itemdata.Description = data:ReadString();
	itemdata.Price = data:ReadLong();
	--itemdata.Weight = data:ReadString()
	-- itemdata.Dist = data:ReadFloat()
	-- itemdata.Damage = data:ReadString()
	-- itemdata.DamageType = data:ReadString()
	-- itemdata.AmmoType = data:ReadString()
	-- itemdata.AmmoCapacity = data:ReadString()
	-- itemdata.MinStrength = data:ReadString()
	-- temdata.LongDescription = data:ReadString()
	
	table.insert(BusinessTable, itemdata);
end
usermessage.Hook("addbusiness", AddBusinessItem);

function ClearBusinessItems()
	
	BusinessTable = {}
	
end
usermessage.Hook("clearbusiness", ClearBusinessItems);

function HasZiptie( ent )

if( ent:HasItem("item_ziptie") ) then return true; end

return false;
end

function InitHiddenButton()
	HiddenButton = vgui.Create("DButton") -- WHAT A HACKY METHOD 
	HiddenButton:SetSize(ScrW(), ScrH());
	HiddenButton:SetText("");
	HiddenButton:SetDrawBackground(false);
	HiddenButton:SetDrawBorder(false);
	HiddenButton.DoRightClick = function()
		local Vect = gui.ScreenToVector(gui.MouseX(), gui.MouseY());
		local tracedata = {};
		tracedata.start = LocalPlayer():GetShootPos();
		tracedata.endpos = LocalPlayer():GetShootPos() + (Vect * 100);
		tracedata.filter = LocalPlayer();
		local trace = util.TraceLine(tracedata);
		
		if(trace.HitNonWorld) then
			local target = trace.Entity;
			
			if( LocalPlayer():GetNWInt( "tiedup" ) == 1 ) then return false; end
			
			local ContextMenu = DermaMenu()
				if(LEMON.IsDoor(target)) then
					ContextMenu:AddOption("Rent/Unrent Door", function() LocalPlayer():ConCommand("rp_purchasedoor " .. target:EntIndex()) end);
					ContextMenu:AddOption("Lock", function() LocalPlayer():ConCommand("rp_lockdoor " .. target:EntIndex()) end);
					ContextMenu:AddOption("Unlock", function() LocalPlayer():ConCommand("rp_unlockdoor " .. target:EntIndex()) end);
				-- we might add a lockpick just for this
				--if(team.GetName(LocalPlayer():Team()) == "Resistance") then
				--ContextMenu:AddOption("Picklock Door", function() LocalPlayer():ConCommand("rp_picklock " .. target:EntIndex()) end);
                --end
				elseif( LEMON.IsLetter(target) ) then
				
				ContextMenu:AddOption("Read", function() LocalPlayer():ConCommand("rp_readletter " .. target:EntIndex()) end);
				
				-- elseif( target:GetNWBool( "container2" ) == true ) then
				
				-- ContextMenu:AddOption("Search", function() LocalPlayer():ConCommand("rp_search2 " .. target:EntIndex()) end);
				
				elseif(target:GetClass() == "item_prop") then
					ContextMenu:AddOption("Pick Up", function() LocalPlayer():ConCommand("rp_pickup " .. target:EntIndex()) end);
					ContextMenu:AddOption("Use", function() LocalPlayer():ConCommand("rp_useitem " .. target:EntIndex()) end);
					--ContextMenu:AddOption("Details", function() RunConsoleCommand( "rp_itemdetails", v.Class, v.Name, v.Model, v.Description, v.Weight, v.Dist, v.Damage, v.DamageType, v.AmmoType, v.AmmoCapacity, v.MinStrength ) end);

				elseif( target:GetNWBool( "container" ) == true ) then

				ContextMenu:AddOption("Search", function() LocalPlayer():ConCommand("rp_search " .. target:EntIndex()) end);
				
				elseif(target:IsPlayer()) then
					local function PopupCredits()
						local CreditPanel = vgui.Create( "DFrame" );
						CreditPanel:SetPos(gui.MouseX(), gui.MouseY());
						CreditPanel:SetSize( 200, 175 )
						CreditPanel:SetTitle( "Give " .. target:Nick() .. " money");
						CreditPanel:SetVisible(true);
						CreditPanel:SetDraggable(true);
						CreditPanel:ShowCloseButton(true);
						CreditPanel:MakePopup();
						
						local Credits = vgui.Create( "DNumSlider", CreditPanel );
						Credits:SetPos( 25, 50 );
						Credits:SetWide(150);
						Credits:SetText("Money to Give");
						Credits:SetMin( 0 );
						Credits:SetMax( tonumber(LocalPlayer():GetNWString("money")) );
						Credits:SetDecimals( 0 );
						
						local Give = vgui.Create( "DButton", CreditPanel );
						Give:SetText("Give");
						Give:SetPos( 25, 125 );
						Give:SetSize( 150, 25 );
						Give.DoClick = function()
							LocalPlayer():ConCommand("rp_givemoney " .. target:EntIndex() .. " " .. Credits:GetValue());
							CreditPanel:Remove();
							CreditPanel = nil;
						end
					end
					
					ContextMenu:AddOption("Give Money", PopupCredits);

					if(target:GetNWInt("tiedup") == 0) then
						ContextMenu:AddOption("Tie Up", function() LocalPlayer():ConCommand("rp_ziptie " .. target:EntIndex()) end);
					elseif(target:GetNWInt("tiedup") == 1) then
						ContextMenu:AddOption("Untie", function() LocalPlayer():ConCommand("rp_ziptie " .. target:EntIndex()) end);
					end
				end
			ContextMenu:Open();
		end
	end
end

function CreateDevModelWindow()

	if(DevModelWindow) then
	
		DevModelWindow:Remove();
		DevModelWindow = nil;
		
	end

	DevModelWindow = vgui.Create( "DFrame" )
	DevModelWindow:SetTitle("Model Information");

	local mdlPanel = vgui.Create( "DModelPanel", DevModelWindow )
	mdlPanel:SetSize( 300, 300 )
	mdlPanel:SetPos( 10, 20 )
	mdlPanel:SetModel( "models/weapons/w_smg1.mdl" )
	mdlPanel:SetAnimSpeed( 0.0 )
	mdlPanel:SetAnimated( false )
	mdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	mdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	mdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	mdlPanel:SetCamPos( Vector( 0, 0, 45 ) )
	mdlPanel:SetLookAt( Vector( 0, 0, 45 ) )
	mdlPanel:SetFOV( 70 )

	
	local RotateSliderTwo = vgui.Create("DNumSlider", DevModelWindow);
	RotateSliderTwo:SetMax(360);
	RotateSliderTwo:SetMin(0);
	RotateSliderTwo:SetText("Rotate X");
	RotateSliderTwo:SetDecimals( 0 );
	RotateSliderTwo:SetWidth(300);
	RotateSliderTwo:SetPos(10, 290);
	
	local RotateSlider = vgui.Create("DNumSlider", DevModelWindow);
	RotateSlider:SetMax(360);
	RotateSlider:SetMin(0);
	RotateSlider:SetText("Rotate Y");
	RotateSlider:SetDecimals( 0 );
	RotateSlider:SetWidth(300);
	RotateSlider:SetPos(10, 320);
	
	local RotateSliderThree = vgui.Create("DNumSlider", DevModelWindow);
	RotateSliderThree:SetMax(360);
	RotateSliderThree:SetMin(0);
	RotateSliderThree:SetText("Rotate Z");
	RotateSliderThree:SetDecimals( 0 );
	RotateSliderThree:SetWidth(300);
	RotateSliderThree:SetPos(10, 350);
	
	local OpenButton = vgui.Create( "DButton" );
	OpenButton:SetText("Get Angles");
	OpenButton:SetPos(10, 20);
	OpenButton.DoClick = function()
	Msg("\nEntity Angles: ".. tostring(mdlPanel.Entity:GetAngles()));
	end

	function mdlPanel:LayoutEntity(Entity)

		Entity:SetAngles( Angle( RotateSliderTwo:GetValue(), RotateSlider:GetValue(), RotateSliderThree:GetValue()) )

	end

	DevModelWindow:SetSize( 320, 420 )
	DevModelWindow:Center()	
	DevModelWindow:MakePopup()
	DevModelWindow:SetKeyboardInputEnabled( false )
	
end
local scrwidth = ScrW()
function InitHUDMenu()

	InitHiddenButton();
if LocalPlayer():Alive() then
	local spawnicon = vgui.Create( "SpawnIcon" );
	spawnicon:SetSize( 64, 64 );
	spawnicon:SetPos( scrwidth - 155, 65 );
	spawnicon:SetIconSize( 64 )
	spawnicon:SetModel(LocalPlayer():GetModel())
	spawnicon:SetToolTip(LocalPlayer():GetModel())
	
	function UpdateGUIData()
		spawnicon:SetModel(LocalPlayer():GetModel());
		spawnicon:SetToolTip( LocalPlayer():Nick() );
	end
	
	spawnicon.PaintOver = function()
		spawnicon:SetPos(scrwidth - 155, 65);
		UpdateGUIData();
		
	end
	
	spawnicon.PaintOverHovered = function()
		
		spawnicon:SetPos(scrwidth - 155, 65);
		UpdateGUIData();
		
	end
end
	-- HUDMenu = vgui.Create( "HudPanel" )
	-- HUDMenu:SetPos( ScrW() - 130 - 5, 5 )
	-- HUDMenu:SetSize( 130, 150 )
	-- HUDMenu:SetTitle( "Identification Card" )
	-- HUDMenu:SetVisible( true )
	-- HUDMenu:SetDraggable( false )
	-- HUDMenu:ShowCloseButton( false )

	-- local label = vgui.Create("DLabel", HUDMenu);
	-- label:SetWide(0);
	-- label:SetPos(5, 25);
	-- label:SetText("Name: " .. LocalPlayer():Nick());

	-- local label2 = vgui.Create("DLabel", HUDMenu);
	-- label2:SetWide(0);
	-- label2:SetPos(5, 40);
	-- label2:SetText("Title: " .. LocalPlayer():GetNWString("title"));
	
	-- local label3 = vgui.Create("DLabel", HUDMenu);
	-- label3:SetWide(0);
	-- label3:SetPos(5, 55);
	-- label3:SetText("Class: " .. team.GetName(LocalPlayer():Team()));
	
	-- local label4 = vgui.Create("DLabel", HUDMenu);
	-- label4:SetWide(0);
	-- label4:SetPos(5, 70);
	-- label4:SetText( "$" .. LocalPlayer():GetNWString("money") .. " Caps");

		-- local spawnicon = vgui.Create( "DModelPanel", HUDMenu )
		-- spawnicon:SetModel( LocalPlayer():GetModel() )
		-- spawnicon:SetPos( 1, 21 )
		-- spawnicon:SetSize( 128, 128 )
		-- spawnicon:SetFOV( 70 )
		-- pawnicon:SetToolTip(LocalPlayer():Nick());

	
	    -- function spawnicon:LayoutEntity(Entity)

		-- spawnicon:RunAnimation()
	    -- spawnicon:SetModel(LocalPlayer():GetModel())

	    -- end

		
	-- local FadeSize = 320;
	
	-- function UpdateGUIData()
		-- label:SetText("Name: " .. LocalPlayer():Nick());
		
		-- label2:SetText("Title: " .. LocalPlayer():GetNWString("title"));
		
		-- label3:SetText("Class: " .. team.GetName(LocalPlayer():Team()));

		-- label4:SetText("$" .. LocalPlayer():GetNWString("money") .. " Caps");

		-- spawnicon:SetModel( LocalPlayer():GetModel() );
		-- pawnicon:SetToolTip( LocalPlayer():Nick() );
	-- end
	
	-- spawnicon.OnCursorEntered = function ()
	
		-- spawnicon:SetPos(FadeSize - 129, 21);
		-- HUDMenu:SetSize(FadeSize, 150);
		-- HUDMenu:SetPos(ScrW() - FadeSize - 5, 5 );
		
		-- label:SetWide(FadeSize - 128);
		-- label2:SetWide(FadeSize - 128);
		-- label3:SetWide(FadeSize - 128);
		-- label4:SetWide(FadeSize - 128);
		
		-- UpdateGUIData();
	-- end
	
	-- spawnicon.OnCursorExited = function ()
	
		-- spawnicon:SetPos(125 - 129, 21);
		-- HUDMenu:SetSize(125, 150);
		-- HUDMenu:SetPos(ScrW() - 125 - 5, 5 );
		
		-- label:SetWide(125 - 128);
		-- label2:SetWide(125 - 128);
		-- label3:SetWide(125 - 128);
		-- label4:SetWide(125 - 128);
	
		-- UpdateGUIData();
	-- end

end

function ItemDetailMenu( ply, cmd, args ) 

	InvFrame = vgui.Create( "InvisiblePanel" )
	InvFrame:SetSize( 500, 300 )
	InvFrame:SetPos( ScrW() / 4, ScrH() / 4 )
	InvFrame:SetTitle( args[2] )
	InvFrame:SetVisible( true )
	InvFrame:SetDraggable( true )
	InvFrame:ShowCloseButton( true )
	InvFrame:SetBackgroundBlur( false )
	InvFrame:MakePopup()
	
	local ItemListDetails = vgui.Create( "DPanelList" )
	ItemListDetails:SetParent( InvFrame )
	ItemListDetails:SetSize( 269, 269 )
	ItemListDetails:SetPos( 4, 27 )
	ItemListDetails:SetSpacing( 5 )
	ItemListDetails:EnableHorizontal( false )
	
	local ItemViewer = vgui.Create( "DModelPanel")
	ItemViewer:SetSize( 269, 269 )
	-- ItemViewer:SetPos( 0, 20 )
	ItemViewer:SetModel( args[3] )
	ItemViewer:SetAnimSpeed( 0.0 )
	ItemViewer:SetAnimated( false )
	ItemViewer:SetAmbientLight( Color( 50, 50, 50 ) )
	ItemViewer:SetDirectionalLight( BOX_TOP, Color( 175, 175, 175 ) )
	ItemViewer:SetDirectionalLight( BOX_BACK, Color( 175, 175, 175 ) )
	ItemViewer:SetCamPos( Vector( 0, 0, 70 ) )
	ItemViewer:SetLookAt( Vector( 0, 0, 0 ) )
	ItemViewer:SetFOV( 70 )
	ItemListDetails:AddItem( ItemViewer )
	
	function ItemViewer:LayoutEntity( Entity )
		delta = math.abs( 1 - 360 )
		--self:RunAnimation();
		Entity:SetPos( Vector( 0, 0, tonumber(args[6]) ) )
		Entity:SetAngles( Angle( delta * CurTime() / 24, 90, 90 ) )
		
	end

	local ItemListDetails = vgui.Create( "DPanelList" )
	ItemListDetails:SetParent( InvFrame )
	ItemListDetails:SetSize( 219, 205 )
	ItemListDetails:SetPos( 277, 27 )
	ItemListDetails:SetSpacing( 5 )
	ItemListDetails:EnableHorizontal( true )
	
	local ItemName = vgui.Create( "DLabel" )
	ItemName:SetSize( 219, 20 )
	ItemName:SetText( " Name: ".. args[2] )
	ItemListDetails:AddItem( ItemName )
	
	local ItemWeight = vgui.Create( "DLabel" )
	ItemWeight:SetSize( 219, 20 )
	ItemWeight:SetText( " Weight: ".. args[5] .." pounds" )
	ItemListDetails:AddItem( ItemWeight )
	
	local ItemDescription = vgui.Create( "DLabel" )
	ItemDescription:SetSize( 219, 20 )
	ItemDescription:SetText( " Description: ".. args[4] )
	ItemListDetails:AddItem( ItemDescription )

	local ItemDamageType = vgui.Create( "DLabel" )
	ItemDamageType:SetSize( 219, 20 )
	ItemDamageType:SetText( " Damage Type: ".. args[8] )
	ItemListDetails:AddItem( ItemDamageType )
	
	local ItemDamage = vgui.Create( "DLabel" )
	ItemDamage:SetSize( 219, 20 )
	ItemDamage:SetText( " Damage: ".. args[7] )
	ItemListDetails:AddItem( ItemDamage )
	
	local ItemAmmoType = vgui.Create( "DLabel" )
	ItemAmmoType:SetSize( 219, 20 )
	ItemAmmoType:SetText( " Ammo Type: ".. args[9] )
	ItemListDetails:AddItem( ItemAmmoType )
	
	local ItemAmmoCap = vgui.Create( "DLabel" )
	ItemAmmoCap:SetSize( 219, 20 )
	ItemAmmoCap:SetText( " Ammo Capacity: ".. args[10] )
	ItemListDetails:AddItem( ItemAmmoCap )
	
	local ItemMinST = vgui.Create( "DLabel" )
	ItemMinST:SetSize( 219, 20 )
	ItemMinST:SetText( " Minimum Strength: ".. args[11] )
	ItemListDetails:AddItem( ItemMinST )
	
	-- local ItemLDescription = vgui.Create( "DLabel" )
	-- ItemLDescription:SetSize( 219, 20 )
	-- ItemLDescription:SetText( " Description: ".. args[6] )
	-- ItemListDetails:AddItem( ItemLDescription )
	
	local ItemListOptions = vgui.Create( "DPanelList" )
	ItemListOptions:SetParent( InvFrame )
	ItemListOptions:SetSize( 219, 60 )
	ItemListOptions:SetPos( 277, 236 )
	ItemListOptions:SetSpacing( 1 )
	ItemListOptions:EnableHorizontal( true )
	
	local ItemListOption1 = vgui.Create( "DButton" )
	ItemListOption1:SetText( "Drop" )
	ItemListOption1:SetSize( 219, 29 )
	ItemListOption1.DoClick = function()
	LocalPlayer():ConCommand( "rp_dropitem ".. args[1] )
	InvFrame:Close()
	end
	ItemListOptions:AddItem( ItemListOption1 )
	
	local ItemListOption2 = vgui.Create( "DButton" )
	ItemListOption2:SetText( "Use" )
	ItemListOption2:SetSize( 219, 29 )
	ItemListOption2.DoClick = function()
	LocalPlayer():ConCommand( "rp_useinvitem ".. args[1] )
	InvFrame:Close()
	end
	ItemListOptions:AddItem( ItemListOption2 )
	
end
concommand.Add( "rp_itemdetails", ItemDetailMenu )
	
	
function CreatePlayerMenu()
	if(PlayerMenu) then
		PlayerMenu:Remove();
		PlayerMenu = nil;
	end
	
	PlayerMenu = vgui.Create( "InvisiblePanel" )
	PlayerMenu:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "Player Control Panel" )
	if LocalPlayer():GetNWBool( "testing" ) then
	PlayerMenu:SetVisible( false )
	else
	PlayerMenu:SetVisible( true )
	end
	PlayerMenu:SetDraggable( false )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetBackgroundBlur( true );
	PlayerMenu:MakePopup()
	
	PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent(PlayerMenu)
	PropertySheet:SetPos( 2, 30 )
	PropertySheet:SetSize( 636, 448 )
	
	local PlayerInfo = vgui.Create( "DPanelList" )
	PlayerInfo:SetPadding(20);
	PlayerInfo:SetSpacing(20);
	PlayerInfo:EnableHorizontal(false);
	
	local icdata = vgui.Create( "DForm" );
	icdata:SetPadding(4);
	icdata:SetName(LocalPlayer():Nick() or "");
	
	local FullData = vgui.Create("DPanelList");
	FullData:SetSize(0, 84);
	FullData:SetPadding(10);
	
	local DataList = vgui.Create("DPanelList");
	DataList:SetSize(0, 64);
	
	local spawnicon = vgui.Create( "SpawnIcon");
	spawnicon:SetModel(LocalPlayer():GetModel());
	spawnicon:SetSize( 64, 64 );


	DataList:AddItem(spawnicon);
	
	
	
	local DataList2 = vgui.Create( "DPanelList" )
	
	local label2 = vgui.Create("DLabel");
	label2:SetText("Title: " .. LocalPlayer():GetNWString("title"));
	DataList2:AddItem(label2);
	
	local label3 = vgui.Create("DLabel");
	label3:SetText("Class: " .. team.GetName(LocalPlayer():Team()));
	DataList2:AddItem(label3);

	local Divider = vgui.Create("DHorizontalDivider");
	Divider:SetLeft(spawnicon);
	Divider:SetRight(DataList2);
	Divider:SetLeftWidth(64);
	Divider:SetHeight(64);
	
	DataList:AddItem(spawnicon);
	DataList:AddItem(DataList2);
	DataList:AddItem(Divider);

	FullData:AddItem(DataList)
	
	icdata:AddItem(FullData)
	
	local vitals = vgui.Create( "DForm" );
	vitals:SetPadding(4);
	vitals:SetName("Vital Signs");
	
	local VitalData = vgui.Create("DPanelList");
	VitalData:SetAutoSize(true)
	VitalData:SetPadding(10);
	vitals:AddItem(VitalData);
	
	local healthstatus = ""
	local hp = LocalPlayer():Health();
	
	if(!LocalPlayer():Alive()) then healthstatus = "Dead";
	elseif(hp > 95) then healthstatus = "Healthy";
	elseif(hp > 50 and hp < 95) then healthstatus = "OK";
	elseif(hp > 30 and hp < 50) then healthstatus = "Near Death";
	elseif(hp > 1 and hp < 30) then healthstatus = "Death Imminent"; end
	
	local health = vgui.Create("DLabel");
	health:SetText("Vitals: " .. healthstatus);
	VitalData:AddItem(health);
	
	local plyradio = vgui.Create( "DForm" )
	plyradio:SetPadding( 4 )
	plyradio:SetName( "Player Radio" )
	
	local radiolist = vgui.Create( "DPanelList" )
	radiolist:SetAutoSize( true )
	radiolist:SetPadding( 10 )
	
	plyradio:AddItem( radiolist )
	
	local frequency = vgui.Create( "DNumSlider" )
	frequency:SetText( "Radio Frequency" )
	frequency:SetMin( 100 )
	frequency:SetMax( 300 )
	frequency:SetDecimals( 0 )
	frequency:SetValue( LocalPlayer():GetNWInt( "pradiostaion" ) )
	
	radiolist:AddItem( frequency )
	
	local frequencybutton = vgui.Create( "DButton" )
	frequencybutton:SetText( "Set Frequency" )
	frequencybutton.DoClick = function()
	
		LocalPlayer():ConCommand( "say /setr ".. frequency:GetValue() )
		
	end
	
	radiolist:AddItem( frequencybutton )

	PlayerInfo:AddItem( icdata )
	PlayerInfo:AddItem( vitals )
	PlayerInfo:AddItem( plyradio )
	
	
	CharPanel = vgui.Create( "DPanelList" )
	CharPanel:SetPadding(20);
	CharPanel:SetSpacing(20);
	CharPanel:EnableHorizontal(false);
	
	local newcharform = vgui.Create( "DForm" );
	newcharform:SetPadding(4);
	newcharform:SetName("New Character");
	newcharform:SetAutoSize(true);
	
	local CharMenu = vgui.Create( "DPanelList" )
	newcharform:AddItem(CharMenu);
	CharMenu:SetSize( 316, 386 )
	CharMenu:SetPadding(10);
	CharMenu:SetSpacing(20);
	CharMenu:EnableVerticalScrollbar();
	CharMenu:EnableHorizontal(false);


	
	local label = vgui.Create("DLabel");
	CharMenu:AddItem(label);
	label:SetSize(400, 25);
	label:SetPos(5, 25);
	label:SetText("FalloutRP");
	label:SetFont("MelonMedium");
	
	local labelz = vgui.Create("DLabel");
	CharMenu:AddItem(labelz);
	labelz:SetSize(400, 25);
	labelz:SetPos(5, 30);
	labelz:SetText("FalloutRP.com");
	labelz:SetFont("MelonMedium");

	local info = vgui.Create( "DForm" );
	info:SetName("Personal Information");
	CharMenu:AddItem(info);

	local label = vgui.Create("DLabel");
	info:AddItem(label);
	label:SetSize(30,25);
	label:SetPos(150, 50);
	label:SetText("First: ");

	local firstname = vgui.Create("DTextEntry");
	info:AddItem(firstname);
	firstname:SetSize(100,25);
	firstname:SetPos(185, 50);
	firstname:SetText("");

	local label = vgui.Create("DLabel");
	info:AddItem(label);
	label:SetSize(30,25);
	label:SetPos(5, 50);
	label:SetText("Last: ");

	local lastname = vgui.Create("DTextEntry");
	info:AddItem(lastname);
	lastname:SetSize(100,25);
	lastname:SetPos(40, 50);
	lastname:SetText("");

	local label = vgui.Create("DLabel");
	info:AddItem(label);
	label:SetSize(100,25);
	label:SetPos(5, 80);
	label:SetText("Title: ");

	local title = vgui.Create("DTextEntry");
	info:AddItem(title);
	title:SetSize(205, 25);
	title:SetPos(80, 80);
	title:SetText("Resident");

	local spawnicon = nil;

	local modelform = vgui.Create( "DForm" );
	modelform:SetPadding(4);
	modelform:SetName("Appearance");
	CharMenu:AddItem(modelform);

	local modellist = vgui.Create( "DPanelList" );

	modellist:EnableHorizontal(true);
	modellist:EnableVerticalScrollbar(true);
	modellist:SetSize(128, 64);
	modelform:AddItem(modellist);

	for n = 1, table.getn(models) do
		
		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetPos( x, y );
		spawnicon:SetSize( 32, 32 );
		spawnicon:SetModel( models[n] );

		spawnicon.DoClick = function() SetChosenModel( models[n] ) end
			
		modellist:AddItem(spawnicon);
			
	end

	local apply = vgui.Create("DButton");
	apply:SetSize(100, 25);
	apply:SetText("Apply");
	apply.DoClick = function ( btn )

		
		if(firstname:GetValue() == "" or lastname:GetValue() == "") then
			LocalPlayer():PrintMessage(3, "You must enter a first and last name!");
			return;
		end
		
		if(!table.HasValue(models, ChosenModel)) then
			LocalPlayer():PrintMessage(3, ChosenModel .. " is not a valid model!");
			return;
		end
		
		LocalPlayer():ConCommand("rp_startcreate");
		LocalPlayer():ConCommand("rp_setmodel \"" .. ChosenModel .. "\"");
		LocalPlayer():ConCommand("rp_changename \"" .. firstname:GetValue() .. " " .. lastname:GetValue() .. "\"");
		LocalPlayer():ConCommand("rp_title \"" .. string.sub(title:GetValue(), 1, 32) .. "\"");
		LocalPlayer().MyModel = ""
		LocalPlayer():ConCommand("rp_finishcreate");
		
		PlayerMenu:Remove();
		PlayerMenu = nil;
		
	end
	CharMenu:AddItem(apply);

	local selectcharform = vgui.Create( "DForm" );
	selectcharform:SetPadding(4);
	selectcharform:SetName("Select Character");
	selectcharform:SetSize(316, 386);

	local charlist = vgui.Create( "DPanelList" );
	
	charlist:SetSize( 316, 386 )
	charlist:SetPadding(10);
	charlist:SetSpacing(20);
	charlist:EnableVerticalScrollbar( );
	charlist:EnableHorizontal(true);

	
	local n = 1;
	if(ExistingChars[n] != nil) then

		mdlPanel = vgui.Create( "DModelPanel" )
		mdlPanel:SetSize( 280, 280 )
		mdlPanel:SetModel( ExistingChars[n]['model'] )
		mdlPanel:SetAnimSpeed( 0.0 )
		mdlPanel:SetAnimated( false )
		mdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
		mdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
		mdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
		mdlPanel:SetCamPos( Vector( 100, 0, 40 ) )
		mdlPanel:SetLookAt( Vector( 0, 0, 40 ) )
		mdlPanel:SetFOV( 70 )

		mdlPanel.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("Trebuchet18");
			surface.SetTextPos((280 - surface.GetTextSize(ExistingChars[n]['name'])) / 2, 260);
			surface.DrawText(ExistingChars[n]['name'])
		end
		
		function mdlPanel:OnMousePressed()
		
			LocalPlayer():ConCommand("rp_selectchar " .. n);
			LocalPlayer().MyModel = ""
			
			PlayerMenu:Remove();
			PlayerMenu = nil;

			
		end

		function mdlPanel:LayoutEntity(Entity)

			self:RunAnimation();
			
		end
		
		function InitAnim()
		
			if(mdlPanel.Entity) then
			
				local iSeq = mdlPanel.Entity:LookupSequence( "idle_angry" );
				mdlPanel.Entity:ResetSequence(iSeq);
			
			end
			
		end
		
		InitAnim()
		charlist:AddItem(mdlPanel);
		
	end
	
	local chars = vgui.Create("DListView");
	chars:SetSize(250, 100);
	chars:SetMultiSelect(false)
	chars:AddColumn("Character Name");
	
	function chars:DoDoubleClick(LineID, Line)
	
		n = LineID;
		mdlPanel:SetModel(ExistingChars[n]['model']);
		InitAnim();
		
	end

	
	for k, v in pairs(ExistingChars) do
	
		chars:AddLine(v['name']);
		
	end
	
	selectcharform:AddItem(chars);
	selectcharform:AddItem(charlist)
	
	
	local divider = vgui.Create("DHorizontalDivider");
	divider:SetLeft(newcharform);
	divider:SetRight(selectcharform);
	divider:SetLeftWidth(316); 

	CharPanel:AddItem(newcharform);
	CharPanel:AddItem(selectcharform);
	CharPanel:AddItem(divider);
	
	--------------------
	-- Class menu
	--------------------
	
	local divider = vgui.Create("DHorizontalDivider");
	divider:SetLeft(newcharform);
	divider:SetRight(selectcharform);
	divider:SetLeftWidth(316); 

	CharPanel:AddItem(newcharform);
	CharPanel:AddItem(selectcharform);
	CharPanel:AddItem(divider);
	
	Commands = vgui.Create( "DPanelList" )
	Commands:SetPadding(20);
	Commands:SetSpacing(20);
	Commands:EnableHorizontal(true);
	Commands:EnableVerticalScrollbar(true);
	
	local Flags = vgui.Create("DListView");
	Flags:SetSize(550,446);
	Flags:SetMultiSelect(false)
	Flags:AddColumn("Flag Name");
	--Flags:AddColumn("Salary");
	Flags:AddColumn("Business Access");
	Flags:AddColumn("Public Flag");
	Flags:AddColumn("Flag Key");
	
	function Flags:DoDoubleClick(LineID, Line)
	
		LocalPlayer():ConCommand("rp_flag " .. TeamTable[LineID].flagkey);
		PlayerMenu:Remove();
		PlayerMenu = nil;
		
	end
	
	for k, v in pairs(TeamTable) do
		local publicflag = "";
		if(v.public) then
			publicflag = "Yes";
		elseif(!v.public) then
			publicflag = "No";
		end
		
		local busaccess = "";
		if(v.business) then
			busaccess = "Yes";
		elseif(!v.business) then
			busaccess = "No";
		end
		
		Flags:AddLine(v.name, busaccess, publicflag, v.flagkey);
	end
	
	Commands:AddItem(Flags);
	
	--------------------
	-- Inventory menu
	--------------------
	
	Inventory = vgui.Create( "DPanelList" )
	Inventory:SetPadding(20);
	Inventory:SetSpacing(20);
	Inventory:EnableHorizontal(true);
	Inventory:EnableVerticalScrollbar(true);
	
	for k, v in pairs(InventoryTable) do

	local spawnicon = vgui.Create( "DModelPanel" )
	spawnicon:SetSize( 128, 128 );
	spawnicon:SetModel( v.Model )
	spawnicon:SetAnimSpeed( 0.0 )
	spawnicon:SetAnimated( false )
	spawnicon:SetAmbientLight( Color( 50, 50, 50 ) )
	spawnicon:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	spawnicon:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	spawnicon:SetCamPos( Vector( 0, 0, 40 ) )
	spawnicon:SetLookAt( Vector( 0, 0, 40 ) )
	spawnicon:SetFOV( 70 )
	spawnicon:SetToolTip(v.Description)
		
		local function DeleteMyself()
			spawnicon:Remove()
			PlayerMenu:Remove();
			PlayerMenu = nil;
		end
		
		spawnicon.DoClick = function ( btn )
		if( LocalPlayer():GetNWInt( "tiedup" ) == 1 ) then return false; end
			local ContextMenu = DermaMenu()
			ContextMenu:AddOption( "Use", function() LocalPlayer():ConCommand("rp_useinvitem " .. v.Class) DeleteMyself() end )
			ContextMenu:AddOption( "Drop", function() LocalPlayer():ConCommand("rp_dropitem ".. v.Class) DeleteMyself() end )
			ContextMenu:AddOption( "Details", function() RunConsoleCommand( "rp_itemdetails", v.Class, v.Name, v.Model, v.Description, v.Weight, v.Dist, v.Damage, v.DamageType, v.AmmoType, v.AmmoCapacity, v.MinStrength ) DeleteMyself() end ) 
			if(TeamTable[LocalPlayer():Team()].business) then
				ContextMenu:AddOption( "Sell", function() LocalPlayer():ConCommand("rp_sellitem ".. v.Class) DeleteMyself() end )
			end
			ContextMenu:Open();
			
		end
		
		spawnicon.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5);
			surface.DrawText(v.Name)
		end
		
		spawnicon.PaintOverHovered = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("DefaultSmall");
			surface.SetTextPos(64 - surface.GetTextSize(v.Name) / 2, 5);
			surface.DrawText(v.Name)
		end
		
		spawnicon.LayoutEntity = function( self, ent )
		
			ent:SetAngles( Angle( 0, 90, 100 ) );
		
		end

		Inventory:AddItem(spawnicon);
	end
	
	--------------------
	-- Business menu
	--------------------
	
	Business = vgui.Create( "DPanelList" )
	Business:SetPadding(20);
	Business:SetSpacing(20);
	Business:EnableHorizontal(true);
	Business:EnableVerticalScrollbar(true);
	if(TeamTable[LocalPlayer():Team()] != nil) then
		if(TeamTable[LocalPlayer():Team()].business) then
			for k, v in pairs(BusinessTable) do

	local spawnicon = vgui.Create( "DModelPanel" )
	spawnicon:SetSize( 128, 128 );
	spawnicon:SetModel( v.Model )
	spawnicon:SetAnimSpeed( 0.0 )
	spawnicon:SetAnimated( false )
	spawnicon:SetAmbientLight( Color( 50, 50, 50 ) )
	spawnicon:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	spawnicon:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	spawnicon:SetCamPos( Vector( 0, 0, 40 ) )
	spawnicon:SetLookAt( Vector( 0, 0, 40 ) )
	spawnicon:SetFOV( 70 )
	spawnicon:SetToolTip(v.Description)
				
				spawnicon.DoClick = function ( btn )
				
					local ContextMenu = DermaMenu()
						if(tonumber(LocalPlayer():GetNWString("money")) >= v.Price) then
							ContextMenu:AddOption("Purchase", function() LocalPlayer():ConCommand("rp_buyitem " .. v.Class); end);
						else
							ContextMenu:AddOption("Not enough money!");
						end
					ContextMenu:Open();
					
				end
				
				spawnicon.PaintOver = function()
					surface.SetTextColor(Color(255,255,255,255));
					surface.SetFont("DefaultSmall");
					surface.SetTextPos(64 - surface.GetTextSize(v.Name .. " (" .. v.Price .. ")") / 2, 5);
					surface.DrawText(v.Name .. " ($" .. v.Price .. ")")
				end
				
				spawnicon.PaintOverHovered = function()
					surface.SetTextColor(Color(255,255,255,255));
					surface.SetFont("DefaultSmall");
					surface.SetTextPos(64 - surface.GetTextSize(v.Name .. " (" .. v.Price .. ")") / 2, 5);
					surface.DrawText(v.Name .. " ($" .. v.Price .. ")")
				end
				
		spawnicon.LayoutEntity = function( self, ent )
		
			ent:SetAngles( Angle( 0, 90, 100 ) );
		
		end
				
				Business:AddItem(spawnicon);
			end
		elseif(!TeamTable[LocalPlayer():Team()].business) then
			local label = vgui.Create("DLabel")
			label:SetText("You do not have access to this tab!");
			label:SetWide(400);
			
			Business:AddItem(label);
		end
	end
	
	FRPRef = vgui.Create( "DPanel" )
	FRPRef:SetSize( 635, 447 )
	FRPRef:SetPos( 1, 1 )

	
	FRPHTML = vgui.Create( "Motd", FRPRef )
	FRPHTML:SetSize( 625, 160 )
	FRPHTML:SetPos( 0, 0 )
	FRPHTML:OpenURL( "http://altusfilms.com/fallout/credits.html" )
	
	FRPSelection = vgui.Create( "DPanelList", FRPRef )
	FRPSelection:SetSize( 625, 68 )
	FRPSelection:SetPos( 0, 163 )
	FRPSelection:EnableVerticalScrollbar( true )

		FRPTickerToggle = vgui.Create( "DButton" )
		FRPTickerToggle:SetText( "Toggle the Help Ticker" )
		FRPTickerToggle.DoClick = function()
		LocalPlayer():ConCommand( "rp_tickertoggle" )
		end
		
	FRPSelection:AddItem( FRPTickerToggle )
	
		FRPBackstory = vgui.Create( "DButton" )
		FRPBackstory:SetText( "Fallout Role-Play Backstory" )
		FRPBackstory.DoClick = function()
		LocalPlayer():ConCommand( "rp_backstory" )
		end
		
	FRPSelection:AddItem( FRPBackstory )
		
		FRPRules = vgui.Create( "DButton" )
		FRPRules:SetText( "Fallout Role-Play Rules" )
		FRPRules.DoClick = function()
		LocalPlayer():ConCommand( "rp_rules" )
		end
	
	FRPSelection:AddItem( FRPRules )
	
		FRPRules2 = vgui.Create( "DButton" )
		FRPRules2:SetText( "Fallout Role-Play Detailed Rules" )
		FRPRules2.DoClick = function()
		LocalPlayer():ConCommand( "rp_rules2" )
		end
	
	FRPSelection:AddItem( FRPRules2 )
	
		FRPHelp = vgui.Create( "DButton" )
		FRPHelp:SetText( "Fallout Role-Play Chat Commands" )
		FRPHelp.DoClick = function()
		LocalPlayer():ConCommand( "rp_chatcommands" )
		end
	
	FRPSelection:AddItem( FRPHelp )
	
		FRPHelp2 = vgui.Create( "DButton" )
		FRPHelp2:SetText( "Fallout Role-Play Server Flags/Tool Trusts 101" )
		FRPHelp2.DoClick = function()
		LocalPlayer():ConCommand( "rp_tooltrusts101" )
		end
	
	FRPSelection:AddItem( FRPHelp2 )	
	
	FRPHTML2 = vgui.Create( "Motd", FRPRef )
	FRPHTML2:SetSize( 625, 215 )
	FRPHTML2:SetPos( 0, 234 )
	FRPHTML2:OpenURL( "http://altusfilms.com/fallout/aboutus.html" )
	
	
	Scoreboard = vgui.Create( "DPanelList" )
	Scoreboard:EnableVerticalScrollbar(true);
	Scoreboard:SetPadding(0);
	Scoreboard:SetSpacing(0);

	-- Let's draw the SCOREBOARD.
	
	for k, v in pairs(player.GetAll()) do
		local DataList = vgui.Create("DPanelList");
		DataList:SetAutoSize( false )
        DataList:SetSize( 200, 80 )
		
		local CollapsableCategory = vgui.Create("DCollapsibleCategory");
		CollapsableCategory:SetExpanded( 1 )
		CollapsableCategory:SetLabel( v:Nick() );
		Scoreboard:AddItem(CollapsableCategory);

		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetModel(v:GetModel());
		spawnicon:SetSize( 64, 64 );
		DataList:AddItem(spawnicon);
		
		local DataList2 = vgui.Create( "DPanelList" )
		DataList2:SetAutoSize( true )
		
		local label = vgui.Create("DLabel");
		label:SetText("OOC Name: " .. v:Name());
		DataList2:AddItem(label);
		
		local label2 = vgui.Create("DLabel");
		label2:SetText("Title: " .. v:GetNWString("title"));
		DataList2:AddItem(label2);

		local label3 = vgui.Create("DLabel");
		label3:SetText("Ping: " .. v:Ping());
		DataList2:AddItem(label3);

		local Divider = vgui.Create("DHorizontalDivider");
		Divider:SetLeft(spawnicon);
		Divider:SetRight(DataList2);
		Divider:SetLeftWidth(64);
		Divider:SetHeight(64);
		
		DataList:AddItem(spawnicon);
		DataList:AddItem(DataList2);
		DataList:AddItem(Divider);
		
		CollapsableCategory:SetContents(DataList);
	end
	
	PropertySheet:AddSheet( "Player Menu", PlayerInfo, "gui/silkicons/user", false, false, "General information.");
	PropertySheet:AddSheet( "Character Menu", CharPanel, "gui/silkicons/group", false, false, "Switch to another character or create a new one.");
	PropertySheet:AddSheet( "Class Selection", Commands, "gui/silkicons/wrench", false, false, "Execute some common commands or set your flag.");
	PropertySheet:AddSheet( "Backpack", Inventory, "gui/silkicons/box", false, false, "View your inventory.")
	PropertySheet:AddSheet( "Business / Armory", Business, "gui/silkicons/box", false, false, "Purchase items.");
	PropertySheet:AddSheet( "Reference", FRPRef, "gui/silkicons/application_view_detail", false, false, "Credits, Rules, Tutorials, etc." )
	PropertySheet:AddSheet( "Scoreboard", Scoreboard, "gui/silkicons/application_view_detail", false, false, "View the scoreboard.");		

end
usermessage.Hook("playermenu", CreatePlayerMenu);


function BackstoryHTML()

	BackstoryF = vgui.Create( "DFrame" )
	BackstoryF:SetTitle( "Fallout Role-Play Backstory" )
	BackstoryF:SetSize( 800, ScrH() - 20 )
	BackstoryF:Center()
	BackstoryF:SetVisible( true )
	BackstoryF:SetDraggable( false )
	BackstoryF:ShowCloseButton( true )
	BackstoryF:SetBackgroundBlur( true );
	BackstoryF:MakePopup()
	
		Backstory = vgui.Create( "Motd" )
		Backstory:SetParent( BackstoryF )
		Backstory:SetSize( BackstoryF:GetWide() - 10, BackstoryF:GetTall() - 50 )
		Backstory:SetPos( 5, 25 )
		Backstory:OpenURL( "http://altusfilms.com/fallout/backstory.html" )
		
		BackstoryB = vgui.Create( "DButton" )
		BackstoryB:SetParent( BackstoryF )
		BackstoryB:SetText( "Close" )
		BackstoryB:SetSize( 60, 15 )
		BackstoryB:SetPos( 370, BackstoryF:GetTall() - 20 )
		BackstoryB.DoClick = function()
			BackstoryF:Close()
		end
		
end
concommand.Add( "rp_backstory", BackstoryHTML )
	
function RulesHTML()

	RulesF = vgui.Create( "DFrame" )
	RulesF:SetTitle( "Fallout Role-Play Rules" )
	RulesF:SetSize( 800, ScrH() - 20 )
	RulesF:Center()
	RulesF:SetVisible( true )
	RulesF:SetDraggable( false )
	RulesF:ShowCloseButton( true )
	RulesF:SetBackgroundBlur( true );
	RulesF:MakePopup()
	
		Rules = vgui.Create( "Motd" )
		Rules:SetParent( RulesF )
		Rules:SetSize( RulesF:GetWide() - 10, RulesF:GetTall() - 50 )
		Rules:SetPos( 5, 25 )
		Rules:OpenURL( "http://altusfilms.com/fallout/rules.html" )
		
		RulesB = vgui.Create( "DButton" )
		RulesB:SetParent( RulesF )
		RulesB:SetText( "Close" )
		RulesB:SetSize( 60, 15 )
		RulesB:SetPos( 370, RulesF:GetTall() - 20 )
		RulesB.DoClick = function()
			RulesF:Close()
		end
		
end
concommand.Add( "rp_rules", RulesHTML )	

function Rules2HTML()

	Rules2F = vgui.Create( "DFrame" )
	Rules2F:SetTitle( "Fallout Role-Play Rules Explanation" )
	Rules2F:SetSize( 800, ScrH() - 20 )
	Rules2F:Center()
	Rules2F:SetVisible( true )
	Rules2F:SetDraggable( false )
	Rules2F:ShowCloseButton( true )
	Rules2F:SetBackgroundBlur( true );
	Rules2F:MakePopup()
	
		Rules2 = vgui.Create( "Motd" )
		Rules2:SetParent( Rules2F )
		Rules2:SetSize( Rules2F:GetWide() - 10, Rules2F:GetTall() - 50 )
		Rules2:SetPos( 5, 25 )
		Rules2:OpenURL( "http://altusfilms.com/fallout/rules2.html" )
		
		Rules2B = vgui.Create( "DButton" )
		Rules2B:SetParent( Rules2F )
		Rules2B:SetText( "Close" )
		Rules2B:SetSize( 60, 15 )
		Rules2B:SetPos( 370, Rules2F:GetTall() - 20 )
		Rules2B.DoClick = function()
			Rules2F:Close()
		end
		
end
concommand.Add( "rp_rules2", Rules2HTML )	

function Rules3HTML()

	Rules3F = vgui.Create( "DFrame" )
	Rules3F:SetTitle( "Fallout Role-Play Rules Explanation" )
	Rules3F:SetSize( 800, ScrH() - 20 )
	Rules3F:Center()
	Rules3F:SetVisible( true )
	Rules3F:SetDraggable( false )
	Rules3F:ShowCloseButton( true )
	Rules3F:SetBackgroundBlur( true );
	Rules3F:MakePopup()
	
		Rules3 = vgui.Create( "Motd" )
		Rules3:SetParent( Rules3F )
		Rules3:SetSize( Rules3F:GetWide() - 10, Rules3F:GetTall() - 50 )
		Rules3:SetPos( 5, 25 )
		Rules3:OpenURL( "http://altusfilms.com/fallout/rules2.html" )
		
		Rules3B = vgui.Create( "DButton" )
		Rules3B:SetParent( Rules3F )
		Rules3B:SetText( "Close" )
		Rules3B:SetSize( 60, 15 )
		Rules3B:SetPos( 370, Rules3F:GetTall() - 20 )
		Rules3B.DoClick = function()
			Rules3F:Close()
			LocalPlayer():ConCommand( "rp_quiz" )
		end
		
end
concommand.Add( "rp_rules3", Rules3HTML )

function ToolTrusts101HTML()

	ToolTrusts101F = vgui.Create( "DFrame" )
	ToolTrusts101F:SetTitle( "Fallout Role-Play Tool Trusts 101" )
	ToolTrusts101F:SetSize( 800, ScrH() - 20 )
	ToolTrusts101F:Center()
	ToolTrusts101F:SetVisible( true )
	ToolTrusts101F:SetDraggable( false )
	ToolTrusts101F:ShowCloseButton( true )
	ToolTrusts101F:SetBackgroundBlur( true );
	ToolTrusts101F:MakePopup()
	
		ToolTrusts101 = vgui.Create( "Motd" )
		ToolTrusts101:SetParent( ToolTrusts101F )
		ToolTrusts101:SetSize( ToolTrusts101F:GetWide() - 10, ToolTrusts101F:GetTall() - 50 )
		ToolTrusts101:SetPos( 5, 25 )
		ToolTrusts101:OpenURL( "http://altusfilms.com/fallout/tooltrusts101.html" )
		
		ToolTrusts101B = vgui.Create( "DButton" )
		ToolTrusts101B:SetParent( ToolTrusts101F )
		ToolTrusts101B:SetText( "Close" )
		ToolTrusts101B:SetSize( 60, 15 )
		ToolTrusts101B:SetPos( 370, ToolTrusts101F:GetTall() - 20 )
		ToolTrusts101B.DoClick = function()
			ToolTrusts101F:Close()
		end
		
end
concommand.Add( "rp_tooltrusts101", ToolTrusts101HTML )	

function ChatCommandsHTML()

	ChatCommandsF = vgui.Create( "DFrame" )
	ChatCommandsF:SetTitle( "Fallout Role-Play Chat Commands 101" )
	ChatCommandsF:SetSize( 800, ScrH() - 20 )
	ChatCommandsF:Center()
	ChatCommandsF:SetVisible( true )
	ChatCommandsF:SetDraggable( false )
	ChatCommandsF:ShowCloseButton( true )
	ChatCommandsF:SetBackgroundBlur( true );
	ChatCommandsF:MakePopup()
	
		ChatCommands = vgui.Create( "Motd" )
		ChatCommands:SetParent( ChatCommandsF )
		ChatCommands:SetSize( ChatCommandsF:GetWide() - 10, ChatCommandsF:GetTall() - 50 )
		ChatCommands:SetPos( 5, 25 )
		ChatCommands:OpenURL( "http://altusfilms.com/fallout/chatcommands.html" )
		
		ChatCommandsB = vgui.Create( "DButton" )
		ChatCommandsB:SetParent( ChatCommandsF )
		ChatCommandsB:SetText( "Close" )
		ChatCommandsB:SetSize( 60, 15 )
		ChatCommandsB:SetPos( 370, ChatCommandsF:GetTall() - 20 )
		ChatCommandsB.DoClick = function()
			ChatCommandsF:Close()
		end
		
end
concommand.Add( "rp_chatcommands", ChatCommandsHTML )	
/*
\a	bell
\b	back space
\f	form feed
\n	newline
\r	carriage return
\t	horizontal tab
\v	vertical tab
\\	backslash
\"	double quote
\'	single quote
\[	left square bracket
\]	right square bracket
*/
function RPQuizVGUI()

	QuizFrame = vgui.Create( "InvisiblePanel" )
	QuizFrame:SetTitle( "Fallout Role-Play Quiz" ) 
	QuizFrame:SetSize( 600, 724 )
	QuizFrame:Center()
	QuizFrame:SetVisible( true )
	QuizFrame:SetDraggable( false )
	QuizFrame:ShowCloseButton( false )
	QuizFrame:MakePopup()
	
		QuizLabel = vgui.Create( "DLabel" )
		QuizLabel:SetParent( QuizFrame )
		QuizLabel:SetPos( 100, 30 )
		QuizLabel:SetSize( 300, 20 )
		QuizLabel:SetText( "Fallout Role-Play Quiz" ) --Text to draw below

		QuizLabel = vgui.Create( "DLabel" )
		QuizLabel:SetParent( QuizFrame )
		QuizLabel:SetPos( 300, 30 )
		QuizLabel:SetSize( 300, 40 )
		QuizLabel:SetText( "Failing to answer any questions in this quiz\nor failing this quiz will result in a kick and\n10 minute ban." ) --Text to draw below
		
		QuizQuestion1 = vgui.Create( "DLabel" )
		QuizQuestion1:SetParent( QuizFrame )
		QuizQuestion1:SetPos( 7, 72 )
		QuizQuestion1:SetSize( 300, 20 )
		QuizQuestion1:SetText( "Question 1 - What is Deathmatching?" )
		
		QuizAnswerSheet1 = vgui.Create( "DPanelList" )
		QuizAnswerSheet1:SetParent( QuizFrame )
		QuizAnswerSheet1:SetSize( 600, 89 )
		QuizAnswerSheet1:SetPos( 0, 92 )
		
		QuizAnswer1Q1 = vgui.Create( "DButton" )
		QuizAnswer1Q1:SetText( "1. DMing" )
		QuizAnswer1Q1.DoClick = function(ply)
			A2Q1 = false
		end
		
		QuizAnswer2Q1 = vgui.Create( "DButton" )
		QuizAnswer2Q1:SetText( "2. When a player kills another player over and over" )
		QuizAnswer2Q1.DoClick = function(ply)
			A2Q1 = true
		end
		
		QuizAnswer3Q1 = vgui.Create( "DButton" )
		QuizAnswer3Q1:SetText( "3. When a Faction shoots anyone that comes near their outpost, and it is RP Related" )
		QuizAnswer3Q1.DoClick = function(ply)
			A2Q1 = false
		end
		
		QuizAnswer4Q1 = vgui.Create( "DButton" )
		QuizAnswer4Q1:SetText( "4. When a faction walks around the map, shooting anyone they see" )
		QuizAnswer4Q1.DoClick = function(ply)
			A2Q1 = false
		end
		
		QuizAnswerSheet1:AddItem( QuizAnswer1Q1 )
		QuizAnswerSheet1:AddItem( QuizAnswer2Q1 )
		QuizAnswerSheet1:AddItem( QuizAnswer3Q1 )
		QuizAnswerSheet1:AddItem( QuizAnswer4Q1 )
		
		QuizQuestion2 = vgui.Create( "DLabel" )
		QuizQuestion2:SetParent( QuizFrame )
		QuizQuestion2:SetPos( 7, 182 )
		QuizQuestion2:SetSize( 300, 20 )
		QuizQuestion2:SetText( "Question 2 - What is the New Life Rule?" )
		
		QuizAnswerSheet2 = vgui.Create( "DPanelList" )
		QuizAnswerSheet2:SetParent( QuizFrame )
		QuizAnswerSheet2:SetSize( 600, 89 )
		QuizAnswerSheet2:SetPos( 0, 202 )
		
		QuizAnswer1Q2 = vgui.Create( "DButton" )
		QuizAnswer1Q2:SetText( "1. When you get killed and go to the same place" )
		QuizAnswer1Q2.DoClick = function(ply)
			A4Q2 = false
		end
		
		QuizAnswer2Q2 = vgui.Create( "DButton" )
		QuizAnswer2Q2:SetText( "2. Where you get shot, and run away" )
		QuizAnswer2Q2.DoClick = function(ply)
			A4Q2 = false
		end
		
		QuizAnswer3Q2 = vgui.Create( "DButton" )
		QuizAnswer3Q2:SetText( "3. When you Deathmatch three people" )
		QuizAnswer3Q2.DoClick = function(ply)
			A4Q2 = false
		end
		
		QuizAnswer4Q2 = vgui.Create( "DButton" )
		QuizAnswer4Q2:SetText( "4. When you get killed, and wait five minutes before going to the place you were killed" )
		QuizAnswer4Q2.DoClick = function(ply)
			A4Q2 = true
		end
		
		QuizAnswerSheet2:AddItem( QuizAnswer1Q2 )
		QuizAnswerSheet2:AddItem( QuizAnswer2Q2 )
		QuizAnswerSheet2:AddItem( QuizAnswer3Q2 )
		QuizAnswerSheet2:AddItem( QuizAnswer4Q2 )
		
		QuizQuestion3 = vgui.Create( "DLabel" )
		QuizQuestion3:SetParent( QuizFrame )
		QuizQuestion3:SetPos( 7, 292 )
		QuizQuestion3:SetSize( 600, 20 )
		QuizQuestion3:SetText( "Question 3 - When are you subject to a Physgun / Gravity Gun Ban?" )
		
		QuizAnswerSheet3 = vgui.Create( "DPanelList" )
		QuizAnswerSheet3:SetParent( QuizFrame )
		QuizAnswerSheet3:SetSize( 600, 89 )
		QuizAnswerSheet3:SetPos( 0, 312 )
		
		QuizAnswer1Q3 = vgui.Create( "DButton" )
		QuizAnswer1Q3:SetText( "1. When you Glitch a Fence open with your Gravity Gun" )
		QuizAnswer1Q3.DoClick = function(ply)
			A3Q3 = false
		end
		
		QuizAnswer2Q3 = vgui.Create( "DButton" )
		QuizAnswer2Q3:SetText( "2. When you Prop Kill a person with your Physgun" )
		QuizAnswer2Q3.DoClick = function(ply)
			A3Q3 = false
		end
		
		QuizAnswer3Q3 = vgui.Create( "DButton" )
		QuizAnswer3Q3:SetText( "3. Both 1 and 2" )
		QuizAnswer3Q3.DoClick = function(ply)
			A3Q3 = true
		end
		
		QuizAnswer4Q3 = vgui.Create( "DButton" )
		QuizAnswer4Q3:SetText( "4. When you get killed by a Deathclaw" )
		QuizAnswer4Q3.DoClick = function(ply)
			A3Q3 = false
		end
		
		QuizAnswerSheet3:AddItem( QuizAnswer1Q3 )
		QuizAnswerSheet3:AddItem( QuizAnswer2Q3 )
		QuizAnswerSheet3:AddItem( QuizAnswer3Q3 )
		QuizAnswerSheet3:AddItem( QuizAnswer4Q3 )
		
		QuizQuestion4 = vgui.Create( "DLabel" )
		QuizQuestion4:SetParent( QuizFrame )
		QuizQuestion4:SetPos( 7, 402 )
		QuizQuestion4:SetSize( 600, 20 )
		QuizQuestion4:SetText( "Question 4 - Which of the following is a Proper Roleplay Name?" )
		
		QuizAnswerSheet4 = vgui.Create( "DPanelList" )
		QuizAnswerSheet4:SetParent( QuizFrame )
		QuizAnswerSheet4:SetSize( 600, 89 )
		QuizAnswerSheet4:SetPos( 0, 422 )
		
		QuizAnswer1Q4 = vgui.Create( "DButton" )
		QuizAnswer1Q4:SetText( "1. Jack Taylor" )
		QuizAnswer1Q4.DoClick = function(ply)
			A14Q4 = true
		end
		
		QuizAnswer2Q4 = vgui.Create( "DButton" )
		QuizAnswer2Q4:SetText( "2. Ben Bullet" )
		QuizAnswer2Q4.DoClick = function(ply)
			A14Q4 = false
		end
		
		QuizAnswer3Q4 = vgui.Create( "DButton" )
		QuizAnswer3Q4:SetText( "3. Major …" )
		QuizAnswer3Q4.DoClick = function(ply)
			A14Q4 = false
		end
		
		QuizAnswer4Q4 = vgui.Create( "DButton" )
		QuizAnswer4Q4:SetText( "4. Jonathon Ivancoch" )
		QuizAnswer4Q4.DoClick = function(ply)
			A14Q4 = true
		end
		
		QuizAnswerSheet4:AddItem( QuizAnswer1Q4 )
		QuizAnswerSheet4:AddItem( QuizAnswer2Q4 )
		QuizAnswerSheet4:AddItem( QuizAnswer3Q4 )
		QuizAnswerSheet4:AddItem( QuizAnswer4Q4 )
		
		QuizQuestion5 = vgui.Create( "DLabel" )
		QuizQuestion5:SetParent( QuizFrame )
		QuizQuestion5:SetPos( 7, 512 )
		QuizQuestion5:SetSize( 600, 20 )
		QuizQuestion5:SetText( "Question 5 - What is Metagaming?" )
		
		QuizAnswerSheet5 = vgui.Create( "DPanelList" )
		QuizAnswerSheet5:SetParent( QuizFrame )
		QuizAnswerSheet5:SetSize( 600, 89 )
		QuizAnswerSheet5:SetPos( 0, 532 )
		
		QuizAnswer1Q5 = vgui.Create( "DButton" )
		QuizAnswer1Q5:SetText( "1. When your character does not know a persons name, and says it" )
		QuizAnswer1Q5.DoClick = function(ply)
			A13Q5 = true
		end
		
		QuizAnswer2Q5 = vgui.Create( "DButton" )
		QuizAnswer2Q5:SetText( "2. When your character does not know a persons name, and assumes that he knows it" )
		QuizAnswer2Q5.DoClick = function(ply)
			A13Q5 = false
		end
		
		QuizAnswer3Q5 = vgui.Create( "DButton" )
		QuizAnswer3Q5:SetText( "3. When a person that your Character does not know, screams your name, and runs away" )
		QuizAnswer3Q5.DoClick = function(ply)
			A13Q5 = true
		end
		
		QuizAnswer4Q5 = vgui.Create( "DButton" )
		QuizAnswer4Q5:SetText( "4. When a player walks up to you, says hello, and asks for your name" )
		QuizAnswer4Q5.DoClick = function(ply)
			A13Q5 = false
		end
		
		QuizAnswerSheet5:AddItem( QuizAnswer1Q5 )
		QuizAnswerSheet5:AddItem( QuizAnswer2Q5 )
		QuizAnswerSheet5:AddItem( QuizAnswer3Q5 )
		QuizAnswerSheet5:AddItem( QuizAnswer4Q5 )
		
		QuizQuestion6 = vgui.Create( "DLabel" )
		QuizQuestion6:SetParent( QuizFrame )
		QuizQuestion6:SetPos( 7, 622 )
		QuizQuestion6:SetSize( 600, 20 )
		QuizQuestion6:SetText( "Question 6 - Have you read, and do you Understand this servers rules?" )
		
		QuizAnswerSheet6 = vgui.Create( "DPanelList" )
		QuizAnswerSheet6:SetParent( QuizFrame )
		QuizAnswerSheet6:SetSize( 600, 45 )
		QuizAnswerSheet6:SetPos( 0, 642 )
		
		QuizAnswer1Q6 = vgui.Create( "DButton" )
		QuizAnswer1Q6:SetText( "1. Yes" )
		QuizAnswer1Q6.DoClick = function(ply)
			A1Q6 = true
		end
		
		QuizAnswer2Q6 = vgui.Create( "DButton" )
		QuizAnswer2Q6:SetText( "2. No" )
		QuizAnswer2Q6.DoClick = function(ply)
			A1Q6 = false
		end
		
		QuizAnswerSheet6:AddItem( QuizAnswer1Q6 )
		QuizAnswerSheet6:AddItem( QuizAnswer2Q6 )
		
		QuizSubmitButton = vgui.Create( "DButton" )
		QuizSubmitButton:SetParent( QuizFrame )
		QuizSubmitButton:SetPos( QuizFrame:GetWide() / 2 - 23, 698 )
		QuizSubmitButton:SetSize( 45, 20 )
		QuizSubmitButton:SetText( "Submit" )
		QuizSubmitButton.DoClick = function(ply)
			
			if A2Q1 == true then
				LocalPlayer():ConCommand( "a2q1" )
			end
			if A4Q2 == true then
				LocalPlayer():ConCommand( "a4q2" )
			end
			if A3Q3 == true then
				LocalPlayer():ConCommand( "a3q3" )
			end
			if A14Q4 == true then
				LocalPlayer():ConCommand( "a14q4" )
			end
			if A13Q5 == true then
				LocalPlayer():ConCommand( "a13q5" )
			end
			if A1Q6 == true then
				LocalPlayer():ConCommand( "a1q6" )
			end
			--print( LocalPlayer():GetNWInt( "a1q1" ) )
			RunConsoleCommand( "rp_checkmytest" )
			
			LocalPlayer():ConCommand( "donetesting" )
				CreatePlayerMenu( )
	PlayerMenu:ShowCloseButton( false )
	PropertySheet:SetActiveTab( PropertySheet.Items[ 2 ].Tab );
	PropertySheet.SetActiveTab = function( ) end;
	
	InitHUDMenu( );QuizFrame:Close()
			-- CreatePlayerMenu( )
			-- PlayerMenu:ShowCloseButton( false )
			-- PropertySheet:SetActiveTab( PropertySheet.Items[ 2 ].Tab );
			-- PropertySheet.SetActiveTab = function( ) end;
	
			-- InitHUDMenu( );
		end
		

end
concommand.Add( "rp_quiz", RPQuizVGUI )	

function ShowLetter(msg)

	LetterMsg = ""
	LetterPos = msg:ReadVector()
	local sectionCount = msg:ReadShort()
	for k=1, sectionCount do
		LetterMsg = LetterMsg .. msg:ReadString()
	end
	
	local LetterBox = vgui.Create( "InvisiblePanel" )
	LetterBox:SetPos( ScrW() / 2 - 150, ScrH() / 2 - 175 )
	LetterBox:SetSize( 300, 350 )
	LetterBox:SetTitle( "Letter" )
	LetterBox:SetVisible( true )
	LetterBox:SetBackgroundBlur( false )
	LetterBox:MakePopup()
	
	local LetterHolder = vgui.Create( "DPanelList", LetterBox )
	LetterHolder:SetParent( LetterBox )
	LetterHolder:SetSize( 290, 328 )
	LetterHolder:SetPos( 5, 22 )
	
	local LetterContents = vgui.Create( "DLabel" )
	--LetterContents:SetParent( LetterBox )
	LetterContents.MarkedUp = markup.Parse( "<font=script><colour=255,255,255,255>" .. LetterMsg .. "</colour></font>\n", 289 ) -- THIS IS SUCH A COOL WAY TO DO DLABELS! ^_^ ^_^ ^_^ Learned from kogistune's Stampede -- think I spelled the name right
	function LetterContents.Paint( self )
		self.MarkedUp:Draw( 2.9, 0, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		return true
	end
	
	LetterContents:SetTall( LetterContents.MarkedUp:GetHeight( ) )
	
	LetterHolder:AddItem( LetterContents )
	--LetterContents:SetText( "".. LetterMsg .. "" )
	
end
usermessage.Hook("ShowLetter", ShowLetter)
	
function GoCommands(data)
    CreatePlayerMenu();
	PropertySheet:SetActiveTab( PropertySheet.Items[ 3 ].Tab );
end
usermessage.Hook("GoCommands", GoCommands);

function GoScore(data)
    CreatePlayerMenu();
	PropertySheet:SetActiveTab( PropertySheet.Items[ 7 ].Tab );
end
usermessage.Hook("GoScore", GoScore);

function GoInv(data)
    CreatePlayerMenu();
	PropertySheet:SetActiveTab( PropertySheet.Items[ 4 ].Tab );
end
usermessage.Hook("GoInv", GoInv);