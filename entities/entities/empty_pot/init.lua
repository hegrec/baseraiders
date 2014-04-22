AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
 
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	self.nextGallonDecrease = CurTime()
	self.On = false
	self.powering = {}
end

function ENT:StartTouch(ent)

	if ent:GetItemName() == "Marijuana Seed" then

		local planter = ent.pOwner
		ent:Remove()
		local plant = ents.Create("weed_plant")
		plant:SetPos(self:GetPos())
		plant:SetAngles(self:GetAngles())
		plant:Spawn()
		plant.planter = planter
		self:Remove()
	end

end