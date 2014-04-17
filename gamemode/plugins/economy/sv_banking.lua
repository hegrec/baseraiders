
banking = banking or {}
banking.bankers = banking.bankers or {}
BankAccounts = BankAccounts or {}
function banking.AddBanker(ply,args)
	if !ply:IsSuperAdmin() then return end

	local ent = ents.Create("npc_generic")
	
	ent:SetNPCName("Banker Joe")
	
	ent:SetModel("models/barney.mdl")
	ent:SetPos(ply:GetPos())
	ent:SetAngles(ply:GetAngles())
	ent:Spawn()
	ent:EnableChat()
	table.insert(banking.bankers,ent)
	banking.SaveBankers()
end
AddChatCommand("addbanker",banking.AddBanker)

local function BankRequestCallBack(tbl,ply)
	BankAccounts[ply] = {}
	local bfr = {}
	local t = string.Explode("|",tbl[1].BankAccount)
	for i,v in pairs(t) do
		local s = string.Explode(":",v)
		bfr[s[1]] = tonumber(s[2])
	end
	
	for i,v in pairs(bfr) do
		if GetItems()[i] then
			BankAccounts[ply][i] = v
		end
	end
	banking.SendBank(ply)
	ply:SetNWBool("Banking",true)
	ply.BankReady = true
end

function banking.RequestBank(ply,cmd,args)
	local tr = {}
	tr.start = ply:GetShootPos()
	tr.endpos = tr.start + ply:GetAimVector()*MAX_INTERACT_DIST
	tr.filter = ply
	tr.mask = MASK_BLOCKLOS_AND_NPCS
	
	tr = util.TraceLine(tr)
	if tr.Entity:IsValid() and tr.Entity:GetClass() == "npc_generic" then
		Query("SELECT BankAccount FROM rp_playerdata WHERE SteamID=\""..ply:SteamID().."\"",function(res) BankRequestCallBack(res,ply) end)
	else
		ply:SendNotify("You are not talking to a banker....","NOTIFY_ERROR",4)
	end
end
concommand.Add("requestBank",banking.RequestBank)

function banking.SaveBankAccount(ply,func)
	if !BankAccounts[ply] then return end
	local str = table.ToSave(BankAccounts[ply])
	Query("UPDATE rp_playerdata SET BankAccount=\""..str.."\" WHERE SteamID=\""..ply:SteamID().."\"",func)
end

function banking.SendBank(ply)
	if !BankAccounts[ply] then error("ERROR: PLAYER does not have a bank account loaded!") return end
	for i,v in pairs(BankAccounts[ply]) do
		umsg.Start("getBankItem",ply)
			umsg.String(i)
			umsg.Long(v)
		umsg.End()
	end
end

function banking.BankFinished(ply,cmd,args)
	ply.BankReady = nil
	ply:SetNWBool("Banking",false)
	banking.SaveBankAccount(ply)
	BankAccounts[ply] = nil
end
concommand.Add("bankFinished",banking.BankFinished)

