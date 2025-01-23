
function HUDShouldDraw( id )

	local nodraw = {

		"CHudHealth",
		"CHudAmmo",
		"CHudSecondaryAmmo",
		"CHudBattery",
		"CHudChat",
		--"CHudCrosshair",
		"CHudWeaponSelection",
		"CHudDamageIndicator",
		"CHudHintDisplay",
		"CHudVoiceStatus",
		"CHudVoiceSelfStatus",
	
	}
	
	for k, v in pairs( nodraw ) do

		if( id == v ) then
		
			return false;
		
		end
	
	end
	
	return true;

end
hook.Add( "HUDShouldDraw", "GearHUDShouldDraw", HUDShouldDraw );

--Copy pasta modification
 function draw.DrawTextOutlined(text, font, x, y, colour, xalign, yalign, outlinewidth, outlinecolour) 
   
 	for _x=-1, 1 do 
 		for _y=-1, 1 do 
 			draw.DrawText(text, font, x + (_x*outlinewidth), y + (_y*outlinewidth), outlinecolour, xalign, yalign) 
 		end 
 	end 

 	draw.DrawText(text, font, x, y, colour, xalign, yalign) 
 	 
 end 

 function draw.DrawTextGlowing(text, font, x, y, colour, xalign, yalign, passes, outlinecolour) 
   
 	for _x=-1, 1 do 
 		for _y=-1, 1 do 
 			for n = 1, passes do
 				draw.DrawText(text, font, x + (_x*(n/2)), y + (_y*(n/2)), Color( outlinecolour.r, outlinecolour.g, outlinecolour.b, math.Clamp( ( ( 1 / n ) * 255 ), 0, outlinecolour.a )), xalign, yalign) 
 			end
 		end 
 	end 
 	 
 	draw.DrawText(text, font, x, y, colour, xalign, yalign) 
 	 
 end 
 

