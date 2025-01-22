
-----------------------------------------------------
local PLUGIN = PLUGIN;
if (SERVER) then
	AddCSLuaFile();
end;

local snacks = {
	{name = "Bag of Chips", class = "uu_chips", price = 15},
	{name = "Packaged Sandwich", class = "uu_sandwich", price = 20},
	{name = "Chocolate Bar", class = "uu_chocolate", price = 11},
	{name = "Coffee", class = "uu_coffee", price = 20}
};

local scale = 0.01;
local textscale = 0.03;
local width = 35.5 / scale;
local height = 50 / scale;
local textwidth = 35.5 / textscale;
local textheight = 50 / textscale;
local rowsize = (textheight - 300) / 4;
local color_red = Color(255, 60, 60);

local BaseClass = baseclass.Get("base_entity");

ENT.PrintName		= "Snack Machine";
ENT.Category		= "HL2RP";
ENT.Spawnable		= true;
ENT.AdminOnly		= true;
ENT.Model			= Model("models/props_canteen/vendingmachine01.mdl");
ENT.RenderGroup 	= RENDERGROUP_BOTH;

if (SERVER) then

	function ENT:SpawnFunction( player, trace, class )
		if ( !trace.Hit ) then return; end;
		local entity = ents.Create( class );
		entity:SetPos( trace.HitPos + trace.HitNormal * 1.5 );
		entity:Spawn();

		entity:Restock();

		return entity;
	end;

	function ENT:Initialize()
		self:SetModel(self.Model);
		self:SetSolid(SOLID_VPHYSICS);
		self:PhysicsInit(SOLID_VPHYSICS);
		self:SetUseType(SIMPLE_USE);

		local phys = self:GetPhysicsObject();

		if (IsValid(phys)) then
			phys:Wake();
			phys:EnableMotion(false);
		end;
	end;

	function ENT:SetupDataTables()
		self:DTVar("Int", 0, "Stock1");
		self:DTVar("Int", 1, "Stock2");
		self:DTVar("Int", 2, "Stock3");
		self:DTVar("Int", 3, "Stock4");

		self:DTVar("Bool", 0, "Recharging");
		self:DTVar("Bool", 1, "Disabled");
	end;

	function ENT:GetRestockPrice()
		local cost = 0;

		for i = 1, 4 do
			cost = cost + ((snacks[i].price * 0.6) * (10 - self:GetDTInt(i - 1)))
		end;

		return cost;
	end;

	function ENT:Restock(player)
		if (IsValid(player)) then
			Clockwork.player:GiveCash(player, -self:GetRestockPrice(), "restocking fee");
			self:EmitSound("ambient/levels/labs/coinslot1.wav");
		end;

		self:SetDTInt(0, 10);
		self:SetDTInt(1, 10);
		self:SetDTInt(2, 10);
		self:SetDTInt(3, 10);

		PLUGIN:SaveSnackMachines();
	end;

	function ENT:Toggle()
		if ((self.nextUse or 0) < CurTime()) then
			if (self:GetDTBool(0)) then
				self:EmitSound("buttons/button3.wav");
			else
				self:EmitSound("buttons/button19.wav");
			end;

			self:SetDTBool(1, !self:GetDTBool(1));
			PLUGIN:SaveSnackMachines();
		end;
	end;

	function ENT:Dispense(choice)
		local dispensePos = self:GetPos() + self:GetForward() * 25 + self:GetUp() * -25;
		local snackItemTable = Clockwork.item:CreateInstance(snacks[choice].class);

		if (snackItemTable) then
			Clockwork.entity:CreateItem(nil, snackItemTable, dispensePos);
			self:EmitSound("buttons/button1.wav");
			self:SetDTInt(choice - 1, self:GetDTInt(choice - 1) - 1);
			PLUGIN:SaveSnackMachines();
		end;
	end;

	function ENT:Use(activator, caller, type, value)
		if (activator:GetFaction() == FACTION_CWU and activator:KeyDown(IN_SPEED)) then
			if (Clockwork.player:CanAfford(activator, self:GetRestockPrice())) then
				self:Restock(activator);
			else
				Clockwork.player:Notify(player, "You cannot afford to restock this machine!");
			end;
		elseif (activator:GetFaction() == FACTION_MPF and activator:KeyDown(IN_SPEED)) then
			self:Toggle();
		else
			if (!self:GetDTBool(0) and !self:GetDTBool(1)) then
				local pos = self:GetPos() + self:GetForward() * 17.8 + self:GetRight() * 21.5 + self:GetUp() * 34;
				local dist = activator:EyePos():Distance(self:GetPos());
				local ang = self:GetAngles();
				ang:RotateAroundAxis(self:GetRight(), 90);
				ang:RotateAroundAxis(self:GetForward(), 90);
				ang:RotateAroundAxis(self:GetUp(), 180);
				local intersect = util.IntersectRayWithPlane(activator:EyePos(), activator:EyeAngles():Forward(), pos, self:GetForward());
				local diff;
				local screenpos;
				local choice;

				if (intersect and dist <= 100) then
					diff = pos - intersect;
					screenpos = Vector(diff:Dot(-ang:Forward()) / textscale, diff:Dot(-ang:Right()) / textscale, 0);

					if (screenpos.x >= 30 and screenpos.x <= textwidth and screenpos.y >= 300 and screenpos.y <= textheight) then
						for i = 0, 3 do
							if (screenpos.y >= (i * rowsize + 300) and screenpos.y <= (i * rowsize + 300 + rowsize) and self:GetDTInt(i) > 0) then
								choice = i + 1;

								if ((self.nextUse or 0) < CurTime()) then
									if (Clockwork.player:CanAfford(activator, snacks[choice].price)) then
										Clockwork.player:GiveCash(activator, -snacks[choice].price, "purchased a " .. snacks[choice].name);

										self:EmitSound("ambient/levels/labs/coinslot1.wav");
										self:Dispense(choice);

										self:SetDTBool(0, true);

										timer.Simple(1.5, function()
											if (IsValid(self)) then
												self:SetDTBool(0, false);
											end;
										end);
									else
										self:EmitSound("buttons/button11.wav");
										Clockwork.player:Notify(activator, "You cannot afford that!");
									end;

									self.nextUse = CurTime() + 1.5;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
	end;

