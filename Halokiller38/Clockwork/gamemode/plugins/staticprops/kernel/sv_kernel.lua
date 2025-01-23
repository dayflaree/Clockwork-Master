--[[
	Free Clockwork!
--]]

-- A function to load the static props.
function PLUGIN:LoadStaticProps()
	self.staticProps = Clockwork:RestoreSchemaData("plugins/props/"..game.GetMap());
	
	for k, v in pairs(self.staticProps) do
		local entity = ents.Create("prop_physics");
		
		entity:SetAngles(v.angles);
		entity:SetModel(v.model);
		entity:SetPos(v.position);
		entity:Spawn();
		
		Clockwork.entity:MakeSafe(entity, true, true, true);
		self.staticProps[k] = entity;
	end;
end;

-- A function to save the static props.
function PLUGIN:SaveStaticProps()
	local staticProps = {};
	
	for k, v in pairs(self.staticProps) do
		if (IsValid(v)) then
			staticProps[#staticProps + 1] = {
				model = v:GetModel(),
				angles = v:GetAngles(),
				position = v:GetPos()
			};
		end;
	end;
	
	Clockwork:SaveSchemaData("plugins/props/"..game.GetMap(), staticProps);
end;