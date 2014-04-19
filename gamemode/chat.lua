

ChatCommands = {}
function ChatArg(str,i)
	return string.Explode(" ",str)[i];
end

function AddChatCommand(cmd,callback)
	if ChatCommands[cmd] then return end
	ChatCommands[cmd] = callback
end

function RunChatCommand(pl,txt)
	local tab = string.Explode(" ",txt)
	local cmd = string.lower(string.sub(tab[1],2))
	if !ChatCommands[cmd] then ChatError(pl,"Invalid Command") return end
	table.remove(tab,1)
	ChatCommands[cmd](pl,tab)
end

function ChatError(pl,msg)
pl:ChatPrint(msg)
end


	

AddChatCommand("l",function(pl,args)
	for i,v in pairs(GetLocalPlayers(pl,CHAT_DIST)) do
		v:ChatPrint(pl:Name()..": "..table.concat(args," "))
	end
	return ""
end)

AddChatCommand("w",function(pl,args)
		for i,v in pairs(GetLocalPlayers(pl,WHISPER_DIST)) do
			v:ChatPrint(pl:Name()..": "..table.concat(args," "))
		end
	return ""
end)
AddChatCommand("y",function(pl,args)
		for i,v in pairs(GetLocalPlayers(pl,YELL_DIST)) do
			v:ChatPrint(pl:Name()..": "..table.concat(args," "))
		end
	return ""
end)