
hook.Add("InitPostEntity","CraftingTable",
	function() 

		local ent = ents.Create("crafting_table")
		ent:SetPos(Vector(272.886475, 3486.694580, -194.968750))
		ent:SetAngles(Angle(0,0,0))
		ent:Spawn()
		
		
		local ent = ents.Create("smelting_furnace")
		ent:SetPos(Vector(272.886475, 3586.694580, -180))
		ent:SetAngles(Angle(0,0,0))
		ent:Spawn()
	end
)