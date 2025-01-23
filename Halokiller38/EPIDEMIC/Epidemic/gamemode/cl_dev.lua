

IRONSIGHTS_DEV = false;

local function ironsights()

	IRONSIGHTS_DEV = !IRONSIGHTS_DEV;

end
concommand.Add( "ironsights", ironsights );

function CreateIronSightsDev()

	IronSightsDev = CreateBPanel( "Ironsights Dev", 10, 10, 200, 150 );

	local tbl = {
	
		"IronSightPos",
		"IronSightAng",
	
	};
	
	local var = {
	
		"x", "y", "z",
	
	};
	
	local p = 0;
	
	local weap = LocalPlayer():GetActiveWeapon();
	
	for k, v in pairs( tbl ) do
	
		if( not IronSightsDev[v] ) then
		
			IronSightsDev[v] = { }
		
		end
	
		for n, m in pairs( var ) do
		
			IronSightsDev[v][m] = vgui.Create( "DNumSlider", IronSightsDev );
			IronSightsDev[v][m]:SetPos( 5, 5 + 16 * p );
			IronSightsDev[v][m]:SetSize( 150, 16 );
			IronSightsDev[v][m]:SetText( v .. "." .. m );
			IronSightsDev[v][m]:SetMin( -200 );
			IronSightsDev[v][m]:SetMax( 200 );
			IronSightsDev[v][m]:SetDecimals( 2 );
			IronSightsDev[v][m]:SetValue( weap:GetTable().Primary[v][m] );

			IronSightsDev[v][m].ValueChanged = function( self )
				
				weap:GetTable().Primary[v][m] = tonumber( IronSightsDev[v][m]:GetValue() );
				
			end
			
			p = p + 1;
			
		end
	
	end
	
	IronSightsDev.InfoButton = IronSightsDev:AddButton( "OUTPUT INFO", 10, 120 );
	IronSightsDev.InfoButton.Action = function()
	
		Msg( "SWEP.Primary.IronSightPos = Vector( " .. IronSightsDev.IronSightPos.x:GetValue().. ", " .. IronSightsDev.IronSightPos.y:GetValue() .. ", " .. IronSightsDev.IronSightPos.z:GetValue() .. " );\n" );
 		Msg( "SWEP.Primary.IronSightAng = Angle( " .. IronSightsDev.IronSightAng.x:GetValue().. ", " .. IronSightsDev.IronSightAng.y:GetValue() .. ", " .. IronSightsDev.IronSightAng.z:GetValue() .. " );\n" );
		
	end

	gui.EnableScreenClicker( true );

end

function DestroyIronSightsDev()

	if( IronSightsDev and IronSightsDev:IsValid() ) then
	
		IronSightsDev:Remove();
		IronSightsDev = nil;
	
	end
	
	HideMouse();

end







local function itemspawn()
	
	CreateItemSpawnDev();

end
concommand.Add( "itemspawn", itemspawn );

function CreateItemSpawnDev()
	
	local dat = file.Read( "Epidemic/mapdata/" .. GetMap() .. ".txt" );
	local pos = LocalPlayer():GetPos();
	dat = dat .. "\nNEW " .. tostring( math.Round( pos.x ) ) .. " " .. tostring( math.Round( pos.y ) ) .. " " .. tostring( math.Round( pos.z ) );
	file.Write( "Epidemic/mapdata/" .. GetMap() .. ".txt", dat );
	table.insert( ItemSpawnPoints, pos );

end

function DestroyItemSpawnDev()

	if( ItemSpawnDev and ItemSpawnDev:IsValid() ) then
	
		ItemSpawnDev:Remove();
		ItemSpawnDev = nil;
	
	end
	
	HideMouse();

end

ItemSpawnPoints = { };
function msgs.GetItemSpawnPoint( um )
	
	table.insert( ItemSpawnPoints, um:ReadVector() );
	
end



attachviewerrows = 32;
attachviewercols = 32;
if( attachviewer ) then
	if( attachviewer.RemoveTitleBar ) then
		attachviewer:RemoveTitleBar();
	end
	attachviewer:Remove();
end
attachviewer = nil;

