include("shared.lua")

offsets = {}
offsets["models/americahat/americahat.mdl"] = {
	UpOffset = 2,
	RightOffset = 0,
	ForwardOffset = -3.2
}
offsets["models/highhat/highhat.mdl"] = {
	UpOffset = 2,
	RightOffset = 0,
	ForwardOffset = -3.2
}
offsets["models/bunnyears/bunnyears.mdl"] = {
	UpOffset = 4.5,
	RightOffset = 0,
	ForwardOffset = -2,
	Scale = 1.1
}
offsets["models/captainshat/captainshat.mdl"] = {
	UpOffset = 2,
	RightOffset = 0,
	ForwardOffset = -3.2
}
offsets["models/beerhat/beerhat.mdl"] = {
	UpOffset = 2,
	RightOffset = 0,
	ForwardOffset = -3.2
}
offsets["models/mariohat/mariohat.mdl"] = {
	UpOffset = 2,
	RightOffset = 0,
	ForwardOffset = -3.2
}
offsets["models/paperbag/paperbag.mdl"] = {
	UpOffset = -8,
	RightOffset = 0,
	ForwardOffset = -3.2,
	Scale = 1.2
}
offsets["models/headcrabclassic.mdl"] = {
	UpOffset = 0.5,
	RightOffset = 0,
	ForwardOffset = 0,
	Scale = 0.75
}
offsets["models/props/de_tides/vending_hat.mdl"] = {
	UpOffset = 0.6,
	RightOffset = 0,
	ForwardOffset = -3.3
}                 

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
	
	self.offsets = offsets[self.Entity:GetModel()]
	if(self.offsets and self.offsets.Scale)then self:SetModelScale(Vector(self.offsets.Scale,self.offsets.Scale,self.offsets.Scale)) end
end

function ENT:Draw()
	if(!self.offsets)then return end
	
	local owner = self:GetOwner()
	if(owner == LocalPlayer() and LocalPlayer():Alive() and !LocalPlayer():GetVehicle():IsValid()) then return end
	if LocalPlayer():GetVehicle():IsValid() && gmod_vehicle_viewmode:GetInt() == 0 && owner == LocalPlayer() then return end

	if !owner:Alive() and owner:GetRagdollEntity() then
		owner = owner:GetRagdollEntity()
	end
		
	local attach = owner:GetAttachment(owner:LookupAttachment("eyes"))
	if attach then
		local ang = attach.Ang
		self:SetAngles(ang)
		if(self.offsets.Scale)then self:SetModelScale(Vector(self.offsets.Scale,self.offsets.Scale,self.offsets.Scale)) end
		local pos = attach.Pos + (ang:Up() * self.offsets.UpOffset)
		pos = pos + (ang:Right() * self.offsets.RightOffset)
		pos = pos + (ang:Forward() * self.offsets.ForwardOffset)
		self:SetPos(pos)
		self:DrawModel()
	end
end 