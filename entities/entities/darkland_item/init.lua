--AddCSLuaFile("cl_init.lua")
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
	
end 

function ENT:Use(activator, caller)
	if !activator:IsPlayer() then return end
	if !activator:GiveItem(self.GroupIndex) then activator:SendNotify("You have no room for that.","NOTIFY_ERROR",3) return end
	self:Remove()
end 