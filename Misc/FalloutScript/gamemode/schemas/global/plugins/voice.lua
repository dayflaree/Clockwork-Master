PLUGIN.Name = "Player Voices"; -- What is the plugin name
PLUGIN.Author = "Looter"; -- Author of the plugin
PLUGIN.Description = "Enables players to say things"; -- The description or purpose of the plugin

LEMON.Voices = { }; -- I hear voices D:>

function ccVoice( ply, cmd, args ) -- People near you will hear the voice

	local id = args[ 1 ];
	
	if( LEMON.Voices[ id ] == nil ) then

		LEMON.SendConsole( ply, "This sound does not exist. Use rp_listvoices" );
		return;
		
	end
	
	if( not ply:Alive() ) then return; end

	local voice = LEMON.Voices[ id ];
	local team = ply:Team( );
	
	if( table.HasValue( LEMON.Teams[ team ][ "sound_groups" ], voice.soundgroup ) ) then
		
		local path = voice.path;
		
		if((string.find(string.lower(ply:GetModel()), "female") or string.lower(ply:GetModel()) == "models/alyx.mdl") and voice.femalealt != "") then
			path = voice.femalealt;
		end
		
		if(LEMON.Teams[ team ].iscombine == true) then
		

			util.PrecacheSound( "/npc/metropolice/vo/on2.wav" );
			util.PrecacheSound( "/npc/metropolice/vo/off2.wav" );
			
			ply:EmitSound( "/npc/metropolice/vo/on2.wav" );
			
			local function EmitThatShitz()
			ply:EmitSound( "/npc/metropolice/vo/off2.wav" );
			end
			
			local function EmitThatShit()
				ply:EmitSound(path);
				timer.Simple(1, EmitThatShitz);
			end

			timer.Simple(1, EmitThatShit);
			
			
			return "";
			
		end
			
		util.PrecacheSound( path );
		ply:EmitSound( path );
		ply:ConCommand( "say " .. voice.line .. "\n" );
		
	end
	
end
concommand.Add( "rp_voice", ccVoice );

function ccListVoice( ply, cmd, args ) -- LIST DA FUKKEN VOICES

	LEMON.SendConsole( ply, "---List of CakeScript Voices---" );
	LEMON.SendConsole( ply, "Please note, these are only for your current flag" );
	
	for _, voice in pairs(LEMON.Voices) do

		if(table.HasValue(LEMON.Teams[ply:Team()]["sound_groups"], voice.soundgroup)) then
		
			LEMON.SendConsole( ply, _ .. " - " .. voice.line .. " - " .. voice.path );
			
		end
		
	end
	
end
concommand.Add( "rp_listvoices", ccListVoice );

function LEMON.AddVoice( id, path, soundgroup, text, fa)

	local voice = { };
	voice.path = path;
	voice.soundgroup = LEMON.NilFix(soundgroup, 0);
	voice.line = LEMON.NilFix(text, "");
	voice.femalealt = LEMON.NilFix(fa, "");
	
	LEMON.Voices[ id ] = voice;
	
end
