
local Clockwork = Clockwork;
local osTime = os.time;

local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Medical Base";
ITEM.uniqueID = "medical_base";
ITEM.amount = 1;
ITEM.healType = "heal";
ITEM.healAmount = 25;
ITEM.healTime = 10;
ITEM.decayDelay = 0;
ITEM.decayTime = 10;
ITEM.useText = "Apply";
ITEM.useSound = "items/medshot4.wav";
ITEM.category = "Medical";
ITEM.customFunctions = {"Give"};
ITEM:AddData("A", -1, true);

function ITEM:GetWeight()
	if (self("amount", 1) > 1) then
		if (self:GetData("A") == -1) then
			return self("amount") * self("useWeight", 1) + self("baseWeight", 0);
		else
			return self("useWeight", 1) * self:GetData("A") + self("baseWeight", 0);
		end;
	else
		return self("baseWeight", 1);
	end;
end;
ITEM:AddQueryProxy("weight", ITEM.GetWeight);

function ITEM:HealPlayer(player)
	local healingTable = player:GetCharacterData("HealingTable", {});

	local healingData = healingTable[self("healType", "heal")];
	if (healingData) then
		local diff = math.pow(2, (self("healAmount", 25) - healingData[1]) / self("healAmount", 25) - 1) * self("healAmount", 25);
		healingData[1] = healingData[1] + diff;
		healingData[2] = self("healAmount", 25) / self("healTime", 10) * (1 - diff / healingData[1])
			+ healingData[2] * diff / healingData[1];

		if (self("decayDelay", 0) > 0) then
			healingData[3] = math.max(healingData[3], osTime() + self("decayDelay") + self("healTime"));
			healingData[4] = healingData[4] or 0;
			healingData[5] = -1 * self("healAmount", 25) / self("decayTime", 10) * (1 - diff / healingData[1])
				+ healingData[5] * diff / healingData[1];
		end;
	else
		healingData = {
			self("healAmount", 25),
			self("healAmount", 25) / self("healTime", 10),
		};

		if (self("decayDelay", 0) > 0) then
			healingData[3] = osTime() + self("decayDelay") + self("healTime", 10);
			healingData[4] = 0;
			healingData[5] = -1 * self("healAmount", 25) / self("decayTime", 10);
			healingData[6] = false;
		else
			healingData[3] = false;
			healingData[4] = 0;
			healingData[5] = 0;
			healingData[6] = true;
		end;

		healingData[7] = self("stopHealOnFullHealth");

		healingTable[self("healType", "heal")] = healingData;
	end;

	player:SetCharacterData("HealingTable", healingTable);
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (!self.CanUseItem or self:CanUseItem(player) != true) then
		self:HealPlayer(player);
		self:SetData("A", self:GetData("A") - 1);

		if (self.OnMedicalItemUsed) then
			self:OnMedicalItemUsed(player, itemEntity)
		end;

		if (self("blurTime", 0) > 0) then
			Clockwork.player:SetDrunk(player, self("blurTime"));
		end;

		if (self:GetData("A") > 0) then
			return true;
		end;
	else
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnInstantiated()
		if (self:GetData("A") == -1) then
			self:SetData("A", self("amount", 1));
		end
	end;

	function ITEM:OnItemSpawnerSpawn()
		self:SetData("A", math.random(1, self("amount", 1)));
	end;

	function ITEM:OnCustomFunction(player, name)
		if (name == "Give") then
			local target = player:GetEyeTraceNoCursor().Entity;
			if (target and target:IsPlayer()) then
				if (target:GetPos():DistToSqr(player:EyePos()) < 192 * 192) then
					if (!self.CanUseItem or self:CanUseItem(target) != false) then
						self:HealPlayer(target);
						target:EmitSound("items/medshot4.wav");
						Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has healed "..target:Name().." with a "..self("name")..".");
						self:SetData("A", self:GetData("A") - 1);

						if (self:GetData("A") == 0) then
							player:TakeItem(self);
						end;
					else
						Clockwork.player:Notify(player, "This player cannot be healed by this item.");
					end;
				else
					Clockwork.player:Notify(player, "This player is too far away.");
				end;
			else
				Clockwork.player:Notify(player, "You are not looking at a valid player.");
			end;
		end;
	end;
else
	function ITEM:GetClientSideInfo()
		if (self("amount", 1) > 1) then
			local amountText = self("amountText", "uses");
			if (self:GetData("A") > 1) then
				amountText = Clockwork.kernel:Pluralize(amountText);
			end;
			return Clockwork.kernel:AddMarkupLine("", self:GetData("A").." "..amountText.." remaining.");
		end;
	end;

	function ITEM:OnHUDPaintTargetID(ent, x, y, alpha) 
		if (self("amount", 1) > 1) then
			local amountText = self("amountText", "uses");
			if (self:GetData("A") > 1) then
				amountText = Clockwork.kernel:Pluralize(amountText);
			end;
			return Clockwork.kernel:DrawInfo("["..self:GetData("A").." "..amountText.." remaining]", x, y, Color(255, 255, 255), alpha);
		end;
	end;
end;

ITEM:Register();