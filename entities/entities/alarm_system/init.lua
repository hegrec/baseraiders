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
	self.ownerGang = self.pOwner:GetGangID()
end

function ENT:Alert(nonGang)
	if !self:IsPowered() then return end
	local placer = self.pOwner
	if self.ownerGang == 0 and !IsValid(placer) then return end
	if (IsValid(placer) && placer:GetGangID() == 0) || nonGang then
		placer:ChatPrint("One of your alarm systems is going off!!!!")
	else
		for i,v in pairs(player.GetAll()) do
			if (v:GetGangID() == self.ownerGang) then
				v:ChatPrint("One of your gang's alarm systems is going off!!!!")
			end
		end
	end
	
	if self:GetNWBool("Alerting") then return end
	self:SetNWBool("Alerting",true)
	self:EmitSound("alarm_active")
end

function ENT:Think()
	if !self:IsPowered() && self:GetNWBool("Alerting") then
		self:AlarmOff()
	end
end
function ENT:AlarmOff()
	self:StopSound("alarm_active")
	self:SetNWBool("Alerting",false) 
end
function ENT:Remove()
	self:AlarmOff()
end