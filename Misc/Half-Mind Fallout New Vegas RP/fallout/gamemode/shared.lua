DeriveGamemode( "sandbox" );

GM.Name = "Half-Logic Fallout Roleplay";

GM.SlowZombies = false;

local meta = FindMetaTable( "Entity" )

team.SetUp( TEAM_SURVIVOR, "Survivors", Color( 200, 255, 255, 255 ) );

GM.InvalidModels = {
	"models/fallout/arms/mistergutsy_arm.mdl",
	"models/fallout/arms/supermutant_arm.mdl",
}

GM.SurvivorModels = { };
GM.SurvivorModels[MALE] = { };
GM.SurvivorModels[FEMALE] = { };

GM.SurvivorModels[MALE]["models/thespireroleplay/humans/group004/male.mdl"] = { "models/lazarusroleplay/heads/ghoul_default.mdl", "models/lazarusroleplay/heads/male_african.mdl", "models/lazarusroleplay/heads/male_asian.mdl", "models/lazarusroleplay/heads/male_caucasian.mdl", "models/lazarusroleplay/heads/male_hispanic.mdl" };
GM.SurvivorModels[MALE]["models/thespireroleplay/humans/group006/male.mdl"] = { "models/lazarusroleplay/heads/ghoul_default.mdl", "models/lazarusroleplay/heads/male_african.mdl", "models/lazarusroleplay/heads/male_asian.mdl", "models/lazarusroleplay/heads/male_caucasian.mdl", "models/lazarusroleplay/heads/male_hispanic.mdl" };
GM.SurvivorModels[MALE]["models/thespireroleplay/humans/group013/male.mdl"] = { "models/lazarusroleplay/heads/ghoul_default.mdl", "models/lazarusroleplay/heads/male_african.mdl", "models/lazarusroleplay/heads/male_asian.mdl", "models/lazarusroleplay/heads/male_caucasian.mdl", "models/lazarusroleplay/heads/male_hispanic.mdl" };
GM.SurvivorModels[MALE]["models/thespireroleplay/humans/group014/male.mdl"] = { "models/lazarusroleplay/heads/ghoul_default.mdl", "models/lazarusroleplay/heads/male_african.mdl", "models/lazarusroleplay/heads/male_asian.mdl", "models/lazarusroleplay/heads/male_caucasian.mdl", "models/lazarusroleplay/heads/male_hispanic.mdl" };
GM.SurvivorModels[MALE]["models/thespireroleplay/humans/group020/male.mdl"] = { "models/lazarusroleplay/heads/ghoul_default.mdl", "models/lazarusroleplay/heads/male_african.mdl", "models/lazarusroleplay/heads/male_asian.mdl", "models/lazarusroleplay/heads/male_caucasian.mdl", "models/lazarusroleplay/heads/male_hispanic.mdl" };
GM.SurvivorModels[MALE]["models/thespireroleplay/humans/group103/male.mdl"] = { "models/lazarusroleplay/heads/ghoul_default.mdl", "models/lazarusroleplay/heads/male_african.mdl", "models/lazarusroleplay/heads/male_asian.mdl", "models/lazarusroleplay/heads/male_caucasian.mdl", "models/lazarusroleplay/heads/male_hispanic.mdl" };
GM.SurvivorModels[MALE]["models/thespireroleplay/humans/group022/male.mdl"] = { "models/lazarusroleplay/heads/ghoul_default.mdl", "models/lazarusroleplay/heads/male_african.mdl", "models/lazarusroleplay/heads/male_asian.mdl", "models/lazarusroleplay/heads/male_caucasian.mdl", "models/lazarusroleplay/heads/male_hispanic.mdl" };

