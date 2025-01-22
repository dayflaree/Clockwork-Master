local PLUGIN = PLUGIN;
local blue = CreateMaterial("thermalfriend", "UnlitGeneric", {
	["$basetexture"] = "vgui/thermal_friendly",
	["$basetexturetransform"] = "center 0 0 scale 1 1 rotate 0 translate 0 0",
	["$model"] = 1,
	["$additive"] = 0,
	["$nolod"] = 1,
	["$translucent"] = 0,
	["$vertexcolor"] = 0
});

-- Called when screen space effects should be rendered.
function PLUGIN:RenderScreenspaceEffects()
	local thermalsActive = Clockwork.Client:GetSharedVar("thermalsActive");

	if (!thermalsActive) then return; end;

	local modulation = {0.5, 0.5, 0.5};

	local colorModify = {};
	colorModify["$pp_colour_brightness"] = 0.1;
	colorModify["$pp_colour_contrast"] = 0.2;
	colorModify["$pp_colour_colour"] = 0;
	colorModify["$pp_colour_addr"] = 0;
	colorModify["$pp_colour_addg"] = 0;
	colorModify["$pp_colour_addb"] = 0;
	colorModify["$pp_colour_mulr"] = 0;
	colorModify["$pp_colour_mulg"] = 0;
	colorModify["$pp_colour_mulb"] = 0;

	DrawColorModify(colorModify);

	cam.Start3D( EyePos(), EyeAngles() );
		for k, v in ipairs( player.GetAll() ) do
			if (v:Alive() and !v:IsRagdolled() and !v:IsNoClipping()) then
				if (v:HasInitialized()) then
					if (thermalsActive) then

						render.SuppressEngineLighting(true);
						render.SetColorModulation( 0.5, 0.5, 0.5 );

						if (Schema:PlayerIsCombine(Clockwork.Client)) then
							render.MaterialOverride((Schema:PlayerIsCombine(v) and blue) or PLUGIN.shinyMaterial);
						else
							render.MaterialOverride(PLUGIN.shinyMaterial);
						end;

						if (v.IsProne and v:IsProne() and IsValid(v.proneModel)) then
							v.proneModel:DrawModel();
						else
							v:DrawModel();
						end;

						render.MaterialOverride(false)

						render.SetColorModulation(1, 1, 1);
						render.SuppressEngineLighting(false);
					end;
				end;
			end;
		end;

		for k, v in ipairs(ents.FindByClass("npc_*")) do
			if (v:Health() <= 0) then continue; end;

			if (thermalsActive) then

				render.SuppressEngineLighting(true);
				render.SetColorModulation( unpack(modulation) );

				render.MaterialOverride(PLUGIN.shinyMaterial);
					v:DrawModel();
				render.MaterialOverride(false)

				render.SetColorModulation(1, 1, 1);
				render.SuppressEngineLighting(false);
			end;
		end;

		for k, v in ipairs(ents.FindByClass("prop_ragdoll")) do
			if (thermalsActive) then

				render.SuppressEngineLighting(true);
				render.SetColorModulation( unpack(modulation) );

				render.MaterialOverride(PLUGIN.shinyMaterial);
					v:DrawModel();
				render.MaterialOverride(false)

				render.SetColorModulation(1, 1, 1);
				render.SuppressEngineLighting(false);
			end;
		end;
	cam.End3D();
end;
