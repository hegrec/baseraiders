
banking = {}
banking.bankers = {}
BankAccounts = {}
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
	ply.BankReady = true
	ply:Freeze(true)
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
	ply:Freeze(false)
	ply.BankReady = nil
	banking.SaveBankAccount(ply)
	BankAccounts[ply] = nil
end
concommand.Add("bankFinished",banking.BankFinished)

function banking.ItemToBank(ply,cmd,args)
	local index = args[1];
	local all = (args[2] == "all")
	if !ply:HasItem(index) or !ply.BankReady or !BankAccounts[ply] then return end
	local amount = 1
	if all then 
		amount = ply.Inventory[index] 
	elseif(tonumber(args[2]))then
		amount = math.Clamp(tonumber(args[2]),0,ply.Inventory[index])
	end
	ply:TakeItem(index,amount)
	umsg.Start("getBankItem",ply)
		umsg.String(index)
		umsg.Long(amount)
	umsg.End()
	BankAccounts[ply][index] = BankAccounts[ply][index] or 0
	BankAccounts[ply][index] = BankAccounts[ply][index] + amount
	ply.BankReady = false
	banking.SaveBankAccount(ply,function() ply.BankReady = true end)
	SaveRPAccount(ply)
end
concommand.Add("itemToBank",banking.ItemToBank)

function banking.ItemToInventory(ply,cmd,args)
	local index = args[1]
	local all = (args[2] == "all")
	if !BankAccounts[ply][index] or BankAccounts[ply][index] < 1 or !ply.BankReady then return end
	local amount = 1
	if all then 
		amount = BankAccounts[ply][index]
	elseif(tonumber(args[2]))then
		amount = math.Clamp(tonumber(args[2]),0,BankAccounts[ply][index])
	end
	for i=1,amount do 
		local bool = ply:GiveItem(index)
		if bool then
			umsg.Start("loseBankItem",ply)
				umsg.String(index)
				umsg.Long(1)
			umsg.End()
			BankAccounts[ply][index] = BankAccounts[ply][index] - 1
			if BankAccounts[ply][index] < 1 then BankAccounts[ply][index] = nil end
			ply.BankReady = false
			banking.SaveBankAccount(ply,function() ply.BankReady = true end)
			SaveRPAccount(ply)
		else
			return
		end
	end
end
concommand.Add("itemToInventory",banking.ItemToInventory)

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