GM.SurvivorModels[FEMALE]["models/thespireroleplay/humans/group004/female.mdl"] = { "models/lazarusroleplay/heads/female_african.mdl", "models/lazarusroleplay/heads/female_asian.mdl", "models/lazarusroleplay/heads/female_caucasian.mdl", "models/lazarusroleplay/heads/female_hispanic.mdl" };
GM.SurvivorModels[FEMALE]["models/thespireroleplay/humans/group006/female.mdl"] = { "models/lazarusroleplay/heads/female_african.mdl", "models/lazarusroleplay/heads/female_asian.mdl", "models/lazarusroleplay/heads/female_caucasian.mdl", "models/lazarusroleplay/heads/female_hispanic.mdl" };
GM.SurvivorModels[FEMALE]["models/thespireroleplay/humans/group013/female.mdl"] = { "models/lazarusroleplay/heads/female_african.mdl", "models/lazarusroleplay/heads/female_asian.mdl", "models/lazarusroleplay/heads/female_caucasian.mdl", "models/lazarusroleplay/heads/female_hispanic.mdl" };
GM.SurvivorModels[FEMALE]["models/thespireroleplay/humans/group014/female.mdl"] = { "models/lazarusroleplay/heads/female_african.mdl", "models/lazarusroleplay/heads/female_asian.mdl", "models/lazarusroleplay/heads/female_caucasian.mdl", "models/lazarusroleplay/heads/female_hispanic.mdl" };
GM.SurvivorModels[FEMALE]["models/thespireroleplay/humans/group020/female.mdl"] = { "models/lazarusroleplay/heads/female_african.mdl", "models/lazarusroleplay/heads/female_asian.mdl", "models/lazarusroleplay/heads/female_caucasian.mdl", "models/lazarusroleplay/heads/female_hispanic.mdl" };
GM.SurvivorModels[FEMALE]["models/thespireroleplay/humans/group103/female.mdl"] = { "models/lazarusroleplay/heads/female_african.mdl", "models/lazarusroleplay/heads/female_asian.mdl", "models/lazarusroleplay/heads/female_caucasian.mdl", "models/lazarusroleplay/heads/female_hispanic.mdl" };
GM.SurvivorModels[FEMALE]["models/thespireroleplay/humans/group120/female.mdl"] = { "models/lazarusroleplay/heads/female_african.mdl", "models/lazarusroleplay/heads/female_asian.mdl", "models/lazarusroleplay/heads/female_caucasian.mdl", "models/lazarusroleplay/heads/female_hispanic.mdl" };

GM.SurvivorFacemaps = { };
GM.SurvivorFacemaps[MALE] = { };
GM.SurvivorFacemaps[FEMALE] = { };

GM.SurvivorFacemaps[MALE]["models/lazarusroleplay/heads/ghoul_default.mdl"] = { 
	"models/lazarusroleplay/humans/shared/skin/ghoul/ghoul_facemap",
	"models/lazarusroleplay/humans/shared/skin/ghoul/ghoul_facemap2",
	"models/lazarusroleplay/humans/shared/skin/ghoul/ghoul_facemap3",
	"models/lazarusroleplay/humans/shared/skin/ghoul/ghoul_facemap4",
	"models/lazarusroleplay/humans/shared/skin/ghoul/ghoul_facemap5"
}
GM.SurvivorFacemaps[MALE]["models/lazarusroleplay/heads/male_african.mdl"] = { 
	"models/lazarus/male/african_facemap",
	"models/lazarus/male/african_facemap_30",
	"models/lazarus/male/african_facemap_40",
	"models/lazarus/male/african_facemap_50",
	"models/lazarus/male/african_facemap_benny",
	"models/lazarus/male/african_facemap_boone",
	"models/lazarus/male/african_facemap_caesar",
	"models/lazarus/male/african_facemap_lanius",
	"models/lazarus/male/african_facemap_lobotomite",
	"models/lazarus/male/african_facemap_old",
	"models/lazarus/male/african_facemap_raider1",
	"models/lazarus/male/african_facemap_raider2",
	"models/lazarus/male/african_facemap_raider3",
	"models/lazarus/male/african_facemap_raider4",
	"models/lazarus/male/african_facemap_rangerandy",
	"models/lazarus/male/african_facemap_rugged"
}
GM.SurvivorFacemaps[MALE]["models/lazarusroleplay/heads/male_asian.mdl"] = {
	"models/lazarus/male/asian_facemap",
	"models/lazarus/male/asian_facemap_30",
	"models/lazarus/male/asian_facemap_40",
	"models/lazarus/male/asian_facemap_50",
	"models/lazarus/male/asian_facemap_benny",
	"models/lazarus/male/asian_facemap_boone",
	"models/lazarus/male/asian_facemap_caesar",
	"models/lazarus/male/asian_facemap_lanius",
	"models/lazarus/male/asian_facemap_lobotomite",
	"models/lazarus/male/asian_facemap_old",
	"models/lazarus/male/asian_facemap_raider1",
	"models/lazarus/male/asian_facemap_raider2",
	"models/lazarus/male/asian_facemap_raider3",
	"models/lazarus/male/asian_facemap_raider4",
	"models/lazarus/male/asian_facemap_rangerandy",
	"models/lazarus/male/asian_facemap_rugged"
}
GM.SurvivorFacemaps[MALE]["models/lazarusroleplay/heads/male_caucasian.mdl"] = { 
	"models/lazarus/male/caucasian_facemap", 
	"models/lazarus/male/caucasian_facemap_30",
	"models/lazarus/male/caucasian_facemap_40", 
	"models/lazarus/male/caucasian_facemap_50", 
	"models/lazarus/male/caucasian_facemap_benny",
	"models/lazarus/male/caucasian_facemap_boone",
	"models/lazarus/male/caucasian_facemap_caesar",
	"models/lazarus/male/caucasian_facemap_lanius",
	"models/lazarus/male/caucasian_facemap_lobotomite",
	"models/lazarus/male/caucasian_facemap_old",
	"models/lazarus/male/caucasian_facemap_raider1",
	"models/lazarus/male/caucasian_facemap_raider2",
	"models/lazarus/male/caucasian_facemap_raider3",
	"models/lazarus/male/caucasian_facemap_raider4",
	"models/lazarus/male/caucasian_facemap_rangerandy",
	"models/lazarus/male/caucasian_facemap_rugged"
}
GM.SurvivorFacemaps[MALE]["models/lazarusroleplay/heads/male_hispanic.mdl"] = { 
	"models/lazarus/male/hispanic_facemap",
	"models/lazarus/male/hispanic_facemap_30",
	"models/lazarus/male/hispanic_facemap_40",
	"models/lazarus/male/hispanic_facemap_50",
	"models/lazarus/male/hispanic_facemap_benny",
	"models/lazarus/male/hispanic_facemap_boone",
	"models/lazarus/male/hispanic_facemap_caesar",
	"models/lazarus/male/hispanic_facemap_lanius",
	"models/lazarus/male/hispanic_facemap_lobotomite",
	"models/lazarus/male/hispanic_facemap_old",
	"models/lazarus/male/hispanic_facemap_raider1",
	"models/lazarus/male/hispanic_facemap_raider2",
	"models/lazarus/male/hispanic_facemap_raider3",
	"models/lazarus/male/hispanic_facemap_raider4",
	"models/lazarus/male/hispanic_facemap_rangerandy",
	"models/lazarus/male/hispanic_facemap_rugged"
}

