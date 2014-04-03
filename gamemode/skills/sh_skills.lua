local skills = {}
--HORRIBLE GAHHH


--[[
SKILL - STAMINA
]]


function AddSkill(name)
	skills[name] = {}
	return skills[name]
end

local meta = FindMetaTable("Player")

function meta:GetSkill(skill)
	if SERVER then
		if !self.Skills then return 0 end
		return self.Skills[skill] or 0
	end	
	return Skills[skill] or 0
end


function meta:GetLevel(skill)
	if SERVER then
		if !self.Levels then return 1 end
		return self.Levels[skill] or 1
	end
	return Levels[skill] or 1
end

function GetSkillList()
	return skills
end

skills["Stamina"] = {
getNeeded = function(pl) return pl:GetLevel("Stamina") * 275 end, --How much do you need per level to level up
levelUp = function(pl) pl:SetWalkSpeed(WALK_SPEED+pl:GetLevel("Stamina")*2) end, --Apply new stuff on level up
maxLevel = 30,
hookUsed = "PlayerFootstep"
}

skills["Security"] = {
getNeeded = function(pl) return pl:GetLevel("Security") * 5 end, --How much do you need per level to level up
levelUp = function(pl) end,--Apply new stuff on level up
maxLevel = 5,
hookUsed = "OnLockPickSuccess",
custFunc = function(pl) pl:SendLua('hook.Call("OnLockPickSuccess",GAMEMODE,Me)'); end
}
/*
skills["Intelligence"] = {
	getNeeded = function(pl) return pl:GetLevel("Intelligence") * 50 end,
	levelUp = function(pl) end,
	maxLevel = 10,
	hookUsed = "OnIntelligenceUp",
	custFunc = function(pl) pl:SendLua('hook.Call("OnIntelligenceUp",GAMEMODE,Me)'); end
}

skills["Engineering"] = {
	getNeeded = function(pl) return pl:GetLevel("Engineering") * 50 end,
	levelUp = function(pl) end,
	maxLevel = 5,
	hookUsed = "OnEngineeringUp",
	custFunc = function(pl) pl:SendLua('hook.Call("OnEngineeringUp",GAMEMODE,Me)'); end
}

*/
