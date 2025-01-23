function PrecacheInit()
	
	for i = 1, 7 do
		
		util.PrecacheModel( "models/infected/necropolis/common/female_0" .. i .. ".mdl" );
		
	end
	
	for i = 1, 9 do
		
		util.PrecacheModel( "models/infected/necropolis/common/male_0" .. i .. ".mdl" );
		util.PrecacheModel( "models/infected/necropolis/common/male_1" .. i .. ".mdl" );
		
	end
	
end
hook.Add( "Initialize", "PrecacheInit", PrecacheInit );