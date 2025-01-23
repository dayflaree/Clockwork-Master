local Entity = FindMetaTable("Entity")

function Entity:HoverInfo(data)
	for k, v in pairs(data) do
		self:SetNWString('Hover'..string.gsub(k, string.Left(k, 1), string.upper(string.Left(k, 1))), v)
	end
end
