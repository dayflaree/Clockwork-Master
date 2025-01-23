/*-------------------------------------------------------------------------------------------------------------------------
	Keypad data
-------------------------------------------------------------------------------------------------------------------------*/

local X = -50
local Y = -100
local W = 100
local H = 200

local keyPos =	{	{X+5, Y+100, 25, 25, -2.2, 3.45, 1.3, -0},
					{X+37.5, Y+100, 25, 25, -0.6, 1.85, 1.3, -0},
					{X+70, Y+100, 25, 25, 1.0, 0.25, 1.3, -0},

					{X+5, Y+132.5, 25, 25, -2.2, 3.45, 2.9, -1.6},
					{X+37.5, Y+132.5, 25, 25, -0.6, 1.85, 2.9, -1.6},
					{X+70, Y+132.5, 25, 25, 1.0, 0.25, 2.9, -1.6},

					{X+5, Y+165, 25, 25, -2.2, 3.45, 4.55, -3.3},
					{X+37.5, Y+165, 25, 25, -0.6, 1.85, 4.55, -3.3},
					{X+70, Y+165, 25, 25, 1.0, 0.25, 4.55, -3.3},

					{X+5, Y+67.5, 40, 25, -2.2, 4.25, -0.3, 1.6},
					{X+55, Y+67.5, 40, 25, 0.3, 1.65, -0.3, 1.6}
				}

/*-------------------------------------------------------------------------------------------------------------------------
	Function which tries to retrieve the code
-------------------------------------------------------------------------------------------------------------------------*/

hook.Add( "Think", "keypadCrack", function( )
	for _, keypad in pairs( ents.FindByClass( "sent_keypad" ) ) do
		local curNum = keypad:GetNWInt( "keypad_num" )
		if keypad:GetNWBool( "keypad_secure" ) then
			// Secure
			if keypad.prevNum != curNum and curNum != 0 then
				if curNum == 1 or !keypad.candidateCode then keypad.candidateCode = "" end
				
				if curNum > 0 then
					// Retrieve player entering the digit
					local usingPlayer = NULL
					for _, pl in pairs( player.GetAll( ) ) do
						local ent = pl:GetEyeTrace( ).Entity
						if ValidEntity( ent ) and ent == keypad then
							usingPlayer = pl
							break
						end
					end
					
					if ValidEntity( usingPlayer ) then
						// Retrieve exact entered digit
						local pos = keypad:WorldToLocal( usingPlayer:GetEyeTrace( ).HitPos )
						local digit = 0
						for i, v in pairs( keyPos ) do
							local x = ( pos.y - v[5] ) / ( v[5] + v[6] )
							local y = 1 - ( pos.z + v[7] ) / ( v[7] + v[8] )
							
							if x >= 0 and y >= 0 and x <= 1 and y <= 1 then
								digit = i
								break
							end
						end
						
						keypad.candidateCode = keypad.candidateCode .. tostring( digit )
					end
				end
			end
			
			// Copy the collected digits to the definitive code variable since we now know it's correct!
			if keypad:GetNetworkedBool( "keypad_access" ) and keypad:GetNetworkedBool( "keypad_showaccess" ) and keypad.code != keypad.candidateCode then
				keypad.code = keypad.candidateCode
			end
		else
			// Non-secure
			
			// Read the correct code when the ACCESS GRANTED message is displayed
			if keypad:GetNetworkedBool( "keypad_access" ) and keypad:GetNetworkedBool( "keypad_showaccess" ) then
				keypad.code = curNum
			end
		end
		
		keypad.prevNum = curNum
	end
end )

/*-------------------------------------------------------------------------------------------------------------------------
	Views collected info when hovering over a keypad
-------------------------------------------------------------------------------------------------------------------------*/

hook.Add( "HUDPaint", "keypadHelp", function( )
	local keypad = LocalPlayer( ):GetEyeTrace( ).Entity
	if ValidEntity( keypad ) and keypad:GetClass( ) == "sent_keypad" then
		local keypadTxt = ""
		local keypadColor = Color( 192, 255, 0, 255 )
		
		if !keypad.code then
			keypadTxt = "Code not retrieved yet!"
			keypadColor = Color( 255, 128, 0, 255 )
		else
			keypadTxt = "Keypad Code: " .. keypad.code
		end
		
		surface.SetFont( "Default" )
		local w, h = surface.GetTextSize( keypadTxt )
		draw.WordBox( 8, ScrW( ) / 2 - w / 2 - 8, ScrH( ) / 2 - h / 2 - 8, keypadTxt, "Default", Color( 0, 0, 0, 128 ), keypadColor )
	end
end )