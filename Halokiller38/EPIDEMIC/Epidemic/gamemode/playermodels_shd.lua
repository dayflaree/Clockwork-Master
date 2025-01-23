PlayerModels = {
	{
		Models = 
		{
			-- Default
		},
		
		Inventories =
		{
			{ Name = "Backpack", ItemData = "backpack", x = -100, y = -120, CanDrop = true },
			{ Name = "Pouch", ItemData = "pouch", x = 100, y = -30, CanDrop = true },
			{ Name = "Left Pocket", Default = true, w = 2, h = 2, x = 70, y = 15 },
			{ Name = "Right Pocket", Default = true, w = 2, h = 2, x = -130, y = 15 },
		}
	
	},
	
	{
		Models = 
		{
			"models/hecu01/1.mdl",
			"models/hecu01/2.mdl",
			"models/hecu01/3.mdl",
			"models/hecu01/4.mdl",
		},
		
		Armor = 100,
		
		Inventories =
		{
		
			{ Name = "Backpack", ItemData = "backpack", x = -100, y = -120, CanDrop = true },
			{ Name = "Pouch", ItemData = "pouch", x = 100, y = -10, CanDrop = true },
			{ Name = "Left Pocket", Default = true, w = 2, h = 2, x = 70, y = 15 },
			{ Name = "Right Pocket", Default = true, w = 2, h = 2, x = -130, y = 15 },
			{ Name = "Right Coat Pocket", Default = true, w = 3, h = 3, x = -150, y = -20 },
			{ Name = "Satchel", Default = true, w = 3, h = 3, x = -100, y = 45 },
			{ Name = "Left Coat Pocket", Default = true, w = 3, h = 3, x = 70, y = -20 },
			{ Name = "Chest Pocket", Default = true, w = 3, h = 2, x = 70, y = -80 },
		}
	},
	
	{
		Models = 
		{
			"models/infected/necropolis/common/female_01.mdl",
			"models/infected/necropolis/common/female_02.mdl",
			"models/infected/necropolis/common/female_03.mdl",
			"models/infected/necropolis/common/female_04.mdl",
			"models/infected/necropolis/common/female_06.mdl",
			"models/infected/necropolis/common/female_07.mdl",
			"models/infected/necropolis/common/male_01.mdl",
			"models/infected/necropolis/common/male_02.mdl",
			"models/infected/necropolis/common/male_03.mdl",
			"models/infected/necropolis/common/male_04.mdl",
			"models/infected/necropolis/common/male_05.mdl",
			"models/infected/necropolis/common/male_06.mdl",
			"models/infected/necropolis/common/male_07.mdl",
			"models/infected/necropolis/common/male_08.mdl",
			"models/infected/necropolis/common/male_12.mdl",
			"models/infected/necropolis/common/male_13.mdl",
			"models/infected/necropolis/common/male_14.mdl",
			"models/infected/necropolis/common/male_15.mdl",
			"models/infected/necropolis/common/male_16.mdl",
			"models/infected/necropolis/common/male_17.mdl",
			"models/infected/necropolis/common/male_18.mdl",
			"models/infected/necropolis/common/male_19.mdl",
			"models/infected/necropolis/armorghoul.mdl",
			"models/infected/necropolis/bloodsucker1.mdl",
			"models/infected/necropolis/bloodsucker2.mdl",
			"models/infected/necropolis/boomer.mdl",
			"models/infected/necropolis/boomer2.mdl",
			"models/infected/necropolis/boomette.mdl",
			"models/infected/necropolis/charger.mdl",
			"models/infected/necropolis/cyclops.mdl",
			"models/infected/necropolis/failure.mdl",
			"models/infected/necropolis/fat.mdl",
			"models/infected/necropolis/femhunter1.mdl",
			"models/infected/necropolis/femhunter2.mdl",
			"models/infected/necropolis/feralghoul.mdl",
			"models/infected/necropolis/gigante.mdl",
			"models/infected/necropolis/hunter.mdl",
			"models/infected/necropolis/hunter2.mdl",
			"models/infected/necropolis/savage.mdl",
			"models/infected/necropolis/smoker.mdl",
			"models/infected/necropolis/smoker2.mdl",
			"models/infected/necropolis/smoker3.mdl",
			"models/infected/necropolis/smoker4.mdl",
			"models/infected/necropolis/snork.mdl",
			"models/infected/necropolis/spitter.mdl",
			"models/infected/necropolis/witch.mdl",
			
		},
		
		Health = 110,
		
		Inventories =
		{
		
		}
	},
}

for k, v in pairs( PlayerModels ) do

	for n, m in pairs( v.Models ) do
	
		PlayerModels[k].Models[n] = string.lower( PlayerModels[k].Models[n] );
	
	end

end