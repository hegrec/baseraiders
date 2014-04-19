gangs = gangs or {}
hook.Add("Initialize","dfdsfasads",function()
gangs.gangcache = {}
end)
function gangs.CreateGang(pl,cmd,args)

	local name = args[1]
	if (pl:GetGangID()!=0) then 
		pl:SendNotify("Leave your current gang first","NOTIFY_ERROR",4)
		return 
	end
	if (pl:GetMoney()<GANG_CREATION_COST) then
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
function gangs.OnLoadPlayerGang(pl,gangID)
	if  gangID == 0 then
		pl:SetGangID(0)
		return
	end
	SendTerritoryInfo(pl)
	if gangs.gangcache[gangID] then
		pl:SetGangName(gangs.gangcache[gangID].Name)
		pl:SetGangID(gangID)
		
		if (gangs.gangcache[gangID].OwnerSteamID == pl:SteamID()) then
			pl:SetGangLeader(true)
		end
	else
	
		Query("SELECT d.PlayerName as name,d.SteamID as SteamID FROM rp_playerdata r JOIN da_misc d on r.SteamID=d.SteamID WHERE r.GangID="..gangID,function(res)
			if !res then return end
			if #res>0 then gangs.gangcache[gangID] = gangs.gangcache[gangID] or {} end
			gangs.gangcache[gangID].Members = {}
			for i,v in pairs(res) do
				table.insert(gangs.gangcache[gangID].Members,{Name=v.name,SteamID=v.SteamID})
			
			
			end
			
			
			Query("SELECT d.PlayerName as name FROM rp_gangdata r JOIN da_misc d on r.OwnerSteamID=d.SteamID WHERE r.ID="..gangID,function(res)
			if !res then return end
			gangs.gangcache[gangID].OwnerName = res[1].name
			end)
			
			end)


		Query("SELECT * FROM rp_gangdata WHERE ID="..gangID,function(res)
			res = res[1]
			if !res then return end
			
			local cachedID = tonumber(res.ID)
			
			
			gangs.gangcache[cachedID] = gangs.gangcache[cachedID] or {}
			gangs.gangcache[cachedID].Name = res.Name
			gangs.gangcache[cachedID].GangBank = util.JSONToTable(res.GangBank) or {}
			for i,v in pairs(gangs.gangcache[cachedID].GangBank) do
				if !GetItems()[i] then 
					gangs.gangcache[cachedID].GangBank[i] = nil
				end
			end
			gangs.gangcache[cachedID].Experience = tonumber(res.Experience)
			gangs.gangcache[cachedID].OwnerSteamID = res.OwnerSteamID
			pl:SetGangName(res.Name)
			pl:SetGangID(gangID)
			
			if (res.OwnerSteamID == pl:SteamID()) then
				pl:SetGangLeader(true)
			end
		end)
	end

end
hook.Add("OnLoadGang","PlayerLoadGang",gangs.OnLoadPlayerGang)

function gangs.LoadGangInfo(pl,cmd,args)

	if (pl:GetGangID() == 0) then 
	
	
	
	return end
	local g = gangs.gangcache[pl:GetGangID()]
	umsg.Start("sendGangInfo",pl)
	umsg.String(g.Name)
	umsg.String(g.OwnerName)
	umsg.Long(g.Experience)
	umsg.End()
	for i,v in pairs(g.Members) do
		umsg.Start("sendGangMember",pl)
			umsg.String(v.Name)
			umsg.String(v.SteamID)
		umsg.End()
	end
	
