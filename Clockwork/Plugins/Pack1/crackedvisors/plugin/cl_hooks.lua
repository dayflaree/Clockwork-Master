local PLUGIN = PLUGIN;

function Schema:RenderScreenspaceEffects()
	if (!Clockwork.kernel:IsScreenFadedBlack()) then
		local curTime = CurTime();
		
		if (self.flashEffect) then
			local timeLeft = math.Clamp( self.flashEffect[1] - curTime, 0, self.flashEffect[2] );
			local incrementer = 1 / self.flashEffect[2];
			
			if (timeLeft > 0) then
				modify = {};
				
				modify["$pp_colour_brightness"] = 0;
				modify["$pp_colour_contrast"] = 1 + (timeLeft * incrementer);
				modify["$pp_colour_colour"] = 1 - (incrementer * timeLeft);
				modify["$pp_colour_addr"] = incrementer * timeLeft;
				modify["$pp_colour_addg"] = 0;
				modify["$pp_colour_addb"] = 0;
				modify["$pp_colour_mulr"] = 1;
				modify["$pp_colour_mulg"] = 0;
				modify["$pp_colour_mulb"] = 0;
				
				DrawColorModify(modify);
				
				if (!self.flashEffect[3]) then
					DrawMotionBlur( 1 - (incrementer * timeLeft), incrementer * timeLeft, self.flashEffect[2] );
				end;
			end;
		end;
		
		if (self:PlayerIsCombine(Clockwork.Client)) then
		render.UpdateScreenEffectTexture();
		if(Clockwork.Client:Health()<=25) then
		Schema.combineOverlay = Material("crackedvisor/combine_binocoverlaycrackthree");
		self.combineOverlay:SetFloat("$refractamount", 0.3);
		self.combineOverlay:SetFloat("$envmaptint", 0);
		self.combineOverlay:SetFloat("$envmap", 0);
		self.combineOverlay:SetFloat("$alpha", 0.5);
		self.combineOverlay:SetInt("$ignorez", 1);
		elseif(Clockwork.Client:Health()<=50) then
		Schema.combineOverlay = Material("crackedvisor/combine_binocoverlaycracktwo");
		self.combineOverlay:SetFloat("$refractamount", 0.3);
		self.combineOverlay:SetFloat("$envmaptint", 0);
		self.combineOverlay:SetFloat("$envmap", 0);
		self.combineOverlay:SetFloat("$alpha", 0.5);
		self.combineOverlay:SetInt("$ignorez", 1);
		elseif(Clockwork.Client:Health()<=75) then
		Schema.combineOverlay = Material("crackedvisor/combine_binocoverlaycrackone");
		self.combineOverlay:SetFloat("$refractamount", 0.3);
		self.combineOverlay:SetFloat("$envmaptint", 0);
		self.combineOverlay:SetFloat("$envmap", 0);
		self.combineOverlay:SetFloat("$alpha", 0.5);
		self.combineOverlay:SetInt("$ignorez", 1);
		else
		Schema.combineOverlay = Material("effects/combine_binocoverlay");
		self.combineOverlay:SetFloat("$refractamount", 0.3);
		self.combineOverlay:SetFloat("$envmaptint", 0);
		self.combineOverlay:SetFloat("$envmap", 0);
		self.combineOverlay:SetFloat("$alpha", 0.5);
		self.combineOverlay:SetInt("$ignorez", 1);
		end;
		
		render.SetMaterial(Schema.combineOverlay);
		render.DrawScreenQuad();
		end;
	end;
end;