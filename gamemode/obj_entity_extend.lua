local meta = FindMetaTable("Entity")

Doors = {"func_door","func_door_rotating","prop_door_rotating"}
function meta:IsDoor()
	return table.HasValue(Doors,self:GetClass())
end

function meta:GetOwn()
	return GetBySteamID(self:GetNWString("Owner"))
end 