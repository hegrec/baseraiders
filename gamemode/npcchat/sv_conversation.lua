local meta = FindMetaTable("NPC")

local voicetable = {}
//voicetable["Craftmaster Flex"] = {Sound("vo/breencast/br_tofreeman02.wav")}
//voicetable["Hat Seller"] = {Sound("")}
//voicetable["Clothes Seller"] = {Sound("vo/npc/female01/hi01"),Sound("vo/npc/female01/hi02")}
//voicetable["Dr. Ned"] = {Sound("")}
//voicetable["Banker Joe"] = {Sound("")}
//voicetable["Arnold, The Hardware Guy"] = {Sound("")}
//voicetable["Drug Dealer"] = {Sound("")}
//voicetable["Achmed, the Gun Dealer"] = {Sound("")}

function meta:SetNPCName(str)
	self.m_Name = str
end
function meta:GetName()
	return self.m_Name
end

 
function TalkToNPC(pl,cmd,args)

	local ent 		= ents.GetByIndex(args[1])
	local response	= tonumber(args[2])
	
	if !IsValid(ent) || !pl:CanReach(ent) then return end

	if !ent:CanChat() || !Dialog[ent:GetName()] then return end --This NPC can't chat

	if !response && !pl.TalkingTo then

		pl:Freeze(true) --freeze them in place while they are talking
		pl.TalkingTo 	= ent:GetName()
		pl.lastTalkEnt	= ent
		pl.ChatNum		= 1
		
		if voicetable[ent:GetName()] then
			local randvoice = math.random(1,#voicetable[ent:GetName()])
			ent:EmitSound(voicetable[ent:GetName()][randvoice],100,100)
		end
		
		ent:SetAngles(pl:GetAngles() + Angle(0,180,0))
		
		umsg.Start("beginChatting",pl)
			umsg.Short(ent:EntIndex())
			umsg.String(ent:GetName())
				local t = Dialog[pl.TalkingTo][pl.ChatNum].Replies
				
				if type(t) == "function" then t = t(pl) end

				for i,v in pairs(t) do
					umsg.Short(v)
				end
		umsg.End()

	elseif response && pl.TalkingTo then
		local t = Dialog[pl.TalkingTo][pl.ChatNum].Replies
		if type(t) == "function" then t = t(pl) end
		for i,v in pairs(t) do
			if v == response then --the reply is a valid reply to your current position in the dialog (so you cant accept a quest right after you say hello)
				local newNum = Replies[pl.TalkingTo][response].OnUse(pl,ent)
				if !newNum then StopChatting(pl) return end
				pl.ChatNum = newNum
				umsg.Start("NPCRespond",pl)
					umsg.Short(newNum) --send the new position you should be at
					local t = Dialog[pl.TalkingTo][pl.ChatNum].Replies
					
					if type(t) == "function" then t = t(pl) end

					for i,v in pairs(t) do
						umsg.Short(v)
					end
				umsg.End()
				return
			end
		end
		return

	end



end
concommand.Add("talkto",TalkToNPC)

function StopChatting(pl)

	pl.TalkingTo = nil
	pl.ChatNum = nil
	umsg.Start("endChat",pl)
	umsg.End()
	pl:Freeze(false)
end

