if ( !CLIENT ) then return end

local HUD = {}

HUD.HealthIcon = surface.GetTextureID("gui/silkicons/heart")
HUD.ArmorIcon = surface.GetTextureID("gui/silkicons/shield")

HUD.x = 20
HUD.y = ScrH() - 120

HUD.NDraw = { "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo" }

HUD.Weapons = {	weapon_pistol = "18", weapon_357 = "6", weapon_smg1 = "45", weapon_ar2 = "30", weapon_shotgun = "6", weapon_crossbow = "1" }

HUD.Tools = { "weapon_physcannon", "weapon_physgun", "gmod_tool" }

function HUD.Initialize()
	timer.Simple(1, function() //Because this goes in autorun
		
		//Override some stuff, for now just DrawTargetID
		function GAMEMODE:HUDDrawTargetID() end
		//function GAMEMODE:HUDPaint() end
	end)
end

function HUD.ShouldDrawHUD(info) //Hide stuff
	if ( table.HasValue(HUD.NDraw, info) ) then
		return false
	end
end

function HUD.DrawAll()
	if ( !LocalPlayer():Alive() ) then return end
	
	HUD.DrawState()		//Draw Health/Armor
	HUD.DrawAmmo()		//Draw Ammo
	HUD.DrawTrace()		//Draw TargetID and Entity Data
end

function HUD.DrawState()
	if ( !HUD.HP || LocalPlayer():Health() ~= HUD.HP ) then
		HUD.HP		=	LocalPlayer():Health()
	end
	
	if ( !HUD.AR || LocalPlayer():Armor() ~= HUD.AR ) then
		HUD.AR		=	LocalPlayer():Armor()
	end
	
	local h = math.Clamp(HUD.HP, 1, 100) / 100
	
	// Health box.
	draw.RoundedBox(8, HUD.x, HUD.y, 200, 26, Color(0, 0, 0, 200))
	surface.SetTexture(HUD.HealthIcon) 
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(HUD.x + 5, HUD.y + 5, 16, 16)
		
	draw.RoundedBox(6, HUD.x + 25, HUD.y + 5, h * 168, 16, Color(255, 255, 255, 80))
	// End health box.
	
	if ( HUD.AR > 0 ) then
		local r = math.Clamp(HUD.AR, 1, 100) / 100
		
		// Armor box.
		draw.RoundedBox(8, HUD.x, HUD.y + 36, 200, 26, Color(0, 0, 0, 180))
		
		surface.SetTexture(HUD.ArmorIcon) 
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(HUD.x + 5, HUD.y + 41, 16, 16)
		
		draw.RoundedBox(6, HUD.x + 25, HUD.y + 41, r * 168, 16, Color(255, 255, 255, 80))
		// End armor box.
	end
	
end

function HUD.IntFormat(A, B)
	if ( A && B ) then
		
		//failure but w/e, can't exactly use %0%sd, and im too lazy to use string.len and string.rep 
		return string.format("%0" .. A .. "d", B)
	end
end

function HUD.DrawAmmo()

	local Weapon = LocalPlayer():GetActiveWeapon()
	
	if ( Weapon:IsWeapon() ) then
		if ( !HUD.Clip_1 || Weapon:Clip1() ~= HUD.Clip_1 ) then
			HUD.Clip_1		=	Weapon:Clip1()
		end
		
		if ( !HUD.Clip_2 || LocalPlayer():GetAmmoCount(Weapon:GetSecondaryAmmoType()) ~= HUD.Clip_2 ) then
			HUD.Clip_2		=	LocalPlayer():GetAmmoCount(Weapon:GetSecondaryAmmoType())
		end
		
		if ( !HUD.Ammo_1 || LocalPlayer():GetAmmoCount(Weapon:GetPrimaryAmmoType()) ~= HUD.Ammo_1 ) then
			HUD.Ammo_1		=	LocalPlayer():GetAmmoCount(Weapon:GetPrimaryAmmoType())
		end
		
			if ( Weapon:GetClass() ~= "weapon_physcannon" ) then //physcannon is the only weapon in C++ that's clip isn't -1 when it comes to HL2 weapons that don't use ammo.
				//The rest of this function is vrrrrry messy :V
				local Ammo1	= HUD.IntFormat(3, HUD.Ammo_1)
				
				if ( HUD.Clip_1 ~= -1 ) then
					if ( HUD.Weapons[Weapon:GetClass()] ) then
						HUD.MaxClip = #HUD.Weapons[Weapon:GetClass()]
						//C++ Weapons
						
					elseif ( Weapon.Primary.ClipSize ) then
						HUD.MaxClip = #tostring(Weapon.Primary.ClipSize) //I has to tostring it to get the digit length
						//Lua Weapons
						
					end
					
					local Clip = HUD.IntFormat(HUD.MaxClip, HUD.Clip_1)
					
					
					if ( HUD.Clip_2 > 0 ) then
						local Ammo2	= HUD.IntFormat(2, HUD.Clip_2)
						
						draw.RoundedBox(8, HUD.x, HUD.y + 46, 200, 26, Color(0, 0, 0, 180))
						
						surface.SetTexture(HUD.ArmorIcon) 
						surface.SetDrawColor(255, 255, 255, 255)
						surface.DrawTexturedRect(HUD.x + 5, HUD.y + 41, 16, 16)
						
						draw.RoundedBox(6, HUD.x + 25, HUD.y + 41, r * 168, 16, Color(255, 255, 255, 80))
						//draw.SimpleTextOutlined(string.format("AMMO %s/%s | %s", Clip, Ammo1, Ammo2), "Default", HUD.x, HUD.y + 8, Color(255, 255, 255, a), 0, 0, 1, Color(0, 0, 0, a))
						
						return
					end
					
					//Ammo formats like 00/000 (for normal weapons)
					draw.RoundedBox(8, HUD.x, HUD.y + 71, 150, 26, Color(0, 0, 0, 180))
						
						surface.SetTexture(HUD.ArmorIcon) 
						surface.SetDrawColor(255, 255, 255, 255)
						surface.DrawTexturedRect(HUD.x + 5, HUD.y + 41, 16, 16)
						
						draw.RoundedBox(6, HUD.x + 25, HUD.y + 41, HUD.Clip_1 * 10, 16, Color(255, 255, 255, 80))
					//draw.SimpleTextOutlined(string.format("AMMO %s/%s", Clip, Ammo1), "Default", HUD.x, HUD.y + 8, Color(255, 255, 255, a), 0, 0, 1, Color(0, 0, 0, a))
					
				elseif ( HUD.Ammo_1 > 0 ) then
					
					//Ammo formats like 000 (for weapons that don't use a clip like grenades and rpgs)
					draw.RoundedBox(8, HUD.x, HUD.y + 46, 200, 26, Color(0, 0, 0, 180))
						
						surface.SetTexture(HUD.ArmorIcon) 
						surface.SetDrawColor(255, 255, 255, 255)
						surface.DrawTexturedRect(HUD.x + 5, HUD.y + 41, 16, 16)
						
						draw.RoundedBox(6, HUD.x + 25, HUD.y + 41, r * 168, 16, Color(255, 255, 255, 80))
					//draw.SimpleTextOutlined(string.format("AMMO %s", Ammo1), "Default", HUD.x, HUD.y + 8, Color(255, 255, 255, a), 0, 0, 1, Color(0, 0, 0, a))
					
				end
			end
			
		end