function createAttachViewer()

	attachviewer = CreateBPanel( "Attachment Creator", 100, 100, 700, 600 );
	
	attachviewer.modelname = "";
	attachviewer.fov = 1;
	attachviewer.mode = "Female"
	
	attachviewer.modelpath = vgui.Create( "DTextEntry", attachviewer );
	attachviewer.modelpath:SetPos( 580, 440 );
	attachviewer.modelpath:SetSize( 200, 16 );
	attachviewer.modelpath:SetEnterAllowed( true );
	attachviewer.modelpath:MakePopup();
	
	attachviewer.modelpath.OnEnter = function( self )
		
		if( string.gsub( self:GetValue(), " ", "" ) == "" ) then return; end
		
		attachviewer.modelname = self:GetValue();
		
		if( SpecialAttach[attachviewer.mode][attachviewer.modelname] ) then
			
			attachviewer.ObjectPos[1]:SetValue( SpecialAttach[attachviewer.mode][attachviewer.modelname][1] );
			attachviewer.ObjectPos[2]:SetValue( SpecialAttach[attachviewer.mode][attachviewer.modelname][2] );
			attachviewer.ObjectPos[3]:SetValue( SpecialAttach[attachviewer.mode][attachviewer.modelname][3] );
			attachviewer.CamPos[4]:SetValue( SpecialAttach[attachviewer.mode][attachviewer.modelname][4] );
			attachviewer.CamPos[5]:SetValue( SpecialAttach[attachviewer.mode][attachviewer.modelname][5] );
			attachviewer.CamPos[6]:SetValue( SpecialAttach[attachviewer.mode][attachviewer.modelname][6] );
			attachviewer.Fov:SetValue( SpecialAttach[attachviewer.mode][attachviewer.modelname][7] );
			attachviewer.fov = SpecialAttach[attachviewer.mode][attachviewer.modelname][7];
			
		end
		
	end
	
	local name = { }
	name[1] = "X";
	name[2] = "Y";
	name[3] = "Z";
	
	local ang = { }
	ang[1] = "F";
	ang[2] = "R";
	ang[3] = "U";
	
	attachviewer.ObjectPos = { }
	
	for j = 1, 3 do
	
		attachviewer.ObjectPos[j] = vgui.Create( "DNumSlider", attachviewer );
		attachviewer.ObjectPos[j]:SetPos( 480, 400 + 16 * j );
		attachviewer.ObjectPos[j]:SetSize( 200, 16 );
		attachviewer.ObjectPos[j]:SetText( name[j] );
		attachviewer.ObjectPos[j]:SetMin( -20 );
		attachviewer.ObjectPos[j]:SetMax( 20 );
		attachviewer.ObjectPos[j]:SetDecimals( 0 );
		attachviewer.ObjectPos[j]:SetValue( 0 );
		
		attachviewer.ObjectPos[j].ValueChanged = function( self )
			
			SpecialAttach[attachviewer.mode][attachviewer.modelname] = { attachviewer.ObjectPos[1]:GetValue(), attachviewer.ObjectPos[2]:GetValue(), attachviewer.ObjectPos[3]:GetValue(), attachviewer.CamPos[1]:GetValue(), attachviewer.CamPos[2]:GetValue(), attachviewer.CamPos[3]:GetValue(), attachviewer.fov, "ValveBiped.Bip01_Spine2" }
			
		end
		
		attachviewer.ObjectPos[j].id = j;
	
	end
	
	attachviewer.CamPos = { }
	
	for j = 1, 3 do
	
		attachviewer.CamPos[j] = vgui.Create( "DNumSlider", attachviewer );
		attachviewer.CamPos[j]:SetPos( 480, 460 + 16 * j );
		attachviewer.CamPos[j]:SetSize( 200, 16 );
		attachviewer.CamPos[j]:SetText( ang[j] );
		attachviewer.CamPos[j]:SetMin( -360 );
		attachviewer.CamPos[j]:SetMax( 360 );
		attachviewer.CamPos[j]:SetDecimals( 0 );
		attachviewer.CamPos[j]:SetValue( 0 );
		
		attachviewer.CamPos[j].ValueChanged = function( self )
			
			SpecialAttach[attachviewer.mode][attachviewer.modelname] = { attachviewer.ObjectPos[1]:GetValue(), attachviewer.ObjectPos[2]:GetValue(), attachviewer.ObjectPos[3]:GetValue(), attachviewer.CamPos[1]:GetValue(), attachviewer.CamPos[2]:GetValue(), attachviewer.CamPos[3]:GetValue(), attachviewer.fov, "ValveBiped.Bip01_Spine2" }
			
		end
		
		attachviewer.CamPos[j].id = j;
	
	end
	
	attachviewer.Fov = vgui.Create( "DNumSlider", attachviewer );
	attachviewer.Fov:SetPos( 480, 530 );
	attachviewer.Fov:SetSize( 200, 16 );
	attachviewer.Fov:SetText( "Scale" );
	attachviewer.Fov:SetMin( 0.1 );
	attachviewer.Fov:SetMax( 10 );
	attachviewer.Fov:SetDecimals( 0 );
	attachviewer.Fov:SetValue( 1 );
	attachviewer.Fov.ValueChanged = function( self )
		attachviewer.fov = self:GetValue();
		SpecialAttach[attachviewer.mode][attachviewer.modelname] = { attachviewer.ObjectPos[1]:GetValue(), attachviewer.ObjectPos[2]:GetValue(), attachviewer.ObjectPos[3]:GetValue(), attachviewer.CamPos[1]:GetValue(), attachviewer.CamPos[2]:GetValue(), attachviewer.CamPos[3]:GetValue(), attachviewer.fov, "ValveBiped.Bip01_Spine2" }
	end
	
end
concommand.Add( "attachviewer", createAttachViewer );