
local PLUGIN = PLUGIN;
local IN_ATTACK2 = IN_ATTACK2;
local math = math;

PLUGIN.blacklist = {
	["cw_combinelock"] = true,
	["cw_unionlock"] = true,
	["cw_rationdispenser"] = true	
};

function PLUGIN:OnEntityCreated(entity)
	if (self.blacklist[entity:GetClass()] and IsValid(entity:GetPhysicsObject())) then
		entity:GetPhysicsObject():SetMass(math.max(entity:GetPhysicsObject():GetMass(), 101));
	end;
end;