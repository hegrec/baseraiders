--AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self.Entity:SetModel(self.tbl.Model)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.gangID = self.pOwner:GetGangID()
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	self:SetUseType(SIMPLE_USE)
end
function ENT:Think()
	if (self:GetPowered()) then
		local players = player.GetAll()
		for i,v in pairs(players) do
			if v:GetPos():Distance(self:GetPos())<400 && v != self.pOwner && v:GetGangID() != self.gangID then
				local tr = {}
				tr.start = self:GetPos()+self.tbl.GunPosition
				tr.endpos = v:GetPos()+v:OBBCenter()
				tr.filter = self
				tr = util.TraceLine(tr)
				if tr.Entity == v then
					local effect = EffectData()
					effect:SetOrigin(v:GetPos()+v:OBBCenter())
					effect:SetStart(self:GetPos()+self.tbl.GunPosition)
					util.Effect("turret_fire",effect)
					self:EmitSound("npc/scanner/scanner_electric2.wav")
					v:TakeDamage(10)
				end
			end
		end
	end
	self:NextThink(CurTime()+0.5)
	return true
end
