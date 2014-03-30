local meta = FindMetaTable("Player")

function BeginRPProfile(pl)
	--SET UP DEFAULTS IN CASE QUERY TAKES FOREVER
	pl:SetTeam(TEAM_CITIZENS)
	pl.Inventory 		= {}
	pl.Clothing 		= {}
	pl.CurrentClothing 	= {}
	pl.Skills 			= {}
	pl.Levels 			= {}
	pl.Cars 			= {}
	pl.TotalWeight 		= 0
	pl:SetMoney(DEFAULT_CASH)
	
	local steamID = pl:SteamID();
	
	
	Query("SELECT Money,Inventory,Vehicle,Skills,Levels,Clothing,CurrentHat,CurrentSkin,Model FROM rp_playerdata WHERE SteamID='"..steamID.."'", function(res) RPLoadCallback(pl, res) end)
end
hook.Add("PlayerInitialSpawn","RPLoadProfile",BeginRPProfile)



function RPLoadCallback(pl, tbl)
	if pl.LoadedRolePlay then return end
	tbl = tbl[1]
	if !tbl then NewProfile(pl) return end
	pl:SetMoney(tonumber(tbl["Money"]))
	if !tbl["Model"] or tbl["Model"] == "" then
		RequestModel(pl)
	end
	pl.Model = tbl["Model"]
	SendModel(pl)
	hook.Call("OnLoadSkills",GAMEMODE,pl,tbl["Skills"],tbl["Levels"])
	hook.Call("OnLoadInventory",GAMEMODE,pl,tbl["Inventory"])
	hook.Call("OnLoadClothing",GAMEMODE,pl,tbl["Clothing"],tbl["CurrentHat"],tbl["CurrentSkin"])
	hook.Call("OnLoadVehicles",GAMEMMODE,pl,tbl["Vehicle"])
	pl:Spawn()
	pl.LoadedRolePlay = true -- Let the script know that vars can be accessed
	local steamid = pl:SteamID()
	timer.Create("SaveTimer_"..steamid,60,0,function() if !IsValid(pl) then timer.Destroy("SaveTimer_"..steamid) return end SaveRPAccount(pl) end)
end

--Player has no profile saved... Create a default one
function NewProfile(pl)
	Query("INSERT INTO rp_playerdata (SteamID,Inventory,Money,Skills,Levels,BankAccount,Clothing) VALUES (\'"..pl:SteamID().."\',\'\',"..DEFAULT_CASH..",\'\',\'\',\'\',\'\')")
	hook.Call("OnLoadSkills",GAMEMODE,pl,'','')
	hook.Call("OnLoadInventory",GAMEMODE,pl,'')
	hook.Call("OnLoadClothing",GAMEMODE,pl,'')
	RequestModel(pl)
	pl.LoadedRolePlay = true -- Let the script know that vars can be accessed
	local steamid = pl:SteamID()
	timer.Create("SaveTimer_"..steamid,60,0,function() if !IsValid(pl) then timer.Destroy("SaveTimer_"..steamid) return end SaveRPAccount(pl) end)
end

function SaveRPAccount(pl)
	if !pl.LoadedRolePlay then return end
	
	local safemoney 	= pl:GetMoneyOffset()
	local safeinv 		= table.ToSave(pl.Inventory)
	local safeid 		= pl:SteamID()
	local skills 		= table.ToSave(pl.Skills)
	local levels 		= table.ToSave(pl.Levels)
	local clothing 		= table.ToSave(pl.Clothing)
	local model 		= pl.Model or ""
	
	if !safeinv or !skills or !levels then error("SOMETHING DIDN'T SAVE ---   Inv - "..tostring(safeinv).." Skills - "..tostring(skills).." Levels - "..tostring(levels)) return end
	Query("UPDATE rp_playerdata SET Money=Money+"..safemoney..",Inventory=\'"..safeinv.."\',Skills=\'"..skills.."\',Levels=\'"..levels.."\',Clothing=\'"..clothing.."\',Model=\'"..model.."\' WHERE SteamID=\'"..safeid.."\'")
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
