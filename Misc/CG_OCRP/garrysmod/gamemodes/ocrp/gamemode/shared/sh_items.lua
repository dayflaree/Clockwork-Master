GM.OCRP_Items = {} 

GM.OCRP_Items["item_medkit"] = {
	Name = "Health kit",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Heals all wounds",-- The description
	Model = "models/items/healthkit.mdl",-- The model
	Price = 20,--Price
	Weight = 1,
	Max = 5,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				local hp = ply:Health()
				if hp >= 100 then 
					return false
				end
				return true
			end,
	Function = 
		function(ply,item) 
			local hp = ply:Health()
			if hp < 100 then 
				ply:SetHealth(100)
			end 
			ply:EmitSound("items/smallmedkit1.wav",110,100) 
		end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}

GM.OCRP_Items["item_bodyarmor01"] = {
	Name = "Citizen Grade Kevlar",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Reduces damage taken",-- The description
	Model = "models/kevlarvest/kevlarvest.mdl",-- The model
	Price = 500,--Price
	Weight = 1,
	Max = 5,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return true
			end,
	Function = 
		function(ply,item) 
			ply:BodyArmor(3)
		end,
	}	
	
GM.OCRP_Items["item_nrg_drink"] = {
	Name = "Energy Drink",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Restores energy",-- The description
	Model = "models/props_junk/PopCan01a.mdl",-- The model
	Price = 20,--Price
	Weight = 1,
	Max = 5,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				local nrg =  ply.Energy or 0
				if nrg >= 100 then 
					return false
				end
				return true
			end,
	Function = 
		function(ply,item) 
			local nrg = ply.Energy or 0
			if nrg < 100 then 
				if (SERVER) then
					ply.Energy = 100
					umsg.Start("soda_energy", ply)
						umsg.Long( 100 )
					umsg.End()
				end
			end 
			ply:EmitSound("items/smallmedkit1.wav",110,100) 
		end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}

--====================================================
GM.OCRP_Items["item_ammo_cop"] = {
	Name = "Police Pistol Ammo",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Pistol rounds for police",-- The description
	Model = "models/items/357ammobox.mdl",-- The model
	Price = 20,--Price
	Weight = 0,
	Max = 5,-- Total Number of items able to be carried.
	AmmoType = "StriderMinigun",
	-- what it does don't touch it.
	DoesntSave = true,
	Condition = function(ply,item) -- Checks to see if the player can use it.
					return true
				end,
	}
	
GM.OCRP_Items["item_ammo_riot"] = {
	Name = "Police Shotgun Ammo",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Shotgun rounds for the police shotguns",-- The description
	Model = "models/items/boxbuckshot.mdl",-- The model
	Price = 20,--Price
	Weight = 0,
	Max = 5,-- Total Number of items able to be carried.
	AmmoType = "GaussEnergy",
	-- what it does don't touch it.
	DoesntSave = true,
	Condition = function(ply,item) -- Checks to see if the player can use it.
					return true
				end,
	}
	
GM.OCRP_Items["item_ammo_ump"] = {
	Name = "Ump45 Ammo",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "30 Rounds",-- The description
	Model = "models/items/boxmrounds.mdl",-- The model
	Price = 20,--Price
	Weight = 0,
	Max = 5,-- Total Number of items able to be carried.
	AmmoType = "CombineCannon",
	DoesntSave = true,
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
					return false
				end,
	}
	
GM.OCRP_Items["item_shotgun_cop"] = {
	Name = "Police Shotgun",-- The Name
	Angle = Angle(120,90,90),---- Allows for manual rotation on the display 
	Desc = "Great for bar defence",-- The description
	Model = "models/weapons/w_shot_m3super90.mdl",-- The model
	Price = 10,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	DoesntSave = true,
	Weapondata = {Weapon = "police_shotgun_ocrp",DontDisplay = true,
		Setup = function(ply,item) 
			end,
			Bone = "ValveBiped.Bip01_Spine4",
			Angle = Angle(-50,120,90),
			Pos = function(obj) 
					local leg = obj:LookupBone(GAMEMODE.OCRP_Items["item_shotgun"].Weapondata.Bone)
					local pos,ang = obj:GetBonePosition( leg )
					return ang:Right() * 2 + ang:Forward() * -10 + ang:Up() * 2
				end,
			},
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return false
			end,
	SpawnFunction = 
		function(self)
			self:Remove()
		end,
	}
	
GM.OCRP_Items["item_taser_cop"] = {
	Name = "Police Taser",-- The Name
	Angle = Angle(120,90,90),---- Allows for manual rotation on the display 
	Desc = "Take down targets with no lethality",-- The description
	Model = "models/weapons/w_pist_fiveseven.mdl",-- The model
	Price = 5,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	DoesntSave = true,
	Weapondata = {Weapon = "weapon_cop_taser",DontDisplay = true,
		Setup = function(ply,item) 
			end,
			},
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return false
			end,
	SpawnFunction = 
		function(self)
			self:Remove()
		end,
	}
	
GM.OCRP_Items["item_ammo_taser"] = {
	Name = "Taser Darts",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "10",-- The description
	Model = "models/items/boxsrounds.mdl",-- The model
	Price = 20,--Price
	Weight = 0,
	Max = 5,-- Total Number of items able to be carried.
	AmmoType = "357",
	DoesntSave = true,
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
					return false
				end,
	}
--=====================================================

GM.OCRP_Items["item_ammo_pistol"] = {
	Name = "Pistol Ammo",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "pistol rounds",-- The description
	Model = "models/items/357ammobox.mdl",-- The model
	Price = 20,--Price
	Weight = 0,
	Max = 5,-- Total Number of items able to be carried.
	AmmoType = "pistol",
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
					return true
				end,
	LootData = {Speed = 6,Level = 3,},
	}
		
GM.OCRP_Items["item_ammo_rifle"] = {
	Name = "Rifle Ammo",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "30 Rounds",-- The description
	Model = "models/items/boxsrounds.mdl",-- The model
	Price = 20,--Price
	Weight = 0,
	Max = 5,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	AmmoType = "ar2",
	Condition = function(ply,item) -- Checks to see if the player can use it.
					return true
				end,
	LootData = {Speed = 6,Level = 3,},
	}
	
GM.OCRP_Items["item_ammo_smg"] = {
	Name = "SMG Ammo",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "30 Rounds",-- The description
	Model = "models/items/boxmrounds.mdl",-- The model
	Price = 20,--Price
	Weight = 0,
	Max = 5,-- Total Number of items able to be carried.
	AmmoType = "SMG1",
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
					return false
				end,
	LootData = {Speed = 6,Level = 3,},
	}
	
GM.OCRP_Items["item_ammo_buckshot"] = {
	Name = "Buckshot Ammo",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "12 Rounds",-- The description
	Model = "models/items/boxbuckshot.mdl",-- The model
	Price = 20,--Price
	Weight = 0,
	Max = 5,-- Total Number of items able to be carried.
	AmmoType = "buckshot",
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
					return false
				end,
	LootData = {Speed = 6,Level = 3,},
	}	
	
