-- A function to load the static props.
function PLUGIN:LoadStaticEnts()
	self.staticEnts = Clockwork.kernel:RestoreSchemaData("plugins/entities/"..game.GetMap());
	
	for k, v in pairs(self.staticEnts) do
		local entity = ents.Create( v.class );
			entity:SetMaterial(v.material);
			entity:SetAngles(v.angles);
			entity:SetColor(v.color);
			entity:SetModel(v.model);
			entity:SetPos(v.position);
			entity:Spawn();
		Clockwork.entity:MakeSafe(entity, true, true, true);
		
		self.staticEnts[k] = entity;
	end;
end;

-- A function to save the static props.
function PLUGIN:SaveStaticEnts()
	local staticEnts = {};
	
	if (type(self.staticEnts) == "table") then
		for k, v in pairs(self.staticEnts) do
			if (IsValid(v)) then
				staticEnts[#staticEnts + 1] = {
					class = v:GetClass(),
					model = v:GetModel(),
					color = v:GetColor(),
					angles = v:GetAngles(),
					position = v:GetPos(),
					material = v:GetMaterial()
				};
			end;
		end;
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/entities/"..game.GetMap(), staticEnts);
end;