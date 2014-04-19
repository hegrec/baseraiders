local meta = FindMetaTable("Player")

function loaddefaults(pl)
	pl:SetTeam(TEAM_CITIZENS)
	pl.Inventory 		= {}
	pl.Clothing 		= {}
	pl.CurrentClothing 	= {}
	pl.Skills 			= {}
	pl.Levels 			= {}
	pl.Cars 			= {}
	pl:SetMoney(DEFAULT_CASH)
	pl:SetExperience(0)
	pl:ChatPrint("Hold on...authenticating your profile!")
	pl:Lock()
end
hook.Add("PlayerInitialSpawn","loaddefaults",loaddefaults)

function BeginRPProfile(pl)
	--SET UP DEFAULTS IN CASE QUERY TAKES FOREVER
	local xmax,ymax = pl:GetInventorySize()
	for y=1,ymax do
		pl.Inventory[y] = {}
		for x=1,xmax do
			pl.Inventory[y][x] = false
		end
	end
	local steamID = pl:SteamID();
	print("loading profile")
	
	Query("SELECT Money,Inventory,Vehicle,Skills,Levels,Clothing,CurrentHat,CurrentSkin,Model,GangID,Experience FROM rp_playerdata WHERE SteamID='"..steamID.."'", function(res) RPLoadCallback(pl, res)  end)
end
hook.Add("PlayerLoadedGlobalProfile","zzzzzRPLoadProfile",BeginRPProfile)



function RPLoadCallback(pl, tbl)
	if pl.LoadedRolePlay then return end
	tbl = tbl[1]
	pl:UnLock()
	
	if !tbl then NewProfile(pl) return end
	print("existing profile")
	pl:SetMoney(tonumber(tbl["Money"]))
	pl:SetExperience(tonumber(tbl["Experience"]))
	if !tbl["Model"] or tbl["Model"] == "" then
		RequestModel(pl)
	end
	pl.Model = tbl["Model"]
	SendModel(pl)
	
	hook.Call("OnLoadSkills",GAMEMODE,pl,tbl["Skills"],tbl["Levels"])
	hook.Call("OnLoadInventory",GAMEMODE,pl,tbl["Inventory"])
	hook.Call("OnLoadClothing",GAMEMODE,pl,tbl["Clothing"],tbl["CurrentHat"],tbl["CurrentSkin"])
	hook.Call("OnLoadVehicles",GAMEMODE,pl,tbl["Vehicle"])
	hook.Call("OnLoadGang",GAMEMODE,pl,tonumber(tbl["GangID"]))
	pl:Spawn()
	pl.LoadedRolePlay = true -- Let the script know that vars can be accessed
	local steamid = pl:SteamID()
	timer.Create("SaveTimer_"..steamid,60,0,function() if !IsValid(pl) then timer.Destroy("SaveTimer_"..steamid) return end SaveRPAccount(pl) end)
	pl:ChatPrint("Profile loaded successfully :D")
end

--Player has no profile saved... Create a default one
function NewProfile(pl)
	print("new profile")
	Query("INSERT INTO rp_playerdata (SteamID,Inventory,Money,Skills,Levels,BankAccount,Clothing) VALUES (\'"..pl:SteamID().."\',\'\',"..DEFAULT_CASH..",\'\',\'\',\'\',\'\')")
	hook.Call("OnLoadSkills",GAMEMODE,pl,'','')
	hook.Call("OnLoadInventory",GAMEMODE,pl,'')
	hook.Call("OnLoadClothing",GAMEMODE,pl,'')
	hook.Call("OnLoadGang",GAMEMODE,pl,0)
	RequestModel(pl)
	pl.LoadedRolePlay = true -- Let the script know that vars can be accessed
	local steamid = pl:SteamID()
	timer.Create("SaveTimer_"..steamid,60,0,function() if !IsValid(pl) then timer.Destroy("SaveTimer_"..steamid) return end SaveRPAccount(pl) end)
	pl:ChatPrint("Welcome new player! Thanks for giving Base Raiders a try :D")
end

function SaveRPAccount(pl)
	if !IsValid(pl) then return end
	if !pl.LoadedRolePlay then return end
	
	local safemoney 	= pl:GetMoneyOffset()
	local safeinv 		= util.TableToKeyValues(pl.Inventory)
	local safeid 		= pl:SteamID()
	local skills 		= table.ToSave(pl.Skills)
	local levels 		= table.ToSave(pl.Levels)
	local clothing 		= table.ToSave(pl.Clothing)
	local model 		= pl.Model or ""
	local experience 		= pl:GetExperience() or ""
	
	if !safeinv or !skills or !levels then error("SOMETHING DIDN'T SAVE ---   Inv - "..tostring(safeinv).." Skills - "..tostring(skills).." Levels - "..tostring(levels)) return end
	Query("UPDATE rp_playerdata SET Money=Money+"..safemoney..",Experience="..experience..",Inventory=\'"..safeinv.."\',Skills=\'"..skills.."\',Levels=\'"..levels.."\',Clothing=\'"..clothing.."\',Model=\'"..model.."\' WHERE SteamID=\'"..safeid.."\'")
end
AddChatCommand("save",function(pl,args)pl.nextSave = pl.nextSave or 0 if pl.nextSave > CurTime() then return end pl.nextSave = CurTime()+5 SaveRPAccount(pl) pl:SendNotify("Your RP Account has successfully saved","NOTIFY_GENERIC",4) end)



function table.ToSave(tbl)
	if !tbl then return end
	local strings = {}
	for i,v in pairs(tbl) do
		table.insert(strings,i..":"..v)
	end
	
	return table.concat(strings,"|")
end

function table.ToLoad(str)
	str = str or ''
	--Load skills into a temp table
	local tbl = {}
	local t = string.Explode("|",str)
	for i,v in pairs(t) do
		local s = string.Explode(":",v)
		tbl[s[1]] = tonumber(s[2])
	end
	
	

	return tbl
end

