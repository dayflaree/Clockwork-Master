
--[[
-------------------
-- PLAYER FLAGS --
-------------------
t - tooltrust
& - 70 prop limit
! - Can create HECU character
C - Can create Spetsnaz character
# - Can create infected character

-------------------
]]--

local meta = FindMetaTable( "Player" );

function meta:HasFlags( type, flags )

	if( flags == "" ) then return true; end

	local curflags;
	
	if( type == "" ) then
		curflags = self:GetPlayerFlags();
	else
		curflags = self:GetTable()[type .. "Flags"];
	end
	
	if( string.find( curflags, "+" ) ) then return true; end
	
	for n = 1, string.len( flags ) do
	
		local flag = string.sub( flags, n, n );
		
		if( not string.find( curflags, flag ) ) then
		
			return false;
		
		end
	
	end
	
	return true;

end

function meta:HasPlayerFlags( flags )

	return self:HasFlags( "", flags );

end

function meta:HasAnyAdminFlags()

	if( string.len( self:GetTable().AdminFlags ) > 0 ) then
	
		return true;
	
	end
	
	return false;

end


function meta:HasAdminFlags( flags )

	return self:HasFlags( "Admin", flags );

end

function meta:AddPlayerFlags( flag )

	if( not self:HasPlayerFlags( flag ) ) then
	
		self:SetPlayerFlags( self:GetPlayerFlags() .. flag );
	
	end

end

function meta:RemovePlayerFlags( flag )

	if( self:HasPlayerFlags( flag ) ) then
	
		self:SetPlayerFlags( string.gsub( self:GetPlayerFlags(), flag, "" ) );
	
	end

end