GM.OCRP_Items["item_ladder"] = {
	Name = "Ladder",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Get Up",-- The description
	Model = "models/props_c17/metalladder001.mdl",-- The model
	Price = 20,--Price
	Weight = 6,
	Max = 1,-- Total Number of items able to be carried.
	Spawnable = true, -- this determines if it spawns in the world. Spawns at feet.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			local free = false
				for _,objs in pairs(ents.FindInSphere(self:GetPos(),64)) do
					if objs:GetClass() == "item_base" && objs:GetNWInt("Class") == "item_ladder" then
						if objs.Ladder != nil && objs.AttachedLadder == nil then
							free = true
							self:SetPos(objs:GetPos() + objs:GetAngles():Forward() * -5 + Vector(0,0,120))
							self:SetAngles(objs:GetAngles())
							objs.AttachedLadder = self
							break
						end
					end
				end	
			if player.GetByID(self:GetNWInt("Owner")):OnGround() || free then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 10)
				self:SetMoveType(MOVETYPE_VPHYSICS)
				self:PhysicsInit(SOLID_VPHYSICS)
				self:GetPhysicsObject():EnableMotion(false)
				self.Ladder = ents.Create("func_useableladder")
				self.Ladder:SetPos(self:GetPos() + self:GetAngles():Forward() * -10)
				self.Ladder:SetKeyValue("point0",tostring(self.Ladder:GetPos() + self.Ladder:GetAngles():Up() * -40))
				self.Ladder:SetKeyValue("point1",tostring(self.Ladder:GetPos() + self.Ladder:GetAngles():Up() * 90))
				self.Ladder:Spawn()
			end
			self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		end,
	PickUpFunction = 
				function(self)
					if self.Ladder != nil && self.Ladder:IsValid() then
						self.Ladder:Remove()
						if self.AttachedLadder != nil && self.AttachedLadder:IsValid() then
							self.AttachedLadder:Detach(self) 
						end
					end
				end,
	}
	
GM.OCRP_Items["item_metal_fence"] = {
	Name = "Chain-link Fence",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Keep out.",-- The description
	Model = "models/props_c17/fence01a.mdl",-- The model
	Price = 480,--Price
	Weight = 0,
	Max = 4,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	}
	
GM.OCRP_Items["item_wood_fence"] = {
	Name = "Wood Fence",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Keep out.",-- The description
	Model = "models/props_wasteland/wood_fence01a.mdl",-- The model
	Price = 80,--Price
	Weight = 0,
	Health = 200,
	Max = 4,-- Total Number of items able to be carried.
	Protected = true,
	SpawnFunction = function(self)
						self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
					end
	-- what it does don't touch it.
	}

GM.OCRP_Items["item_wood_barricade"] = {
	Name = "Wood Barricade",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Caution",-- The description
	Model = "models/props_wasteland/barricade002a.mdl",-- The model
	Price = 20,--Price
	Weight = 0,
	Health = 100,
	Max = 5,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.

	}

GM.OCRP_Items["item_barrier"] = {
	Name = "Concrete barrier",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Indestructable",-- The description
	Model = "models/props_c17/concrete_barrier001a.mdl",-- The model
	Price = 380,--Price
	Weight = 0,
	Health = 400,
	Max = 4,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	}

GM.OCRP_Items["item_cone"] = {
	Name = "Plastic Cone",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Warning",-- The description
	Model = "models/props_junk/TrafficCone001a.mdl",-- The model
	Price = 120,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	}	
	
GM.OCRP_Items["item_fiveseven"] = {
	Name = "Fiveseven",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Well rounded",-- The description
	Model = "models/weapons/w_pist_fiveseven.mdl",-- The model
	Price = 520,--Price
	Weight = 5,
	Max = 1,-- Total Number of items able to be carried.
	Illegalizeable = true,
	Weapondata = {Weapon = "weapon_fiveseven_ocrp",
		Setup = function(ply,item) 
		end,
		Bone = "ValveBiped.Bip01_Pelvis",
		Angle = Angle(90,-10,90),
		Pos = function(obj)
					local leg = obj:LookupBone(GAMEMODE.OCRP_Items["item_fiveseven"].Weapondata.Bone)
					local pos,ang = obj:GetBonePosition( leg )
					return ang:Forward() * -2 + ang:Up() * 3.25
			end,
		},
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return false
			end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 1.7,Level = 5,},
	}

GM.OCRP_Items["item_deagle"] = {
	Name = "Desert Eagle",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Strong and accurate",-- The description
	Model = "models/weapons/w_pist_deagle.mdl",-- The model
	Price = 760,--Price
	Weight = 7,
	Max = 1,-- Total Number of items able to be carried.
	Illegalizeable = true,
	Weapondata = {Weapon = "weapon_deagle_ocrp",
		Setup = function(ply,item) 
		end,
		Bone = "ValveBiped.Bip01_R_Thigh",
		Angle = Angle(0,0,90),
		Pos = function(obj)
					local leg = obj:LookupBone(GAMEMODE.OCRP_Items["item_deagle"].Weapondata.Bone)
					local pos,ang = obj:GetBonePosition( leg )
					return ang:Up() * -3 + ang:Forward() * 3 
				end,
		},
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return false
			end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 1.6,Level = 5,},
	}
	
GM.OCRP_Items["item_molotov"] = {
	Name = "Molotov",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Creates fires",-- The description
	Model = "models/weapons/w_beerbot.mdl",-- The model
	Price = 3000,--Price
	Weight = 7,
	Max = 1,-- Total Number of items able to be carried.
	Illegalizeable = true,
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return true
			end,
	Function = function( ply, item ) ply:Give( "weapon_rp_molotov" ) end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 1.6,Level = 5,},
	}
	
GM.OCRP_Items["item_glock18"] = {
	Name = "Glock-18",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Good for self defence",-- The description
	Model = "models/weapons/w_pist_glock18.mdl",-- The model
	Price = 400,--Price
	Weight = 3,
	Max = 1,-- Total Number of items able to be carried.
	Illegalizeable = true,
	Weapondata = {Weapon = "weapon_glock18_ocrp",
		Setup = function(ply,item) 
		end,
		Bone = "ValveBiped.Bip01_Pelvis",
		Angle = Angle(90,10,90),
		Pos = function(obj)
					local leg = obj:LookupBone(GAMEMODE.OCRP_Items["item_glock18"].Weapondata.Bone)
					local pos,ang = obj:GetBonePosition( leg )
					return ang:Forward() * 5 + ang:Up() * 4
			end,
		},
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return false
			end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 1.8,Level = 5,},
	}
	
GM.OCRP_Items["item_shotgun"] = {
	Name = "Shotgun",-- The Name
	Angle = Angle(120,90,90),---- Allows for manual rotation on the display 
	Desc = "Great for bar defence",-- The description
	Model = "models/weapons/w_shot_m3super90.mdl",-- The model
	Price = 1160,--Price
	Weight = 10,
	Max = 1,-- Total Number of items able to be carried.
	Illegalizeable = true,
	Weapondata = {Weapon = "weapon_shotgun_ocrp",
		Setup = function(ply,item) 
			end,
			Bone = "ValveBiped.Bip01_Spine4",
			Angle = Angle(-10,90,90),
			Pos = function(obj) 
					local leg = obj:LookupBone(GAMEMODE.OCRP_Items["item_shotgun"].Weapondata.Bone)
					local pos,ang = obj:GetBonePosition( leg )
					return ang:Forward() * -10 + ang:Up() * 2
				end,
			},
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return false
			end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 1.2,Level = 6,},
	}

