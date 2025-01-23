local PLUGIN = PLUGIN;

function PLUGIN:PlayerDataLoaded(player)
	local loadModel = player:GetData("model");
	if (!loadModel) then
		loadModel = "models/Player/Group01/Male_01.mdl";
		player:SetData("model", loadModel);
	end;
	player:SetModel(loadModel)
end;

function PLUGIN:PlayerSpawn(ply)
	self:PlayerSetModel(ply);
end;

function PLUGIN:PlayerSetModel(player)
	local loadModel = player:GetData("model");
	if (!loadModel) then
		loadModel = "models/Player/Group01/Male_01.mdl";
		player:SetData("model", loadModel);
	end;
	player:SetModel(loadModel);
end;
