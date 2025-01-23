-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
--
-- cl_binds.lua
-- Changes what keys do.
-------------------------------

LEMON.ContextEnabled = false;

function GM:PlayerBindPress( ply, bind, pressed )

	if( LocalPlayer( ):GetNWInt( "charactercreate" ) == 1 ) then
	
		if( bind == "+forward" or bind == "+back" or bind == "+moveleft" or bind == "+moveright" or bind == "+jump" or bind == "+duck" ) then return true; end -- Disable ALL movement keys.
	
	end
	
	if( bind == "+use" ) then
	
		local trent = LocalPlayer( ):GetEyeTrace( ).Entity;
		
		if( trent != nil and trent:IsValid( ) and LEMON.IsDoor( trent ) ) then
		
			LocalPlayer( ):ConCommand( "rp_opendoor" );
			
		end
		
	end

end

function GM:ScoreboardShow( )

	LEMON.ContextEnabled = true;
	gui.EnableScreenClicker( true )
	HiddenButton:SetVisible( true );
	
end

function GM:ScoreboardHide( )

	LEMON.ContextEnabled = false;
	gui.EnableScreenClicker( false );
	HiddenButton:SetVisible( false );
	
end

function GM:StartChat( )

	LocalPlayer( ):ConCommand( "rp_openedchat" );
	
end

function GM:FinishChat( )

	LocalPlayer( ):ConCommand( "rp_closedchat" );
	
end
