local meta = FindMetaTable("Player")
--Simple lazy function
function meta:EyeTrace(len)
	local tr = {}
	tr.start = self:GetShootPos()
	tr.endpos = tr.start + (self:GetAimVector()*len)
	tr.filter = self
	tr = util.TraceLine(tr)
	return tr
end
function meta:GetExperience()
	return self:GetDTInt(1)
end
function meta:GetLevel()
	return CalculateLevel(self:GetExperience())
end
function meta:GetGangID()
	return self:GetDTInt(0)
end

function meta:GetGangName()
	return self:GetDTString(0)
end

function meta:GetGangLeader()
	return self:GetDTBool(0)
end

function meta:CanReach(ent)
	return self:GetPos():Distance(ent:GetPos()) < MAX_INTERACT_DIST
end 

function meta:FacingNPC(ent)

	local tr = {}
	tr.start = self:GetShootPos()
	tr.endpos = tr.start + self:GetAimVector()*MAX_INTERACT_DIST
	tr.filter = self
	tr.mask = MASK_BLOCKLOS_AND_NPCS
	
	tr = util.TraceLine(tr)


	return tr.Entity == ent
end 

function meta:HasLineOfSight(v)
	local tr = {}
	tr.start = self:GetPos()+Vector(0,0,40)
	tr.endpos = v:GetPos()+Vector(0,0,40)
	tr.filter = self
	tr = util.TraceLine(tr)
	if tr.Entity == v then return true end
	return false
end

local groups = {"owner", "superadmin", "srv_owner"};

function meta:IsStaff()
	if (self:IsAdmin() || self:IsSubAdmin() || self:IsSuperAdmin()) then return true; end //don't need to waste resources in a loop if we can detect it with this
	
	for k,v in ipairs(groups) do
		if (self:IsUserGroup(v)) then return true; end
	end
	return true;
end
