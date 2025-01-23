local Entity = FindMetaTable("Entity")

function Entity:Nick()
	if not self:IsValid() then return "Console" end
end

function Entity:HasPermission(perm)
	if not self:IsValid() then return true end
end

function Entity:GetRank()
	if not self:IsValid() then return table.GetFirstValue(table.SortByKey(NERO.Ranks, true)) end
end

function Entity:GetLevel()
	
end