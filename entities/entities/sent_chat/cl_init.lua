
include('shared.lua')


function ENT:Initialize()
end



function ENT:Draw()
	self.Entity:DrawModel()
end


function ENT:Think( )
	if !IsValid(self.Entity:GetNWEntity("target")) then return end

	self.Targetpos = (self:GetNWEntity("target"):GetPos() + Vector(0,0,100))
	self:SetPos(self.Targetpos + Vector(0,0,math.sin( RealTime()*2 )*10))
	self:SetAngles(self.Entity:GetAngles() + Angle(0,1,0) )
	self:NextThink(RealTime())
end
