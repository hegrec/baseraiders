brproperties = brproperties or {}
brproperties.properties = brproperties.properties or {}

local temp = {}
local tempfloor = {}
function brproperties.Add(ply,args)
	if !ply:IsSuperAdmin() then return end
	local price = tonumber(args[1])
	table.remove(args,1)
	local rent = tonumber(args[1]) == 1
	table.remove(args,1)
	local name = table.concat(args," ")
	if !price || !name then ply:SendNotify("/addproperty <price> <rent 0|1> <name>","NOTIFY_ERROR",4) return end
	
	local num = table.insert(brproperties.properties,{})
	brproperties.properties[num].price = price
	brproperties.properties[num].owner = "None"
	brproperties.properties[num].rent = rent
	brproperties.properties[num].name = name
	brproperties.properties[num].doors = {}
	brproperties.properties[num].sockets = {}
	temp[ply] = brproperties.properties[num]
	ply:SendNotify("You started a property","NOTIFY_ERROR",4)
end
AddChatCommand("addproperty",brproperties.Add)

function brproperties.AddSocket(ply,args)
	if !ply:IsSuperAdmin() || !temp[ply] then return end
	
	local tr = ply:GetEyeTrace()
	
	
	local ent = ents.Create("power_socket")
	ent:SetPos(tr.HitPos+tr.HitNormal*5)
	ent:SetAngles(tr.HitNormal:Angle())
	ent:Spawn()	
	table.insert(temp[ply].sockets,{tr.HitPos+tr.HitNormal*5,tr.HitNormal:Angle()})
	ply:SendNotify("You added a socket to "..temp[ply].name,"NOTIFY_ERROR",4)
end
AddChatCommand("addpropertysocket",brproperties.AddSocket)

function brproperties.AddDoor(ply,args)
	if !ply:IsSuperAdmin() || !temp[ply] then return end
	
	table.insert(temp[ply].doors,ply:GetEyeTrace().Entity:EntIndex()-game.MaxPlayers())
	ply:SendNotify("You added a door to "..temp[ply].name,"NOTIFY_ERROR",4)
end
AddChatCommand("newdoor",brproperties.AddDoor)

function brproperties.FinishProperty(ply,args)
	if !ply:IsSuperAdmin() || !temp[ply] then return end
	for i,v in pairs(temp[ply].doors) do
		local ent = ents.GetByIndex(v+game.MaxPlayers())
		ent:Fire("Close","",0)
		ent:Fire("lock","",0.1)
		ent.Locked = true
		ent:SetNWBool("Property",true)
		if temp[ply].rent then
			ent:SetNWBool("Rental",true)
		end
		ent:SetNWString("Title",temp[ply].name)
		ent:SetNWInt("Cost",temp[ply].price)
	end
	temp[ply] = nil
	brproperties.Save()
	ply:SendNotify("You added a property","NOTIFY_ERROR",4)
end
AddChatCommand("finishproperty",brproperties.FinishProperty)

function brproperties.Save()
	local str = util.TableToKeyValues(table.Sanitise(brproperties.properties))
	file.Write("darklandrp/properties/"..game.GetMap()..".txt",str)
end

function brproperties.Load()
	brproperties.properties = {}
	
	if file.Exists("darklandrp/properties/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/properties/"..game.GetMap()..".txt", "DATA")
		local tbl = util.KeyValuesToTable(str)
		tbl = table.DeSanitise(tbl)
		
		for i,v in pairs(tbl) do
			local temptbl = {}
			temptbl.price = tonumber(v.price)
			temptbl.owner = v.owner
			temptbl.name = v.name
			temptbl.doors = {}
			for i,v in pairs(v.doors) do
				table.insert(temptbl.doors,tonumber(v))
			end
			temptbl.sockets = {}
			for i,v in pairs(v.sockets) do
			
				local ent = ents.Create("power_socket")
				ent:SetPos(v[1])
				ent:SetAngles(v[2])
				ent:Spawn()	
				table.insert(temptbl.sockets,tonumber(v))
			end
			table.insert(brproperties.properties,temptbl)
			
		end
		for i,v in pairs(brproperties.properties) do
			for q,w in pairs(v.doors) do
				local ent = ents.GetByIndex(w+game.MaxPlayers())
			 	ent:Fire("lock","",0)
				ent.Locked = true
				if v.owner != "None" then
					ent.DoorOwner = v.owner
					ent:SetNWBool("Unownable",true)
					ent:SetNWBool("Bought",true)
				end
				ent:SetNWBool("Property",true)
				
				ent:SetNWString("Title",v.name)
				ent:SetNWInt("Cost",v.price)
			end
		end
				
	end
end
hook.Add("InitPostEntity","LoadProperties", brproperties.Load)

local meta = FindMetaTable("Entity")
function meta:IsProperty()
	for i,v in pairs(brproperties.properties) do
		if table.HasValue(v.doors,self:EntIndex()-game.MaxPlayers()) then
			return true
		end
	end
	return false
end

function FindPropertyNumByOwner(steamid)
	for i,v in pairs(brproperties.properties) do
		if v.owner == steamid then
			return i
		end
	end
	return nil
end

function GiveProperty(ply,ent)
	local num
	for i,v in pairs(brproperties.properties) do
		for q,w in pairs(v.doors) do
			if w == ent:EntIndex()-game.MaxPlayers() then
				num = i
			end
		end
	end
	if !brproperties.properties[num].rent then
		brproperties.properties[num].owner = ply:SteamID()
		brproperties.Save()
	else
		brproperties.properties[num].renter = ply:SteamID()
	end
	for i,v in pairs(brproperties.properties[num].doors) do
		local ent = ents.GetByIndex(v+game.MaxPlayers())
		ent.DoorOwner = ply:SteamID()
		ent:SetNWBool("Bought",true)
		ply:GiveObject(ent)
		umsg.Start("boughtDoor",ply)
			umsg.Short(ent:EntIndex())
		umsg.End()
	end
	ply:SendNotify("Congratulations! You have just acquired a property!","NOTIFY_GENERIC",4)
end

function TakeProperty(ply,ent)
	local num
	for i,v in pairs(brproperties.properties) do
		for q,w in pairs(v.doors) do
			if w == ent:EntIndex()-game.MaxPlayers() then
				num = i
			end
		end
	end
	brproperties.properties[num].owner = "None"
	brproperties.Save()
	for i,v in pairs(brproperties.properties[num].doors) do
		local ent = ents.GetByIndex(v+game.MaxPlayers())
		ent:Fire("Close","",0)
		ent:Fire("lock","",0.1)
		ent.Locked = true
		ent.DoorOwner = ""
		ent:SetNWBool("Unownable",false)
		timer.Simple(1,function() ent:SetNWBool("Unownable",nil) end)
	end
	ply:SendNotify("You have just sold a property!","NOTIFY_GENERIC",4)
end

hook.Add("PlayerInitialSpawn","GivePropertyRights",function(pl)
	brproperties.properties = brproperties.properties or {}
	for i,v in pairs(brproperties.properties) do
		if (v.owner == pl:SteamID()) then
			for ii,vv in pairs(v.doors) do
				umsg.Start("boughtDoor",ply)
					umsg.Short(vv+game.MaxPlayers())
				umsg.End()
			end
		end
	end
end)





