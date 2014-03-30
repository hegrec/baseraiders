 function titlecase(str)
    local buf = {}
    for word in string.gmatch(str, "%S+") do          
        local first, rest = string.sub(word, 1, 1), string.sub(word, 2)
        table.insert(buf, string.upper(first) .. string.lower(rest))
    end    
    return table.concat(buf, " ")
end 
 
local doors = {}
doors.Unownables = {}

local meta = FindMetaTable("Entity")
function meta:IsUnownable()
	local entindex = tostring(self:EntIndex()-game.MaxPlayers())
	for i,v in pairs(doors.Unownables) do
		if i == entindex then
			return true
		end
	end
	return false
end

function doors.AddUnownable(ply,args)
	if !ply:IsSuperAdmin() then return end
	--Admin mod integration here? Possibly a global thing.
	
	local addremove = args[1]
	table.remove(args,1)
	
	local locked = args[1]
	table.remove(args,1)
	
	local title = table.concat(args," ")
	if (!(title or locked) and addremove == "add") or !addremove then ply:SendNotify("Syntax is '/unownable <add|remove> <0|1> <title>'","NOTIFY_ERROR",4) return end
	local tr = ply:GetEyeTrace()
	local door = tr.Entity
	if !door:IsValid() or !door:IsDoor() then return end
	
	if addremove == "add" then
	
		door:SetNWBool("Unownable",true)
		door:SetNWString("Title",title)
		
		local str = "unlock"
		if locked == "1" then str = "lock" end
		door:Fire(str,"",0)
		doors.Unownables[door:EntIndex()-game.MaxPlayers()] = {title,locked}
	elseif addremove == "remove" then
		door:SetNWBool("Unownable",false)
		door:SetNWString("Title",DEFAULT_DOOR_TITLE)
		timer.Simple(1,function()
		door:SetNWBool("Unownable",nil)
		door:SetNWString("Title",nil)
		end)
		doors.Unownables[door:EntIndex()-game.MaxPlayers()] = nil
	end
	//Do Reset Owners
	doors.SaveUnownables()
end
AddChatCommand("unownable",doors.AddUnownable)

function doors.SaveUnownables()
	local str = util.TableToKeyValues(doors.Unownables)
	file.Write("darklandrp/doors/"..game.GetMap()..".txt",str)
end

function LoadUnownables()
	if file.Exists("darklandrp/doors/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/doors/"..game.GetMap()..".txt", "DATA")
		local tbl = util.KeyValuesToTable(str)
		doors.Unownables = tbl
	end
	for q,w in pairs(doors.Unownables) do
		local v = ents.GetByIndex(q+game.MaxPlayers())
		v:SetNWBool("Unownable",true)
		if type(w) == "string" then
			v:SetNWString("Title",titlecase(w))
		elseif type(w) == "table" then
			v:SetNWString("Title",titlecase(w[1]))
			local lock = w[2]
			v.ConstLocked = lock
			if lock==1 then v:Fire("lock","",1) end
		end
	end
end