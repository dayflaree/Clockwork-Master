--[[
	Name: cl_auto.lua.
	Author: TJjokerR.
--]]

local PLUGIN = PLUGIN;

openAura:IncludePrefixed("sh_auto.lua");

-- Called when the bars are needed.
function PLUGIN:GetBars(bars)
	local depression = openAura.Client:GetSharedVar("depression");
	
	if (!self.depression) then
		self.depression = depression;
	else
		self.depression = math.Approach(self.depression, depression, 1);
	end;
	
	bars:Add("INSANITY", Color(180, 75, 190, 255), "Insanity", self.depression, 100, self.depression > 25);
end;

-- Called when screen space effects should be rendered.
function PLUGIN:RenderScreenspaceEffects()
	local depression = openAura.Client:GetSharedVar("depression");
	
	if(depression)then
		if(depression >= 75 and depression < 85)then
			DrawMotionBlur(0.8, 0.79, 0.05);
		elseif(depression > 85)then
			DrawMotionBlur(0.1, 0.79, 0.05);
		end;
	end;
end;

function PLUGIN:ScaryShit()
	local depression = p:GetCharacterData("depression");
	local traceEntity = NULL;
	
	if ( IsValid(trace.Entity) and !trace.Entity:IsEffectActive(EF_NODRAW) ) then
		if ( p:GetSharedVar("depression") ) then
			if ( p:Alive() ) then
				if (( p:GetCharacterData("depression")) < 100) then
					p:SetCharacterData("depression", depression + 10 )
				else
					p:SetCharacterData("depression", depression + 0 )
				end;
			end;
		end;
	end;
end;