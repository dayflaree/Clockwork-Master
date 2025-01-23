
function StartAdmin()
if( AdminFrame ) then
AdminFrame:Remove()
AdminFrame = nil
end

  AdminFrame = vgui.Create("InvisiblePanel")
  AdminFrame:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
  AdminFrame:SetSize(640, 480)
  AdminFrame:SetTitle( "FalloutScript Administration Panel" )
  AdminFrame:SetVisible( true )
  AdminFrame:SetDraggable( false )
  AdminFrame:ShowCloseButton( true )
  AdminFrame:SetBackgroundBlur( true )
  AdminFrame:MakePopup()
  
  	PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent(AdminFrame)
	PropertySheet:SetPos( 2, 30 )
	PropertySheet:SetSize( 636, 448 )
	
	PlayerList = vgui.Create( "DPanelList" )
	PlayerList:EnableVerticalScrollbar(false);
	PlayerList:SetPadding(0);
	PlayerList:SetSpacing(0);
	
	for k, v in pairs(player.GetAll()) do
		local DataList = vgui.Create("DPanelList");
		DataList:SetAutoSize( false )
		DataList:EnableVerticalScrollbar( false )
        DataList:SetSize( 200, 150 )
		
		local CollapsablePCategory = vgui.Create("DCollapsibleCategory");
		CollapsablePCategory:SetExpanded( 0 )
		CollapsablePCategory:SetLabel( v:Name() .." - ".. v:Nick() );
		PlayerList:AddItem(CollapsablePCategory);
		
		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetModel(v:GetModel());
		spawnicon:SetSize( 64, 64 );
		
		DataList:AddItem(spawnicon);
		
		local DataList2 = vgui.Create( "DPanelList" )
		DataList2:SetAutoSize( true )
		DataList2:EnableVerticalScrollbar( false )
		
		local label = vgui.Create("DLabel");
		label:SetText("OOC Name: " .. v:Name());
		DataList2:AddItem(label);
		
		local label2 = vgui.Create("DLabel");
		label2:SetText("Title: " .. v:GetNWString("title"));
		DataList2:AddItem(label2);
		
		local label3 = vgui.Create("DLabel");
		label3:SetText("Ping: " .. v:Ping());
		DataList2:AddItem(label3);
		
		
	    local BanButton = vgui.Create("DButton");
	    BanButton:SetText("Superban");
	    BanButton.DoClick = function()

		local args = string.Explode(" ", v:Nick() )
        LocalPlayer():ConCommand("rp_admin superban ".. args[1] .." Superban 0");

	    end
        DataList2:AddItem(BanButton);
		
	    local TempBanButton = vgui.Create("DButton");
	    TempBanButton:SetText("1 Hour Ban");
	    TempBanButton.DoClick = function()

		local args = string.Explode(" ", v:Nick() )
        RunConsoleCommand("rp_admin", "ban", args[1], "Banned 60");

	    end
        DataList2:AddItem(TempBanButton);

	    local KickButton = vgui.Create("DButton");
	    KickButton:SetText("Kick");
	    KickButton.DoClick = function()

	    local args = string.Explode(" ", v:Nick() )
        LocalPlayer():ConCommand("rp_admin kick ".. args[1] .." Kicked");

	    end
		DataList2:AddItem(KickButton);
		
		local Divider = vgui.Create("DHorizontalDivider");
		Divider:SetLeft(spawnicon);
		Divider:SetRight(DataList2);
		Divider:SetLeftWidth(64);
		Divider:SetHeight(64);
		
		DataList:AddItem(spawnicon);
		DataList:AddItem(DataList2);
		DataList:AddItem(Divider);
		
		CollapsablePCategory:SetContents(DataList)
		
	end	
	-- ExtraEntsList = vgui.Create( "DPanelList" )
	-- ExtraEntsList:EnableVerticalScrollbar(false);
	-- ExtraEntsList:SetPadding(0);
	-- ExtraEntsList:SetSpacing(0);
	
	ExtraEntsPanel = vgui.Create( "DPanel" )
	ExtraEntsPanel:SetSize( 630, 442 )
	ExtraEntsPanel:SetPos( 3, 3 )
	
	
	
		local ExtraEntsComboBox = vgui.Create( "DListView", ExtraEntsPanel )
		ExtraEntsComboBox:SetSize( 150, ExtraEntsPanel:GetTall() - 6 )
		ExtraEntsComboBox:SetPos( 3, 3 )
		ExtraEntsComboBox:SetMultiSelect( false )
		ExtraEntsComboBox:AddColumn( "OOC Name" )
		ExtraEntsComboBox:AddColumn( "RP Name" )
	for k, v in pairs(player.GetAll()) do	
		ExtraEntsComboBox:AddLine( v:Name(), v:Nick() )
	end	
		
		local SliderList = vgui.Create( "DPanelList", ExtraEntsPanel )
		SliderList:SetSize( ExtraEntsPanel:GetWide() - 165, ExtraEntsPanel:GetTall() - 6 )
		SliderList:SetPos( 160, 3 )
		SliderList:SetSpacing( 10 )
		SliderList:SetPadding( 5 )
		
		local EPSlider = vgui.Create( "DNumSlider" )
		EPSlider:SetText( "Extra Props" )
		EPSlider:SetMin( 0 )
		EPSlider:SetMax( 100 )
		-- EPSlider:SetValue( LEMON.MaxProps )
		EPSlider:SetDecimals( 0 )
		
		SliderList:AddItem( EPSlider )
		
	    local ApplyEPButton = vgui.Create("DButton")
	    ApplyEPButton:SetText( "Apply Extra Props" );
	    ApplyEPButton.DoClick = function()

	    -- local args = string.Explode( " ", v:Nick() )
		if ExtraEntsComboBox:GetSelected()[1]:GetValue() == nil then
		
			LEMON.SendChat( ply, "Select a Player First." )
		else
		
        LocalPlayer():ConCommand( "rp_admin extraprops ".. ExtraEntsComboBox:GetSelected( )[1]:GetValue(1) .." ".. EPSlider:GetValue() );
		
	    end
		end

		
		SliderList:AddItem( ApplyEPButton )
		
		local ERSlider = vgui.Create( "DNumSlider" )
		ERSlider:SetText( "Extra Ragdolls" )
		ERSlider:SetMin( 0 )
		ERSlider:SetMax( 100 )
		-- ERSlider:SetValue( LEMON.MaxProps )
		ERSlider:SetDecimals( 0 )
		
		SliderList:AddItem( ERSlider )
		
	    local ApplyERButton = vgui.Create("DButton")
	    ApplyERButton:SetText( "Apply Extra Ragdolls" );
	    ApplyERButton.DoClick = function()

	    -- local args = string.Explode( " ", v:Nick() )
		if ExtraEntsComboBox:GetSelected() == nil then
			LEMON.SendChat( ply, "Select a player first." )
			return
		end
		
        LocalPlayer():ConCommand( "rp_admin extraragdolls ".. ExtraEntsComboBox:GetSelected( )[1]:GetValue(1) .." ".. ERSlider:GetValue() );
		
	    end

		
		SliderList:AddItem( ApplyERButton )
		
		local EESlider = vgui.Create( "DNumSlider" )
		EESlider:SetText( "Extra Effects" )
		EESlider:SetMin( 0 )
		EESlider:SetMax( 100 )
		-- EESlider:SetValue( LEMON.MaxProps )
		EESlider:SetDecimals( 0 )
		
		SliderList:AddItem( EESlider )
		
	    local ApplyEEButton = vgui.Create("DButton")
	    ApplyEEButton:SetText( "Apply Extra Effects" );
	    ApplyEEButton.DoClick = function()

	    -- local args = string.Explode( " ", v:Nick() )
		if ExtraEntsComboBox:GetSelected() == nil then
			LEMON.SendChat( ply, "Select a player first." )
			return
		end
		
        LocalPlayer():ConCommand( "rp_admin extraeffects ".. ExtraEntsComboBox:GetSelected( )[1]:GetValue(1) .." ".. EESlider:GetValue() );
		
	    end
		
		SliderList:AddItem( ApplyEEButton )
		
		local EVSlider = vgui.Create( "DNumSlider" )
		EVSlider:SetText( "Extra Vehicles" )
		EVSlider:SetMin( 0 )
		EVSlider:SetMax( 100 )
		-- EVSlider:SetValue( LEMON.MaxProps )
		EVSlider:SetDecimals( 0 )
		
		SliderList:AddItem( EVSlider )
		
	    local ApplyEVButton = vgui.Create("DButton")
	    ApplyEVButton:SetText( "Apply Extra Vehicles" );
	    ApplyEVButton.DoClick = function()

	    -- local args = string.Explode( " ", v:Nick() )
		if ExtraEntsComboBox:GetSelected() == nil then
			LEMON.SendChat( ply, "Select a player first." )
			return
		end
		
        LocalPlayer():ConCommand( "rp_admin extravehicles ".. ExtraEntsComboBox:GetSelected( )[1]:GetValue(1) .." ".. EVSlider:GetValue() );
		
	    end
		
		SliderList:AddItem( ApplyEVButton )
		

	CashPanel = vgui.Create( "DPanel" )
	CashPanel:SetSize( 630, 442 )
	CashPanel:SetPos( 3, 3 )
	
		local CashComboBox = vgui.Create( "DListView", CashPanel )
		CashComboBox:SetSize( 170, CashPanel:GetTall() - 6 )
		CashComboBox:SetPos( 3, 3 )
		CashComboBox:SetMultiSelect( false )
		CashComboBox:AddColumn( "OOC Name" )
		CashComboBox:AddColumn( "RP Name" )
		CashComboBox:AddColumn( "Caps" )
	for k, v in pairs(player.GetAll()) do	
		CashComboBox:AddLine( v:Name(), v:Nick(), v:GetNWString("money") )
	end	
		
		local CashList = vgui.Create( "DPanelList", CashPanel )
		CashList:SetSize( CashPanel:GetWide() - 185, CashPanel:GetTall() - 6 )
		CashList:SetPos( 180, 3 )
		CashList:SetSpacing( 10 )
		CashList:SetPadding( 5 )
		
		local Cashlabel = vgui.Create("DLabel")
		Cashlabel:SetText( "To gift a player some caps, select a player, enter the amount below, and click 'Send Caps'" )
		
		CashList:AddItem( Cashlabel )
		
		local Cashlabel2 = vgui.Create("DLabel")
		Cashlabel2:SetText( "Note: This is a very special command that doesn't take caps out of your own pocket!" )
		
		CashList:AddItem( Cashlabel2 )
		
		local Cashlabel3 = vgui.Create("DLabel")
		Cashlabel3:SetText( "So don't admin abuse/exploit :P -Otoris ^_^" )
		
		CashList:AddItem( Cashlabel3 )
		
		local Cashbox = vgui.Create( "DTextEntry" )
		
		CashList:AddItem( Cashbox )
		
		local Cashbutton = vgui.Create( "DButton" )
		Cashbutton:SetText( "Send Caps" )
		Cashbutton.DoClick = function()

		LocalPlayer():ConCommand( "rp_giftcaps ".. CashComboBox:GetSelected( )[1]:GetValue(1) .." ".. Cashbox:GetValue() )
		
		end
		
		CashList:AddItem( Cashbutton )
		
	WarnPanel = vgui.Create( "DPanel" )
	WarnPanel:SetSize( 630, 442 )
	WarnPanel:SetPos( 3, 3 )
	
		local WarnComboBox = vgui.Create( "DListView", WarnPanel )
		WarnComboBox:SetSize( 170, WarnPanel:GetTall() - 6 )
		WarnComboBox:SetPos( 3, 3 )
		WarnComboBox:SetMultiSelect( false )
		WarnComboBox:AddColumn( "OOC Name" )
		WarnComboBox:AddColumn( "RP Name" )
		WarnComboBox:AddColumn( "Warnings" )
	for k, v in pairs(player.GetAll()) do	
		WarnComboBox:AddLine( v:Name(), v:Nick(), v:GetNWString("warnings") )
	end	
	
		local WarnList = vgui.Create( "DPanelList", WarnPanel )
		WarnList:SetSize( WarnPanel:GetWide() - 185, WarnPanel:GetTall() - 6 )
		WarnList:SetPos( 180, 3 )
		WarnList:SetSpacing( 10 )
		WarnList:SetPadding( 5 )
		
		local reasonlabel = vgui.Create("DLabel")
		reasonlabel:SetText( "How does this tab work?" )
		
		WarnList:AddItem( reasonlabel )
		
		local reasonlabel2 = vgui.Create("DLabel")
		reasonlabel2:SetText( "It is rather simple, basically this is worth 1/3 of a kick/ban" )
		
		WarnList:AddItem( reasonlabel2 )
		
		local reasonlabel3 = vgui.Create("DLabel")
		reasonlabel3:SetText( "Step 1: Select a player." )
		
		WarnList:AddItem( reasonlabel3 )
		
		-- local reasonlabel5 = vgui.Create("DLabel")
		-- reasonlabel5:SetText( "Step two: Enter a reason in the box then hit apply." )
		
		-- WarnList:AddItem( reasonlabel5 )
		
		local reasonlabel6 = vgui.Create("DLabel")
		reasonlabel6:SetText( "Step b): Click on either Add Warning or Subtract Warning" )
		
		WarnList:AddItem( reasonlabel6 )
		
		local reasonlabel7 = vgui.Create("DLabel")
		reasonlabel7:SetText( "The reason is sent to the player privatly for their eyes only." )
		
		WarnList:AddItem( reasonlabel7 )
		
		local reasonlabel4 = vgui.Create("DLabel")
		reasonlabel4:SetText( "After the player has accumulated 3 warnings, they receive a kick/ban (720mins)" )
		
		WarnList:AddItem( reasonlabel4 )
		
		local WarnEntry = vgui.Create( "DTextEntry" )
		
		WarnList:AddItem( WarnEntry )
		
		-- local ApplyReason = vgui.Create( "DButton" )
		-- ApplyReason:SetText( "Apply" )
		-- ApplyReason.DoClick = function()
		-- RunConsoleCommand( "rp_setreason", WarnEntry:GetValue() )
		-- end
		
		-- WarnList:AddItem( ApplyReason )
		
		local GiveWarn = vgui.Create( "DButton" )
		GiveWarn:SetText( "Add" )
		GiveWarn.DoClick = function()
		RunConsoleCommand( "rp_setreason", WarnEntry:GetValue() )
		timer.Create( "warndelay", 1, 1, function() LocalPlayer():ConCommand( "rp_givewarn ".. WarnComboBox:GetSelected( )[1]:GetValue(1) .." 1" ) end )
		end
		
		WarnList:AddItem( GiveWarn )
		
		local TakeWarn = vgui.Create( "DButton" )
		TakeWarn:SetText( "Subtract" )
		TakeWarn.DoClick = function()
		LocalPlayer():ConCommand( "rp_takewarn ".. WarnComboBox:GetSelected( )[1]:GetValue(1) .." 1") --.. LocalPlayer():SetNWString( "wreason", WarnEntry:GetValue() 
		end
		
		WarnList:AddItem( TakeWarn )
		
		
	TrustPanel = vgui.Create( "DPanel" )
	TrustPanel:SetSize( 630, 442 )
	TrustPanel:SetPos( 3, 3 )
	
		local TrustComboBox = vgui.Create( "DListView", TrustPanel )
		TrustComboBox:SetSize( 200, TrustPanel:GetTall() - 6 )
		TrustComboBox:SetPos( 3, 3 )
		TrustComboBox:SetMultiSelect( false )
		TrustComboBox:AddColumn( "OOC Name" )
		--TrustComboBox:AddColumn( "RP Name" )
		TrustComboBox:AddColumn( "TT" )
		TrustComboBox:AddColumn( "GT" )
		TrustComboBox:AddColumn( "PT" )
		TrustComboBox:ColumnWidth( "TT", 20 )
	for k, v in pairs(player.GetAll()) do	
		TrustComboBox:AddLine( v:Name(), v:GetNWInt( "tooltrust" ), v:GetNWInt( "gravtrust" ), v:GetNWInt( "phytrust" ) )
	end	
	
		local TrustList = vgui.Create( "DPanelList", TrustPanel )
		TrustList:SetSize( TrustPanel:GetWide() - 215, TrustPanel:GetTall() - 6 )
		TrustList:SetPos( 210, 3 )
		TrustList:SetSpacing( 10 )
		TrustList:SetPadding( 5 )
		
		-- local CollapsableTCategory = vgui.Create( "DCollapsibleCategory" )
		-- CollapsableTCategory:SetExpanded( 0 )
		-- CollapsableTCategory:SetLabel( "Trusts" )
		-- DataList2:AddItem( CollapsableTCategory )
		
		-- local TrustsList = vgui.Create( "DPanelList" )
		-- TrustsList:SetAutoSize( true )
		local ttlabel = vgui.Create("DLabel")
		ttlabel:SetText( "This tab is for managing player trusts." )
		
		TrustList:AddItem( ttlabel )
		
		local ttlabel2 = vgui.Create("DLabel")
		ttlabel2:SetText( "To use this, begin by selecting a player. Now click on an option." )
		
		TrustList:AddItem( ttlabel2 )
		
		local ttlabel3 = vgui.Create("DLabel")
		ttlabel3:SetText( "TT = ToolTrust GT = GravTrust PT = PhysTrust" )
		
		TrustList:AddItem( ttlabel3 )
		
		local ttlabel4 = vgui.Create("DLabel")
		ttlabel4:SetText( "Tip: You can move the column dividers on your left by clicking between them." )
		
		TrustList:AddItem( ttlabel4 )
		
		local TTButton = vgui.Create("DButton");
	    TTButton:SetText("Give Tooltrust");
	    TTButton.DoClick = function()
		
        LocalPlayer():ConCommand("rp_admin tooltrust ".. TrustComboBox:GetSelected( )[1]:GetValue(1) .." 1");

	    end

		TrustList:AddItem(TTButton)
		
		local TTButton2 = vgui.Create("DButton");
	    TTButton2:SetText("Strip Tooltrust");
	    TTButton2.DoClick = function()
		
        LocalPlayer():ConCommand("rp_admin tooltrust ".. TrustComboBox:GetSelected( )[1]:GetValue(1) .." 0");

	    end

		TrustList:AddItem(TTButton2)
		
		local PTButton = vgui.Create( "DButton" )
	    PTButton:SetText( "Give Physics Gun Trust" )
	    PTButton.DoClick = function()
		LocalPlayer():ConCommand( "rp_admin phystrust ".. TrustComboBox:GetSelected( )[1]:GetValue(1) .. " 1" )
		end
		
		TrustList:AddItem( PTButton )
		
		local PTButton2 = vgui.Create( "DButton" )
	    PTButton2:SetText( "Strip Physics Gun Trust" )
	    PTButton2.DoClick = function()
		LocalPlayer():ConCommand( "rp_admin phystrust ".. TrustComboBox:GetSelected( )[1]:GetValue(1) .. " 0" )
		end
		
		TrustList:AddItem( PTButton2 )
		
		local GTButton = vgui.Create( "DButton" )
	    GTButton:SetText( "Give Gravity Gun Trust" )
	    GTButton.DoClick = function()
		LocalPlayer():ConCommand( "rp_admin gravtrust ".. TrustComboBox:GetSelected( )[1]:GetValue(1) .. " 1" )
		end
		
		TrustList:AddItem( GTButton )
		
		local GTButton2 = vgui.Create( "DButton" )
	    GTButton2:SetText( "Strip Gravity Gun Trust" )
	    GTButton2.DoClick = function()
		LocalPlayer():ConCommand( "rp_admin gravtrust ".. TrustComboBox:GetSelected( )[1]:GetValue(1) .. " 0" )
		end
		
		TrustList:AddItem( GTButton2 )
		
		
	TelePanel = vgui.Create( "DPanel" )
	TelePanel:SetSize( 630, 442 )
	TelePanel:SetPos( 3, 3 )
	
	
	
		local TeleComboBox = vgui.Create( "DListView", TelePanel )
		TeleComboBox:SetSize( 150, TelePanel:GetTall() - 6 )
		TeleComboBox:SetPos( 3, 3 )
		TeleComboBox:SetMultiSelect( false )
		TeleComboBox:AddColumn( "OOC Name" )
		TeleComboBox:AddColumn( "RP Name" )
	for k, v in pairs(player.GetAll()) do	
		TeleComboBox:AddLine( v:Name(), v:Nick() )
	end	
		
		
		local TeleList = vgui.Create( "DPanelList", TelePanel )
		TeleList:SetSize( TelePanel:GetWide() - 165, TelePanel:GetTall() - 6 )
		TeleList:SetPos( 160, 3 )
		TeleList:SetSpacing( 10 )
		TeleList:SetPadding( 5 )
		
		local Telelabel = vgui.Create("DLabel")
		Telelabel:SetText( "This tab is for teleportation purposes." )
		
		TeleList:AddItem( Telelabel )
		
		local Telelabel2 = vgui.Create("DLabel")
		Telelabel2:SetText( "Select a player then click on an option." )
		
		TeleList:AddItem( Telelabel2 )
		
		local Telelabel3 = vgui.Create("DLabel")
		Telelabel3:SetText( "Note: On very very very rare occasions I have had this cakescript \nfunction bring the wrong player" )
		Telelabel3:SetSize( 300, 40 )
		TeleList:AddItem( Telelabel3 )		
		
		local BringButton = vgui.Create( "DButton" )
		BringButton:SetText( "Bring" )
		BringButton.DoClick = function()
		LocalPlayer():ConCommand( "rp_bring ".. TeleComboBox:GetSelected( )[1]:GetValue(1) )
		end
		
		TeleList:AddItem( BringButton )
		
		local GotoButton = vgui.Create( "DButton" )
		GotoButton:SetText( "Goto" )
		GotoButton.DoClick = function()
		LocalPlayer():ConCommand( "rp_goto ".. TeleComboBox:GetSelected( )[1]:GetValue(1) )
		end
		
		TeleList:AddItem( GotoButton )
		
	FlagsPanel = vgui.Create( "DPanel" )
	FlagsPanel:SetSize( 630, 442 )
	FlagsPanel:SetPos( 3, 3 )
	
		local FlagsComboBox = vgui.Create( "DListView", FlagsPanel )
		FlagsComboBox:SetSize( 150, FlagsPanel:GetTall() - 6 )
		FlagsComboBox:SetPos( 3, 3 )
		FlagsComboBox:SetMultiSelect( false )
		FlagsComboBox:AddColumn( "OOC Name" )
		FlagsComboBox:AddColumn( "RP Name" )
	for k, v in pairs(player.GetAll()) do	
		FlagsComboBox:AddLine( v:Name(), v:Nick() )
	end	
	
		local Flags = vgui.Create("DListView", FlagsPanel);
		Flags:SetPos( 160, 3 )
		Flags:SetSize(300, FlagsPanel:GetTall() - 6);
		Flags:SetMultiSelect(false)
		Flags:AddColumn("Flag Name");
		--Flags:AddColumn("Salary");
		Flags:AddColumn("Business Access");
		Flags:AddColumn("Public Flag");
		Flags:AddColumn("Flag Key");
		
		local FlagsList = vgui.Create( "DPanelList", FlagsPanel )
		FlagsList:SetSize( 160, FlagsPanel:GetTall() - 6 )
		FlagsList:SetPos( 465, 3 )
		FlagsList:SetSpacing( 10 )
		FlagsList:SetPadding( 5 )
		
		local Flagslabel = vgui.Create("DLabel")
		Flagslabel:SetSize( 150, 30 )
		Flagslabel:SetText( "This tab is used\n to set player flags" )
		
		FlagsList:AddItem( Flagslabel )
		
		local Flagslabel2 = vgui.Create("DLabel")
		Flagslabel2:SetSize( 150, 30 )
		Flagslabel2:SetText( "Select a player \nthen select a flag" )
		
		FlagsList:AddItem( Flagslabel2 )
		
		local Flagslabel3 = vgui.Create("DLabel")
		Flagslabel3:SetText( "Then click 'Apply'" )
		--Flagslabel3:SetSize( 300, 40 )
		FlagsList:AddItem( Flagslabel3 )		
		
		local FlagButton = vgui.Create( "DButton" )
		FlagButton:SetText( "Give Flag" )
		FlagButton.DoClick = function()
		LocalPlayer():ConCommand( "rp_admin setflags ".. FlagsComboBox:GetSelected( )[1]:GetValue(1) .." ".. Flags:GetSelected( )[4]:GetValue(1) )
		end
		
		FlagsList:AddItem( FlagButton )
		
		-- local GotoButton = vgui.Create( "DButton" )
		-- GotoButton:SetText( "Goto" )
		-- GotoButton.DoClick = function()
		-- LocalPlayer():ConCommand( "rp_goto ".. FlagsComboBox:GetSelected( )[1]:GetValue(1) )
		-- end
		
		-- FlagsList:AddItem( GotoButton )
	
	-- function Flags:DoDoubleClick(LineID, Line)
	
		-- LocalPlayer():ConCommand("rp_flag " .. TeamTable[LineID].flagkey);
		-- PlayerMenu:Remove();
		-- PlayerMenu = nil;
		
	-- end
	
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

	Adminlist = vgui.Create( "DPanelList" )
	Adminlist:SetParent( AdminFrame )
	--Soundslist:SetSize( 280, 240 )
	Adminlist:SetPadding(5)
	Adminlist:SetSpacing(5)
	Adminlist:EnableHorizontal(false)
	Adminlist:EnableVerticalScrollbar(true)	
		
		local AdmList = vgui.Create( "DPanelList" )
		AdmList:SetAutoSize( true )
        --HL1List:SetSize( 280, 240 )
	
		local CollapsableAdminList = vgui.Create( "DCollapsibleCategory" )
		CollapsableAdminList:SetExpanded( 0 )
		CollapsableAdminList:SetLabel( "Props - WIP" )
		--CollapsableHL1List:SetSize( 543, 0 )

		Adminlist:AddItem( CollapsableAdminList )
		
		local randompropbutton = vgui.Create( "DButton" )
		randompropbutton:SetText( "Spawns items throughout the map" )
		randompropbutton.DoClick = function( button ) LocalPlayer():ConCommand( "rp_startrandomdrop" ) end
		
		AdmList:AddItem( randompropbutton )

		local randomremovebutton = vgui.Create( "DButton" )
		randomremovebutton:SetText( "Removes all random items" )
		randomremovebutton.DoClick = function( button ) LocalPlayer():ConCommand( "rp_removerandomitems" ) end
		
		AdmList:AddItem( randomremovebutton )
		
		CollapsableAdminList:SetContents( AdmList )
		
		local OOCSlider = vgui.Create( "DNumSlider" )
		OOCSlider:SetText( "OOC Timer in Seconds" )
		OOCSlider:SetMin( 0 )
		OOCSlider:SetMax( 120 )
		-- OOCSlider:SetValue( LEMON.ConVars[ "OOCDelay" ] )
		-- EPSlider:SetValue( LEMON.MaxProps
		OOCSlider:SetDecimals( 0 )
		
		Adminlist:AddItem( OOCSlider )
		
	    local ApplyOOCButton = vgui.Create("DButton")
	    ApplyOOCButton:SetText( "Apply" );
	    ApplyOOCButton.DoClick = function()

        LocalPlayer():ConCommand( "rp_ooctimer ".. OOCSlider:GetValue() );

	    end
		
		Adminlist:AddItem( ApplyOOCButton )
		
		local observebutton = vgui.Create( "DButton" )
		observebutton:SetText( "Observe - Admin Noclip" )
		observebutton.DoClick = function( button ) LocalPlayer():ConCommand( "rp_admin observe" ) end
		
		Adminlist:AddItem( observebutton )
		
		
	--End admin frame!
	
	--Begin Sounds Tab Here

		

		

		

	PropertySheet:AddSheet( "Management", PlayerList, "gui/silkicons/user", false, false, "Manage Players with a click of a button." )
	--PropertySheet:AddSheet( "Sounds List", Soundslist, "gui/silkicons/sound", false, false, "List of Sounds." )
	PropertySheet:AddSheet( "Trusts", TrustPanel, "gui/silkicons/heart", false, false, "Trust is a two way street." )
	PropertySheet:AddSheet( "Teleport", TelePanel, "gui/silkicons/pill", false, false, "Red pill or Blue pill?" )
	PropertySheet:AddSheet( "Warnings", WarnPanel, "gui/silkicons/exclamation", false, false, "Wag your finger at players..." )
	PropertySheet:AddSheet( "Flags", FlagsPanel, "gui/silkicons/application_xp_terminal", false, false, "Flag IC Players..." )
	PropertySheet:AddSheet( "Player Limits", ExtraEntsPanel, "gui/silkicons/shield", false, false, "Players extra entity limits." )
	PropertySheet:AddSheet( "Cap Managment", CashPanel, "gui/silkicons/check_on", false, false, "The only tab that makes you feel rich..." )
	PropertySheet:AddSheet( "Server-Side", Adminlist, "gui/silkicons/user", false, false, "Server stuff..." )
	--application_xp_terminal
	
end
function oSoundMenu( )

  SoundFrame = vgui.Create("InvisiblePanel")
  SoundFrame:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
  SoundFrame:SetSize(640, 480)
  SoundFrame:SetTitle( "FalloutScript Sounds" )
  SoundFrame:SetVisible( true )
  SoundFrame:SetDraggable( false )
  SoundFrame:ShowCloseButton( true )
  SoundFrame:SetBackgroundBlur( true )
  SoundFrame:MakePopup()

	Soundslist = vgui.Create( "DPanelList" )
	Soundslist:SetParent( SoundFrame )
	Soundslist:SetPos( 0, 20 )
	Soundslist:SetSize( 620, 475 )
	Soundslist:SetPadding(5)
	Soundslist:SetSpacing(5)
	Soundslist:EnableHorizontal(false)
	Soundslist:EnableVerticalScrollbar(true)	
	--Begin HL1 Sounds
		local HL1List = vgui.Create( "DPanelList" )
		HL1List:SetAutoSize( true )
        --HL1List:SetSize( 280, 240 )
	
		local CollapsableHL1List = vgui.Create( "DCollapsibleCategory" )
		CollapsableHL1List:SetExpanded( 0 )
		CollapsableHL1List:SetLabel( "Half-Life 1" )
		--CollapsableHL1List:SetSize( 543, 0 )

		Soundslist:AddItem( CollapsableHL1List )
		
		hl1button1 = vgui.Create( "DButton" )
		hl1button1:SetText( "''Black Mesa Inbound''" )
		hl1button1.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song3.mp3" ) end
		
		HL1List:AddItem( hl1button1 )
		
		hl1button2 = vgui.Create( "DButton" )
		hl1button2:SetText( "''Unforeseen Consequences''" )
		hl1button2.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song5.mp3" ) end
		
		HL1List:AddItem( hl1button2 )	
		
		hl1button3 = vgui.Create( "DButton" )
		hl1button3:SetText( "''Tunnels''" )
		hl1button3.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song6.mp3" ) end
		
		HL1List:AddItem( hl1button3 )		

		hl1button4 = vgui.Create( "DButton" )
		hl1button4:SetText( "''Song 9''" )
		hl1button4.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song9.mp3" ) end
		
		HL1List:AddItem( hl1button4 )
		
		hl1button5 = vgui.Create( "DButton" )
		hl1button5:SetText( "''Helicopter Chase''" )
		hl1button5.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song10.mp3" ) end
		
		HL1List:AddItem( hl1button5 )	
		
		hl1button6 = vgui.Create( "DButton" )
		hl1button6:SetText( "''Valve Theme''" )
		hl1button6.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song11.mp3" ) end
		
		HL1List:AddItem( hl1button6 )	

		hl1button7 = vgui.Create( "DButton" )
		hl1button7:SetText( "''Song 14''" )
		hl1button7.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song14.mp3" ) end
		
		HL1List:AddItem( hl1button7 )
		
		hl1button8 = vgui.Create( "DButton" )
		hl1button8:SetText( "''Lighthouse Stand''" )
		hl1button8.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song15.mp3" ) end
		
		HL1List:AddItem( hl1button8 )	
		
		hl1button9 = vgui.Create( "DButton" )
		hl1button9:SetText( "''Heavy Machinery''" )
		hl1button9.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song17.mp3" ) end
		
		HL1List:AddItem( hl1button9 )		

		hl1button10 = vgui.Create( "DButton" )
		hl1button10:SetText( "''Sustainability''" )
		hl1button10.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song19.mp3" ) end
		
		HL1List:AddItem( hl1button10 )
		
		hl1button11 = vgui.Create( "DButton" )
		hl1button11:SetText( "''Black Mesa East''" )
		hl1button11.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song20.mp3" ) end
		
		HL1List:AddItem( hl1button11 )	
		
		hl1button12 = vgui.Create( "DButton" )
		hl1button12:SetText( "''Song 21''" )
		hl1button12.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song21.mp3" ) end
		
		HL1List:AddItem( hl1button12 )			
		
		hl1button13 = vgui.Create( "DButton" )
		hl1button13:SetText( "''Song 24''" )
		hl1button13.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song24.mp3" ) end
		
		HL1List:AddItem( hl1button13 )
		
		hl1button14 = vgui.Create( "DButton" )
		hl1button14:SetText( "''End Credits Mix''" )
		hl1button14.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song25_REMIX3.mp3" ) end
		
		HL1List:AddItem( hl1button14 )	
		
		hl1button15 = vgui.Create( "DButton" )
		hl1button15:SetText( "''Cascade Resonance''" )
		hl1button15.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL1_song26.mp3" ) end
		
		HL1List:AddItem( hl1button15 )		
		
		CollapsableHL1List:SetContents( HL1List )
		
		--Begin HL2 Sounds
		
		local HL2List = vgui.Create( "DPanelList" )
		HL2List:SetAutoSize( true )
        --HL2List:SetSize( 200, 300 )
	
		local CollapsableHL2List = vgui.Create( "DCollapsibleCategory" )
		CollapsableHL2List:SetExpanded( 0 )
		CollapsableHL2List:SetLabel( "Half-Life 2" )
		CollapsableHL2List:SetSize( 543, 0 )

		Soundslist:AddItem( CollapsableHL2List )
		
		hl2button1 = vgui.Create( "DButton" )
		hl2button1:SetText( "''Radio''" )
		hl2button1.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/radio1.mp3" ) end
		
		HL2List:AddItem( hl2button1 )	
		
		hl2button2 = vgui.Create( "DButton" )
		hl2button2:SetText( "''Ravenholm''" )
		hl2button2.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/Ravenholm_1.mp3" ) end
		
		HL2List:AddItem( hl2button2 )			
		
		hl2button3 = vgui.Create( "DButton" )
		hl2button3:SetText( "''HL2 Intro''" )
		hl2button3.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_intro.mp3" ) end
		
		HL2List:AddItem( hl2button3 )			
		
		hl2button4 = vgui.Create( "DButton" )
		hl2button4:SetText( "''Citadel''" )
		hl2button4.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song0.mp3" ) end
		
		HL2List:AddItem( hl2button4 )	
		
		hl2button5 = vgui.Create( "DButton" )
		hl2button5:SetText( "''Song 1''" )
		hl2button5.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song1.mp3" ) end
		
		HL2List:AddItem( hl2button5 )			
		
		hl2button6 = vgui.Create( "DButton" )
		hl2button6:SetText( "''Song 2''" )
		hl2button6.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song2.mp3" ) end
		
		HL2List:AddItem( hl2button6 )	

		hl2button7 = vgui.Create( "DButton" )
		hl2button7:SetText( "''Highway 17''" )
		hl2button7.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song3.mp3" ) end
		
		HL2List:AddItem( hl2button7 )	
		
		hl2button8 = vgui.Create( "DButton" )
		hl2button8:SetText( "''Song 4''" )
		hl2button8.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song4.mp3" ) end
		
		HL2List:AddItem( hl2button8 )			
		
		hl2button9 = vgui.Create( "DButton" )
		hl2button9:SetText( "''Strider''" )
		hl2button9.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song6.mp3" ) end
		
		HL2List:AddItem( hl2button9 )
		
		hl2button10 = vgui.Create( "DButton" )
		hl2button10:SetText( "''Ravenholm 2''" )
		hl2button10.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song7.mp3" ) end
		
		HL2List:AddItem( hl2button10 )	
		
		hl2button11 = vgui.Create( "DButton" )
		hl2button11:SetText( "''Kleiner's Lab''" )
		hl2button11.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song10.mp3" ) end
		
		HL2List:AddItem( hl2button11 )			
		
		hl2button12 = vgui.Create( "DButton" )
		hl2button12:SetText( "''Disrepair''" )
		hl2button12.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song11.mp3" ) end
		
		HL2List:AddItem( hl2button12 )	

		hl2button13 = vgui.Create( "DButton" )
		hl2button13:SetText( "''Song 12''" )
		hl2button13.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song12_long.mp3" ) end
		
		HL2List:AddItem( hl2button13 )	
		
		hl2button14 = vgui.Create( "DButton" )
		hl2button14:SetText( "''Song 13''" )
		hl2button14.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song13.mp3" ) end
		
		HL2List:AddItem( hl2button14 )			
		
		hl2button15 = vgui.Create( "DButton" )
		hl2button15:SetText( "''Water Hazard''" )
		hl2button15.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song14.mp3" ) end
		
		HL2List:AddItem( hl2button15 )	
		
		hl2button16 = vgui.Create( "DButton" )
		hl2button16:SetText( "''The Nexus''" )
		hl2button16.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song15.mp3" ) end
		
		HL2List:AddItem( hl2button16 )	
		
		hl2button17 = vgui.Create( "DButton" )
		hl2button17:SetText( "''Follow Freeman''" )
		hl2button17.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song16.mp3" ) end
		
		HL2List:AddItem( hl2button17 )			
		
		hl2button18 = vgui.Create( "DButton" )
		hl2button18:SetText( "''Song 17''" )
		hl2button18.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song17.mp3" ) end
		
		HL2List:AddItem( hl2button18 )	

		hl2button19 = vgui.Create( "DButton" )
		hl2button19:SetText( "''Nova Prospekt''" )
		hl2button19.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song19.mp3" ) end
		
		HL2List:AddItem( hl2button19 )	
		
		hl2button20 = vgui.Create( "DButton" )
		hl2button20:SetText( "''Song 20 Submix 4''" )
		hl2button20.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song20_submix4.mp3" ) end
		
		HL2List:AddItem( hl2button20 )			
		
		hl2button21 = vgui.Create( "DButton" )
		hl2button21:SetText( "''Gunship Down''" )
		hl2button21.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song23_SuitSong3.mp3" ) end
		
		HL2List:AddItem( hl2button21 )		
		
		hl2button22 = vgui.Create( "DButton" )
		hl2button22:SetText( "''Combine Theme''" )
		hl2button22.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song25_Teleporter.mp3" ) end
		
		HL2List:AddItem( hl2button22 )			
		
		hl2button23 = vgui.Create( "DButton" )
		hl2button23:SetText( "''Hardly Ideal''" )
		hl2button23.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song26.mp3" ) end
		
		HL2List:AddItem( hl2button23 )		
		
		hl2button24 = vgui.Create( "DButton" )
		hl2button24:SetText( "''Welcome to City 17''" )
		hl2button24.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song26_trainstation1.mp3" ) end
		
		HL2List:AddItem( hl2button24 )			
		
		hl2button25 = vgui.Create( "DButton" )
		hl2button25:SetText( "''Sight of Citadel''" )
		hl2button25.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song27_trainstation2.mp3" ) end
		
		HL2List:AddItem( hl2button25 )		
		
		hl2button26 = vgui.Create( "DButton" )
		hl2button26:SetText( "''Song 28''" )
		hl2button26.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song28.mp3" ) end
		
		HL2List:AddItem( hl2button26 )			
		
		hl2button27 = vgui.Create( "DButton" )
		hl2button27:SetText( "''Head to Route Canal''" )
		hl2button27.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song29.mp3" ) end
		
		HL2List:AddItem( hl2button27 )	
		
		hl2button28 = vgui.Create( "DButton" )
		hl2button28:SetText( "''Song 30''" )
		hl2button28.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song30.mp3" ) end
		
		HL2List:AddItem( hl2button28 )		
		
		hl2button29 = vgui.Create( "DButton" )
		hl2button29:SetText( "''Song 31''" )
		hl2button29.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song31.mp3" ) end
		
		HL2List:AddItem( hl2button29 )			
		
		hl2button30 = vgui.Create( "DButton" )
		hl2button30:SetText( "''Song 32''" )
		hl2button30.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song32.mp3" ) end
		
		HL2List:AddItem( hl2button30 )	
		
		hl2button31 = vgui.Create( "DButton" )
		hl2button31:SetText( "''Song 33''" )
		hl2button31.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song33.mp3" ) end
		
		HL2List:AddItem( hl2button31 )	
		
		CollapsableHL2List:SetContents( HL2List )
		
		local CollapsableEP1List = vgui.Create( "DCollapsibleCategory" )
		CollapsableEP1List:SetExpanded( 0 )
		CollapsableEP1List:SetLabel( "Half-Life 2 - Episode 1" )
		CollapsableEP1List:SetSize( 543, 0 )
		
		Soundslist:AddItem( CollapsableEP1List )
		
		local EP1List = vgui.Create( "DPanelList" )
		EP1List:SetAutoSize( true )
		
		ep1button1 = vgui.Create( "DButton" )
		ep1button1:SetText( "''Eine Kleiner Elevatormuzik''" )
		ep1button1.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song1.mp3" ) end
		
		EP1List:AddItem( ep1button1 )			
		
		ep1button2 = vgui.Create( "DButton" )
		ep1button2:SetText( "''Combine Advisory''" )
		ep1button2.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song2.mp3" ) end
		
		EP1List:AddItem( ep1button2 )	
		
		ep1button3 = vgui.Create( "DButton" )
		ep1button3:SetText( "''Guard Down''" )
		ep1button3.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song4.mp3" ) end
		
		EP1List:AddItem( ep1button3 )		

		ep1button4 = vgui.Create( "DButton" )
		ep1button4:SetText( "''Darkness at Noon''" )
		ep1button4.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song8.mp3" ) end
		
		EP1List:AddItem( ep1button4 )			
		
		ep1button5 = vgui.Create( "DButton" )
		ep1button5:SetText( "''Disrupted Origninal''" )
		ep1button5.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song11.mp3" ) end
		
		EP1List:AddItem( ep1button5 )	
		
		ep1button6 = vgui.Create( "DButton" )
		ep1button6:SetText( "''Self-Destruction''" )
		ep1button6.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song12.mp3" ) end
		
		EP1List:AddItem( ep1button6 )	

		ep1button7 = vgui.Create( "DButton" )
		ep1button7:SetText( "''What kind of Hospital is this?''" )
		ep1button7.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song18.mp3" ) end
		
		EP1List:AddItem( ep1button7 )		

		ep1button8 = vgui.Create( "DButton" )
		ep1button8:SetText( "''Infraradiant''" )
		ep1button8.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song19a.mp3" ) end
		
		EP1List:AddItem( ep1button8 )			
		
		ep1button9 = vgui.Create( "DButton" )
		ep1button9:SetText( "''Decay Mode''" )
		ep1button9.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song19b.mp3" ) end
		
		EP1List:AddItem( ep1button9 )	
		
		ep1button10 = vgui.Create( "DButton" )
		ep1button10:SetText( "''Penultimatum''" )
		ep1button10.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song21.mp3" ) end
		
		EP1List:AddItem( ep1button10 )		
		
		
		CollapsableEP1List:SetContents( EP1List )
		
		local CollapsableEP2List = vgui.Create( "DCollapsibleCategory" )
		CollapsableEP2List:SetExpanded( 0 )
		CollapsableEP2List:SetLabel( "Half-Life 2 - Episode 2" )
		CollapsableEP2List:SetSize( 543, 0 )
		
		Soundslist:AddItem( CollapsableEP2List )
		
		local ep2List = vgui.Create( "DPanelList" )
		ep2List:SetAutoSize( true )
		
		ep2button1 = vgui.Create( "DButton" )
		ep2button1:SetText( "''No One Rides For Free''" )
		ep2button1.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song0.mp3" ) end
		
		ep2List:AddItem( ep2button1 )			
		
		ep2button2 = vgui.Create( "DButton" )
		ep2button2:SetText( "''Dark Interval''" )
		ep2button2.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song3.mp3" ) end
		
		ep2List:AddItem( ep2button2 )	
		
		ep2button3 = vgui.Create( "DButton" )
		ep2button3:SetText( "''Song 9''" )
		ep2button3.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song9.mp3" ) end
		
		ep2List:AddItem( ep2button3 )		

		ep2button4 = vgui.Create( "DButton" )
		ep2button4:SetText( "''Nectarium''" )
		ep2button4.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song15.mp3" ) end
		
		ep2List:AddItem( ep2button4 )			
		
		ep2button5 = vgui.Create( "DButton" )
		ep2button5:SetText( "''Extinction Event Horizon''" )
		ep2button5.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song20.mp3" ) end
		
		ep2List:AddItem( ep2button5 )	
		
		ep2button6 = vgui.Create( "DButton" )
		ep2button6:SetText( "''Vortal Combat''" )
		ep2button6.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song22.mp3" ) end
		
		ep2List:AddItem( ep2button6 )	

		ep2button7 = vgui.Create( "DButton" )
		ep2button7:SetText( "''Sector Sweep''" )
		ep2button7.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song23.mp3" ) end
		
		ep2List:AddItem( ep2button7 )		

		ep2button8 = vgui.Create( "DButton" )
		ep2button8:SetText( "''Shu'ulathoi''" )
		ep2button8.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song23ambient.mp3" ) end
		
		ep2List:AddItem( ep2button8 )			
		
		ep2button9 = vgui.Create( "DButton" )
		ep2button9:SetText( "''Last Legs''" )
		ep2button9.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song24.mp3" ) end
		
		ep2List:AddItem( ep2button9 )	
		
		ep2button10 = vgui.Create( "DButton" )
		ep2button10:SetText( "''Abandoned In Place''" )
		ep2button10.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song25.mp3" ) end
		
		ep2List:AddItem( ep2button10 )		
		
		ep2button11 = vgui.Create( "DButton" )
		ep2button11:SetText( "''Inhuman Frequency''" )
		ep2button11.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song26.mp3" ) end
		
		ep2List:AddItem( ep2button11 )			
		
		ep2button12 = vgui.Create( "DButton" )
		ep2button12:SetText( "''Hunting Party''" )
		ep2button12.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song27.mp3" ) end
		
		ep2List:AddItem( ep2button12 )	
		
		ep2button13 = vgui.Create( "DButton" )
		ep2button13:SetText( "''Eon Trap''" )
		ep2button13.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/VLVX_song28.mp3" ) end
		
		ep2List:AddItem( ep2button13 )		
		
		
		CollapsableEP2List:SetContents( ep2List )
		
		local CollapsablePortalList = vgui.Create( "DCollapsibleCategory" )
		CollapsablePortalList:SetExpanded( 0 )
		CollapsablePortalList:SetLabel( "Portal" )
		CollapsablePortalList:SetSize( 543, 0 )
		
		Soundslist:AddItem( CollapsablePortalList )
		
		local portalList = vgui.Create( "DPanelList" )
		portalList:SetAutoSize( true )
		
		portalbutton1 = vgui.Create( "DButton" )
		portalbutton1:SetText( "''Subject Name Here''" )
		portalbutton1.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/portal_subject_name_here.mp3" ) end
		
		portalList:AddItem( portalbutton1 )			
		
		portalbutton2 = vgui.Create( "DButton" )
		portalbutton2:SetText( "''Taste of Blood''" )
		portalbutton2.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/portal_taste_of_blood.mp3" ) end
		
		portalList:AddItem( portalbutton2 )	
		
		portalbutton3 = vgui.Create( "DButton" )
		portalbutton3:SetText( "''Android Hell''" )
		portalbutton3.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/portal_android_hell.mp3" ) end
		
		portalList:AddItem( portalbutton3 )		

		portalbutton4 = vgui.Create( "DButton" )
		portalbutton4:SetText( "''Self-Esteem Fund''" )
		portalbutton4.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/portal_self_esteem_fund.mp3" ) end
		
		portalList:AddItem( portalbutton4 )			
		
		portalbutton5 = vgui.Create( "DButton" )
		portalbutton5:SetText( "''Procedural Jiggle Bone''" )
		portalbutton5.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/portal_procedural_jiggle_bone.mp3" ) end
		
		portalList:AddItem( portalbutton5 )	
		
		portalbutton6 = vgui.Create( "DButton" )
		portalbutton6:SetText( "''No Cake For You''" )
		portalbutton6.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/portal_no_cake_for_you.mp3" ) end
		
		portalList:AddItem( portalbutton6 )	

		portalbutton7 = vgui.Create( "DButton" )
		portalbutton7:SetText( "''4000 Degrees Kelvin''" )
		portalbutton7.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/portal_4000_degrees_kelvin.mp3" ) end
		
		portalList:AddItem( portalbutton7 )		

		portalbutton8 = vgui.Create( "DButton" )
		portalbutton8:SetText( "''Stop What You Are Doing''" )
		portalbutton8.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/portal_stop_what_you_are_doing.mp3" ) end
		
		portalList:AddItem( portalbutton8 )			
		
		portalbutton9 = vgui.Create( "DButton" )
		portalbutton9:SetText( "''Party Escort''" )
		portalbutton9.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/portal_party_escort.mp3" ) end
		
		portalList:AddItem( portalbutton9 )	
		
		portalbutton10 = vgui.Create( "DButton" )
		portalbutton10:SetText( "''Your Not a Good Person''" )
		portalbutton10.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/portal_youre_not_a_good_person.mp3" ) end
		
		portalList:AddItem( portalbutton10 )		
		
		portalbutton11 = vgui.Create( "DButton" )
		portalbutton11:SetText( "''You Can't Escape You Know''" )
		portalbutton11.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/portal_you_cant_escape_you_know.mp3" ) end
		
		portalList:AddItem( portalbutton11 )			
		
		portalbutton12 = vgui.Create( "DButton" )
		portalbutton12:SetText( "''Still Alive''" )
		portalbutton12.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/portal_atill_alive.mp3" ) end
		
		portalList:AddItem( portalbutton12 )	
		
		CollapsablePortalList:SetContents( portalList )
		
		local CollapsableRequestList = vgui.Create( "DCollapsibleCategory" )
		CollapsableRequestList:SetExpanded( 0 )
		CollapsableRequestList:SetLabel( "Requests - request sounds on the forums." )
		CollapsableRequestList:SetSize( 543, 0 )

		Soundslist:AddItem( CollapsableRequestList )
		
		local RequestList = vgui.Create( "DPanelList" )
		RequestList:SetAutoSize( true )
		
		requestedbutton1 = vgui.Create( "DButton" )
		requestedbutton1:SetText( "''Sustainability''" )
		requestedbutton1.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song19.mp3" ) end
		
		RequestList:AddItem( requestedbutton1 )	
		
		requestedbutton2 = vgui.Create( "DButton" )
		requestedbutton2:SetText( "''Gunship Down''" )
		requestedbutton2.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song23_suitsong3.mp3" ) end
		
		RequestList:AddItem( requestedbutton2 )	
		
		requestedbutton3 = vgui.Create( "DButton" )
		requestedbutton3:SetText( "''HL2 - Song 17'' [Stinger]" )
		requestedbutton3.DoClick = function( button ) LocalPlayer():ConCommand( "playsound music/HL2_song17.mp3" ) end
		
		RequestList:AddItem( requestedbutton3 )	
		
		CollapsableRequestList:SetContents( RequestList )
		
end
concommand.Add( "rp_soundmenu", oSoundMenu )
function msgStartAdmin( data )

StartAdmin();

end
usermessage.Hook( "startadmin", msgStartAdmin );

