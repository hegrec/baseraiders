include("shared.lua")

function ENT:Initialize()
	self:SetRenderBounds(Vector(-1000,-1000,-1000),Vector(1000,1000,1000))
end
function ENT:Draw()
	self:DrawModel()
	if (!self:GetPowered()) then return end
	local amt = 1
	local tbl = GetItems()[self:GetItemName()]
	local offset = Vector(0,0,0)
	if tbl then
		amt = tbl.LightFactor
		offset = tbl.LightOffset
	end
	
	
	local light = DynamicLight(self:EntIndex())
	light.Pos = self.Entity:GetPos()+offset
	light.Dir = Vector(0,0,0)
	light.r = 255
	light.g = 255
	light.b = 255
	light.Brightness = 0.01
	light.Size = 100*amt
	light.Decay = 1000
	light.DieTime = CurTime()+0.1
end