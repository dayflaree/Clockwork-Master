GM.ModelDefinitions = { };

GM.ModelDefinitions[""] = {
	ViewOffset = Vector( 0, 0, 64 ),
	ViewOffsetDucked = Vector( 0, 0, 28 ),
};

for _,v in pairs( GM.SupermutantModels ) do

	GM.ModelDefinitions[v] = {
		ViewOffset = Vector( 0, 15, 90 ),
		ViewOffsetDucked = Vector( 0, 0, 40 ),
	};
	
end

local meta = FindMetaTable( "Player" );

function meta:GetModelDef()
	
	local s = self:GetSpecialAnimSet();
	
	if( s and GAMEMODE.ModelDefinitions[s] ) then
		
		return GAMEMODE.ModelDefinitions[s];
		
	elseif( GAMEMODE.ModelDefinitions[self:GetModel()] ) then
		
		return GAMEMODE.ModelDefinitions[self:GetModel()];
		
	else
		
		return GAMEMODE.ModelDefinitions[""];
		
	end
	
end