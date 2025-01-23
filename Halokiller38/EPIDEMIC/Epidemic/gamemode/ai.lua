--[[require( "navigation" );

EPI_NAV_MESH = CreateNav( 32 );

function InitAiNavMesh()

	EPI_NAV_MESH:Load( "data/epidemic/navmesh/" .. GetMap() .. ".nav" );
	
end
hook.Add( "InitPostEntity", "InitAiNavMesh", InitAiNavMesh );
--]]