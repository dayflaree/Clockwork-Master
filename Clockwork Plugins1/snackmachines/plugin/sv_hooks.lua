local PLUGIN = PLUGIN;

function PLUGIN:SaveSnackMachines()
	local buffer = {};

	for k, v in pairs(ents.FindByClass("cw_snackmachine")) do
		buffer[#buffer + 1] = {
			pos = v:GetPos(),
			angles = v:GetAngles(),
			disabled = v:GetDTBool(1),
			stocks = {
				v:GetDTInt(0),
				v:GetDTInt(1),
				v:GetDTInt(2),
				v:GetDTInt(3)
			}
		};
	end;

	Clockwork.kernel:SaveSchemaData("plugins/snackmachines/" .. game.GetMap(), buffer);
end;

function PLUGIN:LoadSnackMachines()
	local buffer = Clockwork.kernel:RestoreSchemaData("plugins/snackmachines/" .. game.GetMap());

	for k, v in pairs(buffer) do
		local machine = ents.Create("cw_snackmachine");

		machine:SetPos(v.pos);
		machine:SetAngles(v.angles);
		machine:Spawn();
		machine:Activate();

		if (IsValid(machine)) then
			for i = 0, 3 do
				machine:SetDTInt(i, v.stocks[i + 1]);
			end;
			machine:SetDTBool(1, v.disabled);
			machine:GetPhysicsObject():EnableMotion(false);
		end;
	end;
end;

function PLUGIN:PostSaveData()
	self:SaveSnackMachines();
end;

function PLUGIN:ClockworkInitPostEntity()
	self:LoadSnackMachines();
end;