GM.OCRP_Items["item_mp5"] = {
	Name = "MP5 SMG",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Fast fire rate",-- The description
	Model = "models/weapons/w_smg_mp5.mdl",-- The model
	Price = 800,--Price
	Weight = 10,
	Max = 1,-- Total Number of items able to be carried.
	Illegalizeable = true,
	Weapondata = {Weapon = "weapon_mp5_ocrp",
		Setup = function(ply,item) 
			end,
			Bone = "ValveBiped.Bip01_Spine4",
			Angle = Angle(-50,90,90),
			Pos = function(obj) 
					local leg = obj:LookupBone(GAMEMODE.OCRP_Items["item_mp5"].Weapondata.Bone)
					local pos,ang = obj:GetBonePosition( leg )
					return ang:Forward() * -10 + ang:Up() * 6
				end,
			},
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return false
			end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 1.1,Level = 7,},
	}

GM.OCRP_Items["item_mac10"] = {
	Name = "Mac10",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Kill people gansta style",-- The description
	Model = "models/weapons/w_smg_mac10.mdl",-- The model
	Price = 960,--Price
	Weight = 10,
	Max = 1,-- Total Number of items able to be carried.
	Illegalizeable = true,
	Weapondata = {Weapon = "weapon_mac10_ocrp",
		Setup = function(ply,item) 
		end,
		Bone = "ValveBiped.Bip01_l_Thigh",
		Angle = Angle(0,0,90),
		Pos = function(obj) 
					local leg = obj:LookupBone(GAMEMODE.OCRP_Items["item_mac10"].Weapondata.Bone)
					local pos,ang = obj:GetBonePosition( leg )
					return ang:Up() * 3 + ang:Forward() * 5  + ang:Right() * -3
				end,
		},
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return false
			end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 1.1,Level = 7,},
	}
	
GM.OCRP_Items["item_m4a1"] = {
	Name = "M4-A1 Rifle",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Accurate",-- The description
	Model = "models/weapons/w_rif_m4a1.mdl",-- The model
	Price = 1400,--Price
	Weight = 10,
	Max = 1,-- Total Number of items able to be carried.
	Illegalizeable = true,
	Weapondata = {Weapon = "weapon_m4_ocrp",
		Setup = function(ply,item) 
			end,
			Bone = "ValveBiped.Bip01_Spine4",
			Angle = Angle(-30,90,90),
			Pos = function(obj) 
					local leg = obj:LookupBone(GAMEMODE.OCRP_Items["item_m4a1"].Weapondata.Bone)
					local pos,ang = obj:GetBonePosition( leg )
					return  ang:Forward() * -10 + ang:Up() * 4
				end,
			},
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return false
			end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 1,Level = 2,},
	}	
	
GM.OCRP_Items["item_physgun"] = {
	Name = "Physgun",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Allows for better building",-- The description
	Model = "models/weapons/w_physics.mdl",-- The model
	Price = 25000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	Illegalizeable = false,
	Weapondata = {Weapon = "weapon_physgun",DontDisplay = true,DontDrop = true},
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return false
			end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	}	
	
GM.OCRP_Items["item_ak47"] = {
	Name = "Ak-47",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Powerful",-- The description
	Model = "models/weapons/w_rif_ak47.mdl",-- The model
	Price = 1360,--Price
	Weight = 10,
	Max = 1,-- Total Number of items able to be carried.
	Illegalizeable = true,
	Weapondata = {Weapon = "weapon_ak47_ocrp",
		Setup = function(ply,item) 
			end,
			Bone = "ValveBiped.Bip01_Spine4",
			Angle = Angle(10,90,90),
			Pos = function(obj) 
					local leg = obj:LookupBone(GAMEMODE.OCRP_Items["item_ak47"].Weapondata.Bone)
					local pos,ang = obj:GetBonePosition( leg )
					return ang:Right() * 1 + ang:Forward() * -10 
				end,
			},
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return false
			end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 1,Level = 2,},
	}	
	
GM.OCRP_Items["item_knife"] = {
	Name = "knife",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Stealthy kills",-- The description
	Model = "models/weapons/w_knife_t.mdl",-- The model
	Price = 300,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	Illegalizeable = true,
	Weapondata = {Weapon = "weapon_knife_ocrp",
		Setup = function(ply,item) 
			end,
			Bone = "ValveBiped.Bip01_l_calf",
			Angle = Angle(-45,0,90),
			Pos = function(obj) 
					local leg = obj:LookupBone(GAMEMODE.OCRP_Items["item_knife"].Weapondata.Bone)
					local pos,ang = obj:GetBonePosition( leg )
					return ang:Up() * 2 + ang:Right() * 3
				end,
			},
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return false
			end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 4,},
	}

GM.OCRP_Items["item_bat"] = {
	Name = "Baseball bat",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Useful for self defense",-- The description
	Model = "models/weapons/w_basebt2.mdl",-- The model
	Price = 300,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	Illegalizeable = true,
	Weapondata = {Weapon = "weapon_bat_ocrp",
		Setup = function(ply,item) 
			end,
			Bone = "ValveBiped.Bip01_Spine4",
			Angle = Angle(20,90,90),
			Pos = function(obj) 
					local leg = obj:LookupBone(GAMEMODE.OCRP_Items["item_bat"].Weapondata.Bone)
					local pos,ang = obj:GetBonePosition( leg )
					return ang:Right() * 3 + ang:Up() * 2 
				end,
			},
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				return false
			end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 4,},
	}
	
GM.OCRP_Items["item_lockpick"] = {
	Name = "Lock Pick",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used to unlock doors",-- The description
	Model = "models/weapons/w_crowbar.mdl",-- The model
	Price = 360,--Price
	Weight = 1,
	Max = 5,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				if SERVER then
					if ply:HasWeapon("weapon_lockpick_ocrp") || !ply:HasSkill("skill_picking") then 
						return false
					end
				end
				return true
			end,
	Function = 
		function(ply,item) 
			ply:Give("weapon_lockpick_ocrp")
		end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 2,Level = 1,},
	}
	
	GM.OCRP_Items["item_wrench"] = {
	Name = "Repair Wrench",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used to repair vehicles",-- The description
	Model = "models/props_c17/tools_wrench01a.mdl",-- The model
	Price = 300,--Price
	Weight = 1,
	Max = 5,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				if SERVER then
					if ply:HasWeapon("weapon_wrench") || !ply:HasSkill("skill_craft_mech", 2) || !ply:HasSkill("skill_craft_circ") then 
						return false
					end
				end
				return true
			end,
	Function = 
		function(ply,item) 
			ply:Give("weapon_wrench")
		end,
	LootData = {Speed = 2,Level = 1,},
	}
	
GM.OCRP_Items["item_pot"] = {
	Name = "Pot",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Grow things...",-- The description
	Model = "models/props_c17/pottery09a.mdl",-- The model
	Price = 60,--Price
	Weight = 1,
	Max = 5,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	LootData = {Speed = 6,Level = 2,},
	}