GM.SurvivorFacemaps[FEMALE]["models/lazarusroleplay/heads/female_african.mdl"] = { 
	"models/lazarus/female/african_facemap",
	"models/lazarus/female/african_facemap_30",
	"models/lazarus/female/african_facemap_40",
	"models/lazarus/female/african_facemap_50",
	"models/lazarus/female/african_facemap_legateslave",
	"models/lazarus/female/african_facemap_raider1",
	"models/lazarus/female/african_facemap_raider2",
	"models/lazarus/female/african_facemap_raider3",
	"models/lazarus/female/african_facemap_raider4",
	"models/lazarus/female/african_facemap_siri",
	"models/lazarus/female/african_facemap_slave1",
	"models/lazarus/female/african_facemap_slave2",
};
GM.SurvivorFacemaps[FEMALE]["models/lazarusroleplay/heads/female_asian.mdl"] = { 
	"models/lazarus/female/asian_facemap",
	"models/lazarus/female/asian_facemap_30",
	"models/lazarus/female/asian_facemap_40",
	"models/lazarus/female/asian_facemap_50",
	"models/lazarus/female/asian_facemap_legateslave",
	"models/lazarus/female/asian_facemap_raider1",
	"models/lazarus/female/asian_facemap_raider2",
	"models/lazarus/female/asian_facemap_raider3",
	"models/lazarus/female/asian_facemap_raider4",
	"models/lazarus/female/asian_facemap_siri",
	"models/lazarus/female/asian_facemap_slave1",
	"models/lazarus/female/asian_facemap_slave2",
}
GM.SurvivorFacemaps[FEMALE]["models/lazarusroleplay/heads/female_caucasian.mdl"] = {
	"models/lazarus/female/caucasian_facemap",
	"models/lazarus/female/caucasian_facemap_30",
	"models/lazarus/female/caucasian_facemap_40",
	"models/lazarus/female/caucasian_facemap_50",
	"models/lazarus/female/caucasian_facemap_legateslave",
	"models/lazarus/female/caucasian_facemap_raider1",
	"models/lazarus/female/caucasian_facemap_raider2",
	"models/lazarus/female/caucasian_facemap_raider3",
	"models/lazarus/female/caucasian_facemap_raider4",
	"models/lazarus/female/caucasian_facemap_siri",
	"models/lazarus/female/caucasian_facemap_slave1",
	"models/lazarus/female/caucasian_facemap_slave2",
}
GM.SurvivorFacemaps[FEMALE]["models/lazarusroleplay/heads/female_hispanic.mdl"] = {
 	"models/lazarus/female/hispanic_facemap",
	"models/lazarus/female/hispanic_facemap_30",
	"models/lazarus/female/hispanic_facemap_40",
	"models/lazarus/female/hispanic_facemap_50",
	"models/lazarus/female/hispanic_facemap_legateslave",
	"models/lazarus/female/hispanic_facemap_raider1",
	"models/lazarus/female/hispanic_facemap_raider2",
	"models/lazarus/female/hispanic_facemap_raider3",
	"models/lazarus/female/hispanic_facemap_raider4",
	"models/lazarus/female/hispanic_facemap_siri",
	"models/lazarus/female/hispanic_facemap_slave1",
	"models/lazarus/female/hispanic_facemap_slave2",
}

