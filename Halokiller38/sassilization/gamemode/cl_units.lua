UNITS = UNITS or {}
UNITS.colors = {}
UNITS.targets = {}
UNITS.selected = {}
UNITS.health = {}

function GM:EntityRemoved( ent )
	UNITS.colors[ent:EntIndex()] = nil
	UNITS.targets[ent:EntIndex()] = nil
	UNITS.selected[ent:EntIndex()] = nil
	UNITS.health[ent:EntIndex()] = nil
end

--Update Unit Color
usermessage.Hook( "UUC", function( um )
	
	local eid = um:ReadShort()
	local r,g,b = um:ReadShort(), um:ReadShort(), um:ReadShort()
	UNITS.colors[ eid ] = Color( r, g, b, 255 )
	
end )

--Update Unit Target
usermessage.Hook( "UUT", function( um )
	
	local eid = um:ReadShort()
	local eeid = um:ReadShort()
	UNITS.targets[ eid ] = eeid == 0 and nil or eeid
	
end )

--Update Unit Health
usermessage.Hook( "UUH", function( um )
	
	local eid = um:ReadShort()
	local health = um:ReadShort()
	UNITS.health[ eid ] = health
	
end )

--Select Unit
usermessage.Hook( "SU", function( um )
	
	local eid = um:ReadShort()
	UNITS.selected[ eid ] = true
	
end )

--Deselect Unit
usermessage.Hook( "DSU", function( um )
	
	local eid = um:ReadShort()
	UNITS.selected[ eid ] = nil
	
end )