GM.OCRP_Items["item_weed_seed"] = {
	Name = "Marijuana seeds",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Use with a pot",-- The description
	Model = "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl",-- The model
	Price = 300,--Price
	Weight = 1,
	Material = "katharsmodels/contraband/ocrp_contraband_see",
	Max = 5,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				if ply:Team() != CLASS_CITIZEN then return false end
				local counter = 0
				for _,ent in pairs(ents.FindByClass("item_base")) do
					if ent:GetNWInt("Owner") == ply:EntIndex() then
						if ent.Drug != nil then
							counter = counter + 1
						end
					end
				end
				if counter >= 5 then ply:Hint("You already have too many pots") return false end
				
				local pos = ply:EyePos()
				local posang = ply:GetAimVector()
				local tracedata = {}
				tracedata.start = pos
				tracedata.endpos = pos+(posang*80)
				tracedata.filter = ply
				local trace = util.TraceLine(tracedata)
				if trace.HitWorld then return false end
				if trace.HitNonWorld then
					if trace.Entity:GetClass() == "item_base" && trace.Entity:GetNWString("Class") == "item_pot" && trace.Entity.Drug == nil and trace.Entity:GetNWInt("Owner") == ply:EntIndex() then
						if SERVER then 
							if ply:HasSkill("skill_herb") then
								return true
							end
						else
							if CL_HasSkill("skill_herb") then
								return true
							end
						end
					end
				end
				return false
			end,
	Function = 
		function(ply,item) 
				local pos = ply:EyePos()
				local posang = ply:GetAimVector()
				local tracedata = {}
				tracedata.start = pos
				tracedata.endpos = pos+(posang*80)
				tracedata.filter = ply
				local trace = util.TraceLine(tracedata)

				if trace.HitWorld then return false end
				if trace.HitNonWorld then
					if trace.Entity:GetClass() == "item_base" && trace.Entity:GetNWString("Class") == "item_pot" && trace.Entity.Drug == nil && ply:HasSkill("skill_herb",1) and trace.Entity:GetNWInt("Owner") == ply:EntIndex() then
							trace.Entity.Drug = {Ready = false,}
							local multiplier = 1
							if trace.Entity:GetNWInt("Owner") > 0 then
								local ply = player.GetByID(trace.Entity:GetNWInt("Owner") || 0) 
									if ply:IsValid() && ply:HasSkill("skill_herb",2) then
										multiplier = .95
										if ply:HasSkill("skill_herb",4) then
											multiplier = .9
										end
									end
							end
						for _,ply in pairs(player.GetAll()) do
							if ply:IsValid() then
								umsg.Start("OCRP_CreateWeed",ply)
									umsg.Entity(trace.Entity)
								umsg.End()
							end
						end
						timer.Simple(math.Round(300*multiplier),function() 
							if trace.Entity:IsValid() then 						
								for _,ply in pairs(player.GetAll()) do
									if ply:IsValid() then
										umsg.Start("OCRP_UpdateWeed",ply)
											umsg.Entity(trace.Entity)
											umsg.Bool(true)
										umsg.End()
									end
								end 
								if trace.Entity.Drug != nil then
									trace.Entity.Drug.Ready = true 
								else
									trace.Entity.Drug = {Ready = true,}
								end
							end 
						end)
					end
				end
		end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 10,Level = 1,},
	}

GM.OCRP_Items["item_weed_bag"] = {
	Name = "3g of Marijuana",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Use with a pot",-- The description
	Model = "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl",-- The model
	Price = 300,--Price
	Weight = 0,
	Max = 150,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 10,Level = 1,},
	}	
	
GM.OCRP_Items["item_padlock"] = {
	Name = "Pad-Lock",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Secure your doors",-- The description
	Model = "models/props_wasteland/prison_padlock001a.mdl",-- The model
	Price = 360,--Price
	Weight = 0,
	Protected = true,
	Max = 5,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				local pos = ply:EyePos()
				local posang = ply:GetAimVector()
				local tracedata = {}
				tracedata.start = pos
				tracedata.endpos = pos+(posang*80)
				tracedata.filter = ply
				local trace = util.TraceLine(tracedata)

				if trace.HitWorld then return false end
				if trace.HitNonWorld then
					if trace.Entity:IsDoor() && trace.Entity:GetNWInt("Owner") == ply:EntIndex()  && trace.Entity.PadLock == nil then
						return true
					end
				end
				return false
			end,
	Function = 
		function(ply,item) 
				local pos = ply:EyePos()
				local posang = ply:GetAimVector()
				local tracedata = {}
				tracedata.start = pos
				tracedata.endpos = pos+(posang*80)
				tracedata.filter = ply
				local trace = util.TraceLine(tracedata)

				if trace.HitWorld then return false end
				if trace.HitNonWorld then
					if trace.Entity:IsDoor() && trace.Entity:GetNWInt("Owner") == ply:EntIndex() && trace.Entity.PadLock == nil then
						trace.Entity.PadLock = ents.Create("item_base")
						trace.Entity.PadLock.Owner = ply
						trace.Entity.PadLock:SetNWString("Class","item_padlock")
						trace.Entity.PadLock:SetPos(trace.Entity:GetPos() + ply:GetAngles():Forward() * -4 + trace.Entity:GetAngles():Right() * -42.5 + trace.Entity:GetAngles():Up() * -13)
						trace.Entity.PadLock:SetParent(trace.Entity)
						trace.Entity.PadLock:SetAngles(trace.Entity:GetAngles())
						trace.Entity.PadLock:Spawn()
						trace.Entity.PadLock:SetHealth(40)
						trace.Entity:Fire("Lock")
					end
				end
		end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	PickUpFunction = 
				function(self)
					if self:GetParent() != nil then
						self:GetParent().PadLock = nil
					end
				end,
	LootData = {Speed = 2,Level = 3,},
	}
	
GM.OCRP_Items["item_metal"] = {
	Name = "metal",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used in crafting",-- The description
	Model = "models/Gibs/metal_gib4.mdl",-- The model
	Price = 80,--Price
	Weight = 0,
	Max = 3,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,}, -- less is more time
	}
	
GM.OCRP_Items["item_clay"] = {
	Name = "Clay",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used in crafting",-- The description
	Model = "models/props_junk/terracotta_chunk01a.mdl",-- The model
	Price = 20,--Price
	Weight = 0,
	Max = 5,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}
	
GM.OCRP_Items["item_plastic"] = {
	Name = "Plastic",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used in crafting",-- The description
	Model = "models/props_junk/garbage_plasticbottle003a.mdl",-- The model
	Price = 40,--Price
	Weight = 0,
	Max = 4,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}
	
GM.OCRP_Items["item_wood"] = {
	Name = "Wood Chunk",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used in crafting",-- The description
	Model = "models/props_debris/wood_board04a.mdl",-- The model
	Price = 20,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}

GM.OCRP_Items["item_pole"] = {
	Name = "metal pole",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used in crafting",-- The description
	Model = "models/props_c17/signpole001.mdl",-- The model
	Price = 80,--Price
	Weight = 0,
	Max = 4,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}
	
GM.OCRP_Items["item_cardboard"] = {
	Name = "Cardboard",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used in crafting",-- The description
	Model = "models/props_junk/cardboard_box004a.mdl",-- The model
	Price = 50,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}

GM.OCRP_Items["item_casing"] = {
	Name = "Bullet-Casing",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used in crafting",-- The description
	Model = "models/Items/AR2_Grenade.mdl",--"models/shells/shell_large.mdl",-- The model
	Price = 160,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}	

GM.OCRP_Items["item_cinderblock"] = {
	Name = "concrete block",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used in crafting",-- The description
	Model = "models/props_junk/CinderBlock01a.mdl",-- The model
	Price = 100,--Price
	Weight = 0,
	Max = 3,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}

