
doc_npc = doc_npc or {}
doc_npc.seller = doc_npc.seller or nil
function doc_npc.SetSeller(ply,args)
	if !ply:IsSuperAdmin() then return end
	if doc_npc.seller then
		doc_npc.seller:SetPos(ply:GetPos())
		doc_npc.seller:SetAngles(ply:GetAngles())
		return
	end
	local ent = ents.Create("npc_generic")
	ent:SetNPCName("Dr. Ned")
	ent:SetModel("models/kleiner.mdl")
	ent:SetPos(ply:GetPos())
	ent:SetAngles(ply:GetAngles())
	ent:Spawn()
	ent:EnableChat()
	doc_npc.seller = ent
	doc_npc.seller.store = doc_npc.GetStore()
	doc_npc.SaveSeller()
end
AddChatCommand("setdoctor",doc_npc.SetSeller)

function doc_npc.SaveSeller()
	if (doc_npc.seller == nil) then return end
	local tbl = {}
	local vec = doc_npc.seller:GetPos()
	local ang = doc_npc.seller:GetAngles()
	local str = vec.x .. " " .. vec.y .. " " .. vec.z .. " " .. ang.pitch .. " " .. ang.yaw .. " " .. ang.roll
	file.Write("darklandrp/doctornpc/"..game.GetMap()..".txt",str)
end




function doc_npc.GetStore()
	local store = {Title = "Dr. Ned's Medicine Cabinet",items = {}}
	store.items["Stim-pak"] = 25
	store.items["Medkit"] = 50
	store.items["Adrenaline"] = 50
	return store
end


function doc_npc.LoadSeller()
	if file.Exists("darklandrp/doctornpc/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/doctornpc/"..game.GetMap()..".txt", "DATA")	
		local t = string.Explode(" ",str)
		local ent = ents.Create("npc_generic")
		
		ent:SetNPCName("Dr. Ned")
		ent:SetModel("models/kleiner.mdl")
		ent:SetPos(Vector(t[1],t[2],t[3]))
		ent:SetAngles(Angle(tonumber(t[4]),tonumber(t[5]),tonumber(t[6])))
		ent:Spawn()
		ent:EnableChat()
		
		doc_npc.seller = ent
		doc_npc.seller.store = doc_npc.GetStore()
	end
end
hook.Add("InitPostEntity","doc_npc.LoadSeller",doc_npc.LoadSeller)




