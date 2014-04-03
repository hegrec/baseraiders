--AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self.Entity:SetModel("models/props_wasteland/gaspump001a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	self:SetNWInt("ChargePercentage",0)
	self:SetUseType(SIMPLE_USE)
end
function ENT:Use(ent)
	ent:ConCommand("useGangBank "..self:EntIndex())

end
function ENT:SetTerritory(territoryID)
	self:SetNWInt("TerritoryID",territoryID)
end
function ENT:Explode()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart( vPoint ) -- not sure if ( we need a start and origin ( endpoint ) for this effect, but whatever
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 1 )
	util.Effect( "HelicopterMegaBomb", effectdata )
	self:Remove()
	self:EmitSound("ambient/explosions/explode_4.wav")
end
function ENT:SetGangID(gangID)
	self:SetNWInt("GangID",gangID)
end
function ENT:SetGangName(gangName)
	self:SetNWString("GangName",gangName)
end
function ENT:Charge()
	local amt = 0
	local players = player.GetAll()
	for i,v in pairs(players) do
		if v:GetNWInt("GangID") == self:GetGangID() and v:GetPos():Distance(self:GetPos())<100 then
			amt = amt + 1
		end
	end
	self:SetNWInt("ChargePercentage",self:GetNWInt("ChargePercentage")+amt)
	if self:GetNWInt("ChargePercentage")>=100 then
		self:SetNWInt("ChargePercentage",0)
		return true
	end
	return false
end