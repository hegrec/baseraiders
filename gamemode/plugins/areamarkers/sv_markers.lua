local markers = {}
local savedmarks = {}

local function saveMarkers()
	file.Write("darklandrp/areamarkers/"..game.GetMap()..".txt",util.TableToKeyValues(table.Sanitise(markers)))
end
local function loadMarkers()
	if file.Exists("darklandrp/areamarkers/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/areamarkers/"..game.GetMap()..".txt", "DATA")
		local tbl = table.DeSanitise(util.KeyValuesToTable(str))
		for i,v in pairs(tbl) do
			local pos = v[1]
			local start = v[2]
			local endpos = v[3]
			local name = v[4]
			local ent = ents.Create("darkland_areamarker")
			ent:SetPos(pos)
			ent:SetMaxVector(start)
			ent:SetMinVector(endpos)
			ent:SetMarker(name)
			ent:Spawn()
			table.insert(markers,{pos,start,endpos,name})
		end
	end
end
hook.Add("InitPostEntity","loadMarkers",loadMarkers)


local function addMarkerStart(ply,args)
	if !ply:IsSuperAdmin() then return end
	local pos = ply:GetEyeTrace().HitPos
	savedmarks[ply] = {table.concat(args," "),pos}
	ply:SendNotify("You started an area marker","NOTIFY_GENERIC",5)
end
AddChatCommand("startmarker",addMarkerStart)

local function addMarkerFinish(ply,args)
	if !savedmarks[ply] then return end
	local name = savedmarks[ply][1]
	local startPos = savedmarks[ply][2]
	local endPos = ply:GetEyeTrace().HitPos
	local center = (endPos + startPos)/2
	local tr = {}
	tr.start = center
	tr.endpos = center - Vector(0,0,1000)
	tr = util.TraceLine(tr)
	
	local ent = ents.Create("darkland_areamarker")
	ent:SetPos(tr.HitPos)
	ent:SetMaxVector(startPos-tr.HitPos)
	ent:SetMinVector(endPos-tr.HitPos)
	ent:SetMarker(name)
	ent:Spawn()
	table.insert(markers,{tr.HitPos,startPos-tr.HitPos,endPos-tr.HitPos,name})
	savedmarks[ply] = nil
	saveMarkers()
end
AddChatCommand("finishmarker",addMarkerFinish)


local function removePlayerMark(pl)
	pl.lastMark = nil
end
hook.Add("PlayerDeath","removePlayerMark",removePlayerMark)
