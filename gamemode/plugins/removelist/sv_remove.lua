removelist = {}
removelist.indexs = {}
function removelist.AddRemove(ply,args)
	if !ply:IsSuperAdmin() then return "" end
	local tr = ply:GetEyeTrace()
	if(tr.Entity:IsValid() and tr.Entity:GetClass() != "World")then
	
		table.insert(removelist.indexs,tr.Entity:EntIndex()-game.MaxPlayers())
		tr.Entity:Remove()
		ply:SendNotify("You removed this item","NOTIFY_GENERIC",4)
	removelist.SaveList()
	else
		ply:SendNotify("You cannot remove this item","NOTIFY_ERROR",4)
	end
end
AddChatCommand("addremove",removelist.AddRemove)

function removelist.SaveList()
	local str = util.TableToKeyValues(removelist.indexs);
	file.Write("darklandrp/removelist/"..game.GetMap()..".txt",str)
end

function removelist.LoadList()
	if file.Exists("darklandrp/removelist/"..game.GetMap()..".txt","DATA")then
		local str = file.Read("darklandrp/removelist/"..game.GetMap()..".txt","DATA")
		for i,v in pairs(util.KeyValuesToTable(str)) do
			removelist.indexs[tonumber(i)] = v
		end
	end
	for i,v in pairs(removelist.indexs) do
		local ent = ents.GetByIndex(v+game.MaxPlayers())
		if ent:IsValid() then ent:Remove() end
	end
end
hook.Add("InitPostEntity","RemoveListLoad",function() removelist.LoadList() end)