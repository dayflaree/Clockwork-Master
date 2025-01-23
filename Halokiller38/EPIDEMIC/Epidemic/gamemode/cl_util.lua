

--I had to hack this in without doing major code edits to how model icons are created and edited
RotatedModelIcons = 
{

	"models/weapons/w_axe.mdl",
	"models/weapons/w_keyboard.mdl",
	"models/weapons/w_shovel.mdl",

}
--Neva forget

function CreateModelIcon( mdl, campos, lookat, fov, skin )

	local modelpnl = vgui.Create( "BModelPanel" );

	modelpnl:SetModel( mdl );

	modelpnl:SetCamPos( campos );
	modelpnl:SetLookAt( lookat );
	modelpnl:SetFOV( fov );

	modelpnl.LayoutEntity = function( self ) 
	
		if( table.HasValue( RotatedModelIcons, mdl ) ) then
	
			modelpnl.Entity:SetAngles( Angle( 90, 0, 0 ) );
	
		end
	
	end
	
	modelpnl.Entity:SetSkin( skin or 0 );
	
	return modelpnl;

end

ScopeOn = false;

function ScopeMode( b )

	LocalPlayer():GetViewModel():SetNoDraw( b );
	ScopeOn = b;

end


function SetWeaponHolster( val )

	if( not LocalPlayer().GetActiveWeapon ) then return; end

	local weap = LocalPlayer():GetActiveWeapon();
	
	if( weap and weap:IsValid() and weap:GetTable() and weap:GetTable().Primary ) then

		if( weap:GetTable().HolsterToggle ) then
		
			weap:GetTable().HolsterToggle( weap );	
		
		end
	
		if( val ) then
			
			weap:GetTable().Primary.PositionMode = 2;
			weap:GetTable().Primary.PositionMul = 0;
		
		else
			
			if( weap:GetTable().PlayDrawHolsterAnim ) then
				
				weap:GetTable().Primary.PositionMode = 0;
				weap:GetTable().Primary.PositionMul = 1;
				weap:Deploy( true );
				
			else
				
				weap:GetTable().Primary.GoToOriginalPosition = true;
				weap:GetTable().Primary.NextPositionMode = 0;
				
			end
		
		end
		
	end
	
	if( ScopeOn ) then
	
		ScopeMode( false );

	end
	
end


function TestForOpenScreenPos()

	Msg( "IntroCameraPositions[\"" .. GetMap() .. "\"] = {\n\n" );

	local eyepos = LocalPlayer():EyePos();
	local eyeang = LocalPlayer():EyeAngles();
	
	Msg( "Pos = Vector( " .. eyepos.x .. ", " .. eyepos.y .. ", " .. eyepos.z .. " ), \n" );
	Msg( "Ang = Angle( " .. eyeang.pitch .. ", " .. eyeang.yaw .. ", " .. eyeang.roll .. " ), \n" );

	Msg( "\n\n};" );

end