GM.SurvivorHair = { };
GM.SurvivorHair[MALE] = {
	"",
	"models/lazarusroleplay/heads/male_hair/hair01.mdl",
	"models/lazarusroleplay/heads/male_hair/hair02.mdl",
	"models/lazarusroleplay/heads/male_hair/hair03.mdl",
	"models/lazarusroleplay/heads/male_hair/hair04.mdl",
	"models/lazarusroleplay/heads/male_hair/hair05.mdl",
	"models/lazarusroleplay/heads/male_hair/hair06.mdl",
	"models/lazarusroleplay/heads/male_hair/hair07.mdl",
	"models/lazarusroleplay/heads/male_hair/hair08.mdl",
	"models/lazarusroleplay/heads/male_hair/hair09.mdl",
	"models/lazarusroleplay/heads/male_hair/hair10.mdl",
	"models/lazarusroleplay/heads/male_hair/hair11.mdl",
	"models/lazarusroleplay/heads/male_hair/hair12.mdl",
	"models/lazarusroleplay/heads/male_hair/hair13.mdl",
	"models/lazarusroleplay/heads/male_hair/hair14.mdl",
	"models/lazarusroleplay/heads/male_hair/hair15.mdl",
	"models/lazarusroleplay/heads/male_hair/hair16.mdl",
	"models/lazarusroleplay/heads/male_hair/hair17.mdl",
	"models/lazarusroleplay/heads/male_hair/hair18.mdl",
	"models/lazarusroleplay/heads/male_hair/hair19.mdl",
	"models/lazarusroleplay/heads/male_hair/hair20.mdl",
};
GM.SurvivorHair.FacialHair = {
	"",
	"models/lazarusroleplay/heads/male_hair/facial_hair01.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair02.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair03.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair04.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair05.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair06.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair07.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair08.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair09.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair10.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair11.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair12.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair13.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair14.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair15.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair16.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair17.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair18.mdl",
	"models/lazarusroleplay/heads/male_hair/facial_hair19.mdl",
};
GM.SurvivorHair[FEMALE] = {
	"",
	"models/lazarusroleplay/heads/female_hair/hair01.mdl",
	"models/lazarusroleplay/heads/female_hair/hair02.mdl",
	"models/lazarusroleplay/heads/female_hair/hair04.mdl",
	"models/lazarusroleplay/heads/female_hair/hair05.mdl",
	"models/lazarusroleplay/heads/female_hair/hair06.mdl",
	"models/lazarusroleplay/heads/female_hair/hair07.mdl",
	"models/lazarusroleplay/heads/female_hair/hair08.mdl",
	"models/lazarusroleplay/heads/female_hair/hair09.mdl",
	"models/lazarusroleplay/heads/female_hair/hair10.mdl",
	"models/lazarusroleplay/heads/female_hair/hair11.mdl",
	"models/lazarusroleplay/heads/female_hair/hair12.mdl",
	"models/lazarusroleplay/heads/female_hair/hair13.mdl",
	"models/lazarusroleplay/heads/female_hair/hair14.mdl",
	"models/lazarusroleplay/heads/female_hair/hair15.mdl",
	"models/lazarusroleplay/heads/female_hair/hair16.mdl",
	"models/lazarusroleplay/heads/female_hair/hair17.mdl",
	"models/lazarusroleplay/heads/female_hair/hair18.mdl",
	"models/lazarusroleplay/heads/female_hair/hair19.mdl",
	"models/lazarusroleplay/heads/female_hair/hair20.mdl",
	"models/lazarusroleplay/heads/female_hair/hair21.mdl",
	"models/lazarusroleplay/heads/female_hair/hair22.mdl",
	"models/lazarusroleplay/heads/female_hair/hair23.mdl",
	"models/lazarusroleplay/heads/female_hair/hair24.mdl",
	"models/lazarusroleplay/heads/female_hair/hair25.mdl",
	"models/lazarusroleplay/heads/female_hair/hair26.mdl",
	"models/lazarusroleplay/heads/female_hair/hair27.mdl",
	"models/lazarusroleplay/heads/female_hair/hair28.mdl",
	"models/lazarusroleplay/heads/female_hair/hair29.mdl",
};

GM.Eyemaps = { 
	"models/lazarus/shared/eye_blue",
	"models/lazarus/shared/eye_brown",
	"models/lazarus/shared/eye_default2",
	"models/lazarus/shared/eye_dichromatic",
	"models/lazarus/shared/eye_diseased",
	"models/lazarus/shared/eyecoloured1",
	"models/lazarus/shared/eyecoloured2",
	"models/lazarus/shared/eyecoloured3",
	"models/lazarus/shared/eyecoloured3_coloured_2",
	"models/lazarus/shared/eyecoloured4",
	"models/lazarus/shared/eyedarkblue",
	"models/lazarus/shared/eyedarkbrown",
	"models/lazarus/shared/eyedarkbrown2",
	"models/lazarus/shared/eyedarkbrown2_coloured3",
	"models/lazarus/shared/eyedefault",
	"models/lazarus/shared/eyedefault2",
	"models/lazarus/shared/eyegold",
	"models/lazarus/shared/eyegold_coloured3",
	"models/lazarus/shared/eyeGoldgreen",
	"models/lazarus/shared/eyegreen",
	"models/lazarus/shared/eyegreen2",
	"models/lazarus/shared/eyepalegrey",
	"models/lazarus/shared/eyepalegrey2",
	"models/lazarus/shared/eyeraider",
	"models/lazarus/shared/eyeraider2",
	"models/lazarus/shared/eyeVibrantBlue",
};

