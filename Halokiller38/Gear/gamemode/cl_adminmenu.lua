
AdminMenuPanel = nil;

function CreateAdminMenu()

	AdminMenuPanel = CreateBPanel( "Admin Menu", 100, 100, 520, 520 );

	AdminMenuPanel:AddButton( "Players", 10, 10, function() ClearAdminMenuBody(); AdminMenuCreateBody(); AdminMenuGoToPlayerMenu(); end );
	AdminMenuPanel:AddButton( "Server", 70, 10, function() ClearAdminMenuBody(); AdminMenuCreateBody(); AdminMenuGoToServerMenu(); end );
	AdminMenuPanel:AddButton( "Logs", 130, 10, function() ClearAdminMenuBody(); AdminMenuCreateBody(); AdminMenuGoToLogsMenu(); end );
	
	AdminMenuCreateBody();
	AdminMenuGoToPlayerMenu();
	
	gui.EnableScreenClicker( true );
	
end

function AdminMenuGoToLogsMenu()

end

function AdminMenuGoToServerMenu()

end

function AdminMenuCreatePlayerInfoPanel()

	AdminMenuPanel.PlayerInfoPanel = CreateBPanel( nil, 180, 0, 290, 440 );
	AdminMenuPanel.PlayerInfoPanel:SetParent( AdminMenuPanel.BodyPanel );
	AdminMenuPanel.BodyPanel:AddObject( AdminMenuPanel.PlayerInfoPanel );
	AdminMenuPanel.PlayerInfoPanel:SetBodyColor( Color( 40, 40, 40, 200 ) );

end

function AdminMenuGoToPlayerMenu()

	AdminMenuPanel.PlayerPanel = CreateBPanel( nil, 10, 0, 150, 440 );
	AdminMenuPanel.PlayerPanel:SetParent( AdminMenuPanel.BodyPanel );
	AdminMenuPanel.PlayerPanel:SetBodyColor( Color( 40, 40, 40, 200 ) );

	AdminMenuPanel.PlayerPanel.ChosenPlayer = 0;
	AdminMenuPanel.PlayerPanel.LastPlayerCount = #player.GetAll();

	AdminMenuPanel.PlayerPanel.Think = function()
	
		if( AdminMenuPanel.PlayerPanel.LastPlayerCount ~= #player.GetAll() ) then
		
			AdminMenuPanel.PlayerPanel.LastPlayerCount = #player.GetAll();
			AdminMenuBuildPlayerList();	
			
			local ply = player.GetByID( AdminMenuPanel.PlayerPanel.ChosenPlayer );
			
			if( not ply:IsValid() ) then
			
				AdminMenuCreatePlayerInfoPanel();
			
			end
		
		end
	
	end

	AdminMenuBuildPlayerList();
	AdminMenuCreatePlayerInfoPanel();

end

function ClearAdminMenuBody()

	AdminMenuPanel.BodyPanel:RemoveObjects();
	
end

function AdminMenuCreateKickReasonPanel( index )

	local ply = player.GetByID( index );

	local x, y = AdminMenuPanel:GetPos();
	local w, h = AdminMenuPanel:GetSize();
	
	local question = "Kick player?: " .. ply:Nick();

	surface.SetFont( "NewChatFont" );

	local questionwidth = surface.GetTextSize( question );

	if( questionwidth + 20 < 130 ) then
		questionwidth = 130;
	end

	AdminMenuPanel.ReasonPanel = CreateBPanel( "Kick", x + w / 2, y + h / 2, questionwidth + 20, 100 );
	AdminMenuPanel.ReasonPanel:AddLabel( question .. "\nReason:", "NewChatFont", 5, 5, Color( 200, 200, 200, 255 ) );
	
	local entry = vgui.Create( "DTextEntry" );
	entry.Think = function()
		local x, y = AdminMenuPanel.ReasonPanel:GetPos();
		entry:SetPos( x + 5, y + 40 );
	end
	entry:SetSize( questionwidth + 10, 16 );
	entry:SetParent( AdminMenuPanel.ReasonPanel );
	entry:MakePopup();

	AdminMenuPanel.ReasonPanel:AddButton( "Kick", questionwidth - 75, 70, function() RunConsoleCommand( "kickid", ply:UserID(), entry:GetValue() ); end );
	AdminMenuPanel.ReasonPanel:AddButton( "Cancel", questionwidth - 35, 70, function() entry:Remove(); AdminMenuPanel.ReasonPanel:Remove(); AdminMenuPanel:Remove(); end );
	

end

function AdminMenuDisplayPlayerInfo( index )
	
	local ply = player.GetByID( index );
	
	RunConsoleCommand( "rui", index );

	AdminMenuPanel.PlayerInfoPanel:AddLabel( "Name: " .. ply:Nick(), "NewChatFont", 5, 5, Color( 200, 200, 200, 255 ) );
	AdminMenuPanel.PlayerInfoPanel:AddLabel( "Lua index: " .. index, "NewChatFont", 5, nil, Color( 200, 200, 200, 255 ) );
	AdminMenuPanel.PlayerInfoPanel:AddLabel( "UserID: " .. ply:UserID(), "NewChatFont", 5, nil, Color( 200, 200, 200, 255 ) );
	AdminMenuPanel.PlayerInfoPanel.SteamIDLbl = AdminMenuPanel.PlayerInfoPanel:AddLabel( "SteamID: ", "NewChatFont", 5, nil, Color( 200, 200, 200, 255 ) );
	
	local adminstatus = "Not admin";
	
	if( ply:IsSuperAdmin() ) then
	
		adminstatus = "Super Admin";
	
	elseif( ply:IsAdmin() ) then
	
		adminstatus = "Admin";
	
	end
	
	AdminMenuPanel.PlayerInfoPanel:AddLabel( "Admin Status: " .. adminstatus, "NewChatFont", 5, nil, Color( 200, 200, 200, 255 ) );
		
	local starty = AdminMenuPanel.PlayerInfoPanel.BottomY + 10;
	
	AdminMenuPanel.PlayerInfoPanel:AddButton( "Kick", 5, starty, function() AdminMenuCreateKickReasonPanel( index ); end );

end

function AdminMenuBuildPlayerList()

	AdminMenuPanel.PlayerPanel:RemoveObjects();

	local yoffset = 2;

	for k, v in pairs( player.GetAll() ) do
	
		AdminMenuPanel.PlayerPanel:AddLink( v:Nick(), "NewChatFont", 2, yoffset, Color( 200, 200, 200, 255 ), function() AdminMenuPanel.PlayerPanel.ChosenPlayer = k; AdminMenuDisplayPlayerInfo( k ); end );
		yoffset = yoffset + 15;
		
	end

end

function AdminMenuCreateBody()

	if( AdminMenuPanel.BodyPanel ) then
	
		AdminMenuPanel.BodyPanel:RemoveObjects();
		AdminMenuPanel.BodyPanel:Remove();
	
	end
	
	AdminMenuPanel.BodyPanel = CreateBPanel( nil, 10, 20, 490, 470 );
	AdminMenuPanel.BodyPanel:SetParent( AdminMenuPanel );
	AdminMenuPanel.BodyPanel:SetBodyColor( Color( 70, 70, 70, 200 ) );

end

local function msgRecieveUserInfo( msg )

	local steamid = msg:ReadString();
	
	AdminMenuPanel.PlayerInfoPanel.SteamIDLbl:SetText( "SteamID: " .. steamid );
	AdminMenuPanel.PlayerInfoPanel.SteamIDLbl:SizeToContents();

end
usermessage.Hook( "RUI", msgRecieveUserInfo );

