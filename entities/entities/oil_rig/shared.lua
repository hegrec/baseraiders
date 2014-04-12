ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.BarrelSettings = {
model="models/props_c17/oildrum001.mdl",
pos = Vector(0,0,0),
ang = Angle(0,0,0),
}
function ENT:GetBarrelPos()
	return self:GetPos()+self:GetRight()*-60+Vector(0,0,1)
end