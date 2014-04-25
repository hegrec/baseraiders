--AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self.Entity:SetModel("models/props/cs_militia/roof_vent.mdl")
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
	ent:SendNotify("This is a gang hub. You need a vault to access the gang bank.","NOTIFY_GENERIC",5);
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
	self:SetDTInt(0,gangID)
end
function ENT:SetGangName(gangName)
	self:SetDTString(0,gangName)
end
function ENT:Charge()
	local amt = 0
	local players = player.GetAll()
	for i,v in pairs(players) do
		if v:Alive() && v:GetGangID() == self:GetGangID() and v:GetPos():Distance(self:GetPos())<100 then
			amt = amt + 0.5
		end
	end
	self:SetNWInt("ChargePercentage",self:GetNWInt("ChargePercentage")+amt)
	if self:GetNWInt("ChargePercentage")>=100 then
		self:SetNWInt("ChargePercentage",0)
		return true
	end
	return false
end