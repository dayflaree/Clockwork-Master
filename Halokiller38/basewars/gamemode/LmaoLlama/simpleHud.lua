

function hidehud(name)
    for k, v in pairs{"CHudHealth", "CHudBattery"} do
        if name == v then return false end
    end
end
hook.Add("HUDShouldDraw", "hidehud", hidehud)
    
