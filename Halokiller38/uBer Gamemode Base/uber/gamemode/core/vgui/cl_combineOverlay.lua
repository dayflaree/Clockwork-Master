function paintshit()		
	local combineOverlay = Material("effects/combine_binocoverlay");			
	render.UpdateScreenEffectTexture();			
	combineOverlay:SetMaterialFloat("$refractamount", 0.3);
	combineOverlay:SetMaterialFloat("$envmaptint", 0);
	combineOverlay:SetMaterialFloat("$envmap", 0);
	combineOverlay:SetMaterialFloat("$alpha", 0.8);
	combineOverlay:SetMaterialInt("$ignorez", 1);
	render.SetMaterial(combineOverlay);
	render.DrawScreenQuad()
end;
hook.Add("HUDPaint","shitpan",paintshit);