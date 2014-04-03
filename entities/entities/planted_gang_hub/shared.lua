ENT.Type = "anim"
ENT.Base = "base_anim" 

function ENT:GetGangName()
	return self:GetNWString("GangName")
end
function ENT:GetGangID()
	return self:GetNWInt("GangID")
end
