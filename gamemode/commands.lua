function GiveMoney(pl,args)
	local amt = tonumber(args[1])
	if !amt then pl:SendNotify("You need to enter an amount to give","NOTIFY_ERROR",4) return ""
	elseif amt < 10 then pl:SendNotify("Number must be higher than 10","NOTIFY_ERROR",4) return ""
	end
	amt = math.floor(amt)
	tr = pl:EyeTrace(100)
	if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
		if pl.Money < amt then pl:SendNotify("You do not have that much money!","NOTIFY_ERROR",5) return "" end
		tr.Entity:AddMoney(amt)
		pl:AddMoney(amt*-1)
		pl:SendNotify("You have given "..tr.Entity:Name().." $"..amt,"NOTIFY_GENERIC",5)
		tr.Entity:SendNotify(pl:Name().." has given you $"..amt,"NOTIFY_GENERIC",5)
		SaveRPAccount(pl)
		SaveRPAccount(tr.Entity)
		//filex.Append("givemoneylog.txt","To: "..tr.Entity:SteamID().." From: "..pl:SteamID().." Amt: "..amt.."\n")
	else
		pl:SendNotify("You must look at a player","NOTIFY_ERROR",4)
	end
end
AddChatCommand("givemoney",GiveMoney)

function PrivateMessage(pl,args)
	if !args[1] then return "" end
	local recvr = player.FindNameMatch(args[1])
	if !recvr then 
		pl:SendNotify("Player with a name containing '"..escape(args[1]).."' was not found","NOTIFY_ERROR",5)
		return "" 
	end
	recvr.LastPM = pl
	table.remove(args,1)
	
	umsg.Start("__chatcust",pl)	
		umsg.Entity(pl)
		umsg.String('[PM ('..recvr:Name()..')] '..table.concat(args," "))
		umsg.Short(255)
		umsg.Short(45)
		umsg.Short(45)
	umsg.End()
	
	umsg.Start("__chatcust",recvr)	
		umsg.Entity(pl)
		umsg.String('[PM] '..table.concat(args," "))
		umsg.Short(255)
		umsg.Short(45)
		umsg.Short(45)
	umsg.End()
end
AddChatCommand("pm",PrivateMessage)

function Reply(pl,args)
	if !args[1] then return "" end
	if(!pl.LastPM)then
		pl:SendNotify("You have not received a PM","NOTIFY_ERROR",4)
		return "" 
	end
	local recvr = pl.LastPM
	if(!recvr:IsValid())then 
		pl:SendNotify("The player you are replying to has left","NOTIFY_ERROR",4)
		return "" 
	end
	recvr.LastPM = pl
	
	if !recvr then return "" end
		umsg.Start("__chatcust",pl)	
		umsg.Entity(pl)
		umsg.String('[PM ('..recvr:Name()..')] '..table.concat(args," "))
		umsg.Short(255)
		umsg.Short(45)
		umsg.Short(45)
	umsg.End()
	
	umsg.Start("__chatcust",recvr)	
		umsg.Entity(pl)
		umsg.String('[PM] '..table.concat(args," "))
		umsg.Short(255)
		umsg.Short(45)
		umsg.Short(45)
	umsg.End()
end
AddChatCommand("reply",Reply)

function Me(pl,args)
	if !args[1] then return "" end
	for i,v in pairs(GetLocalPlayers(pl,CHAT_DIST)) do
		umsg.Start("__chatcust",v)	
			umsg.Entity(NULL)
			umsg.String(pl:Name() .. " " .. table.concat(args," "))
			umsg.Short(255)
			umsg.Short(160)
			umsg.Short(60)
		umsg.End()
	end
end
AddChatCommand("me",Me)

function Advert(pl,args)
	if !args[1] then return "" end
	umsg.Start("__chatcust")	
		umsg.Entity(NULL)
		umsg.String("(ADVERT) " .. table.concat(args," "))
		umsg.Short(150)
		umsg.Short(255)
		umsg.Short(130)
	umsg.End()
	MsgAdmin(pl:Name().." used ADVERT to say: "..escape(table.concat(args," ")),2);
end
AddChatCommand("advert",Advert)

function Admin(pl,args)
	if !args[1] then return "" end
	if(!pl:IsStaff())then pl:SendNotify("You are not an admin","NOTIFY_ERROR",5) return end
	for k,v in pairs(player.GetAll())do
		if(v:IsStaff())then
			umsg.Start("__chatcust",v)	
				umsg.Entity(pl)
				umsg.String("[STAFF] " .. table.concat(args," "))
				umsg.Short(128)
				umsg.Short(128)
				umsg.Short(255)
			umsg.End()
		end
	end
end
AddChatCommand("staff",Admin)

function Gang(pl,args)
	if !args[1] then return "" end
	if(pl:Team() != TEAM_GANG and pl:Team() != TEAM_MOBBOSS)then pl:SendNotify("You are not a gangster","NOTIFY_ERROR",5) return end
	for k,v in pairs(player.GetAll())do
		if(v:Team() == TEAM_GANG or v:Team() == TEAM_MOBBOSS)then
			umsg.Start("__chatcust",v)	
				umsg.Entity(pl)
				umsg.String("[Gang] " .. table.concat(args," "))
				umsg.Short(80)
				umsg.Short(80)
				umsg.Short(80)
			umsg.End()			
			--v:SendLua('AddHistory('..pl:UserID()..',\"'..tmysql.escape(table.concat(args," "))..'\",11)')
		end
	end
	MsgAdmin(pl:Name().." used GANG to say: "..escape(table.concat(args," ")),7);
end
AddChatCommand("gang",Gang)

