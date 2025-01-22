local PLUGIN = PLUGIN;

function PLUGIN:SaveData()
	local buffer = {};

	for k, v in pairs(ents.FindByClass("cw_newff")) do
		buffer[#buffer + 1] = {
			pos = v:GetPos(),
			ang = v:GetAngles(),
			mode = v.mode or 1,
			fencepos = v.post:GetPos()
		};
	end;

	Clockwork.kernel:SaveSchemaData("plugins/forcefields/" .. game.GetMap(), buffer);
end;

function PLUGIN:LoadData()
	local buffer = Clockwork.kernel:RestoreSchemaData("plugins/forcefields/" .. game.GetMap());

	for k, v in ipairs(buffer) do
		local entity = ents.Create("cw_newff");

		entity.noCorrect = true;
		entity.forcePos = v.fencepos;
		entity:SetPos(v.pos);
		entity:SetAngles(v.ang);
		entity:Spawn();
		entity.mode = v.mode or 1;
		entity:SetDTInt(0, entity.mode);
	end;
end;

function PLUGIN:ClockworkInitPostEntity()
	self:LoadData();
end;

function PLUGIN:PostSaveData()
	self:SaveData();
end;

function PLUGIN:KeyPress(player, key)
	local data = {};
	data.start = player:GetShootPos();
	data.endpos = data.start + player:GetAimVector() * 84;
	data.filter = player;
	local trace = util.TraceLine(data);
	local entity = trace.Entity;

	if (key == IN_USE and IsValid(entity) and entity:GetClass() == "cw_newff") then
		entity:Use(player, player, USE_ON, 1);
	end;
end;

--CREDIT TO DMG | BOBBLEHEAD FOR THE BASE OF THIS FUNCTION
function PLUGIN:EntityFireBullets(ent, bullet)
	if ent.FiredBullet then return; end;

	for i = 1, (bullet.Num or 1) do
		local tr = util.QuickTrace(bullet.Src, bullet.Dir * 10000, ent);

		if (IsValid(tr.Entity) and tr.Entity:GetClass() == "cw_newff") then
			local newbullet = table.Copy(bullet);
			newbullet.Src = tr.HitPos + tr.Normal * 1;
			newbullet.Attacker = ent;

			ent.FiredBullet = true;
			ent:FireBullets(newbullet);
			ent.FiredBullet = false;

			return false;
		end;
	end;
end;