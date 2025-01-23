local meta = FindMetaTable( "Player" );

function meta:IsAddingGoodWep( name )

	local BadWeapons =
	{ 
		"donator", 
		"kanyewest", 
		"stormninja",
		"hands", 
		"base", 
		"gatlin", 
		"30gauge", 
		"40watt",
		"50watt",
		"styer",
		"60watt", 
		"70watt", 
		"80watt",
		"90watt",
		"godfist",
		"rpg7",
		"sniper",	
		"styerscout",			
		"mapeditor",
		
	}
	
	for k, v in pairs( BadWeapons ) do
	
		if( string.find( name, v ) ) then
		
			return false;
			
		end
	
	end
	
	return true;

end

function meta:GetRPName()

	return self:GetNWString( "RPName" );

end

--Title 1 and title 2 should already be synced as it is sent to the client when
--a person loads or sets their title. If not, get the title via command.
function meta:GetTitle()

	if( SERVER ) then
	
		return self:GetPlayerTitle();
	
	else
	
		if( self.PlayerTitle ) then
		
			return self.PlayerTitle;
		
		end
		if (self.NextTitleRequest or 0) <= CurTime() then
			RunConsoleCommand( "eng_us", 1, self:EntIndex() );
			self.NextTitleRequest = CurTime()+5
		end
		return "";
	
	end
	
end

function meta:GetTitle2()

	if( SERVER ) then
	
		return self:GetPlayerTitle2();
	
	else
	
		if( self.PlayerTitle2 ) then
		
			return self.PlayerTitle2;
		
		end
		
		if (self.NextTitle2Request or 0) <= CurTime() then
			RunConsoleCommand( "eng_us", 2, self:EntIndex() );
			self.NextTitle2Request = CurTime()+5
		end
		return "";
	
	end
	
end

function meta:IsCitizen()

	if( self:Team() == 1 ) then
		return true;
	end
	
	return false;

end

function meta:IsCP()

	if( self:Team() == 2 ) then
		return true;
	end
	
	return false;

end

function meta:IsOW()

	if( self:Team() == 3 ) then
		return true;
	end
	
	return false;

end

function meta:IsOWElite()
	return self:IsOW() and false;
end

function meta:IsCA()

	if( self:Team() == 4 ) then
		return true;
	end
	
	return false;

end

function meta:IsVort()

	if( self:Team() == 5 ) then
		return true;
	end
	
	return false;

end

function meta:CanOpenCombineDoors()

	if (self:IsCP() or self:IsOW() or self:IsCA()) then
		return true;
	end	
	
	return false;
end

-- Mind if I ask WHY PLAYERS CAN BE DOORS?
local DoorTypes =
{
	
	"func_door",
	"func_door_rotating",
	"prop_door_rotating",

}

function meta:IsDoor()

	for k, v in pairs( DoorTypes ) do
	
		if( self:GetClass() == v ) then
			return true;
		end
	
	end
	
	return false;

end