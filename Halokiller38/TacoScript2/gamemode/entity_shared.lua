
local meta = FindMetaTable( "Entity" );

function meta:IsProp()

	if( self and self:IsValid() and self:GetClass() == "prop_physics" ) then
	
		return true;
		
	end
	
	return false;

end

function meta:IsItem()

	if( self.ItemData ) then
	
		return true;
	
	end
	
	return false;

end

function meta:GetItemClass()

	if( self.ItemData ) then
	
		return self.ItemData.ID;
	
	end	

	return "";

end

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
	
	-- TacoDoors
	if self:GetClass() == "prop_dynamic" then
		return self.IsDoor
	end	
	
	return false;

end