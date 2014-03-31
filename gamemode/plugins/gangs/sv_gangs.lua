gangs = {}

function gangs.CreateGang(pl,cmd,args)

	local name = args[1]
	if (pl:GetNWInt("GangID")!=0) then 
		pl:SendNotify("Leave your current gang first","NOTIFY_ERROR",4)
		return 
	end
	if (pl:GetMoney()<GANG_CREATION_COST and false) then
		pl:SendNotify("You need $"..GANG_CREATION_COST.." to create a gang","NOTIFY_ERROR",4)
		return
	end
	Query("SELECT * FROM rp_gangdata WHERE Name='"..escape(name).."'",function(res)
		
		if (#res>0) then 
			pl:SendNotify("A gang with that name already exists!","NOTIFY_ERROR",4)
			return
		end
		gangs.ConfirmCreation(pl,name)
	end)
end
concommand.Add("creategang",gangs.CreateGang)


local insertIDHolder = {}
function gangs.ConfirmCreation(pl,name)
	local q = Query("INSERT INTO rp_gangdata (OwnerSteamID,Name) VALUES ('"..pl:SteamID().."','"..escape(name).."')",function(res,s,sss) 

		
		local lastID = insertIDHolder[pl]:lastInsert()
		insertIDHolder[pl] = nil
		Query("UPDATE rp_playerdata set GangID="..lastID.." WHERE SteamID='"..pl:SteamID().."'")
		pl:SetNWString("GangName",name)
		pl:SetNWInt("GangID",lastID)
		pl:SetNWBool("GangLeader",true)
	end)
	insertIDHolder[pl] = q
end


function gangs.LeaveGang(pl,cmd,args)
	if (pl:GetNWInt("GangID")==0) then return end
	Query("UPDATE rp_playerdata set GangID=0 WHERE SteamID='"..pl:SteamID().."'")
end
concommand.Add("leavegang",gangs.LeaveGang)

function gangs.DisbandGang(pl,cmd,args)
	if (pl:GetNWInt("GangID")==0) then return end
	local gangID = pl:GetNWInt("GangID")
	Query("UPDATE rp_playerdata set GangID=0 WHERE GangID="..gangID)
	Query("DELETE FROM rp_gangdata WHERE ID="..gangID)
	
	for i,v in pairs(player.GetAll()) do
		if v:GetNWInt("GangID") == gangID then
			v:SetNWInt("GangID",0)
			v:SetNWString("GangName","")
			v:SetNWBool("GangLeader",false)
		end
	end
end
concommand.Add("disbandgang",gangs.DisbandGang)

function gangs.PlantHub(pl,cmd,args)
	if (pl:GetNWInt("TerritoryID") == 0) then
		pl:SendNotify("You must plant your gang hub in a territory!","NOTIFY_ERROR",4)
		return
	end
	if (pl:GetNWInt("GangID") == 0) then
		pl:SendNotify("You must be in a gang to plant a gang hub!","NOTIFY_ERROR",4)
		return
	end
	if (territories[pl:GetNWInt("TerritoryID")].ActiveHub and territories[pl:GetNWInt("TerritoryID")].ActiveHub.gangID == pl:GetNWInt("GangID")) then
		pl:SendNotify("Your gang already owns this territory","NOTIFY_ERROR",4)
		return
	end
	
	
	local hub = ents.Create("planted_gang_hub")
	local tr = {}
	tr.start = pl:GetShootPos()
	tr.endpos = tr.start + pl:GetAimVector()*100
	tr.filter = player.GetAll()
	tr = util.TraceLine(tr)
	
	
	
	local tr2 = {}
	tr2.start = tr.HitPos
	tr2.endpos = tr2.start - Vector(0,0,1000)
	tr2.filter = player.GetAll()
	tr2 = util.TraceLine(tr2)
	

	hub:SetPos(tr2.HitPos)
	hub:SetOwningGang(pl:GetNWInt("GangID"))
	hub:SetTerritory(pl:GetNWInt("TerritoryID"))
	hub:Spawn()
	
	local x,y = pl:HasItem("Gang Hub")
	pl:TakeItem(x,y)
	
	territories[pl:GetNWInt("TerritoryID")].ActiveHub = hub
	SetGlobalString("t_owner_"..pl:GetNWInt("TerritoryID"),pl:GetNWString("GangName"))
end
concommand.Add("plant_hub",gangs.PlantHub)

function gangs.OnLoadPlayerGang(pl,gangID)
	Query("SELECT * FROM rp_gangdata WHERE ID="..gangID,function(res)
		res = res[1]
		PrintTable(res)
		print(gangID)
		pl:SetNWString("GangName",res.Name)
		pl:SetNWInt("GangID",gangID)
		
		if (res.OwnerSteamID == pl:SteamID()) then
			pl:SetNWBool("GangLeader",true)
		end
	end)
end
hook.Add("OnLoadGang","PlayerLoadGang",gangs.OnLoadPlayerGang)
--TERRITORY STUFF
function gangs.LoadTerritories()
	for i,v in pairs(territories) do
		local center = (v.Max + v.Min)/2
		local tr = {}
		tr.start = center
		tr.endpos = center - Vector(0,0,1000)
		tr = util.TraceLine(tr)
		local pos = tr.HitPos
		local start = v.Min-tr.HitPos
		local endpos = v.Max-tr.HitPos
		local name = v.Name
		local ent = ents.Create("territory_collide")
		ent:SetPos(pos)
		ent.TerritoryID = i
		ent:SetMaxVector(start)
		ent:SetMinVector(endpos)
		ent:SetMarker(name)
		ent:Spawn()
	end
	
	local center = (territories[1].MaxFurnace + territories[1].MinFurnace)/2
	local tr = {}
	tr.start = center
	tr.endpos = center - Vector(0,0,1000)
	tr = util.TraceLine(tr)
	local pos = tr.HitPos
	local start = territories[1].MinFurnace-tr.HitPos
	local endpos = territories[1].MaxFurnace-tr.HitPos
	local name = "Power Plant"
	local ent = ents.Create("power_furnace")
	ent:SetPos(pos)
	ent:SetMaxVector(start)
	ent:SetMinVector(endpos)
	ent:SetMarker(name)
	ent:Spawn()

end
hook.Add("InitPostEntity","loadterritories",gangs.LoadTerritories)