function banking.ItemToBank(ply,cmd,args)
	local x = tonumber(args[1])
	local y = tonumber(args[2])
	local all = args[3] == "1"
	local amt = 1
	
	
	
	local item = ply:GetItem(x,y)
	local tbl = GetItems()[item]
	if !tbl then return end
	
	
	
	
	if !ply:HasItem(item) or !ply:GetNWBool("Banking") or !BankAccounts[ply] then return end
	
	local tr = {}
	tr.start = ply:GetShootPos()
	tr.endpos = tr.start + ply:GetAimVector()*MAX_INTERACT_DIST
	tr.filter = ply
	tr.mask = MASK_BLOCKLOS_AND_NPCS
	
	tr = util.TraceLine(tr)
	--this is not really a true logical statement, could be talking to the craftsman and its true
	if !(tr.Entity:IsValid() and tr.Entity:GetClass() == "npc_generic") then
		ply:SendNotify("You are not talking to a banker....","NOTIFY_ERROR",4)
		ply:SetNWBool("Banking",false)
		return
	end
	
	
	
	
	local tot = 0
	for i,v in pairs(BankAccounts[ply]) do
		local xs,ys = 2,2
		if GetItems()[i].Size then
		
			xs,ys = unpack(GetItems()[i].Size)
		end
		tot = tot + xs*ys*v
	end
	local xs,ys = 2,2
	if tbl.Size then
		xs,ys = unpack(tbl.Size)
	end
	local newItemSize = xs*ys
	if all then
		newItemSize = newItemSize * ply:GetAmount(item)
	end
	
	tot = tot + newItemSize --new size
	if (tot>BANK_SPACE) then
		ply:SendNotify("You don't have enough space in your bank for that","NOTIFY_ERROR",4)
		return
	end
	
	ply:TakeItem(x,y) --we always take an initial item because the minimum to transfer is 1
	local amt = 1
	if all then
		while(true) do
			x,y = ply:HasItem(item)
			if !x or !y then break end
			ply:TakeItem(x,y)
			amt = amt + 1
		end
	end
	
	BankAccounts[ply][item] = BankAccounts[ply][item] or 0
	BankAccounts[ply][item] = BankAccounts[ply][item] + amt
	
	
	umsg.Start("getBankItem",ply)
		umsg.String(item)
		umsg.Long(BankAccounts[ply][item])
	umsg.End()

	ply.BankReady = false
	banking.SaveBankAccount(ply,function() ply.BankReady = true end)
	SaveRPAccount(ply)
end
concommand.Add("item_to_bank",banking.ItemToBank)

function banking.ItemToInventory(ply,cmd,args)
	local index = args[1]
	if !BankAccounts[ply][index] or BankAccounts[ply][index] < 1 or !ply.BankReady then return end

	
	local tr = {}
	tr.start = ply:GetShootPos()
	tr.endpos = tr.start + ply:GetAimVector()*MAX_INTERACT_DIST
	tr.filter = ply
	tr.mask = MASK_BLOCKLOS_AND_NPCS
	
	tr = util.TraceLine(tr)
	--this is not really a true logical statement, could be talking to the craftsman and its true
	if !(tr.Entity:IsValid() and tr.Entity:GetClass() == "npc_generic") then
		ply:SendNotify("You are not talking to a banker....","NOTIFY_ERROR",4)
		ply:SetNWBool("Banking",false)
		return
	end
	
	
	for i=1,1 do 
		local bool = ply:GiveItem(index)
		if bool then

			BankAccounts[ply][index] = BankAccounts[ply][index] - 1
			
			
			umsg.Start("getBankItem",ply)
				umsg.String(index)
				umsg.Long(BankAccounts[ply][index])
			umsg.End()
			
			if BankAccounts[ply][index] < 1 then BankAccounts[ply][index] = nil end
			
			
			
			ply.BankReady = false
			banking.SaveBankAccount(ply,function() ply.BankReady = true end)
			SaveRPAccount(ply)
		else
			return
		end
	end
end
concommand.Add("bank_to_inv",banking.ItemToInventory)

function banking.SaveBankers()
	local tbl = {}
	for i,v in pairs(banking.bankers) do
		local vec = v:GetPos()
		local ang = v:GetAngles()
		local str = vec.x .. " " .. vec.y .. " " .. vec.z .. " " .. ang.pitch .. " " .. ang.yaw .. " " .. ang.roll
		table.insert(tbl,str)
	end
	local str = util.TableToKeyValues(tbl)
	file.Write("darklandrp/economy/bankers/"..game.GetMap()..".txt",str)
end

function banking.LoadBankers()
	if file.Exists("darklandrp/economy/bankers/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/economy/bankers/"..game.GetMap()..".txt", "DATA")
		local tbl = util.KeyValuesToTable(str)
		for i,v in pairs(tbl) do
			local t = string.Explode(" ",v)
			local ent = ents.Create("npc_generic")
			
			ent:SetNPCName("Banker Joe")
			
			ent:SetModel("models/barney.mdl")
			ent:SetPos(Vector(t[1],t[2],t[3]))
			ent:SetAngles(Angle(t[4],t[5],t[6]))
			ent:Spawn()
			ent:EnableChat()
			table.insert(banking.bankers,ent) 
		end
		
	end
end
hook.Add("InitPostEntity","LoadBankers",banking.LoadBankers)
