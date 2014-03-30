include("shared.lua")


function ENT:Draw()
	self:DrawModel()
	local light = DynamicLight(self:EntIndex())
	light.Pos = self.Entity:GetPos()
	light.Dir = Vector(0,0,0)
	light.r = 255
	light.g = 255
	light.b = 255
	light.Brightness = 0.5
	light.Size = 300
	light.Decay = 0
	light.DieTime = CurTime()+2
end