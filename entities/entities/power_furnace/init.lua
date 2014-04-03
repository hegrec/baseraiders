ENT.Type = "brush"

function ENT:Initialize()
	self:PhysicsInitBox(self.minVec,self.maxVec)
	self:SetCollisionBounds(self.minVec,self.maxVec)
	 
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid( SOLID_BBOX )
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion( false )
	end
	self.PoweringWood = {}
end

function ENT:SetMarker(str)
	self.marker = str
end
function ENT:SetMaxVector(v)
	self.maxVec = v
end
function ENT:SetMinVector(v)
	self.minVec = v
end

function ENT:StartTouch(ent)
	if ent:GetItemName() == "Wood" and !ent.in_furnace then
		table.insert(self.PoweringWood,ent)
		ent:Ignite(60)
		ent.in_furnace = true
		timer.Simple(59,function()if ent:IsValid() then ent:Remove() end end)
	elseif ent.in_furnace then
		ent:Remove()
	end
end
function ENT:Think()


	local amtwood = 0
	local new = {}
	for i,v in ipairs(self.PoweringWood) do
		if v:IsValid() then
				table.insert(new,v)
				amtwood = amtwood + 1
		end
	end
	self.PoweringWood = new
	amtwood = math.min(MAX_WOOD_BOOST,amtwood)
	SetGlobalInt("PowerBoost",WOOD_BOOST*amtwood)

end
function ENT:EndTouch(ent)
	if ent:GetItemName() == "Wood" then
		local amtwood = 0
		local new = {}
		for i,v in ipairs(self.PoweringWood) do
			if v:IsValid() and v != ent then
					table.insert(new,v)
					amtwood = amtwood + 1
			end
		end
		self.PoweringWood = new
		ent:Remove()
	end
end