GM.SupermutantModels = {
	"models/fallout/supermutant.mdl",
	"models/fallout/supermutant_heavy.mdl",
	"models/fallout/supermutant_light.mdl",
	"models/fallout/supermutant_medium.mdl",
	"models/fallout/supermutant_nightkin.mdl",
};

if( CLIENT ) then -- Precache the materials

	for k, v in pairs( GM.SurvivorModels[MALE] ) do
		
		util.PrecacheModel( k )
		for _,n in pairs(v) do
			util.PrecacheModel( n )
		end
		
	end

	for k, v in pairs( GM.SurvivorModels[FEMALE] ) do
		
		util.PrecacheModel( k )
		for _,n in pairs(v) do
			util.PrecacheModel( n )
		end
		
	end
	
	for k, v in pairs( GM.SurvivorHair[MALE] ) do
		
		util.PrecacheModel( v )
		
	end
	
	for k, v in pairs( GM.SurvivorHair[FEMALE] ) do
		
		util.PrecacheModel( v )
		
	end
	
	for k, v in pairs( GM.SurvivorFacemaps[MALE] ) do
		
		for _, n in pairs( v ) do
			
			surface.SetMaterial( Material( n ) );
			
		end
		
	end

	for k, v in pairs( GM.SurvivorFacemaps[FEMALE] ) do
		
		for _, n in pairs( v ) do
			
			surface.SetMaterial( Material( n ) );
			
		end
		
	end
	
end

function meta:GetClothesSheet()
	
	if( string.find( string.lower( self:GetModel() ), "/player/" ) ) then
		
		local tab = self:GetMaterials();
		
		for k, v in pairs( tab ) do
			
			if( string.find( v, "players_sheet" ) ) then return k - 1 end
			
		end
		
		return -1;
		
	end
	
	return -1;
	
end

function meta:GetFacemap()
	
	if( string.find( string.lower( self:GetModel() ), "/heads/" ) ) then
		
		local tab = self:GetMaterials();
		
		for k, v in pairs( tab ) do
			
			if( string.find( v, "facemap" ) ) then return k - 1 end
			//if( string.find( v, "cylmap" ) ) then return k - 1 end
			
		end
		
		return -1;
		
	end
	
	return -1;
	
end

