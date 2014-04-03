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
	if pl:GetNWBool("GangLeader") then 
		pl:SendNotify("You must declare a new leader before leaving or disband your gang altogether!","NOTIFY_ERROR",6)
		return
	end 
	pl:SetNWInt("GangID",0)
	pl:SetNWString("GangName","")
	pl:SetNWBool("GangLeader",false)
	Query("UPDATE rp_playerdata set GangID=0 WHERE SteamID='"..pl:SteamID().."'")
end
concommand.Add("leavegang",gangs.LeaveGang)

function gangs.DisbandGang(pl,cmd,args)
	if (pl:GetNWInt("GangID")==0) then return end
	if !pl:GetNWBool("GangLeader") then 
		return
	end
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
	if (pl:GetNWInt("GangID") == 0) then
		pl:SendNotify("You must be in a gang to plant a gang hub!","NOTIFY_ERROR",4)
		return
	end
	if (pl:GetNWInt("TerritoryID") == 0) then
		pl:SendNotify("You must plant your gang hub in a territory!","NOTIFY_ERROR",4)
		return
	end
	if (territories[pl:GetNWInt("TerritoryID")].ActiveHub and territories[pl:GetNWInt("TerritoryID")].ActiveHub:GetGangID() == pl:GetNWInt("GangID")) then
		pl:SendNotify("Your gang already controls this territory","NOTIFY_ERROR",4)
		return
	end
	local x,y = pl:HasItem("Unplanted Gang Hub")
	if !x or !y then return end
	pl:TakeItem(x,y)
	
	local hub = ents.Create("planted_gang_hub")
	local tr = {}
	tr.start = pl:GetShootPos()
	tr.endpos = tr.start + pl:GetAimVector()*100
	tr.filter = player.GetAll()
	tr = util.TraceLine(tr)
	
	--if there is a hub and it is not the planter's initiate contest mode only if a contest is not in place
	if (territories[pl:GetNWInt("TerritoryID")].ActiveHub and territories[pl:GetNWInt("TerritoryID")].ContestingHub) then
		pl:SendNotify("A power struggle is already occurring! Wait for things to return to normal","NOTIFY_ERROR",4)
		return
	end
	
	local tr2 = {}
	tr2.start = tr.HitPos
	tr2.endpos = tr2.start - Vector(0,0,1000)
	tr2.filter = player.GetAll()
	tr2 = util.TraceLine(tr2)
	

	hub:SetPos(tr2.HitPos)
	hub:SetGangID(pl:GetNWInt("GangID"))
	hub:SetGangName(pl:GetNWString("GangName"))
	hub:SetNWInt("TerritoryID",pl:GetNWInt("TerritoryID"))
	hub:Spawn()
	
	
	
	
	if (territories[pl:GetNWInt("TerritoryID")].ActiveHub and territories[pl:GetNWInt("TerritoryID")].ActiveHub:IsValid()) then
		territories[pl:GetNWInt("TerritoryID")].ContestingHub = hub
		SetGlobalString("t_contester_"..pl:GetNWInt("TerritoryID"),pl:GetNWString("GangName"))
		SetGlobalString("t_contester_id_"..pl:GetNWInt("TerritoryID"),pl:GetNWString("GangID"))
	else
		territories[pl:GetNWInt("TerritoryID")].ActiveHub = hub
		SetGlobalInt("t_holdstart_"..pl:GetNWInt("TerritoryID"),CurTime())
		SetGlobalString("t_owner_"..pl:GetNWInt("TerritoryID"),pl:GetNWString("GangName"))
		SetGlobalString("t_owner_id_"..pl:GetNWInt("TerritoryID"),pl:GetNWString("GangID"))
	end
end
concommand.Add("plant_hub",gangs.PlantHub)

local territory_entities = {}


function gangs.SpawnHUBResources()
	for i,v in pairs(territories) do
		local hub = v.ActiveHub
		if hub and hub:IsValid() and !v.ContestingHub then
			
			
			territory_entities[i] = territory_entities[i] or {}
			local leftover = {}
			for i,v in ipairs(territory_entities[i]) do
				if v:IsValid() then
					table.insert(leftover,v)
				end
			end
			territory_entities[i] = leftover
			if #territory_entities[i] < 5 then
				local pos = hub:GetPos()+hub:GetForward()*hub:OBBMaxs():Length()+Vector(0,0,10)
				
				local tr = {}
				tr.start = pos
				tr.endpos = pos + Vector(0,0,1000)
				tr.filter = territory_entities[i]
				tr = util.TraceLine(tr)
				
				
				local tr2 = {}
				tr2.start = tr.HitPos-Vector(0,0,1)
				tr2.endpos = pos - Vector(0,0,3000)
				tr2 = util.TraceLine(tr2)
				
				
				
				
				local ent = SpawnRoleplayItem(v.HubSpawns,tr2.HitPos)
				table.insert(territory_entities[i],ent)
			end
		end
	end
end
timer.Create("g_HubSpawnResources",30,0,gangs.SpawnHUBResources)


function gangs.CaptureTerritory(territoryID,capturing_hub)
	local t = territories[territoryID]
	t.ContestingHub = nil
	t.ActiveHub:Explode()
	t.ActiveHub = capturing_hub
	SetGlobalInt("t_holdstart_"..territoryID,CurTime())
	SetGlobalString("t_contester_"..territoryID,"")
	SetGlobalString("t_contester_id_"..territoryID,0)
	SetGlobalString("t_owner_"..territoryID,capturing_hub:GetGangName())
	SetGlobalString("t_owner_id_"..territoryID,capturing_hub:GetGangID())
end

function gangs.HoldTerritory(territoryID,defending_hub)

	local t = territories[territoryID]
	t.ContestingHub:Explode()
	t.ContestingHub = nil
	SetGlobalString("t_contester_"..territoryID,"")
	SetGlobalString("t_contester_id_"..territoryID,0)
end


function gangs.ChargeContestingHubs()

	for i,v in pairs(territories) do
		local contesting_hub = v.ContestingHub
		if (contesting_hub and contesting_hub:IsValid()) then
			if contesting_hub:Charge() then
				gangs.CaptureTerritory(i,contesting_hub)
			elseif v.ActiveHub:Charge() then
				gangs.HoldTerritory(i,v.ActiveHub)
			end
		end
	end
end
timer.Create("g_ChargeContestingHubs",0.1,0,gangs.ChargeContestingHubs)
function gangs.OnLoadPlayerGang(pl,gangID)
	Query("SELECT * FROM rp_gangdata WHERE ID="..gangID,function(res)
		res = res[1]
		if res then
			pl:SetNWString("GangName",res.Name)
			pl:SetNWInt("GangID",gangID)
			
			if (res.OwnerSteamID == pl:SteamID()) then
				pl:SetNWBool("GangLeader",true)
			end
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