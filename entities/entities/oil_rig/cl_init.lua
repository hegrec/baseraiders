 include("shared.lua")
function ENT:Initialize()
	self.barrel= ents.CreateClientProp()
	self.barrel:SetModel(self.BarrelSettings.model)
	self.barrel:SetNoDraw(true)
	self.barrel:Spawn()
	
	self.barrel2= ents.CreateClientProp()
	self.barrel2:SetModel(self.BarrelSettings.model)
	self.barrel2:Spawn()
	self.barrel2:SetNoDraw(true)
	self.barrel2:SetMaterial("models/wireframe")
	self:SetModelScale(0.5,0)
end
function ENT:Remove()
	self.barrel:Remove()
	self.barrel2:Remove()
end
function ENT:Draw()
	self.BarrelSettings.pos = self:GetBarrelPos()
	
	
	if (self:GetNWInt("FillPercentage")<5) then return end
	
	
	self.barrel:SetPos(self.BarrelSettings.pos)	
	self.barrel2:SetPos(self.BarrelSettings.pos)	
	local normal = self:GetUp()*-1
	local Mins = self.barrel:OBBMins().z
	local Maxs = self.barrel:OBBMaxs().z
	local Z = Mins+(((Maxs-Mins)/100)*self.Entity:GetNWInt("FillPercentage"))
	local distance = normal:Dot(self.barrel:LocalToWorld(Vector(0,0,Z)))
	render.EnableClipping(true)
	render.PushCustomClipPlane(normal,distance)
	self.barrel:DrawModel()
	render.PopCustomClipPlane()
	
	local normal = self:GetUp()*1
	local Mins = self.barrel:OBBMins().z
	local Maxs = self.barrel:OBBMaxs().z
	local Z = Mins+(((Maxs-Mins)/100)*self.Entity:GetNWInt("FillPercentage"))
	local distance = normal:Dot(self.barrel:LocalToWorld(Vector(0,0,Z)))
	render.EnableClipping(true)
	render.PushCustomClipPlane(normal,distance)
	self.barrel2:DrawModel()
	render.PopCustomClipPlane()
	
end
