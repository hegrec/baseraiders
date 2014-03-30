--normal billboard size is 221x115

local billboards = {}
billboards.entities = {}
billboards.helpstring = "Syntax is '/addbbstart to start, /addbbend  [ownable] [cost] [default text] to finish. Start in top left, finish bottom right//'"
billboards.temptable = {} --used in the creation of buildboards

function billboards.AddStart(ply, args)
	if !ply:IsSuperAdmin() then return "" end
	local trace = ply:GetEyeTrace()
	billboards.temptable[ply:Name()] = {}
	billboards.temptable[ply:Name()].startpos = trace.HitPos + trace.HitNormal * 2
	ply:SendNotify("You added a billboard start point","NOTIFY_GENERIC",4)
end
AddChatCommand("addbbstart",billboards.AddStart)
--use the 2 optional arguments for setting stuff for unownable billboards
function billboards.AddFinish(ply, args)
	if !ply:IsSuperAdmin() then return "" end 
	if(!billboards.temptable[ply:Name()])then ply:SendNotify(billboards.helpstring,"NOTIFY_ERROR",4) return end
	local trace = ply:GetEyeTrace()
	local startpos = billboards.temptable[ply:Name()].startpos
	local endpos = trace.HitPos + trace.HitNormal * 2
	local angle = trace.HitNormal:Angle()
	angle:RotateAroundAxis(angle:Forward(), 90)
	angle:RotateAroundAxis(angle:Right(), -90)
	
	local ownable = true
	if(args[1] == "false")then ownable = false end
	
	local cost = 1000
	if(args[2])then cost = args[2] end
	
	local txt = {}
	txt["1"] = "FOR SALE"
	if(args[3])then --fixed the whole explode by space thing
		txt["1"] = args[3]
		for i = 4,#args do
			txt["1"] = txt["1"] .. " " .. args[i]
		end
	end
	if(ownable)then txt["2"] = "Billboard #"..#billboards.entities + 1 end
	
	local height = math.abs(endpos.z - startpos.z)
	local width = math.abs(endpos.y - startpos.y)
	local length = math.abs(endpos.x - startpos.x)
	
	local hypo = math.sqrt(width * width + length * length)
		
	local ent = ents.Create("billboard")
	ent:SetUpDefault(txt,Color(255,255,255,255),Color(0,0,0,255))
	ent:SetUpInfo(startpos, angle, Color(0,0,0,255), hypo, height, txt, Color(255,255,255,255),ownable,cost)
	ent:Spawn()
	
	table.insert(billboards.entities,ent)
	billboards.Save()
	ply:SendNotify("You added a billboard","NOTIFY_GENERIC",4)
	billboards.temptable[ply:Name()] = nil
end
AddChatCommand("addbbend",billboards.AddFinish)

function billboards.Save()
	local t = {} --Have to clear stuff but don't want to clear out old zombie stuff
	local num=1
	for i,v in pairs(billboards.entities) do 
		t[num] = {}
		t[num]["startpos"] = v:GetPos()
		t[num]["endpos"] = v:GetNWVector("endpoint")
		t[num]["angle"] = v:GetAngles()
		t[num]["width"] = v:GetNWInt("width")
		t[num]["height"] = v:GetNWInt("height")
		t[num]["ownable"] = tostring(v:GetNWBool("ownable"))
		t[num]["txt"] = {}
		for i=1,6 do --faster since no table.count call
			t[num]["txt"][i] = v.DText["dtxt"..i]
		end
		local txtclr = Color(255,255,255,255)
		if(v:GetNWString("dtxtclr") != "")then
			local tmpclr = string.Explode("|",v:GetNWString("dtxtclr"))
			txtclr = Color(tmpclr[1],tmpclr[2],tmpclr[3],255)
		end
		t[num]["txtclr"] = {}
		t[num]["txtclr"]["r"] = txtclr.r
		t[num]["txtclr"]["g"] = txtclr.g
		t[num]["txtclr"]["b"] = txtclr.b
		
		local bgclr = Color(0,0,0,255)
		if(v:GetNWString("dbgclr") != "")then
			local tmpclr = string.Explode("|",v:GetNWString("dbgclr"))
			bgclr = Color(tmpclr[1],tmpclr[2],tmpclr[3],255)
		end
		t[num]["bgclr"] = {}
		t[num]["bgclr"]["r"] = bgclr.r
		t[num]["bgclr"]["g"] = bgclr.g
		t[num]["bgclr"]["b"] = bgclr.b
		
		t[num]["cost"] = v:GetNWInt("cost") or 1000
		num=num+1 
	end
	local str = util.TableToKeyValues(table.Sanitise(t))
	file.Write("darklandrp/billboards/"..game.GetMap()..".txt",str)