end

function HUD.DrawTrace()
	
	local trace = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))
	
	if ( ValidEntity(trace.Entity) ) then
		if ( trace.Entity:IsPlayer() ) then
			if ( !HUD.DrawTarget ) then return end
			
			local p		=	{ x = ScrW() / 2, y = ScrH() / 2 }
			local y 	=	0
			
			
			if ( gmod.GetGamemode().Name == "Sandbox" || GM.IsSandboxDerived ) then
				if ( HUD.DisplayWebsite && string.len(trace.Entity:GetWebsite()) > 0 ) then
					y = 10
					
					draw.SimpleTextOutlined(tostring(trace.Entity:GetWebsite()), "DefaultSmall", p.x, p.y + 32, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, 0, 0.8, Color(0, 0, 0, 200))
				end
			end
			
			draw.SimpleTextOutlined(trace.Entity:Name() .. " " .. math.max(trace.Entity:Health(), 0) .. "%", "Default", p.x, p.y + 18, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, 0, 1, Color(0, 0, 0, 200))
			
			local h = math.Clamp(trace.Entity:Health(), 1, 100) / 100
			
			draw.RoundedBox(0, p.x - 31, p.y + 38 + y, 60, 4, Color(0, 0, 0, 200))
			draw.RoundedBox(0, p.x - 30, p.y + 39 + y, h * 58, 2, Color(HUD.ColorHealth.r, HUD.ColorHealth.g, HUD.ColorHealth.b, 255))
			
			if ( trace.Entity:Armor() > 0 ) then
				local r = math.Clamp(trace.Entity:Armor(), 1, 100) / 100
				
				draw.RoundedBox(0, p.x - 31, p.y + 42 + y, 60, 2, Color(0, 0, 0, 200))
				draw.RoundedBox(0, p.x - 30, p.y + 42 + y, r * 58, 1, Color(HUD.ColorArmor.r, HUD.ColorArmor.g, HUD.ColorArmor.b, 255))
			end
			
		elseif ( HUD.DrawPData && ValidEntity(LocalPlayer():GetActiveWeapon()) && table.HasValue(HUD.Tools, LocalPlayer():GetActiveWeapon():GetClass()) ) then //Only draw if we have a tool out
			local EntData = { //I has to tostring all dis har shat
				class	= tostring(trace.Entity:GetClass()),	//Class Name
				index	= tostring(trace.Entity:EntIndex()),	//Index
				model	= tostring(trace.Entity:GetModel()),	//Model
				angle	= string.Replace(tostring(trace.Entity:GetAngles()), " ", ", "),	//Angles
				wpos	= string.Replace(tostring(trace.Entity:LocalToWorld(trace.Entity:OBBCenter())), " ", ", ")	//World Position from the center of the entity
			}
			
			draw.SimpleTextOutlined(string.format("( %s ) [ %s ] %s", EntData.class, EntData.index, EntData.model), "Default", 2, 0, Color(255, 255, 255, 255), 0, 3, 1, Color(0,0,0,255))
			draw.SimpleTextOutlined(string.format("Angle(%s) Pos(%s)", EntData.angle, EntData.wpos), "Default", 2, 15, Color(255, 255, 255, 255), 0, 3, 1, Color(0,0,0,255))
		end
	end
end

hook.Add("HUDShouldDraw", "SilkHUDHide", HUD.ShouldDrawHUD)
hook.Add("HUDPaint", "SilkHUDDraw", HUD.DrawAll)
hook.Add("Initialize", "SilkHUDInitialize", HUD.Initialize)