local vending = {}
vending.entities = {}

function vending.AddSpawn(ply,args)
	if !ply:IsSuperAdmin() then return end
	local ent = ents.Create("vendingmachine")
	ent:Spawn()
	local z = ent:OBBMaxs().z
	ent:SetPos(ply:GetPos()+Vector(0,0,z))
	ent:SetAngles(Angle(0.1,ply:EyeAngles().y,0.1)) --fixes it always facing  one direction (bug in sanitize)
	table.insert(vending.entities,ent)

	vending.SaveSpawns()
	ply:SendNotify("You added a vending machine","NOTIFY_GENERIC",4)
end
AddChatCommand("addvending",vending.AddSpawn)

function vending.SaveSpawns()
	local t = {}
	local num=1
	for i,v in pairs(vending.entities) do 
		t[num] = {}
		t[num]["pos"] = v:GetPos()
		t[num]["angle"] = v:GetAngles()
		num=num+1
	end
	local str = util.TableToKeyValues(table.Sanitise(t))
	file.Write("darklandrp/vendingspawns/"..game.GetMap()..".txt",str)
end

function vending.LoadSpawns()
	if file.Exists("darklandrp/vendingspawns/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/vendingspawns/"..game.GetMap()..".txt", "DATA")
		local tbl = table.DeSanitise( util.KeyValuesToTable(str))
		for i,v in pairs(tbl) do
			local ent = ents.Create("vendingmachine")
			ent:Spawn()
			ent:SetPos(v.pos)
			ent:SetAngles(v.angle)
			
			table.insert(vending.entities,ent)
		end
	end
end
hook.Add("InitPostEntity","VendingLoadSpawns",vending.LoadSpawns)