end

function billboards.Load()
	if file.Exists("darklandrp/billboards/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/billboards/"..game.GetMap()..".txt", "DATA")
		local tbl = util.KeyValuesToTable(str)
		local temppositions = table.DeSanitise(tbl)
		for i,v in pairs(temppositions) do
			local ent = ents.Create("billboard")
			
			local bgclr = Color(v.bgclr.r,v.bgclr.g,v.bgclr.b,255)
			local txtclr = Color(v.txtclr.r,v.txtclr.g,v.txtclr.b,255)
			local cost = v.cost or 1000
			
			ent:SetUpDefault(v.txt,txtclr,bgclr)

			ent:SetUpInfo(v.startpos,v.endpos, v.angle, bgclr, v.width, v.height, v.txt, txtclr,tobool(v.ownable),tonumber(cost))
			ent:Spawn()
			
			table.insert(billboards.entities,ent)
		end
	end
end
hook.Add("InitPostEntity","LoadBillboards",billboards.Load)

function billboards.Purchase(ply, cmd, args)
	local ent = ents.GetByIndex(args[1])
	if(!IsValid(ent) or ent:GetClass() != "billboard" or ent:GetOwn())then return end
	if(ply:GetMoney() < ent:GetNWInt("cost"))then ply:SendNotify("You can not afford this item","NOTIFY_ERROR",4) return end
	ply:AddMoney(ent.cost * -1)
	ply:GiveObject(ent)
	ply:SendNotify("You bought a billboard for $"..ent.cost,"NOTIFY_GENERIC",4)
end
concommand.Add("purchasebb",billboards.Purchase)

function billboards.ChangeFGColor(ply, cmd, args)
	local ent = ents.GetByIndex(args[1])
	if(!args[4])then return end
	if(!IsValid(ent) or ent:GetClass() != "billboard" or ent:GetOwn() != ply)then return end
	ent:SetNWString("txtclr",args[2] .. "|" .. args[3] .. "|" .. args[4])
	ply:SendNotify("Changed the text color","NOTIFY_GENERIC",4)
end
concommand.Add("bb_setfgclr",billboards.ChangeFGColor)

function billboards.ChangeBGColor(ply, cmd, args)
	local ent = ents.GetByIndex(args[1])
	if(!args[4])then return end
	if(!IsValid(ent) or ent:GetClass() != "billboard" or ent:GetOwn() != ply)then return end
	ent:SetNWString("bgclr",args[2] .. "|" .. args[3] .. "|" .. args[4])
	ply:SendNotify("Changed the background color","NOTIFY_GENERIC",4)
end
concommand.Add("bb_setbgclr",billboards.ChangeBGColor)

function billboards.SetText(ply, cmd, args)
	local ent = ents.GetByIndex(args[1])
	if(!args[3])then return end
	if(!IsValid(ent) or ent:GetClass() != "billboard" or ent:GetOwn() != ply)then return end
	ent:SetNWString("txt"..tonumber(args[2]),args[3])
	ply:SendNotify("Changed billboard's text on line "..tonumber(args[2]),"NOTIFY_GENERIC",4)
end
concommand.Add("bb_settxt",billboards.SetText)

function billboards.Sell(ply, cmd, args)
	local ent = ents.GetByIndex(args[1])
	if(!IsValid(ent) or ent:GetClass() != "billboard" or ent:GetOwn() != ply)then return end
	ply:AddMoney(ent.cost/2)	
	for i=1,6 do --reset text
		ent:SetNWString("txt"..i,ent.DText["dtxt"..i])
	end
	ent:SetNWString("bgclr",ent.dbgclr)
	ent:SetNWString("txtclr",ent.dtxtclr)
	RemoveObject(ent)
	ply:SendNotify("You sold your billboard for $"..ent.cost/2,"NOTIFY_GENERIC",4)
end
concommand.Add("bb_sell",billboards.Sell)

function billboards.StripOwner(bb)
	for i=1,6 do --reset text
		bb:SetNWString("txt"..i,bb.DText["dtxt"..i])
	end
	bb:SetNWString("bgclr",bb.dbgclr)
	bb:SetNWString("txtclr",bb.dtxtclr)
end
AddChatCommand("billboard",billboards.StripOwner)