function meta:GetEyemap()

	if( string.find( string.lower( self:GetModel() ), "/heads/" ) ) then
		
		local tab = self:GetMaterials();
		local ret = {};
		
		for k, v in pairs( tab ) do
			
			if( string.find( v, "eye" ) and !string.find( v, "eyeball" ) ) then -- since there are two eyes, we need both when setting submat.

				ret[#ret + 1] = k - 1;

			end
			
		end

		return ret;
		
	end
	
	return {};

end

function meta:ResetSubMaterials()
	
	local tab = self:GetMaterials();
	
	for k, v in pairs( tab ) do
		
		self:SetSubMaterial( k - 1, "" );
		
	end
	
end

function GM:GetClothingByModel( model )

	for class,item in pairs( GAMEMODE.MetaItems ) do
	
		if( item.Clothing ) then

			if( string.find( model, item.PlayerModel:lower() ) ) then

				return item.Class;
			
			end
		
		end
	
	end

end

function GM:GetUnderwear( sex )

	if( sex == MALE ) then
	
		return "models/thespireroleplay/humans/group100/male.mdl";
		
	elseif( sex == FEMALE ) then
	
		return "models/thespireroleplay/humans/group100/female.mdl";
		
	end
	
end

function GM:GetModelArms( clothes, face, facemap ) // very ghetto, supreme ghetto

	if (!clothes) then return end;
	if (!face) then return end;

	local mdlGender;
	local mdlRace;
	local clothStrTbl = string.Explode("/", string.StripExtension(clothes));
	for k,v in pairs(clothStrTbl) do
	
		if (k == #clothStrTbl) then
		
			mdlGender = v;
			
			clothStrTbl[k] = nil;
			
		end
		
	end
	
	local faceStrTbl = string.Explode("/", string.StripExtension(face));
	for k,v in pairs(faceStrTbl) do

		if (k == #faceStrTbl) then

			if (v != "ghoul_default") then
			
				mdlRace = string.Explode("_", v)[2];

			else
			
				mdlGender = "ghoul";

			end
			
		end
		
	end

	if (mdlRace) then

		if (mdlRace == "caucasian") then
		
			retRace = 0;
			
		elseif (mdlRace == "african") then
		
			retRace = 2;
			
		elseif (mdlRace == "asian") then
		
			retRace = 6;
			
		elseif (mdlRace == "hispanic") then
		
			retRace = 4;
			
		end
		
	elseif( mdlGender == "ghoul" ) then

		if( facemap == "models/lazarusroleplay/humans/shared/skin/ghoul/ghoul_facemap" ) then
		
			retRace = 0;
	
		elseif( facemap == "models/lazarusroleplay/humans/shared/skin/ghoul/ghoul_facemap2" ) then
		
			retRace = 1;
		
		elseif( facemap == "models/lazarusroleplay/humans/shared/skin/ghoul/ghoul_facemap3" ) then
		
			retRace = 2;
		
		elseif( facemap == "models/lazarusroleplay/humans/shared/skin/ghoul/ghoul_facemap4" ) then
		
			retRace = 3;
		
		elseif( facemap == "models/lazarusroleplay/humans/shared/skin/ghoul/ghoul_facemap5" ) then
		
			retRace = 4;
		
		end
		
	end
	
	return Format("%s/%s/%s_%s", string.Implode("/", clothStrTbl), "arms", mdlGender, "arm.mdl"), retRace;
	
end

function GM:GetModelGender( model, gender )

	if( !model ) then return end;
	if( !gender ) then return end;
	
	if( gender == MALE ) then
	
		return Format( "%s/male.mdl", model );
		
	elseif( gender == FEMALE ) then
	
		return Format( "%s/female.mdl", model );
		
	end

end

function GM:GetHeadgearGender( model, gender, suffix )

	if( !model ) then return end;
	if( !gender ) then return end;
	
	local prefix, inputMdl;
	
	if( gender == MALE ) then
	
		prefix = "m";

	elseif( gender == FEMALE ) then
	
		prefix = "f";
	
	end
	
	local mdlStr = string.Explode( "/", string.StripExtension( model ) );
	for k,v in pairs( mdlStr ) do
	
		if ( k == #mdlStr ) then
			
			inputMdl = v;
			mdlStr[k] = nil;
			
		end
		
	end
	
	if( suffix ) then -- the ncr hats use a suffix, not a prefix.
	
		return Format("%s/%s_%s.mdl", string.Implode( "/", mdlStr ), inputMdl, prefix);
		
	end
	
	return Format("%s/%s_%s.mdl", string.Implode( "/", mdlStr ), prefix, inputMdl);
	
end

GM.MinNameLength = 5;
GM.MaxNameLength = 40;
GM.MaxDescLength = 500;

GM.MaxChars = 8;

GM.PrettyMobNames = {
	["npc_gecko"] = "Gecko",
	["npc_gecko_green"] = "Green Gecko",
	["npc_gecko_golden"] = "Golden Gecko",
	["npc_giantrat"] = "Giant Rat",
	["npc_mantis"] = "Mantis",
	["npc_mantis_nymph"] = "Mantis Nymph"
}

function GM:GetPrettyName(class)

	return self.PrettyMobNames[class] or "N/A";
	
end

if ( SERVER ) then

	function GM:GetFactionSpawnPos( class )
		
		return GAMEMODE.FactionSpawns[class] or Vector(0,0,0);
		
	end
	
	function GM:LoadFactionSpawns()
		
		local posTbl = util.JSONToTable( file.Read( "infected/spawns.txt", "DATA" ) );
		GAMEMODE.FactionSpawns = posTbl or {};
	
	end
	
	function GM:SaveFactionSpawns()
	
		file.Write( "infected/spawns.txt", util.TableToJSON( GAMEMODE.FactionSpawns ) );
		self:Log( "spawns", "SAVE", "Saved " .. tostring(#GAMEMODE.FactionSpawns) .. " spawn(s) to file." );
	
	end
	
end

function GM:CheckValidCharacter( ply, class, name, desc, model, sex, face, facemap, hair, facialhair )
	
	if( class == PLAYERCLASS_SUPERMUTANT and !string.find( ply:CharCreateFlags(), "m" ) ) then
		
		return false, "You don't have permissions to make this type of character.";
		
	end
	
	if( class == PLAYERCLASS_ANIMAL and !string.find( ply:CharCreateFlags(), "i" ) ) then
		
		return false, "You don't have permissions to make this type of character.";
		
	end
	
	if( string.len( name ) < self.MinNameLength ) then
		
		return false, "Name is too short.";
		
	end
	
	if( string.len( name ) > self.MaxNameLength ) then
		
		return false, "Name is too long.";
		
	end
	
	if( string.len( desc ) > self.MaxDescLength ) then
		
		return false, "Description is too long.";
		
	end
	
	if( class == PLAYERCLASS_SURVIVOR ) then
		
		local good = false;
		
		for k, v in pairs( self.SurvivorModels[MALE] ) do
			
			if( k == model ) then
				
				good = true;
				
			end
			
		end
		
		for k, v in pairs( self.SurvivorModels[FEMALE] ) do
			
			if( k == model ) then
				
				good = true;
				
			end
			
		end
		
		if( !good ) then
			
			return false, "Invalid model.";
			
		end
		
		if( self.SurvivorModels[MALE][model] ) then
			
			if( !table.HasValue( self.SurvivorModels[MALE][model], face ) ) then
				
				return false, "Invalid face.";
				
			end
			
		end
		
		if( self.SurvivorModels[FEMALE][model] ) then
			
			if( !table.HasValue( self.SurvivorModels[FEMALE][model], face ) ) then
				
				return false, "Invalid face.";
				
			end
			
		end
		
		if( sex == MALE ) then
		
			if( !table.HasValue( self.SurvivorHair[MALE], hair ) ) then
			
				return false, "Invalid hair.";
				
			end
			
			if( !table.HasValue( self.SurvivorFacemaps[MALE][face], facemap ) ) then
		
				return false, "Invalid facemap.";
			
			end
			
		elseif( sex == FEMALE ) then
		
			if( !table.HasValue( self.SurvivorHair[FEMALE], hair ) ) then
				
				return false, "Invalid hair.";
				
			end
		
			if( !table.HasValue( self.SurvivorFacemaps[FEMALE][face], facemap ) ) then
			
				return false, "Invalid facemap.";
			
			end
		
		end
		
	elseif( class == PLAYERCLASS_SUPERMUTANT ) then
		
		local good = false;
		
		for k, v in pairs( self.SupermutantModels ) do
			
			if( v == model ) then
				
				good = true;
				
			end
			
		end
		
		if( !good ) then
			
			return false, "Invalid model.";
			
		end

	elseif( class == PLAYERCLASS_ANIMAL ) then
		
		local good = false;
		
		for k, v in pairs( self.SpecialInfectedModels ) do
			
			if( v == model ) then
				
				good = true;
				
			end
			
		end
		
		if( !good ) then
			
			return false, "Invalid model.";
			
		end
		
		if( face != "" ) then
			
			return false, "Invalid face.";
			
		end
		
		if( clothes != "" ) then
			
			return false, "Invalid clothes.";
			
		end
		
	end
	
	return true;
	
end

function GM:CanSeePos( pos1, pos2, filter )
	
	local trace = { };
	trace.start = pos1;
	trace.endpos = pos2;
	trace.filter = filter;
	trace.mask = MASK_SOLID + CONTENTS_WINDOW + CONTENTS_GRATE;
	local tr = util.TraceLine( trace );
	
	if( tr.Fraction == 1.0 ) then
		
		return true;
		
	end
	
	return false;
	
end

function GM:ShouldCollide( e1, e2 )
	
	if( e1:GetClass() == "inf_zombie" and e2:GetClass() == "inf_zombie" ) then
		
		return false;
		
	end
	
	return true;
	
end

function meta:CanSeePlayer( ply )
	
	return GAMEMODE:CanSeePos( self:EyePos(), ply:EyePos(), { self, ply } );
	
end

function meta:GetHandTrace( len )
	
	local trace = { };
	trace.start = self:GetShootPos();
	trace.endpos = trace.start + self:GetAimVector() * ( len or 60 );
	trace.filter = self;
	local tr = util.TraceLine( trace );
	
	return tr;
	
end

function GM:IsSpotClear( pos )
	
	local trace = { };
	trace.start = pos + Vector( 0, 0, 4 );
	trace.endpos = pos + Vector( 0, 0, 72 );
	trace.filter = { };
	trace.mins = Vector( -32, -32, 0 );
	trace.maxs = Vector( 32, 32, 1 );
	local tr = util.TraceHull( trace );
	
	if( !tr.Hit ) then
		
		return true;
		
	end
	
	return false;
	
end

function GM:CanPlayerSeeZombieAt( pos )
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:IsTargetable() ) then
			
			local d = v:GetPos():Distance( pos );
			
			if( d < 1000 ) then return true end 
			if( v:VisibleVec( pos ) ) then return true end 
			
			local dir = ( pos * v:EyePos() ):GetNormal();
			
			if( dir:Dot( v:GetAimVector() ) > 0.7071 and d < 2500 ) then
				
				return true;
				
			end
			
		end
		
	end
	
	return false;
	
end

function GM:CanPlayerSeeItemAt( pos )
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:IsTargetable() ) then
			
			local d = v:GetPos():Distance( pos );
			
			if( d < 500 ) then return true end 
			if( v:VisibleVec( pos ) ) then return true end 
			
			local dir = ( pos * v:EyePos() ):GetNormal();
			
			if( dir:Dot( v:GetAimVector() ) > 0.7071 and d < 2500 ) then
				
				return true;
				
			end
			
		end
		
	end
	
	return false;
	
end

function GM:FormatLine( str, font, size )
	
	if( string.len( str ) == 1 ) then return str, 0 end
	
	local start = 1;
	local c = 1;
	
	surface.SetFont( font );
	
	local endstr = "";
	local n = 0;
	local lastspace = 0;
	local lastspacemade = 0;
	
	while( string.len( str or "" ) > c ) do
	
		local sub = string.sub( str, start, c );
	
		if( string.sub( str, c, c ) == " " ) then
			lastspace = c;
		end
		
		if( surface.GetTextSize( sub ) >= size and lastspace ~= lastspacemade ) then
			
			local sub2;
			
			if( lastspace == 0 ) then
				lastspace = c;
				lastspacemade = c;
			end
			
			if( lastspace > 1 ) then
				sub2 = string.sub( str, start, lastspace - 1 );
				c = lastspace;
			else
				sub2 = string.sub( str, start, c );
			end
			
			endstr = endstr .. sub2 .. "\n";
			
			lastspace = c + 1;
			lastspacemade = lastspace;
			
			start = c + 1;
			n = n + 1;
		
		end
	
		c = c + 1;
	
	end
	
	if( start < string.len( str or "" ) ) then
	
		endstr = endstr .. string.sub( str or "", start );
	
	end
	
	return endstr, n;

end

function GM:GetTraceDecal( tr )
	
	if( tr.MatType == MAT_ALIENFLESH ) then return "Impact.AlientFlesh" end
	if( tr.MatType == MAT_ANTLION ) then return "Impact.Antlion" end
	if( tr.MatType == MAT_CONCRETE ) then return "Impact.Concrete" end
	if( tr.MatType == MAT_METAL ) then return "Impact.Metal" end
	if( tr.MatType == MAT_WOOD ) then return "Impact.Wood" end
	if( tr.MatType == MAT_GLASS ) then return "Impact.Glass" end
	if( tr.MatType == MAT_FLESH ) then return "Impact.Flesh" end
	if( tr.MatType == MAT_BLOODYFLESH ) then return "Impact.BloodyFlesh" end
	
	return "Impact.Concrete";
	
end

function meta:IsDoor()
	
	if( self:GetClass() == "prop_door_rotating" ) then return true end
	return false
	
end

function meta:GetDataByCharID( id )
	
	for _, v in pairs( GAMEMODE.CharData[self:SteamID()] ) do
		
		if( v.id == id ) then
			
			return v;
			
		end
		
	end
	
end

function meta:GetIndexByCharID( id )

	if( !GAMEMODE.CharData[self:SteamID()] ) then return end
	
	for k, v in pairs( GAMEMODE.CharData[self:SteamID()] ) do
		
		if( v.id == id ) then
			
			return k;
			
		end
		
	end
	
end

function meta:GetItemDataByCharID( id )
	
	if( !GAMEMODE.ItemData[self:SteamID()] ) then return end
	
	for k, v in pairs( GAMEMODE.ItemData[self:SteamID()] ) do
		
		if( k == id ) then
			
			return v;
			
		end
		
	end
	
end

function meta:FindPlayer( str )
	
	if( str == "^" ) then return self end
	if( str == "*" ) then
		
		local tr = self:GetEyeTrace();
		
		if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
			
			return tr.Entity;
			
		end
		
	end
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:SteamID() == str ) then
			
			return v;
			
		end
		
	end
	
	for _, v in pairs( player.GetAll() ) do
		
		if( string.find( string.lower( v:RPName() ), string.lower( str ) ) ) then
			
			return v;
			
		elseif( string.find( string.lower( v:Nick() ), string.lower( str ) ) ) then
			
			return v;
			
		end
		
	end
	
end

function meta:SendNet( str )
	
	net.Start( str );
	net.Send( self );
	
end

function meta:IsTargetable()
	
	if( self:GetNoDraw() ) then return false end
	if( self:IsPlayer() and !self:Alive() ) then return false end
	if( self:IsPlayer() and self:CharID() == -1 and !self:IsBot() ) then return false end
	
	return true;
	
end

function string.FormatDigits( str )
	
	if( tonumber( str ) < 10 ) then
		
		return "0" .. str;
		
	end
	
	return str;
	
end

function player.GetAllBut( ply )
	
	local ret = { };
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v != ply ) then
			
			table.insert( ret, v );
			
		end
		
	end
	
	return ret;
	
end

if( CLIENT ) then

	local function nPrintConsole()
	
		local str = net.ReadString();
		
		print( str );
	
	end
	net.Receive( "nPrintConsole", nPrintConsole );
	
	local function nNotify()
	
		local col = net.ReadColor();
		local length = net.ReadFloat();
		local startTime = CurTime();
		local font = net.ReadString();
		local str = net.ReadString();
		
		if( !GAMEMODE.NotifyLines ) then GAMEMODE.NotifyLines = {} end;
		
		GAMEMODE.NotifyLines[#GAMEMODE.NotifyLines + 1] = { col, length, startTime, font, str };
	
	end
	net.Receive( "nNotify", nNotify );
	
end