else

	local function definecanvas(ref)
		render.ClearStencil();
		render.SetStencilEnable(true);
		render.SetStencilCompareFunction(STENCIL_ALWAYS);
		render.SetStencilPassOperation(STENCIL_REPLACE);
		render.SetStencilFailOperation(STENCIL_KEEP);
		render.SetStencilZFailOperation(STENCIL_KEEP);
		render.SetStencilWriteMask(254);
		render.SetStencilTestMask(254);
		render.SetStencilReferenceValue(ref or 43);
	end;

	local function drawon()
		render.SetStencilCompareFunction(STENCIL_EQUAL);
	end;

	local function stopcanvas()
		render.SetStencilEnable(false);
	end;

	local blur = Material("pp/blurscreen");

	surface.CreateFont("snack", {font = "Roboto", size = 200, weight = 500, antialias = true});
	surface.CreateFont("snackinfo", {font = "Roboto", size = 75, weight = 500, antialias = true});


	function ENT:Initialize()
		self:SetSolid(SOLID_VPHYSICS);
		self.lerpalpha = 15;
		self.lerpblur = 3;
		self.lerptextalpha = 255;
		self.lerptextshadow = 100;
		self.selecty = 0;
		self.selectalpha = 0;
		self.selected = -1;
	end;

	function ENT:Draw()
		self:DrawModel();
	end;

	function ENT:DrawTranslucent()
		local pos = self:GetPos() + self:GetForward() * 17.8 + self:GetRight() * 21.5 + self:GetUp() * 34;
		local dist = LocalPlayer():EyePos():Distance(self:GetPos());
		local ang = self:GetAngles();
		ang:RotateAroundAxis(self:GetRight(), 90);
		ang:RotateAroundAxis(self:GetForward(), 90);
		ang:RotateAroundAxis(self:GetUp(), 180);

		if (dist <= 100 and LocalPlayer():GetEyeTraceNoCursor().Entity == self and !self:GetDTBool(0)) then
			self.lerpalpha = Lerp(FrameTime() * 5, self.lerpalpha, 15);
			self.lerpblur = Lerp(FrameTime() * 5, self.lerpblur, 5);
			self.lerptextalpha = Lerp(FrameTime() * 5, self.lerptextalpha, 255);
			self.lerptextshadow = Lerp(FrameTime() * 5, self.lerptextshadow, 130);
		else
			self.lerpalpha = Lerp(FrameTime() * 5, self.lerpalpha, 0);
			self.lerpblur = Lerp(FrameTime() * 5, self.lerpblur, 0);
			self.lerptextalpha = Lerp(FrameTime() * 5, self.lerptextalpha, 0);
			self.lerptextshadow = Lerp(FrameTime() * 5, self.lerptextshadow, 0);
			self.selectalpha = Lerp(FrameTime() * 5, self.selectalpha, 0);
		end;

		if (self.lerptextalpha > 1 and !self:GetDTBool(1)) then
			local intersect = util.IntersectRayWithPlane(LocalPlayer():EyePos(), LocalPlayer():EyeAngles():Forward(), pos, self:GetForward());
			local diff;
			local screenpos;

			if (intersect) then
				diff = pos - intersect;
				screenpos = Vector(diff:Dot(-ang:Forward()) / textscale, diff:Dot(-ang:Right()) / textscale, 0);
			end;

			definecanvas(322);
			cam.Start3D2D(pos, ang, scale);
				surface.SetDrawColor(255, 255, 255, self.lerpalpha);
				surface.DrawRect(0, 0, width, height);
			cam.End3D2D();
			drawon();

			render.SetMaterial(blur);

			for i = 0.4, 1, 0.2 do
				blur:SetFloat("$blur", i * self.lerpblur);
				blur:Recompute();
				render.UpdateScreenEffectTexture();
				render.DrawScreenQuad();
			end;

			stopcanvas();

			-- faded primary

			cam.Start3D2D(pos - self:GetForward() * 1.5, ang, textscale);
				draw.SimpleText("UNION VENDOR", "snack", textwidth / 2, 50, ColorAlpha(color_white, self.lerptextalpha / 13), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
			cam.End3D2D();

			-- Selection box
			if (intersect and dist <= 100 and !self:GetDTBool(0) and !self:GetDTBool(1)) then
				cam.Start3D2D(pos, ang, textscale);

				if (screenpos.x >= 30 and screenpos.x <= textwidth and screenpos.y >= 300 and screenpos.y <= textheight) then
					for i = 0, 3 do
						if (screenpos.y >= (i * rowsize + 300) and screenpos.y <= (i * rowsize + 300 + rowsize)) then
							if (self:GetDTInt(i) > 0) then
								self.lasty = (i * rowsize + 300);
							end;

							self.selected = i;
						end;
					end;
				else
					self.selecty = 0;
					self.selected = -1;
				end;

				if (self.selected >= 0) then
					if (self:GetDTInt(self.selected) > 0) then
						if (self.selecty == 0) then
							self.selecty = (self.selected * rowsize + 300)
						end;

						self.selectalpha = Lerp(FrameTime() * 5, self.selectalpha, 200);
						self.selecty = Lerp(FrameTime() * 8, self.selecty or 0, (self.selected * rowsize + 300));
					else
						self.selecty = 0;
						self.selectalpha = Lerp(FrameTime() * 5, self.selectalpha, 0);
					end;
				else
					self.selecty = 0;
					self.selectalpha = Lerp(FrameTime() * 5, self.selectalpha, 0);
				end;


				if (self.lasty) then
					surface.SetDrawColor(255, 150, 0, self.selectalpha);
					surface.DrawRect(30, self.selecty != 0 and self.selecty or self.lasty, textwidth - 30, rowsize);
				end;

				cam.End3D2D();
			end;

			for i = 1, 4 do
				-- faded primary
				cam.Start3D2D(pos - self:GetForward() * 1.5, ang, textscale)
					draw.SimpleText(snacks[i].name, "snack", 50, (i - 1) * rowsize + 320, ColorAlpha(color_white, self.lerptextalpha / 13), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
					draw.SimpleText("Price: " .. snacks[i].price .. " tokens", "snackinfo", 50, (i - 1) * rowsize + 455, ColorAlpha(color_white, Clockwork.player:GetCash(Clockwork.Client) >= snacks[i].price and self.lerptextalpha / 13 or 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
					draw.SimpleText("Remaining: " .. self:GetDTInt(i - 1), "snackinfo", 50, (i - 1) * rowsize + 530, ColorAlpha(color_white, self.lerptextalpha / 13), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
				cam.End3D2D();

				if (self:GetDTInt(i - 1) > 0) then
					--shadow
					cam.Start3D2D(pos, ang, textscale)
						draw.SimpleText(snacks[i].name, "snack", 50, (i - 1) * rowsize + 320, ColorAlpha(color_black, self.lerptextshadow), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
						draw.SimpleText("Price: " .. snacks[i].price .. " tokens", "snackinfo", 50, (i - 1) * rowsize + 455, ColorAlpha(color_black, self.lerptextshadow), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
						draw.SimpleText("Remaining: " .. self:GetDTInt(i - 1), "snackinfo", 50, (i - 1) * rowsize + 530, ColorAlpha(color_black, self.lerptextshadow), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
					cam.End3D2D();

					-- primary
					cam.Start3D2D(pos + self:GetForward() * 0.5, ang, textscale);
						draw.SimpleText(snacks[i].name, "snack", 50, (i - 1) * rowsize + 320, ColorAlpha(color_white, self.lerptextalpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
						draw.SimpleText("Price: " .. snacks[i].price .. " tokens", "snackinfo", 50, (i - 1) * rowsize + 455, ColorAlpha(Clockwork.player:GetCash(Clockwork.Client) >= snacks[i].price and color_white or color_red, self.lerptextalpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
						draw.SimpleText("Remaining: " .. self:GetDTInt(i - 1), "snackinfo", 50, (i - 1) * rowsize + 530, ColorAlpha(color_white, self.lerptextalpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
					cam.End3D2D();
				end;
			end;

			-- shadow

			cam.Start3D2D(pos, ang, textscale);
				draw.SimpleText("UNION VENDOR", "snack", textwidth / 2, 50, ColorAlpha(color_black, self.lerptextshadow), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
			cam.End3D2D();

			-- primary texts

			cam.Start3D2D(pos + self:GetForward() * 0.5, ang, textscale);
				draw.SimpleText("UNION VENDOR", "snack", textwidth / 2, 50, ColorAlpha(color_white, self.lerptextalpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
			cam.End3D2D();

		elseif (self:GetDTBool(1)) then
			definecanvas(322);
			cam.Start3D2D(pos, ang, scale);
				surface.SetDrawColor(255, 0, 0, self.lerpalpha * 2);
				surface.DrawRect(0, 0, width, height);
			cam.End3D2D();
			drawon();

			render.SetMaterial(blur);

			for i = 0.4, 1, 0.2 do
				blur:SetFloat("$blur", i * self.lerpblur);
				blur:Recompute();
				render.UpdateScreenEffectTexture();
				render.DrawScreenQuad();
			end;

			stopcanvas();

			-- faded primary texts
			cam.Start3D2D(pos - self:GetForward() * 1.5, ang, textscale);
				draw.SimpleText("DISABLED", "snack", textwidth / 2, 600, ColorAlpha(color_white, self.lerptextalpha / 13), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
			cam.End3D2D();

			-- shadow
			cam.Start3D2D(pos, ang, textscale);
				draw.SimpleText("DISABLED", "snack", textwidth / 2, 600, ColorAlpha(color_black, self.lerptextshadow), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
			cam.End3D2D();

			-- primary texts

			cam.Start3D2D(pos + self:GetForward() * 0.5, ang, textscale);
				draw.SimpleText("DISABLED", "snack", textwidth / 2, 600, ColorAlpha(color_white, self.lerptextalpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
			cam.End3D2D();
		end;
	end;
end;