GM.OCRP_Items["item_explosives"] = {
	Name = "Explosives",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used in crafting",-- The description
	Model = "models/dav0r/tnt/tnt.mdl",-- The model
	Price = 440,--Price
	Weight = 2,
	Illegalizeable = true,
	Max = 3,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetHealth(10)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}
	
GM.OCRP_Items["item_gascan"] = {
	Name = "Gasoline",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used in crafting",-- The description
	Model = "models/props_junk/gascan001a.mdl",-- The model
	Price = 120,--Price
	Weight = 0,
	Max = 3,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	-- what it does don't touch it.
	Condition = function(ply,item)
		local tr = ply:GetEyeTrace()
		if tr.Entity:IsValid() then
			if SERVER then
				local MAX = GAMEMODE.OCRP_Cars[tr.Entity:GetCarType()].GasTank 
				if tr.Entity.Gas < MAX then
					return true
				else
					ply:Hint("The tank is full")
					return false
				end
			else
				return true
			end
		end
		if SERVER then
			ply:Hint("You can't pour this here, find a vehicle")
		end
		return false
	end,
	Function = function(ply,item)
		local tr = ply:GetEyeTrace()
		if tr.Entity:IsValid() then
			local MAX = GAMEMODE.OCRP_Cars[tr.Entity:GetCarType()].GasTank 
			if tr.Entity.Gas + 200 <= MAX then
				tr.Entity.Gas = tr.Entity.Gas + 200
			else
				tr.Entity.Gas = MAX
			end
			ply:EmitSound("ambient/water/water_spray1.wav",100,100)
			tr.Entity.GasCheck = CurTime()
		else 
			ply:Hint("The tank is full")
		end
		return false
	end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}	

GM.OCRP_Items["item_pipe"] = {
	Name = "metal Pipe",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used in crafting",-- The description
	Model = "models/props_lab/pipesystem03c.mdl",-- The model
	Price = 160,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}	

GM.OCRP_Items["item_oil"] = {
	Name = "Oil",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Used in crafting",-- The description
	Model = "models/props_junk/garbage_plasticbottle002a.mdl",-- The model
	Price = 40,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}	
	
GM.OCRP_Items["item_life_alert"] = {
	Name = "Life alert",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Calls for help!",-- The description
	Model = "models/props_lab/reciever01d.mdl",-- The model
	Protected = true,
	Price = 240,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	}	

--[[
GM.OCRP_Items["item_door_alarm"] = {
	Name = "Door alarm",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Alerts the police of a break-in!",-- The description
	Model = "models/props_c17/consolebox05a.mdl",-- The model
	Protected = true,
	Price = 1500,--Price
	Max = 1,-- Total Number of items able to be carried.
	Condition = function(ply,item) -- Checks to see if the player can use it.
				local pos = ply:EyePos()
				local posang = ply:GetAimVector()
				local tracedata = {}
				tracedata.start = pos
				tracedata.endpos = pos+(posang*80)
				tracedata.filter = ply
				local trace = util.TraceLine(tracedata)

				if trace.HitWorld then return false end
				if trace.HitNonWorld then
					if trace.Entity:IsDoor() && trace.Entity:GetNWInt("Owner") == ply:EntIndex() && !trace.Entity.DoorAlarm then
						return true
					end
				end
				return false
			end,
	Function = 
		function(ply,item) 
				local pos = ply:EyePos()
				local posang = ply:GetAimVector()
				local tracedata = {}
				tracedata.start = pos
				tracedata.endpos = pos+(posang*80)
				tracedata.filter = ply
				local trace = util.TraceLine(tracedata)

				if trace.HitWorld then return false end
				if trace.HitNonWorld then
					if trace.Entity:IsDoor() && trace.Entity:GetNWInt("Owner") == ply:EntIndex() && !trace.Entity.DoorAlarm then
						trace.Entity.DoorAlarm = true
					end
				end
		end,	
	}		]]--
GM.OCRP_Items["item_furnace"] = {
	Name = "Furnace",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Provides a heat source",-- The description
	Model = "models/props_c17/FurnitureFireplace001a.mdl",-- The model
	Protected = true,
	Price = 1500,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	}
	
GM.OCRP_Items["item_sink"] = {
	Name = "Sink",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Provides a water source",-- The description
	Model = "models/props_c17/FurnitureSink001a.mdl",-- The model
	Protected = true,
	Price = 1500,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	}	
GM.OCRP_Items["item_radio"] = {
	Name = "Radio",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Listen to music",-- The description
	Model = "models/props/cs_office/radio.mdl",-- The model
	Price = 20,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 6,Level = 3,},
	}	

---------------------------------------------------
---- Skills -----------------------------------
---------------------------------------------------
	
GM.OCRP_Items["item_skill_craft_basic"] = {
	Name = "Basic Crafting",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Craft by pressing f3",-- The description
	Model = "models/props_lab/bindergreen.mdl",-- The model
	Price = 1000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_craft_basic") && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_craft_basic")
				end,
	}		
	
GM.OCRP_Items["item_skill_craft_bal"] = {
	Name = "Ballistic Crafting",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Requires basic crafting",-- The description
	Model = "models/props_lab/binderredlabel.mdl",-- The model
	Price = 2500,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_craft_bal") && ply:HasSkill("skill_craft_basic") && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_craft_bal")
				end,
	}		
	
GM.OCRP_Items["item_skill_craft_mech"] = {
	Name = "Mechanical Crafting",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Requires basic crafting",-- The description
	Model = "models/props_lab/bindergraylabel01a.mdl",-- The model
	Price = 2000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_craft_mech") && ply:HasSkill("skill_craft_basic") && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_craft_mech")
				end,
	}
	
GM.OCRP_Items["item_skill_craft_circ"] = {
	Name = "Circuitry Crafting",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Requires basic crafting level 3",-- The description
	Model = "models/props_lab/bindergraylabel01b.mdl",-- The model
	Price = 1000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_craft_circ") && ply:HasSkill("skill_craft_basic",3) && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_craft_circ")
				end,
	}	

GM.OCRP_Items["item_skill_craft_weapon"] = {
	Name = "Weapon Crafting",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Requires basic crafting",-- The description
	Model = "models/props_lab/binderredlabel.mdl",-- The model
	Price = 3000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_craft_weapon") && ply:HasSkill("skill_craft_basic") && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_craft_weapon")
				end,
	}	
	
GM.OCRP_Items["item_skill_conc"] = {
	Name = "Concentration Training",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Concentrate harder",-- The description
	Model = "models/props_lab/binderbluelabel.mdl",-- The model
	Price = 1500,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_conc") &&  ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_conc")
				end,
	}
	
GM.OCRP_Items["item_skill_end"] = {
	Name = "Endurance Training",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Adrian!!!",-- The description
	Model = "models/props_lab/binderblue.mdl",-- The model
	Price = 1000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_end") && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_end")
				end,
	}

GM.OCRP_Items["item_skill_str"] = {
	Name = "Strength Training",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "You wouldn't like me when I'm angry",-- The description
	Model = "models/props_lab/binderredlabel.mdl",-- The model
	Price = 1000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_str") && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_str")
				end,
	}

