include("sh_skills.lua")

local skills = GetSkillList()

function GM:OnLoadSkills(pl,skills,levels)
	pl.Skills = {}
	pl.Levels = {}
	if skills == "" or levels == "" then
		for i,v in pairs(GetSkillList()) do
			pl.Skills[i] = 0
			pl.Levels[i] = 1
		end
		return
	end
	local t = table.ToLoad(skills)
	pl.Skills = {}
	for i,v in pairs(t) do
		if GetSkillList()[i] then
			pl.Skills[i] = tonumber(v)
		end
	end

	
	local t = table.ToLoad(levels)
	pl.Levels = {}
	for i,v in pairs(t) do
		if GetSkillList()[i] then
			pl.Levels[i] = tonumber(v)
		end
	end
	ClientSkillUpdate(pl)
end

for i,v in pairs(skills) do
	hook.Add(v.hookUsed,i.."Increase",
		function(pl)
			if !pl.Skills[i] then return end
			pl.Skills[i] = math.Clamp(pl.Skills[i] + 1,0,skills[i].getNeeded(pl))
			if pl.Skills[i] >= skills[i].getNeeded(pl) and pl:CanLevel(i) then pl:LevelUp(i) end
			if v.custFunc then v.custFunc(pl); end
		end
	)
end



local meta = FindMetaTable("Player")
function meta:LevelUp(skill)
	self.Levels[skill] = self.Levels[skill] + 1
	self.Skills[skill] = 0
	GetSkillList()[skill].levelUp(self)
	umsg.Start("skillLeveled",self) umsg.String(skill) umsg.End()
end


function meta:CanLevel(skill)
	return self.Levels[skill] < GetSkillList()[skill].maxLevel
end






function ClientSkillUpdate(pl)
	local skills = pl.Skills
	local levels = pl.Levels

	for i,v in pairs(GetSkillList()) do
	
		if skills[i] > 0 then
			umsg.Start("skillSet",pl)
				umsg.String(i)
				umsg.Long(skills[i])
			umsg.End()
		end
		
		if levels[i] > 1 then
			umsg.Start("levelSet",pl)
				umsg.String(i)
				umsg.Char(levels[i])
			umsg.End()
		end
		
	end
	
end