end
concommand.Add("load_gang_info",gangs.LoadGangInfo)
function gangs.ConfirmCreation(pl,name)
	local q = Query("INSERT INTO rp_gangdata (OwnerSteamID,Name) VALUES ('"..pl:SteamID().."','"..escape(name).."')",function(res,s,sss) 
		
		local lastID = tonumber(sss)
		Query("UPDATE rp_playerdata set GangID="..lastID.." WHERE SteamID='"..pl:SteamID().."'")
		pl:SetGangName(name)
		pl:SetGangID(lastID)
		pl:SetGangLeader(true)
		pl:AddMoney(-1*GANG_CREATION_COST)
		
		gangs.gangcache[lastID] = gangs.gangcache[lastID] or {}
		gangs.gangcache[lastID].Name = name
		gangs.gangcache[lastID].GangBank = {}
		gangs.gangcache[lastID].Experience = 0
		gangs.gangcache[lastID].Level = 1
		gangs.gangcache[lastID].OwnerSteamID = pl:SteamID()
		gangs.gangcache[lastID].Members = {Name=pl:Name(),SteamID=pl:SteamID()}
		
		
		gangs.LoadGangInfo(pl)
	end,QUERY_FLAG_LASTID)
end
gangs.ganginvites = {}
function gangs.InvitePlayer(pl,args)
	local playername = args[1]
	
	local ply = player.FindNameMatch(playername)
	
	if (pl:GetGangID() == 0) then pl:SendNotify("You are not in a gang","NOTIFY_ERROR",4) return end
	
	if (#gangs.gangcache[pl:GetGangID()].Members>=GetMaxGangMembers(gangs.gangcache[pl:GetGangID()].Experience)) then
		pl:SendNotify("Your gang can only support "..GetMaxGangMembers(gangs.gangcache[pl:GetGangID()].Experience).." members. Level up for more","NOTIFY_ERROR",4)
		return
	end
	if !ply then pl:SendNotify("Player '"..playername.."' not found","NOTIFY_ERROR",4) return end
	gangs.ganginvites[pl:GetGangID()] = gangs.ganginvites[pl:GetGangID()] or {}
	gangs.ganginvites[pl:GetGangID()][ply:EntIndex()] = true
	umsg.Start("invitedToGang",ply)
	umsg.String(pl:GetGangName())
	umsg.Short(pl:GetGangID())
	umsg.End()
	
	
end
AddChatCommand("invitegang",gangs.InvitePlayer)

function gangs.JoinGang(pl,cmd,args)
	local gang_id = tonumber(args[1])
	if (pl:GetGangID()!=0) then pl:SendNotify("You must leave your gang before joining another!","NOTIFY_ERROR",6) return end
	local found = false
	local invites
	for i,v in pairs(gangs.ganginvites) do
		if tonumber(i) == gang_id then found = true invites = v break end
	end
	if !found then pl:SendNotify("An error has occurred "..gang_id.." is not a valid gang id","NOTIFY_ERROR",6) return end
	found = false
	for i,v in pairs(invites) do
		if tonumber(i) == tonumber(pl:EntIndex()) then found = true break end
	end
	if !found then pl:SendNotify("Sorry you were not invited to join that gang!","NOTIFY_ERROR",6)  return end
	Query("UPDATE rp_playerdata set GangID="..gang_id.." WHERE SteamID='"..pl:SteamID().."'")
	pl:SetGangName(gangs.gangcache[gang_id].Name)
	pl:SetGangID(gang_id)
	table.insert(gangs.gangcache[gang_id].Members,{Name=pl:Name(),SteamID=pl:SteamID()})
	gangs.ganginvites[gang_id][pl:EntIndex()] = nil
	
end
concommand.Add("join_gang",gangs.JoinGang)
function gangs.LeaveGang(pl,cmd,args)
	if (pl:GetGangID()==0) then return end
	if pl:GetGangLeader() then 
		pl:SendNotify("You must declare a new leader before leaving or disband your gang altogether!","NOTIFY_ERROR",6)
		return
	end 
	for i,v in ipairs(gangs.gangcache[pl:GetGangID()].Members) do
		if v.SteamID == pl:SteamID() then
			table.remove(gangs.gangcache[pl:GetGangID()].Members,i)
			break
		end
	end
	
	
	pl:SetGangID(0)
	pl:SetGangName("")
	pl:SetGangLeader(false)
	
	Query("UPDATE rp_playerdata set GangID=0 WHERE SteamID='"..pl:SteamID().."'")
end
concommand.Add("leavegang",gangs.LeaveGang)

function gangs.GangKick(pl,cmd,args)
	if (pl:GetGangID()==0) then return end
	
	if !pl:GetGangLeader() then 
		pl:SendNotify("Only the gang leader can kick members","NOTIFY_ERROR",6)
		return
	end 
	local steamid = args[1]
	
	if (steamid == pl:SteamID()) then
		pl:SendNotify("You can not kick yourself from the gang","NOTIFY_ERROR",6)
		return
	end 
	local gang = gangs.gangcache[pl:GetGangID()]
	for i,v in pairs(gang.Members) do
		if v.SteamID == steamid then
			Query("UPDATE rp_playerdata set GangID=0 WHERE SteamID='"..steamid.."'")
			local ply = player.GetBySteamID(steamid)
			if ply and ply:IsValid() then
				ply:SetGangID(0)
				ply:SetGangName("")
				ply:SendNotify("You have been kicked from your gang","NOTIFY_GENERIC",10)
			end
			table.remove(gang.Members,i)
			break
		end
	end
end
concommand.Add("gang_kick",gangs.GangKick)


function gangs.UseGangBank(pl,cmd,args)
	local ent = ents.GetByIndex(args[1])
	if !pl:GetEyeTrace().Entity==ent then return end
	if ent:GetClass() != "gang_vault" then return end
	local gangID = ent:GetGangID()
	if gangID != pl:GetGangID() then pl:SendNotify("That is not your gang's vault! You may lock pick it however","NOTIFY_ERROR",4) return end
	local gang = gangs.gangcache[gangID]
	umsg.Start("sendGangBank",pl)
	umsg.String(gang.Name)
	umsg.End()
	for i,v in pairs(gang.GangBank) do
	umsg.Start("sendGangBankItem",pl)
		umsg.String(i)
		umsg.Short(v)
	umsg.End()
	end
end
concommand.Add("use_gang_bank",gangs.UseGangBank)
function gangs.ItemToHub(pl,cmd,args)
	local x = tonumber(args[1])
	local y = tonumber(args[2])
	local all = args[3] == "1"
	local amt = 1
	
	
	
	local item = pl:GetItem(x,y)
	local tbl = GetItems()[item]
	if !tbl then return end
	
	local hub = pl:GetEyeTrace().Entity 
	if hub:GetClass() != "gang_vault" then return end
	if hub:GetGangID() != pl:GetGangID() then pl:SendNotify("That is not your gang's vault!","NOTIFY_ERROR",4) return end
	if !pl:HasItem(item) then return end
	pl:TakeItem(x,y)
	local amt = 1
	if all then
		while(true) do
			x,y = pl:HasItem(item)
			if !x or !y then break end
			pl:TakeItem(x,y)
			amt = amt + 1
		end
	end
	
	
	local gangID = hub:GetGangID()
	local gang = gangs.gangcache[gangID]
	
	local found = false
	for i,v in pairs(gang.GangBank) do
		if i == item then
			found = true
			gang.GangBank[i] = gang.GangBank[i] + amt
			break
		end
	end
	if !found then gang.GangBank[item] = amt end
	
	for i,v in pairs(gang.GangBank) do
	umsg.Start("sendGangBankItem",pl)
		umsg.String(i)
		umsg.Short(v)
	umsg.End()
	end
	Query("UPDATE rp_gangdata set GangBank='"..escape(util.TableToJSON(gang.GangBank)).."' WHERE ID="..gangID)
end
concommand.Add("item_to_hub",gangs.ItemToHub)
function gangs.HubToInv(pl,cmd,args)
	local item = args[1]
	
	local tbl = GetItems()[item]
	if !tbl then return end
	
	local hub = pl:GetEyeTrace().Entity 
	if hub:GetClass() != "gang_vault" then return end
	if !pl:CanHold(item) then pl:SendNotify("You don't have room for that","NOTIFY_ERROR",3) return end
	if hub:GetGangID() != pl:GetGangID() then pl:SendNotify("That is not your gang's bank!","NOTIFY_ERROR",4) return end
	local gangID = hub:GetGangID()
	local gang = gangs.gangcache[gangID]
	local found = false
	for i,v in pairs(gang.GangBank) do
		if i == item && gang.GangBank[i] >= 1 then
			found = true
			gang.GangBank[i] = gang.GangBank[i] - 1
			if gang.GangBank[i] < 1 then
				gang.GangBank[i] = 0
			end
			break
		end
	end
	if (found) then
		pl:GiveItem(item)
	end
	for i,v in pairs(gang.GangBank) do
	umsg.Start("sendGangBankItem",pl)
		umsg.String(i)
		umsg.Short(v)
	umsg.End()
	end
	Query("UPDATE rp_gangdata set GangBank='"..escape(util.TableToJSON(gang.GangBank)).."' WHERE ID="..gangID)
end
concommand.Add("hub_to_inv",gangs.HubToInv)
function gangs.StealGangVaultItem(vault,plStealer)
	
	local gang = gangs.gangcache[vault:GetGangID()]

	local bank = gang.GangBank
	if table.Count(bank) < 1 then 
		plStealer:SendNotify("The gang vault was empty","NOTIFY_GENERIC",10)
		return end
	local types = {}
	for i,v in pairs(bank) do
		if v > 0 then
			table.insert(types,i)
		end
	end

	local stolenType = types[math.random(#types)];
	
	local tbl = GetItems()[stolenType]
	if !tbl then return end
	

	gang.GangBank[stolenType] = gang.GangBank[stolenType] - 1
	if gang.GangBank[stolenType] < 1 then
		gang.GangBank[stolenType] = 0
	end

	SpawnRoleplayItem(stolenType,vault:GetPos()+Vector(0,0,70))
	plStealer:SendNotify("You stole an item from the gang vault ("..stolenType..")","NOTIFY_GENERIC",10)
	Query("UPDATE rp_gangdata set GangBank='"..escape(util.TableToJSON(gang.GangBank)).."' WHERE ID="..vault:GetGangID())


end
function gangs.DisbandGang(pl,cmd,args)
	if (pl:GetGangID()==0) then return end
	if !pl:GetGangLeader() then 
		return
	end
	local gangID = pl:GetGangID()
	Query("UPDATE rp_playerdata set GangID=0 WHERE GangID="..gangID)
	Query("DELETE FROM rp_gangdata WHERE ID="..gangID)
	
	for i,v in pairs(player.GetAll()) do
		if v:GetGangID() == gangID then
			v:SetGangID(0)
			v:SetGangName("")
			v:SetGangLeader(false)
		end
	end
	
	SendUserMessage("gangDisbanded",pl)
end
concommand.Add("disbandgang",gangs.DisbandGang)

function gangs.PlantHub(pl,cmd,args)
	if (pl:GetGangID() == 0) then
		pl:SendNotify("You must be in a gang to plant a gang hub!","NOTIFY_ERROR",4)
		return
	end
	if (pl:GetNWInt("TerritoryID") == 0) then
		pl:SendNotify("You must plant your gang hub in a territory!","NOTIFY_ERROR",4)
		return
	end
	if (territories[pl:GetNWInt("TerritoryID")].ActiveHub and territories[pl:GetNWInt("TerritoryID")].ActiveHub:GetGangID() == pl:GetGangID()) then
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
	hub:SetGangID(pl:GetGangID())
	hub:SetGangName(pl:GetGangName())
	hub:SetNWInt("TerritoryID",pl:GetNWInt("TerritoryID"))
	hub:Spawn()
	
	
	
	
	if (territories[pl:GetNWInt("TerritoryID")].ActiveHub and territories[pl:GetNWInt("TerritoryID")].ActiveHub:IsValid()) then
		territories[pl:GetNWInt("TerritoryID")].ContestingHub = hub
		territories[pl:GetNWInt("TerritoryID")].ContestingGangName = pl:GetGangName()
		territories[pl:GetNWInt("TerritoryID")].ContestingGangID = pl:GetGangID()
	else
		territories[pl:GetNWInt("TerritoryID")].ActiveHub = hub	
		territories[pl:GetNWInt("TerritoryID")].CaptureTime = CurTime()
		territories[pl:GetNWInt("TerritoryID")].OwnerGangName = pl:GetGangName()
		territories[pl:GetNWInt("TerritoryID")].OwnerGangID = pl:GetGangID()
		
		
		gangs.AddGangExperience(hub:GetGangID(),25)
		local pos = hub:GetPos()+Vector(0,0,hub:OBBMaxs().z)
		umsg.Start("experienceUp")
			umsg.Vector(pos)
			umsg.Short(25)
		umsg.End()
		pl:AddExperience(50)
		umsg.Start("experienceUp")
			umsg.Vector(pl:EyePos()+(pl:GetAimVector()*25-Vector(0,0,10)))
			umsg.Short(50)
			umsg.Bool(pl:IsVIP())
		umsg.End()
		
		
	end
	
	
	SendTerritoryInfo()
end
concommand.Add("plant_hub",gangs.PlantHub)

local territory_entities = {}
function gangs.AddGangExperience(gangID,amt)
gangs.gangcache[gangID].Experience = gangs.gangcache[gangID].Experience + amt
Query("UPDATE rp_gangdata set Experience=Experience+"..amt.." WHERE ID="..gangID)
end

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
			gangs.AddGangExperience(hub:GetGangID(),1)
			local pos = hub:GetPos()+Vector(0,0,hub:OBBMaxs().z)
			umsg.Start("experienceUp")
				umsg.Vector(pos)
				umsg.Short(1)
			umsg.End()
		end
	
	end
end
timer.Create("g_HubSpawnResources",30,0,gangs.SpawnHUBResources)


function gangs.CaptureTerritory(territoryID,capturing_hub)
	local t = territories[territoryID]
	t.ContestingHub = nil
	t.ContestingGangName = nil
	t.ContestingGangID = nil
	t.ActiveHub:Explode()
	t.ActiveHub = capturing_hub
	
	
	t.CaptureTime = CurTime()
	t.OwnerGangName = capturing_hub:GetGangName()
	t.OwnerGangID = capturing_hub:GetGangID()
	gangs.AddGangExperience(capturing_hub:GetGangID(),100)
	local pos = capturing_hub:GetPos()+Vector(0,0,capturing_hub:OBBMaxs().z)
	
	local players = player.GetAll()
	for i,v in pairs(players) do
		if (v:GetGangID() == capturing_hub:GetGangID() and v:GetPos():Distance(capturing_hub:GetPos()) < 600) then
			v:AddExperience(100)
			umsg.Start("experienceUp")
				umsg.Vector(v:EyePos()+(v:GetAimVector()*25-Vector(0,0,10)))
				umsg.Short(100)
				umsg.Bool(v:IsVIP())
			umsg.End()
		end
	end
	
	

	SendTerritoryInfo()
end

function gangs.HoldTerritory(territoryID,defending_hub)

	local t = territories[territoryID]
	t.ContestingHub:Explode()
	t.ContestingHub = nil
	t.ContestingGangName = nil
	t.ContestingGangID = nil
	SendTerritoryInfo()
	gangs.AddGangExperience(defending_hub:GetGangID(),100)
	local pos = defending_hub:GetPos()+Vector(0,0,defending_hub:OBBMaxs().z)
	umsg.Start("experienceUp")
		umsg.Vector(pos)
		umsg.Short(100)
	umsg.End()
	
	
	
	local players = player.GetAll()
	for i,v in pairs(players) do
		if (v:GetGangID() == defending_hub:GetGangID() and v:GetPos():Distance(defending_hub:GetPos()) < 600) then
			v:AddExperience(100)
			umsg.Start("experienceUp")
				umsg.Vector(v:EyePos()+(v:GetAimVector()*25-Vector(0,0,10)))
				umsg.Short(100)
				umsg.Bool(v:IsVIP())
			umsg.End()
		end
	end
end


function SendTerritoryInfo(pl)

	if !pl then pl = player.GetAll() end
	for i,v in pairs(territories) do
		umsg.Start("sendTerritoryInfo",pl)
			umsg.Char(i)
			if v.ActiveHub and v.ActiveHub:IsValid() then
				umsg.Bool(true)
				umsg.String(v.OwnerGangName)
				umsg.Short(v.OwnerGangID)
				umsg.Long(v.CaptureTime)
				if v.ContestingHub and v.ContestingHub:IsValid() then
					umsg.Bool(true)
					umsg.String(v.ContestingGangName)
					umsg.Short(v.ContestingGangID)
				else
					umsg.Bool(false)
				end
			else
				umsg.Char(false)
			end
			
		umsg.End()
	end

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


function gangs.AddTerritoryDoor(ply,args)
	if !ply:IsSuperAdmin() then return end
	--Admin mod integration here? Possibly a global thing.
	
	local addremove = args[1]
	table.remove(args,1)
	
	local territoryID = tonumber(args[1])
	table.remove(args,1)

	if (!territoryID and addremove == "add") or !addremove then ply:SendNotify("Syntax is '/unownable <add|remove> <territory_id>'","NOTIFY_ERROR",4) return end
	local tr = ply:GetEyeTrace()
	local door = tr.Entity
	if !door:IsValid() or !door:IsDoor() then return end
	door:SetNWInt("Territory",territoryID)
	territories[territoryID].doors = territories[territoryID].doors or {}
	if addremove == "add" then
	

		territories[territoryID].doors[door:EntIndex()-game.MaxPlayers()] = 1
	elseif addremove == "remove" then

		territories[territoryID].doors[door:EntIndex()-game.MaxPlayers()] = nil
	end
	
	//Do Reset Owners
	gangs.SaveTerritoryDoors()
end
AddChatCommand("territorydoor",gangs.AddTerritoryDoor)

function gangs.SaveTerritoryDoors()

	local tblsave = {}
	for i,v in pairs(territories) do
		if v.doors then
			tblsave[i] = v.doors
		end
	end



	local str = util.TableToKeyValues(tblsave)
	file.Write("darklandrp/territories/"..game.GetMap()..".txt",str)
end

function gangs.LoadTerritoryDoors()
	if file.Exists("darklandrp/territories/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/territories/"..game.GetMap()..".txt", "DATA")
		local tbl = util.KeyValuesToTable(str)
		for i,v in pairs(tbl) do
			territories[i].doors = v
		end
		for q,w in pairs(territories) do
			if w.doors then
				for ndx,one in pairs(w.doors) do
					local v = ents.GetByIndex(ndx+game.MaxPlayers())
					v:SetNWInt("Territory",q)
					v:Fire("unlock","",1)
				end
			end
		end
	end
end
--TERRITORY STUFF
function gangs.LoadTerritories()
	gangs.LoadTerritoryDoors()
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
	power_plant = ents.Create("power_furnace")
	power_plant:SetPos(pos)
	power_plant:SetMaxVector(start)
	power_plant:SetMinVector(endpos)
	power_plant:SetMarker(name)
	power_plant:Spawn()

end
hook.Add("InitPostEntity","loadterritories",gangs.LoadTerritories)