GM.OCRP_Items["item_skill_picking"] = {
	Name = "Lockpicking",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "All of this is mine now",-- The description
	Model = "models/props_lab/binderredlabel.mdl",-- The model
	Price = 3000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_picking") && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_picking")
				end,
	}
	
GM.OCRP_Items["item_skill_herb"] = {
	Name = "Herbalism",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Dam this stuff is good!",-- The description
	Model = "models/props_lab/bindergreenlabel.mdl",-- The model
	Price = 1000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_herb") && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_herb")
				end,
	}	
	
GM.OCRP_Items["item_skill_reset"] = {
	Name = "Relaxation training",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Resets your skills",-- The description
	Model = "models/props_lab/bindergraylabel01a.mdl",-- The model
	Price = 5000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
	
					if SERVER then
						return true
					elseif CLIENT then
						local GUI_Search_Frame = vgui.Create("DFrame")
						GUI_Search_Frame:SetTitle("")
						GUI_Search_Frame:SetSize(260 ,70)
						GUI_Search_Frame:Center()
						GUI_Search_Frame.Paint = function()
													draw.RoundedBox(8,1,1,GUI_Search_Frame:GetWide()-2,GUI_Search_Frame:GetTall()-2,OCRP_Options.Color)
												end
						GUI_Search_Frame:MakePopup()
						GUI_Search_Frame:ShowCloseButton(false)

						local GUI_Ask  = vgui.Create("DLabel")
						GUI_Ask:SetParent(GUI_Search_Frame) 
						GUI_Ask:SetFont("UIBold")
						GUI_Ask:SetText("This book will reset your skills. Would you like to Reset?")
						GUI_Ask:SetPos(5,5)
						GUI_Ask:SetColor(Color(255,255,255,255))
						GUI_Ask:SetSize(250,25)
						GUI_Ask:SetWrap(true)
						
						local GUI_Ask_Search = vgui.Create("DButton")
						GUI_Ask_Search:SetParent(GUI_Search_Frame)	
						GUI_Ask_Search:SetSize(120,20)
						GUI_Ask_Search:SetPos(5,40)
						GUI_Ask_Search:SetText("Yes")
						GUI_Ask_Search.Paint = function() 
								draw.RoundedBox(8,0,0,GUI_Ask_Search:GetWide(),GUI_Ask_Search:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(8,1,1,GUI_Ask_Search:GetWide()-2,GUI_Ask_Search:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))	
												end
						GUI_Ask_Search.DoClick = function()
													RunConsoleCommand("OCRP_UseItem","item_skill_reset")
													GUI_Search_Frame:Remove()
													return true
												end
						
						local GUI_Ask_Exit = vgui.Create("DButton")
						GUI_Ask_Exit:SetParent(GUI_Search_Frame)	
						GUI_Ask_Exit:SetSize(120,20)
						GUI_Ask_Exit:SetPos(130,40)
						GUI_Ask_Exit:SetText("No")
						GUI_Ask_Exit.Paint = function() 
								draw.RoundedBox(8,0,0,GUI_Ask_Exit:GetWide(),GUI_Ask_Exit:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(8,1,1,GUI_Ask_Exit:GetWide()-2,GUI_Ask_Exit:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
								end
						GUI_Ask_Exit.DoClick = function()
													GUI_Search_Frame:Remove()
													return false
												end
				
					end
				end,
	Function = function(ply,item)
					ply:ResetSkills()
				end,
	}
		
GM.OCRP_Items["item_skill_acro"] = {
	Name = "Acrobatic Training",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Jump high in the sky!",-- The description
	Model = "models/props_lab/binderblue.mdl",-- The model
	Price = 750,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_acro") && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_acro")
				end,
	}	
	
GM.OCRP_Items["item_skill_pack"] = {
	Name = "Back-Pack Training",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Allows your character to carry more",-- The description
	Model = "models/props_lab/binderblue.mdl",-- The model
	Price = 1000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_pack") && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_pack")
				end,
	}
GM.OCRP_Items["item_skill_loot"] = {
	Name = "Looting",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Requires Robbery level 6",-- The description
	Model = "models/props_lab/bindergreen.mdl",-- The model
	Price = 2000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if ply:HasSkill("skill_rob",6) && !ply:HasSkill("skill_loot") && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_loot")
				end,
	}

GM.OCRP_Items["item_skill_rob"] = {
	Name = "Robbery",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Allows you to steal more mayor money",-- The description
	Model = "models/props_lab/binderredlabel.mdl",-- The model
	Price = 1000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_rob") && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_rob")
				end,
	}	

GM.OCRP_Items["item_skill_theft"] = {
	Name = "Theft",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Allows pickup shop goods without paying. If the owner isn't attending their shop.",-- The description
	Model = "models/props_lab/binderredlabel.mdl",-- The model
	Price = 1000,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	Condition = function(ply,item)
					if CLIENT then
						return true
					elseif SERVER then
						if !ply:HasSkill("skill_theft") && ply.OCRPData["Skills"].Points > 0 then
							return true
						end
					end
				end,
	Function = function(ply,item)
					ply:UpgradeSkill("skill_theft")
				end,
	}	
---------------------------------------------------
---- Containers -----------------------------------
---------------------------------------------------	
GM.OCRP_Items["item_container_small01"] = {
	Name = "Large Box",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Holds 10",-- The description
	Model = "models/props_junk/cardboard_box003a.mdl",-- The model
	Price = 15,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self.OCRPData = {}
				self.OCRPData["Inventory"] = {WeightData = {Cur = 0,Max = 10}}
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	PickUpFunction = 
				function(self,activator)
					if self.OCRPData != nil && self.OCRPData["Inventory"] != nil then
						for item,amount in pairs(self.OCRPData["Inventory"]) do
							if item != "WeightData" then
								activator:GiveItem(item,amount)
								local owner = player.GetByID(self:GetNWInt("Owner")) 
								if owner:IsValid() then
									owner:UnStoreItem(item,amount)
								end
							end
						end
					end
				end,	
	}
GM.OCRP_Items["item_container_small02"] = {
	Name = "Box",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Holds 8",-- The description
	Model = "models/props_junk/cardboard_box002a.mdl",-- The model
	Price = 10,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self.OCRPData = {}
				self.OCRPData["Inventory"] = {WeightData = {Cur = 0,Max = 8}}
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	PickUpFunction = 
				function(self,activator)
					if self.OCRPData != nil && self.OCRPData["Inventory"] != nil then
						for item,amount in pairs(self.OCRPData["Inventory"]) do
							if item != "WeightData" then
								activator:GiveItem(item,amount)
								local owner = player.GetByID(self:GetNWInt("Owner")) 
								if owner:IsValid() then
									owner:UnStoreItem(item,amount)
								end
							end
						end
					end
				end,
	}

GM.OCRP_Items["item_container_small03"] = {
	Name = "Small Box",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Holds 6",-- The description
	Model = "models/props_junk/cardboard_box002a.mdl",-- The model
	Price = 5,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self.OCRPData = {}
				self.OCRPData["Inventory"] = {WeightData = {Cur = 0,Max = 6}}
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	PickUpFunction = 
				function(self,activator)
					if self.OCRPData != nil && self.OCRPData["Inventory"] != nil then
						for item,amount in pairs(self.OCRPData["Inventory"]) do
							if item != "WeightData" then
								activator:GiveItem(item,amount)
								local owner = player.GetByID(self:GetNWInt("Owner")) 
								if owner:IsValid() then
									owner:UnStoreItem(item,amount)
								end
							end
						end
					end
				end,
	}	
	
