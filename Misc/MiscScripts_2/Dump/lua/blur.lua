local mat = Material("pp/blurscreen")
local I, Min, Max = 0, 0, 5
local Ents = {"prop_*", "player", "gmod_*", "wire_*", "weapon_*"}
 
hook.Add("PostDrawOpaqueRenderables", "StencilTest", function()
    render.ClearStencil()
    render.SetStencilEnable(true)
     
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
    render.SetStencilFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
 
    render.SetStencilReferenceValue(1)
     
    cam.Start2D()   
        surface.SetDrawColor(50, 50, 50, 10)
        surface.DrawRect(0, 0, ScrW(), ScrH()) 
    cam.End2D()
     
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
     
    for k,v in pairs(ents.GetAll()) do
        for k2,v2 in pairs(Ents) do
            if(string.find(v:GetClass(), v2)) then
                v:DrawModel()
            end
        end
    end
     
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
     
    render.SetStencilReferenceValue(1)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    if not((I == Max) or (math.Round(I) == Max)) then
        if(I < Max) then
            I = I + 0.01
        else
            I = I - 0.01
        end
    else
        local temp = Min
        Min = Max
        Max = temp
    end
    for i = 0.33, 1, 0.33 do
        mat:SetMaterialFloat( "$blur", (I*i))
        render.UpdateScreenEffectTexture()
        render.SetMaterial( mat )
        render.DrawScreenQuad()
    end
 
    render.SetStencilEnable(false)
end)