resource.AddSingleFile( "resource/fonts/bebasneue.ttf" );
resource.AddSingleFile( "materials/fallout/vgui/main_title.png" );
resource.AddSingleFile( "materials/fallout/vgui/main_background.png" );

resource.AddWorkshop( 768388226 );
resource.AddWorkshop( 493808566 );
resource.AddWorkshop( 493809632 );
resource.AddWorkshop( 493812236 );
resource.AddWorkshop( 849268315 );
resource.AddWorkshop( 873935480 );
resource.AddWorkshop( 950734108 );
resource.AddWorkshop( 950753735 );

GM.WorkshopMaps = { };
GM.WorkshopMaps["rp_oldworld_optim_v5"] = 806373455;

if( GM.WorkshopMaps[game.GetMap()] ) then
	
	resource.AddWorkshop( GM.WorkshopMaps[game.GetMap()] );
	
else
	
	resource.AddSingleFile( "maps/" .. game.GetMap() .. ".bsp" );
	
end