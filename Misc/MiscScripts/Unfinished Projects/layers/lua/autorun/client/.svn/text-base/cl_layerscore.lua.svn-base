--[[------------------------------------------------------------------------------------------------------------------
	Clientside layers core
------------------------------------------------------------------------------------------------------------------]]--

Layers = {}

--[[------------------------------------------------------------------------------------------------------------------
	Get layer function
------------------------------------------------------------------------------------------------------------------]]--

function _R.Entity:GetLayer()
	if ( !self:IsValid() ) then return 1 end
	
	local val = self:GetDTInt( 3 )
	
	if ( val == 0 and self != LocalPlayer() ) then val = LocalPlayer():GetLayer() end
	
	return val
end

function _R.Entity:GetViewLayer()
	local val = self:GetDTInt( 2 )
	
	if ( val == 0 ) then val = LocalPlayer():GetLayer() end
	
	return val
end

--[[------------------------------------------------------------------------------------------------------------------
	Collision prediction
------------------------------------------------------------------------------------------------------------------]]--

function Layers.ShouldCollide( ent1, ent2 )
	if ( ent1:GetLayer() != ent2:GetLayer() && !ent1:IsWorld() && !ent2:IsWorld() ) then
		return false
	end
end
hook.Add( "ShouldCollide", "LayersCollisionHandling", Layers.ShouldCollide )

--[[------------------------------------------------------------------------------------------------------------------
	Trace modification
------------------------------------------------------------------------------------------------------------------]]--

Layers.OriginalTraceLine = util.TraceLine
function util.TraceLine( td, layer )
	if ( !layer ) then layer = LocalPlayer():GetLayer() end
	
	local originalResult = Layers.OriginalTraceLine( td )
	
	if ( !originalResult.Entity:IsValid() or originalResult.Entity:GetLayer() == layer ) then
		return originalResult
	else
		if ( td.filter ) then
			if ( type( td.filter ) == "table" ) then
				table.insert( td.filter, originalResult.Entity )
			else
				td.filter = { td.filter, originalResult.Entity }
			end
		else
			td.filter = originalResult.Entity
		end
		
		return util.TraceLine( td )
	end
end

Layers.OriginalPlayerTrace = util.GetPlayerTrace
function util.GetPlayerTrace( ply, dir )
	local originalResult = Layers.OriginalPlayerTrace( ply, dir )
	originalResult.filter = { ply }
	
	for _, ent in ipairs( ents.GetAll() ) do
		if ( ent:GetLayer() != ply:GetLayer() ) then
			table.insert( originalResult.filter, ent )
		end
	end
	
	return originalResult
end

--[[------------------------------------------------------------------------------------------------------------------
	Rendering
------------------------------------------------------------------------------------------------------------------]]--

function Layers:SetEntityVisiblity( ent, layer )
	if ( ent:EntIndex() < 0 or !ent:IsValid() ) then return end
	
	local visible = false
	
	if ( ent:GetOwner():IsValid() ) then
		visible = ent:GetOwner():GetLayer() == layer
	elseif ( ent:GetClass() == "class C_RopeKeyframe" ) then
		visible = ent:GetNWEntity( "CEnt", ent ):GetLayer() == layer
	else
		visible = ent:GetLayer() == layer
	end
	
	if ( ent:GetClass() == "class C_RopeKeyframe" ) then
		if ( visible ) then
			ent:SetColor( 255, 255, 255, 255 )
		else
			ent:SetColor( 255, 255, 255, 0 )
		end
	else
		ent:SetNoDraw( !visible )
		
		if ( visible and !ent.LayerVisibility ) then
			ent:CreateShadow()
		end
	end
	
	ent.LayerVisibility = visible
end

function Layers.RenderEntities()
	local localLayer = LocalPlayer():GetViewLayer()
	
	for _, ent in ipairs( ents.GetAll() ) do
		Layers:SetEntityVisiblity( ent, localLayer )
		
		if ( ent.Layer and ent.Layer != ent:GetLayer() and ( ent.Layer != localLayer and ent:GetLayer() == localLayer ) or ( ent.Layer == localLayer and ent:GetLayer() != localLayer ) and !ent:GetOwner():IsValid() ) then
			local ed = EffectData()
			
			ed:SetEntity( ent )
			util.Effect( "entity_remove", ed, true, true )	
		end
		
		ent.Layer = ent:GetLayer()
	end
end
hook.Add( "RenderScene", "LayersEntityDrawing", Layers.RenderEntities )