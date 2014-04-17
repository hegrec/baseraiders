GANG_CREATION_COST = 5000
GANG_EXP_PER_LEVEL = 1000
--hook.Add("Initialize","noreload",function()
territories = territories or {}
territories[1] = territories[1] or {
	Name = "Power Plant",
	HubSpawns = "Wood",
	Min = Vector(6053.164063, 5098.930664, -177.968750),
	Max = Vector(6455.944824, 6039.595703, -50.031250),
	MinFurnace = Vector(5924.120605, 5098.976563, -177.968750),
	MaxFurnace = Vector(6455.641602, 5291.199219, -50.031250),
	LabelPos = Vector(5904.968750, 5455.014160, -37.287628),
	LabelAngle = Angle(0,-90,90),
	Label = function()
	
		draw.SimpleTextOutlined("Power Plant","TerritoryTitle",0,-20,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))
		draw.RoundedBox(0,0,30,500,30,Color(0,0,0,255))
		
		local percentage = power.GetCityPowerUsed()/power.GetCityMaxPower()
		local maxsize = 500-4
		
		draw.RoundedBox(0,2,32,maxsize*percentage,26,Color(200,0,0,255))
		draw.SimpleText(power.GetCityPowerUsed().."/"..power.GetCityMaxPower().." KW","Billboard",10,32,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
	
	end
}

territories[2] = territories[2] or {
	Name = "Oil Factory",
	HubSpawns = "Crude Oil",
	LabelAngle = Angle(0,0,90),
	Min = Vector(-1486.823730, 6649.146973, -182.968750),
	Max = Vector(-707.747131, 7427.968750, 24.850937),
	LabelPos = Vector(-962.831848, 6628.968750, -61.272655),
	Label = function()
	
		draw.SimpleTextOutlined("Oil Factory","TerritoryTitle",0,0,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))
		
	end
}
territories[3] = territories[3] or {
	Name = "Silicon Factory",
	HubSpawns = "Silicon",
	Min = Vector(-4770.882813, 588.223083, -2.031250),
	Max = Vector(-5280.166504, 89.927063, -191.968750),
	LabelPos = Vector(-5294.031250, 400.409576, -129.520035),
	LabelAngle = Angle(0,-90,90),
	Label = function()
	
		draw.SimpleTextOutlined("Silicon Factory","TerritoryTitle",0,0,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,2,Color(0,0,0,255))
	
	end
}
territories[4] = territories[4] or {
	Name = "Metal Factory",
	HubSpawns = "Metal",
	Min = Vector(6180.249023, -2999.526367, -199.968750),
	Max = Vector(6689.968750, -2442.475342, 54.833847),
	LabelPos = Vector(6168.968750, -2577.312500, -2.480301),
	LabelAngle = Angle(0,-90,90),
	Label = function()
		draw.RoundedBox(0,0,0,270,100,Color(0,0,0,255))
		draw.SimpleText("Metal Factory","TerritoryTitle",30,30,Color(255,255,255,255),TEXT_ALIGN_LEFT)
	end
}
--end)

level_experience = {}
level_experience[1] = 0
level_experience[2] = 500
level_experience[3] = 1500
level_experience[4] = 3000
level_experience[5] = 6000
level_experience[6] = 10000
level_experience[7] = 15000
level_experience[8] = 22000
level_experience[9] = 30000
level_experience[10] = 40000
level_experience[11] = 55000
level_experience[12] = 75000
level_experience[13] = 100000
level_experience[14] = 130000
level_experience[15] = 170000
level_experience[16] = 220000
level_experience[17] = 300000
level_experience[18] = 420000
level_experience[19] = 670000
level_experience[20] = 1000000

function GetMaxGangMembers(xp)
	return 5+CalculateLevel(xp)*2
end
function CalculateLevel(experience)
	local level = 0
	for i=1,20 do
		if experience < level_experience[i] then
			break
		end
		level = level + 1
		experience = experience - level_experience[i]
	end
	return level
end

function CalculateExperienceForLevel(level)
	local total = 0
	for i=1,level do
		total = total + level_experience[i]
	end
	return total
end

function CalculateExperienceThisLevel(experience)
	for i=1,20 do
		if experience < level_experience[i] then
			break
		end
		experience = experience - level_experience[i]
	end
	return experience
end


local ITEM = items.DefineItem("Unplanted Gang Hub")
ITEM.Group = "Gang Stuff"
ITEM.EntityClass = "darkland_item"
ITEM.Model = "models/props_wasteland/gaspump001a.mdl"
ITEM.Description = "Used to control other territories"
ITEM.Size = {2,3}
ITEM.Craftable = {"Metal",1}
ITEM.LookAt = Vector(0,0,20)
ITEM.CamPos = Vector(40,40,40)
ITEM.CanHold = true
ITEM.MenuAdds = function(menu,index)
	menu:AddOption("Plant Hub",function() RunConsoleCommand("plant_hub") end)
end


local ITEM = items.DefineItem("Standing Turret")
ITEM.Group = "Defense Systems"
ITEM.EntityClass = "turret"
ITEM.GunPosition = Vector(11.253671, 2.355192, 52.978268)
ITEM.Model = "models/combine_turrets/floor_turret.mdl"
ITEM.Description = "Used to defend your territory or your home"
ITEM.Size = {2,4}
ITEM.Watts = 600
ITEM.Craftable = {"Sensor Module",5,"Circuit Board",5,"Metal Plating",10,"Weapon Sights",1}
ITEM.LookAt = Vector(10,0,20)
ITEM.CamPos = Vector(35,20,20)
ITEM.CanHold = true
