
gun_npc = gun_npc or {}
gun_npc.seller = gun_npc.seller or nil
function gun_npc.SetSeller(ply,args)
	if !ply:IsSuperAdmin() then return end
	if gun_npc.seller then
		gun_npc.seller:SetPos(ply:GetPos())
		gun_npc.seller:SetAngles(ply:GetAngles())
		return
	end
	local ent = ents.Create("npc_generic")
	ent:SetNPCName("Achmed, the Gun Dealer")
	ent:SetModel("models/eli.mdl")
	ent:SetPos(ply:GetPos())
	ent:SetAngles(ply:GetAngles())
	ent:Spawn()
	ent:EnableChat()
	gun_npc.seller = ent
	gun_npc.seller.store = gun_npc.GetStore()
	gun_npc.SaveSeller()
end
AddChatCommand("setgunseller",gun_npc.SetSeller)

function gun_npc.SaveSeller()
	if (gun_npc.seller == nil) then return end
	local tbl = {}
	local vec = gun_npc.seller:GetPos()
	local ang = gun_npc.seller:GetAngles()
	local str = vec.x .. " " .. vec.y .. " " .. vec.z .. " " .. ang.pitch .. " " .. ang.yaw .. " " .. ang.roll
	file.Write("darklandrp/gunnpc/"..game.GetMap()..".txt",str)
end



DEFAULT_RESERVE = 10 
local gunReserves = {}
function gun_npc.CreateGunReserve()	
	
	for i,v in pairs(gun_npc.GetStore().items) do
			gunReserves[i] = DEFAULT_RESERVE
	end
end

hook.Add("Initialize","CreateGunReserve",gun_npc.CreateGunReserve)

function gun_npc.ReUpReserve()
	for i,v in pairs(gunReserves) do
		gunReserves[i] = math.min(gunReserves[i]+1,DEFAULT_RESERVE)
	end
end
timer.Create("upgunReserve",600,0,gun_npc.ReUpReserve)
		

function gun_npc.CanBuy(pl,item)

	if (gunReserves[item] > 0) then
		return true
	end
	pl:SendNotify("NPC is out of "..item.."s, come back later","NOTIFY_ERROR",4)
	return false	
end



function gun_npc.BoughtWeapon(pl,item)

	gunReserves[item] = gunReserves[item] - 1

end










function gun_npc.GetStore()
	local store = {Title = "Achmed's Gun Shop",items = {}}
	store.OnBuy = gun_npc.BoughtWeapon
	store.CanBuy = gun_npc.CanBuy
	store.items["FiveSeven"] = 650
	store.items["Glock"] = 500
	store.items["Mac 10"] = 850
	store.items["Pistol Ammo"] = 40
	store.items["Shotgun Ammo"] = 50
	store.items["Rifle Ammo"] = 60
	return store
end


function gun_npc.LoadSeller()
	if file.Exists("darklandrp/gunnpc/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/gunnpc/"..game.GetMap()..".txt", "DATA")	
		local t = string.Explode(" ",str)
		local ent = ents.Create("npc_generic")
		
		ent:SetNPCName("Achmed, the Gun Dealer")
		ent:SetModel("models/eli.mdl")
		ent:SetPos(Vector(t[1],t[2],t[3]))
		ent:SetAngles(Angle(tonumber(t[4]),tonumber(t[5]),tonumber(t[6])))
		ent:Spawn()
		ent:EnableChat()
		
		gun_npc.seller = ent
		gun_npc.seller.store = gun_npc.GetStore()
	end
end
hook.Add("InitPostEntity","gun_npc.LoadSeller",gun_npc.LoadSeller)




