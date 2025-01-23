-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
--
-- shared.lua
-- Some shared functions
-------------------------------

--Should be used for the Tip Ticker that ticks away tips ^_^

HelpSentances = 
{

	"Hai ^_^ Copyright 2009",
	"This is a warning....err, test I mean.",
	"Welcome to Fallout Role-Play"

}

ContainerItems =
{
	"drink_booze",
	"drink_beer",
	"food_noodles",
	"food_watermelon",
	"food_fruit",
	"drink_milk",
	"ammo_44mn",
	"food_beans"
}

DoorTypes =
{

	"func_door",
	"func_door_rotating",
	"prop_door_rotating"

}

BlockedEntities =
{
	
	"func_door",
	"func_door_rotating",
	"prop_door_rotating",
	"prop_dynamic",
	"func_button",
	"func_breakable",
	"func_brush",
	"func_tracktrain",
	"func_physbox",
	"func_breakable_surf",
	"func_movelinear",
	"func_monitor"
	
}

NamedEntities =
{

	"plragdoll",
	"plkoragdoll"
	
}

function LEMON.IsDoor( door )

        if (!ValidEntity(door)) then return false end
	local class = door:GetClass();
	
	for k, v in pairs( DoorTypes ) do
	
		if( v == class ) then return true; end
	
	end
	
	return false;

end

function LEMON.IsLetter( ent )

	if(!ValidEntity(ent)) then return false end
	local class = ent:GetClass()
	
	if( "item_letter" == class ) then return true; end
	
	return false;
	
end

function LEMON.IsBlocked( ent )

	local class = ent:GetClass();
	local name = ent:GetName()
	
	for k, v in pairs( BlockedEntities ) do
	
		if( v == class ) then return true; end
	
	end
	
	for k, v in pairs( NamedEntities ) do
	
		if( v == name ) then return true; end
		
	end
	
	return false;

end