properties = {}
properties.properties = {}
local temp = {}
local tempfloor = {}
function properties.Add(ply,args)
	if !ply:IsSuperAdmin() then return end
	local price = tonumber(args[1])
	table.remove(args,1)
	local name = table.concat(args," ")
	if !price || !name then ply:SendNotify("/addproperty <price> <name>","NOTIFY_ERROR",4) return end
	
	local num = table.insert(properties.properties,{})
	properties.properties[num].price = price
	properties.properties[num].owner = "None"
	properties.properties[num].name = name
	properties.properties[num].doors = {}
	properties.properties[num].floors = {}
	temp[ply] = properties.properties[num]
	ply:SendNotify("You started a property","NOTIFY_ERROR",4)
end
AddChatCommand("addproperty",properties.Add)

function properties.AddDoor(ply,args)
	if !ply:IsSuperAdmin() || !temp[ply] then return end
	
	table.insert(temp[ply].doors,ply:GetEyeTrace().Entity:EntIndex()-game.MaxPlayers())
	ply:SendNotify("You added a door to "..temp[ply].name,"NOTIFY_ERROR",4)
end
AddChatCommand("newdoor",properties.AddDoor)

function properties.FinishProperty(ply,args)
	if !ply:IsSuperAdmin() || !temp[ply] then return end
	for i,v in pairs(temp[ply].doors) do
		local ent = ents.GetByIndex(v+game.MaxPlayers())
		ent:Fire("Close","",0)
		ent:Fire("lock","",0.1)
		ent.Locked = true
		ent:SetNWBool("Property",true)
		ent:SetNWString("Title",temp[ply].name)
		ent:SetNWInt("Cost",temp[ply].price)
	end
	temp[ply] = nil
	properties.Save()
	ply:SendNotify("You added a property","NOTIFY_ERROR",4)
end
AddChatCommand("finishproperty",properties.FinishProperty)

function properties.Save()
	local str = util.TableToKeyValues(table.Sanitise(properties.properties))
	file.Write("darklandrp/properties/"..game.GetMap()..".txt",str)
end

function properties.Load()
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
			table.insert(properties.properties,temptbl)
			
		end
		for i,v in pairs(properties.properties) do
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
hook.Add("InitPostEntity","LoadProperties", properties.Load)

local meta = FindMetaTable("Entity")
function meta:IsProperty()
	for i,v in pairs(properties.properties) do
		if table.HasValue(v.doors,self:EntIndex()-game.MaxPlayers()) then
			return true
		end
	end
	return false
end

function FindPropertyNumByOwner(steamid)
	for i,v in pairs(properties.properties) do
		if v.owner == steamid then
			return i
		end
	end
	return nil
end

function GiveProperty(ply,ent)
	local num
	for i,v in pairs(properties.properties) do
		for q,w in pairs(v.doors) do
			if w == ent:EntIndex()-game.MaxPlayers() then
				num = i
			end
		end
	end
	properties.properties[num].owner = ply:SteamID()
	properties.Save()
	for i,v in pairs(properties.properties[num].doors) do
		local ent = ents.GetByIndex(v+game.MaxPlayers())
		ent.DoorOwner = ply:SteamID()
		ent:SetNWBool("Unownable",true)
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
	for i,v in pairs(properties.properties) do
		for q,w in pairs(v.doors) do
			if w == ent:EntIndex()-game.MaxPlayers() then
				num = i
			end
		end
	end
	properties.properties[num].owner = "None"
	properties.Save()
	for i,v in pairs(properties.properties[num].doors) do
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
	for i,v in pairs(properties.properties) do
		if (v.owner == pl:SteamID()) then
			for ii,vv in pairs(v.doors) do
				umsg.Start("boughtDoor",ply)
					umsg.Short(vv+game.MaxPlayers())
				umsg.End()
			end
		end
	end
end)





