
local PLAYER_CLASS = {};
PLAYER_CLASS.DisplayName = "Clockwork Player";

DEFINE_BASECLASS("player_default");

local modelList = {};

for k, v in pairs(player_manager.AllValidModels()) do
	modelList[string.lower(v)] = k;
end;

-- Called when the data tables are setup.
function PLAYER_CLASS:SetupDataTables()
	if (!self.Player or !self.Player.DTVar) then
		return;
	end;
	
	self.Player:DTVar("Int", 0, "SharedCharacterKey");
	self.Player:DTVar("Int", 1, "SharedCharacterGender");
	self.Player:DTVar("Int", 2, "SharedCharacterFaction");
	self.Player:DTVar("Int", 3, "SharedActionDuration");

	self.Player:DTVar("Float", 0, "SharedStartActionTime");

	self.Player:DTVar("Bool", 0, "Initialized");
	self.Player:DTVar("Bool", 1, "WeaponRaised");
	self.Player:DTVar("Bool", 2, "JoggingMode");
	self.Player:DTVar("Bool", 3, "RunningMode");

	self.Player:DTVar("String", 0, "CharacterName");
	self.Player:DTVar("String", 1, "CharacterPhysDesc");
	self.Player:DTVar("String", 2, "CharacterFlags");
	self.Player:DTVar("String", 3, "SharedActionName");

	self.Player:DTVar("Entity", 0, "SharedRagdollEntity");
end;

-- Called on player spawn to determine which hand model to use.
function PLAYER_CLASS:GetHandsModel()
	local playerModel = string.lower(self.Player:GetModel());
	local simpleName = nil;

	if (modelList[playerModel]) then
		return player_manager.TranslatePlayerHands(modelList[playerModel]);
	end;

	for k, v in pairs(modelList) do
		if (string.find(string.gsub(playerModel, "_", ""), v)) then
			modelList[playerModel] = v;

			break;
		end;
	end;

	return player_manager.TranslatePlayerHands(modelList[playerModel]);
end;

-- Called after view model is drawn.
function PLAYER_CLASS:PostDrawViewModel(viewmodel, weapon)
	if (weapon.UseHands or !weapon:IsScripted()) then
		local handsEntity = Clockwork.Client:GetHands();
		
		if (IsValid(handsEntity)) then
			handsEntity:DrawModel();
		end;
	end;
end;

player_manager.RegisterClass("cwPlayer", PLAYER_CLASS, "player_default");
