function SetSignText(pl,cmd,args)

	local ent = ents.GetByIndex(args[1])
	if !IsValid(ent) || ent.textSet then return end
	
	ent:SetNWString("txt",string.sub(args[2],1,15))
	ent.textSet = true
	pl:GiveObject(ent)
	
end
concommand.Add("setSign",SetSignText)

AddRemoveFunction("sign",function(ent) ent:Remove() end)