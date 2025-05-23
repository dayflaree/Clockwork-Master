--[[
	Free Clockwork!
--]]

-- A function to load the cash.
function PLUGIN:LoadCash()
	local cash = Clockwork:RestoreSchemaData("plugins/cash/"..game.GetMap());
	
	for k, v in pairs(cash) do
		local entity = Clockwork.entity:CreateCash({key = v.key, uniqueID = v.uniqueID}, v.amount, v.position, v.angles);
		
		if (IsValid(entity) and !v.isMoveable) then
			local physicsObject = entity:GetPhysicsObject();
			
			if (IsValid(physicsObject)) then
				physicsObject:EnableMotion(false);
			end;
		end;
	end;
end;

-- A function to save the cash.
function PLUGIN:SaveCash()
	local cash = {};
	
	for k, v in pairs(ents.FindByClass("cw_cash")) do
		local physicsObject = v:GetPhysicsObject();
		local bMoveable = nil;
		
		if (IsValid(physicsObject)) then
			bMoveable = physicsObject:IsMoveable();
		end;
		
		cash[#cash + 1] = {
			key = Clockwork.entity:QueryProperty(v, "key"),
			angles = v:GetAngles(),
			amount = v.cwAmount,
			uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID"),
			position = v:GetPos(),
			isMoveable = bMoveable
		};
	end;
	
	Clockwork:SaveSchemaData("plugins/cash/"..game.GetMap(), cash);
end;