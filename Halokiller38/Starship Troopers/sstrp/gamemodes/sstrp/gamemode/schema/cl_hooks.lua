--[[
Name: "cl_hooks.lua".
Product: "Starship Troopers".
--]]

-- Called when the cinematic intro info is needed.
function SCHEMA:GetCinematicIntroInfo()
	return {
		credits = "Designed and developed by "..self.author..".",
		title = nexus.config.Get("intro_text_big"):Get(),
		text = nexus.config.Get("intro_text_small"):Get()
	};
end;

-- Called each tick.
function SCHEMA:Tick()
	if ( IsValid(g_LocalPlayer) ) then
		if ( NEXUS:IsCharacterScreenOpen(true) ) then
			if (!self.musicSound) then
				self.musicSound = CreateSound(g_LocalPlayer, "sstrp/intro.mp3");
				self.musicSound:Play();
			end;
		elseif (self.musicSound) then
			self.musicSound:FadeOut(10);
			
			timer.Simple(10, function()
				self.musicSound = nil;
			end);
		end;
	end;
end;