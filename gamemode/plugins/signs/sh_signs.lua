
local ITEM = items.DefineItem("Sign")
ITEM.Group = "General"
ITEM.EntityClass = "sign"
ITEM.Model = "models/props_junk/TrashDumpster02b.mdl"
ITEM.Description = "A sign for anything that needs it"
ITEM.BulkPrice = 300
ITEM.Craftable = {"Metal Plating",5,"Plastic",10}
ITEM.BulkAmt = 1
ITEM.Size = {2,2}
ITEM.CamPos = Vector(0,0,100)
ITEM.OnSpawn = function(pl,ent) pl:SendLua("OpenSignMenu("..ent:EntIndex()..")") ent:SetNWString("Owner",pl:SteamID()) end
ITEM.Args = {}