
crafting = {}
crafting.craftman = nil
CraftAccounts = {}
function crafting.AddCrafter(ply,args)
	if !ply:IsSuperAdmin() then return end
	if crafting.craftman then
		crafting.craftman:SetPos(ply:GetPos())
		crafting.craftman:SetAngles(ply:GetAngles())
		return
	end
	local ent = ents.Create("npc_generic")
	
	ent:SetNPCName("Craftmaster Flex")
	
	ent:SetModel("models/breen.mdl")
	ent:SetPos(ply:GetPos())
	ent:SetAngles(ply:GetAngles())
	ent:Spawn()
	ent:EnableChat()
	crafting.craftman = ent
	crafting.SaveCrafters()
end
AddChatCommand("setcraftman",crafting.AddCrafter)

function crafting.StartCrafting(ply,cmd,args)
	ply:Freeze(true)
	
	local ent = ents.GetByIndex(args[1])
	local isSmelter = ent:GetClass() == "smelting_furnace"
	ply.craftingTable = ent
	
	umsg.Start("showCraftMenu",ply)
	umsg.Bool(isSmelter)
	umsg.End()
end
concommand.Add("start_crafting",crafting.StartCrafting)

function crafting.CraftingFinished(ply,cmd,args)
	ply:Freeze(false)
end
concommand.Add("crafting_finished",crafting.CraftingFinished)


function crafting.CraftItem(ply,cmd,args)
	
	local item = args[1]
	local tbl = GetItems()[item]
	if !tbl then return end
	local isSmelter = ply.craftingTable:GetClass() == "smelting_furnace"
	
	local var = "Craftable"
	if isSmelter then
		var = "Smeltable"
	end
	
	for i=1,#tbl[var],2 do
		local amtReq = tonumber(tbl[var][i+1])
		
		local myAmount = ply:GetAmount(tbl[var][i])
		
		local text = "enough "
		if (myAmount == 0) then text = "any " end
		
		
		if myAmount<amtReq then ply:SendNotify("You don't have "..text..tbl[var][i].."s","NOTIFY_ERROR",3) return end
		
	end
	if !ply:CanHold(item) then
		ply:SendNotify("You don't have room for this in your inventory","NOTIFY_ERROR",3)
	return end
	--we had all reqs, remove em and give new item now
	for i=1,#tbl[var],2 do
		local amtReq = tonumber(tbl[var][i+1])
		for ii=1,amtReq do
			ply:TakeItem(tbl[var][i])	
		end
	end
	ply:GiveItem(item)
	ply:AddExperience(2)
	umsg.Start("experienceUp")
		umsg.Vector(ply:EyePos()+(ply:GetAimVector()*25-Vector(0,0,10)))
		umsg.Short(2)
		umsg.Bool(pl:IsVIP())
	umsg.End()

end
concommand.Add("craft_item",crafting.CraftItem)

function crafting.SaveCrafters()
	if (crafting.craftman == nil) then return end
	local tbl = {}
	local vec = crafting.craftman:GetPos()
	local ang = crafting.craftman:GetAngles()
	local str = vec.x .. " " .. vec.y .. " " .. vec.z .. " " .. ang.pitch .. " " .. ang.yaw .. " " .. ang.roll
	file.Write("darklandrp/crafting/crafters/"..game.GetMap()..".txt",str)
end
function crafting.GiveStarterTools(pl)
	if !pl:HasItem("Hatchet") then pl:GiveItem("Hatchet") end
	if !pl:HasItem("Pickaxe") then pl:GiveItem("Pickaxe") end
	if !pl:HasItem("Shovel") then pl:GiveItem("Shovel") end

end

function crafting.MakeFire(pl,cmd,args)

	if !pl:HasItem("Wood") then return end
	local fire = ents.Create("darkland_fire")
	fire:SetPos(pl:GetEyeTrace().HitPos)
	fire:Spawn()
	local x,y = pl:HasItem("Wood")
	pl:TakeItem(x,y)

end
concommand.Add("make_fire",crafting.MakeFire)
function crafting.LoadCrafters()
	if file.Exists("darklandrp/crafting/crafters/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/crafting/crafters/"..game.GetMap()..".txt", "DATA")	
		local t = string.Explode(" ",str)
		local ent = ents.Create("npc_generic")
		
		ent:SetNPCName("Craftmaster Flex")
		
		ent:SetModel("models/breen.mdl")
		ent:SetPos(Vector(t[1],t[2],t[3]))
		ent:SetAngles(Angle(tonumber(t[4]),tonumber(t[5]),tonumber(t[6])))
		ent:Spawn()
		ent:EnableChat()
		
		crafting.craftman = ent		
	end
end
hook.Add("InitPostEntity","LoadCrafters",crafting.LoadCrafters)