GM.OCRP_Items["item_container_large01"] = {
	Name = "Crate",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Holds 20",-- The description
	Model = "models/props_junk/wood_crate001a.mdl",-- The model
	Price = 30,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self.OCRPData = {}
				self.OCRPData["Inventory"] = {WeightData = {Cur = 0,Max = 20}}
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	PickUpFunction = 
				function(self,activator)
					if self.OCRPData != nil && self.OCRPData["Inventory"] != nil then
						for item,amount in pairs(self.OCRPData["Inventory"]) do
							if item != "WeightData" then
								activator:GiveItem(item,amount)
								local owner = player.GetByID(self:GetNWInt("Owner")) 
								if owner:IsValid() then
									owner:UnStoreItem(item,amount)
								end
							end
						end
					end
				end,
	}		
GM.OCRP_Items["item_container_large02"] = {
	Name = "Large Crate",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Holds 40",-- The description
	Model = "models/props_junk/wood_crate002a.mdl",-- The model
	Price = 80,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			local phys = self:GetPhysicsObject()
			if SERVER then
				self.OCRPData = {}
				self.OCRPData["Inventory"] = {WeightData = {Cur = 0,Max = 40}}
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
				phys:SetMass( 350 )
				
			end
		end,
	PickUpFunction = 
				function(self,activator)
					if self.OCRPData != nil && self.OCRPData["Inventory"] != nil then
						for item,amount in pairs(self.OCRPData["Inventory"]) do
							if item != "WeightData" then
								activator:GiveItem(item,amount)
								local owner = player.GetByID(self:GetNWInt("Owner")) 
								if owner:IsValid() then
									owner:UnStoreItem(item,amount)
								end
							end
						end
					end
				end,
	}	
	
GM.OCRP_Items["item_safe01"] = {
	Name = "Safe",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Holds 10",-- The description
	Model = "models/Items/ammocrate_grenade.mdl",-- The model
	Price = 1000,--Price
	Weight = 10,
	Max = 1,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self.OCRPData = {}
				self.OCRPData["Inventory"] = {WeightData = {Cur = 0,Max = 10}}
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	PickUpFunction = 
				function(self,activator)
					if self.OCRPData != nil && self.OCRPData["Inventory"] != nil then
						for item,amount in pairs(self.OCRPData["Inventory"]) do
							if item != "WeightData" then
								activator:GiveItem(item,amount)
								local owner = player.GetByID(self:GetNWInt("Owner")) 
								if owner:IsValid() then
									owner:UnStoreItem(item,amount)
								end
							end
						end
					end
				end,
	}	

---------------------------------------------------
---- Furniture -----------------------------------
---------------------------------------------------	
GM.OCRP_Items["item_couch"] = {
	Name = "Couch",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Furniture",-- The description
	Model = "models/props_c17/FurnitureCouch001a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 4,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self.Seats = {}
			GAMEMODE.CreatePassengerSeat( self,Vector(0,-15,-9), Angle(self:GetAngles().p,-90,self:GetAngles().p)  )
			GAMEMODE.CreatePassengerSeat( self,Vector(0,15,-9), Angle(self:GetAngles().p,-90,self:GetAngles().p)  )
			end,
	PickUpFunction = 
				function(self)
					if self.Seats != nil then
						for _,v in pairs(self.Seats) do
							if v:IsValid() then
								v:Remove()
							end
						end	
					end
				end,
	}
	
GM.OCRP_Items["item_circtable"] = {
	Name = "Circular Table",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Furniture",-- The description
	Model = "models/props_c17/FurnitureTable001a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 4,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = function(self)
		self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
	end,
	}
	
GM.OCRP_Items["item_recttable"] = {
	Name = "Rectangle Table",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Furniture",-- The description
	Model = "models/props_c17/FurnitureTable002a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 4,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = function(self)
		self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
	end,
	}
	
GM.OCRP_Items["item_angledbarrier"] = {
	Name = "Angled Barrier",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Barrier",-- The description
	Model = "models/props_wasteland/barricade001a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 4,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = function(self)
		self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
	end,
	}
	
GM.OCRP_Items["item_longtable"] = {
	Name = "Long Table",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Furniture",-- The description
	Model = "models/props_wasteland/cafeteria_table001a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 4,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = function(self)
		self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
	end,
	}
	
GM.OCRP_Items["item_halffence"] = {
	Name = "Half Fence",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Fence",-- The description
	Model = "models/props_wasteland/wood_fence02a.mdl",-- The model
	Price = 80,--Price
	Weight = 0,
	Health = 200,
	Max = 4,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	Protected = true,
	-- what it does don't touch it.	
	}
	
GM.OCRP_Items["item_drawer"] = {
	Name = "Drawer",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Holds 3",-- The description
	Model = "models/props_c17/FurnitureDrawer001a.mdl",-- The model
	Price = 80,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self.OCRPData = {}
				self.OCRPData["Inventory"] = {WeightData = {Cur = 0,Max = 3}}
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	PickUpFunction = 
				function(self,activator)
					if self.OCRPData != nil && self.OCRPData["Inventory"] != nil then
						for item,amount in pairs(self.OCRPData["Inventory"]) do
							if item != "WeightData" then
								activator:GiveItem(item,amount)
								local owner = player.GetByID(self:GetNWInt("Owner")) 
								if owner:IsValid() then
									owner:UnStoreItem(item,amount)
								end
							end
						end
					end
				end,
	}	

	
GM.OCRP_Items["item_wardrobe"] = {
	Name = "Wardrobe",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Allows you to change clothes",-- The description
	Model = "models/props_c17/FurnitureDresser001a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
				self:SetAngles(self:GetAngles() * -1 )
			end
		end,
	}

GM.OCRP_Items["item_cashregister"] = {
	Name = "Cash Register",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Taxes items you sell, makes your shops legal.",-- The description
	Model = "models/props_c17/cashregister01a.mdl",-- The model
	Price = 300,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}

GM.OCRP_Items["item_gbean_seed"] = {
	Name = "Green Bean Seeds",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Use with a pot",-- The description
	Model = "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl",-- The model
	Price = 300,--Price
	Weight = 0,
	Material = "katharsmodels/contraband/ocrp_contraband_see",
	Max = 5,-- Total Number of items able to be carried.
	-- what it does don't touch it.
	Condition = function()
		return true
		end,
	Function = 
		function(ply,item) 
			local trace = ply:GetEyeTrace()

			if trace.HitWorld then
				if trace.MatType == MAT_DIRT then
					local coola = ents.Create("food_gbean")
					coola:SetPos(trace.HitPos)
					coola:SetAngles(Angle(0,0,0))
					coola:Spawn()
				end
			end
		end,
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end,
	LootData = {Speed = 10,Level = 1,},
	}	

