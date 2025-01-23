-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
--
-- player_shared.lua
-- This is a shared file that contains functions for the players, of which is loaded on client and server.
-------------------------------

PlayerWeaponsStorage = {  }
pWeps = { }
local meta = FindMetaTable( "Player" );

function meta:CanTraceTo( ent ) -- Can the player and the entity "see" eachother?

	local trace = {  }
	trace.start = self:EyePos( );
	trace.endpos = ent:EyePos( );
	trace.filter = self;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity:IsValid( ) and tr.Entity:EntIndex( ) == ent:EntIndex( ) ) then return true; end
	
	return false;

end

function meta:Nick( )
	
	return self:GetNWString( "name" );

end
-- The main function for storing players weapons in a table
function meta:StoreWeapons2( )
table.Empty( pWeps )
self.Weps = pWeps
for k, v in pairs(self:GetWeapons()) do
	table.insert( pWeps, v:GetClass() )
end

end	



function meta:CalcDrop( )

	local pos = self:GetShootPos( );
	local ang = self:GetAimVector( );
	local tracedata = {  };
	tracedata.start = pos;
	tracedata.endpos = pos+( ang*80 );
	tracedata.filter = self;
	local trace = util.TraceLine( tracedata );
	
	return trace.HitPos;
	
end



