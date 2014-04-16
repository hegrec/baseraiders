local meta = FindMetaTable("Entity")
function meta:GetDoorLevel()
	local lvl = self:GetNWInt("doorlevel")
	if lvl == 0 then lvl = 1 end
	return lvl
end

function meta:SetDoorLevel(lvl)
	if(CLIENT)then return end
	self:SetNWInt("doorlevel",lvl)
end