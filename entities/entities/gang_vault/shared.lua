ENT.Type = "anim"
ENT.Base = "base_anim" 

function ENT:GetGangName()
	return self:GetDTString(0)
end
function ENT:GetGangID()
	return self:GetDTInt(0)
end
