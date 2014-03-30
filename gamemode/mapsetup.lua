
hook.Add("InitPostEntity","CraftingTable",
	function() 

		local ent = ents.Create("crafting_table")
		ent:SetPos(Vector(260.510040, 3460.147461, -50.968750))
		ent:SetAngles(Angle(0,90,0))
		ent:Spawn()
		ent:Activate()
		
		
		local ent = ents.Create("smelting_furnace")
		ent:SetPos(Vector(157.510040, 3460.147461, -36.968750))
		ent:SetAngles(Angle(0,90,0))
		ent:Spawn()
		ent:Activate()
	end
)