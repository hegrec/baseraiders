
elec_npc = elec_npc or {}
elec_npc.seller = elec_npc.seller or nil
function elec_npc.SetSeller(ply,args)
	if !ply:IsSuperAdmin() then return end
	if elec_npc.seller then
		elec_npc.seller:SetPos(ply:GetPos())
		elec_npc.seller:SetAngles(ply:GetAngles())
		return
	end
	local ent = ents.Create("npc_generic")
	ent:SetNPCName("Arnold, The Hardware Guy")
	ent:SetModel("models/odessa.mdl")
	ent:SetPos(ply:GetPos())
	ent:SetAngles(ply:GetAngles())
	ent:Spawn()
	ent:EnableChat()
	elec_npc.seller = ent
	elec_npc.seller.store = elec_npc.GetStore()
	elec_npc.SaveSeller()
end
AddChatCommand("setelecseller",elec_npc.SetSeller)

function elec_npc.SaveSeller()
	if (gun_npc.seller == nil) then return end
	local tbl = {}
	local vec = elec_npc.seller:GetPos()
	local ang = elec_npc.seller:GetAngles()
	local str = vec.x .. " " .. vec.y .. " " .. vec.z .. " " .. ang.pitch .. " " .. ang.yaw .. " " .. ang.roll
	file.Write("darklandrp/elecnpc/"..game.GetMap()..".txt",str)
end

function elec_npc.GetStore()
	local store = {Title = "Arnold's Hardware Store",items = {}}
	store.items["Advanced Electronics"] = 150
	store.items["Circuit Board"] = 50
	store.items["Clay Pot"] = 10
	store.items["Mechanical Parts"] = 35
	store.items["Gasoline"] = 50
	store.items["Crowbar"] = 80
	return store
end


function elec_npc.LoadSeller()
	if file.Exists("darklandrp/elecnpc/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/elecnpc/"..game.GetMap()..".txt", "DATA")	
		local t = string.Explode(" ",str)
		local ent = ents.Create("npc_generic")
		
		ent:SetNPCName("Arnold, The Hardware Guy")
		ent:SetModel("models/odessa.mdl")
		ent:SetPos(Vector(t[1],t[2],t[3]))
		ent:SetAngles(Angle(tonumber(t[4]),tonumber(t[5]),tonumber(t[6])))
		ent:Spawn()
		ent:EnableChat()
		
		elec_npc.seller = ent
		elec_npc.seller.store = elec_npc.GetStore()
	end
end
hook.Add("InitPostEntity","elec_npc.LoadSeller",elec_npc.LoadSeller)
