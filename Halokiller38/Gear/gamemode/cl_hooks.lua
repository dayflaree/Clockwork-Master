
function PlayerBindPress( ply, bind, down )
	
	--Chat window
	if( string.find( bind, "messagemode" ) ) then
	
		OpenChatBox();
		return true;
	
	end
	
end
hook.Add( "PlayerBindPress", "GearPlayerBindPress", PlayerBindPress );

function CalcView( ply, origin, angles, fov )

	--Copy pasta--
	local wep = ply:GetActiveWeapon() 
	local view = {} 
 	view.origin 	= origin 
 	view.angles		= angles 
 	view.fov 		= fov 
	
	 if ( ValidEntity( wep ) ) then 
 	 
 		local func = wep.GetViewModelPosition 
 		if ( func ) then 
 			view.vm_origin,  view.vm_angles = func( wep, origin*1, angles*1 ) // Note: *1 to copy the object so the child function can't edit it. 
 		end 
 		 
 		local func = wep.CalcView 
 		if ( func ) then 
 			view.origin, view.angles, view.fov = func( wep, ply, origin*1, angles*1, fov ) // Note: *1 to copy the object so the child function can't edit it. 
 		end 
 	 
 	 	return view;
 	 
 	end 
	--End copy pasta--
	
end
hook.Add( "CalcView", "GearCalcView", CalcView );

function Think()

	local weap = LocalPlayer():GetActiveWeapon();
	
	if( weap:IsValid() and weap:GetTable() and weap:GetTable().Primary and weap:GetTable().Primary.PositionMode ) then
	
		if( LocalPlayer():KeyDown( IN_ATTACK2 ) and not weap:GetNetworkedBool( "reloading", false ) ) then
		
			if( weap:GetTable().Primary.PositionMode ~= 1 ) then
		
				weap:GetTable().Primary.PositionMode = 1;
				weap:GetTable().Primary.PositionMul = 0;
				
			end
			
		elseif( weap:GetTable().Primary.PositionMode == 1 ) then
		
			weap:GetTable().Primary.GoToOriginalPosition = true;
			weap:GetTable().Primary.NextPositionMode = 0;
		
		end
	
	end

end
hook.Add( "Think", "GearThink", Think );