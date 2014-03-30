local meta = FindMetaTable("Entity")
function meta:GetLevel()
	local lvl = self:GetNWInt("level")
	if lvl == 0 then lvl = 1 end
	return lvl
end

function meta:SetLevel(lvl)
	if(CLIENT)then return end
	self:SetNWInt("level",lvl)
end