GM.OCRP_Items["item_gbeans"] = {
	Name = "Green Beans",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Eat em.",-- The description
	Model = "models/props/cs_italy/it_mkt_container1a.mdl",-- The model
	Price = 300,--Price
	Weight = 4,
	Max = 3,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_desk"] = {
	Name = "Desk",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Sit at it.",-- The description
	Model = "models/props_combine/breendesk.mdl",-- The model
	Price = 200,--Price
	Weight = 0,
	Max = 3,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	

GM.OCRP_Items["item_chair01"] = {
	Name = "Chair",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Take a seat. Right over there.",-- The description
	Model = "models/props_c17/chair02a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self.Seats = {}
			GAMEMODE.CreatePassengerSeat( self,Vector(15,-5,-5), Angle(self:GetAngles().p,-90,self:GetAngles().p) ) 
			end,
	PickUpFunction = 
				function(self)
					if self.Seats != nil then
						for _,v in pairs(self.Seats) do
							if v:IsValid() then
								v:Remove()
							end
						end	
					end
				end,
	}


GM.OCRP_Items["item_chair02"] = {
	Name = "Chair",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Take a seat. Right over there.",-- The description
	Model = "models/props_combine/breenchair.mdl",-- The model
	Price = 750,--Price
	Weight = 0,
	Max = 1,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self.Seats = {}
			GAMEMODE.CreatePassengerSeat( self,Vector(2,0,8),  Angle(self:GetAngles().p,-90,self:GetAngles().p) )
			end,
	PickUpFunction = 
				function(self)
					if self.Seats != nil then
						for _,v in pairs(self.Seats) do
							if v:IsValid() then
								v:Remove()
							end
						end	
					end
				end,
	}	
	
GM.OCRP_Items["item_cell"] = {
	Name = "Cell Phone",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Allows you to use chat communication.",-- The description
	Model = "models/weapons/w_camphone.mdl",-- The model
	Price = 20,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	}
	
GM.OCRP_Items["item_policeradio"] = {
	Name = "Police Radio",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Allows you to use the radio.",-- The description
	Model = "models/props_lab/citizenradio.mdl",-- The model
	Price = 0,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	DoesntSave = true,
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			local ply = player.GetByID(self:GetNWInt("Owner"))
			ply:Hint("Radio destroyed")
			self:Remove()
			end,
}

--=======================================--
--=========== UPDATE ITEMS ==============--
--=======================================--

GM.OCRP_Items["item_lockers"] = {
	Name = "Lockers",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Stuff things in it.",-- The description
	Model = "models/props_c17/Lockers001a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self.OCRPData = {}
				self.OCRPData["Inventory"] = {WeightData = {Cur = 0,Max = 20}}
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	PickUpFunction = 
				function(self,activator)
					if self.OCRPData != nil && self.OCRPData["Inventory"] != nil then
						for item,amount in pairs(self.OCRPData["Inventory"]) do
							if item != "WeightData" then
								activator:GiveItem(item,amount)
								local owner = player.GetByID(self:GetNWInt("Owner")) 
								if owner:IsValid() then
									owner:UnStoreItem(item,amount)
								end
							end
						end
					end
				end,
	}
	
GM.OCRP_Items["item_oildrum"] = {
	Name = "Oil Drum",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "It's oil, in a drum.",-- The description
	Model = "models/props_c17/oildrum001.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_woodpole"] = {
	Name = "Wood Pole",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "It's pole, a dock pole.",-- The description
	Model = "models/props_docks/dock01_pole01a_128.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_trashcan"] = {
	Name = "Trashcan",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "It's a trashcan, put trash in it.",-- The description
	Model = "models/props_trainstation/trashcan_indoor001b.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}

GM.OCRP_Items["item_dockplank"] = {
	Name = "Dock Plank",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "It's a dock plank.",-- The description
	Model = "models/props_wasteland/dockplank01a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_plasticcrate"] = {
	Name = "Plastic Crate",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "It's a plastic crate.",-- The description
	Model = "models/props_junk/PlasticCrate01a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_floodlight"] = {
	Name = "Flood Light",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "It's a flood light.",-- The description
	Model = "models/props_c17/light_floodlight02_off.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_computer"] = {
	Name = "Computer (prop)",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "It's a non-usable computer.",-- The description
	Model = "models/props/cs_office/computer.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_exitsign"] = {
	Name = "Exit Sign",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "It's a exit sign.",-- The description
	Model = "models/props/cs_office/Exit_ceiling.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_displaycooler"] = {
	Name = "Display Shelf/Cooler",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Great for shops.",-- The description
	Model = "models/props_c17/display_Cooler01a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_woodenshelfs"] = {
	Name = "Wooden Shelfs",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Great for home use.",-- The description
	Model = "models/props_interiors/Furniture_shelf01a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}

GM.OCRP_Items["item_kitchenshelf"] = {
	Name = "Kitchen Shelfs",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Great for kitchen use.",-- The description
	Model = "models/props_wasteland/kitchen_shelf001a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_longdesk"] = {
	Name = "Long Desk",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Has many uses.",-- The description
	Model = "models/props_wasteland/controlroom_desk001a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_twoshelf"] = {
	Name = "Two Story Shelf",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Has many uses.",-- The description
	Model = "models/props_wasteland/prison_shelf002a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_bench"] = {
	Name = "Bench",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Has many uses.",-- The description
	Model = "models/props_trainstation/bench_indoor001a.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_sawhorse"] = {
	Name = "Saw Horse",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Has many uses.",-- The description
	Model = "models/props/CS_militia/sawhorse.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_shedtable"] = {
	Name = "Shed Table",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Has many uses.",-- The description
	Model = "models/props/CS_militia/table_shed.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_markettable1"] = {
	Name = "Market Table 1",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Commonly used in markets.",-- The description
	Model = "models/props/cs_italy/it_mkt_table1.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_markettable2"] = {
	Name = "Market Table 2",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Commonly used in markets.",-- The description
	Model = "models/props/cs_italy/it_mkt_table2.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}
	
GM.OCRP_Items["item_markettable3"] = {
	Name = "Market Table 3",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Commonly used in markets.",-- The description
	Model = "models/props/cs_italy/it_mkt_table3.mdl",-- The model
	Price = 500,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}

GM.OCRP_Items["item_vendingcart"] = {
	Name = "Vending Cart",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Commonly used in markets.",-- The description
	Model = "models/props/de_tides/Vending_cart.mdl",-- The model
	Price = 1000,--Price
	Weight = 0,
	Max = 2,-- Total Number of items able to be carried.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			if SERVER then
				self:SetPos(self:GetPos() + self:GetAngles():Forward() * 30 )
			end
		end,
	}

GM.OCRP_Items["item_cosmosfm_radio"] = {
	Name = "Radio (CosmosFM Exclusive)",-- The Name
	Angle = Angle(90,90,90),---- Allows for manual rotation on the display 
	Desc = "Listen to music",-- The description
	Model = "models/props/cs_office/radio.mdl",-- The model
	Price = 20,--Price
	Weight = 1,
	Max = 1,-- Total Number of items able to be carried.
	Spawnable = false, -- this determines if it spawns in the world. Spawns at feet.
	Protected = true,
	-- what it does don't touch it.
	SpawnFunction = 
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			self:SetColor( 255, 20, 30, 255 )
		end,
	}
	
GM.OCRP_Items["item_present_one"] = {
	Name = "Present",
	Angle = Angle(90,90,90),
	Desc = "For something special",
	Model = "models/effects/bday_gib01.mdl",
	Price = 500,
	Weight = 1,
	Max = 1,
	Spawnable = false,
	Protected = true,
	SpawnFunction =
		function(self)
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			self:SetSkin(math.random(1,2))
		end,
}
	




























