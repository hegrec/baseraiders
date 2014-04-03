 include("shared.lua")
function ENT:Initialize()
	self.barrel= ents.CreateClientProp()
	self.barrel:SetModel(self.BarrelSettings.model)
	self.barrel:SetNoDraw(true)
	self.barrel:Spawn()
end

function ENT:Draw()
	self.BarrelSettings.pos = self:GetBarrelPos()
	
	--if (self:GetNWInt("FillPercentage")<5) then return end
	self:DrawModel()
	
	self.barrel:SetPos(self.BarrelSettings.pos)	
	local normal = self:GetUp()*-1
	local Mins = self.barrel:OBBMins().z
	local Maxs = self.barrel:OBBMaxs().z
	local Z = Mins+(((Maxs-Mins)/100)*self:GetNWInt("FillPercentage"))
	local distance = normal:Dot(self.barrel:LocalToWorld(Vector(0,0,Z)))
	render.EnableClipping(true)
	render.PushCustomClipPlane(normal,distance)
	self.barrel:DrawModel()
	render.PopCustomClipPlane()
	
end
