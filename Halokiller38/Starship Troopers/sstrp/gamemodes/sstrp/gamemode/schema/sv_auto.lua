--[[
Name: "sv_auto.lua".
Product: "Starship Troopers".
--]]

NEXUS:IncludePrefixed("sh_auto.lua");

resource.AddFile("sound/sstrp/intro.mp3");

-- Let's create a config option that defines a small description to new players.
nexus.config.Add("intro_text_small", "Do you wanna live forever?", true);

-- Let's create a config option that defines a big title to new players.
nexus.config.Add("intro_text_big", "Starship Troopers", true);

-- Disable the nexus introduction for new players.
nexus.config.Get("nexus_intro_enabled"):Set(false);

-- Default money.
nexus.config.Get("default_cash"):Set(1000);

-- Set the prop cost scale to 0.
nexus.config.Get("scale_prop_cost"):Set(0);

-- Disable players crosshar.
nexus.config.Get("enable_crosshair"):Set(false);

-- Disable sprays.
nexus.config.Get("disable_sprays"):Set(true);

-- The time that a player has to wait to speak out-of-character again (seconds) (set to 0 for never).
nexus.config.Get("ooc_interval"):Set(10);

-- The class changing wait time.
nexus.config.Get("change_class_interval"):Set(10);

-- Whether or not to enable headbob.
nexus.config.Get("enable_headbob"):Set(false);

-- Whether or not the recognise system is enabled.
nexus.config.Get("recognise_system"):Set(false);

--Called when a player's weapons should be given.
function SCHEMA:PlayerGiveWeapons(player)
	if (nexus.player.HasFlags(player, "h")) then
		player:Give("federation_hmg");
	end;
	
	if (nexus.player.HasFlags(player, "j")) then
		player:Give("federation_br2");
	end;
	
	if (nexus.player.HasFlags(player, "v")) then
		player:Give("federation_900k");
	end;
	
	if (nexus.player.HasFlags(player, "F")) then
		player:Give("weapon_frag");
		player:Give("weapon_frag");
		player:Give("weapon_frag");
	end;
	
	if (nexus.player.HasFlags(player, "M")) then
		player:Give("nx_healstick");
		player:Give("weapon_mad_medic");
	end;
	
	if (nexus.player.HasFlags(player, "R")) then
		player:SetHealth(200)
	end;
	
	if (nexus.player.HasFlags(player, "K")) then
		player:SetArmor(200)
	end;
	
	if (nexus.player.HasFlags(player, "T")) then
		player:Give("federation_kvk");
	end;
	
	if (nexus.player.HasFlags(player, "!")) then
		player:SetNWBool("officer", true);
	end;
	
	if (!nexus.player.HasFlags(player, "!")) then
		player:SetNWBool("officer", false);
	end;
end;

--A function to scale damage by hit group.
function SCHEMA:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	local endurance = nexus.attributes.Fraction(player, ATB_ENDURANCE, 0.75, 0.75);
	
	-- Scale the damage based on their endurance attribute.
	damageInfo:ScaleDamage(1.5 - endurance);
end;

