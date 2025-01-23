
local firstDeath_Enabled = false;

local function lib_first_Death( pl, origin, angles, fov )
	local ragdoll = pl:GetRagdollEntity();
    if( !ragdoll || ragdoll == NULL || !ragdoll:IsValid() ) then return; end
       
    local eyes = ragdoll:GetAttachment( ragdoll:LookupAttachment( "eyes" ) );
    local view = {
		origin = eyes.Pos,
        angles = eyes.Ang,
		fov = 90, 
    };
	
    return view;
end

function lib_first_Enable()
	if firstdeath_Enabled then return end;
	hook.Add( "CalcView", "lib_first_Death", lib_first_Death );
	firstdeath_Enabled = true;
end

function lib_first_Disble()
	if !firstdeath_Enabled then return end;
	hook.Remove( "CalcView", "lib_firstDeath");
	firstdeath_Enabled = false;
end