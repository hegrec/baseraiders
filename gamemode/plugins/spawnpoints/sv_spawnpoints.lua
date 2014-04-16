spawnpoints = spawnpoints or {}
spawnpoints.entities = spawnpoints.entities or {}
spawnpoints.positions = spawnpoints.positions or {}
function spawnpoints.AddSpawn(ply,args)
	if !ply:IsSuperAdmin() then return end
	local pos = ply:GetPos()
	local ent = ents.Create("darkland_spawn")
	ent:SetPos(pos)
	ent:Spawn()
	table.insert(spawnpoints.entities,ent)
	table.insert(spawnpoints.positions,pos)
	spawnpoints.SaveSpawns()
	ply:SendNotify("You added a spawnpoint","NOTIFY_ERROR",4)
end
AddChatCommand("addspawn",spawnpoints.AddSpawn)

function spawnpoints.SaveSpawns()
	local str = util.TableToKeyValues(table.Sanitise(spawnpoints.positions))
	file.Write("darklandrp/spawns/"..game.GetMap()..".txt",str)
end

local function MakeSpawn(w)
	local ent = ents.Create("darkland_spawn")
	ent:SetPos(w)
	ent:Spawn()
	table.insert(spawnpoints.entities,ent)
end
function spawnpoints.LoadSpawns()
	if file.Exists("darklandrp/spawns/"..game.GetMap()..".txt","DATA") then
		local str = file.Read("darklandrp/spawns/"..game.GetMap()..".txt","DATA")
		local tbl = table.DeSanitise(util.KeyValuesToTable(str))
		spawnpoints.positions = tbl

		
		local num = 0
		for i,v in pairs(spawnpoints.positions) do
			num=num+1
			timer.Simple(0.01*num,function() MakeSpawn(v) end)
		end
	end
end
hook.Add("InitPostEntity","LoadSpawns2",spawnpoints.LoadSpawns)




function spawnpoints.SelectSpawn(pl)
		
	local spawns = spawnpoints.entities
	--//First check for any entirely free spawnpoints
	for _, spawn in pairs( spawns ) do
		if ( spawn && spawn:IsValid() && spawn:IsInWorld() ) then
			local blockers = ents.FindInBox(spawn:GetPos() + Vector(-16, -16, 0), spawn:GetPos() + Vector(16, 16, 60))
			if (#blockers < 2) then return spawn end
		end
	end
	if #spawns > 0 then return spawns[math.random(#spawns)] end
	spawns = ents.FindByClass( "info_player_start" )
	if #spawns > 0 then
		local randomspawn = math.random(table.getn(spawns))
		return spawns[randomspawn]
	end
	spawns = ents.FindByClass( "gmod_player_start" )
	if #spawns > 0 then
		local randomspawn = math.random(table.getn(spawns))
		return spawns[randomspawn]
	end

	if #spawns == 0 then
		return nil
	end
	return nil
end
hook.Add("PlayerSelectSpawn","PickGoodSpawn",spawnpoints.SelectSpawn)

