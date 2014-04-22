// Add rules here
local Rules = {
"1. General Rules", 
	{
"1a. Respect all admins/super admins/developers",
"1b. Do not crash the server.", 
"1c. Do not flame. (offend another player)",
"1d. No racism.(Check Definitions Tab for any definition related question!)",
"1e. Breaking New Life Rule.  You may not go back to where you just died unless",
"you are returning to your house/property, drug plants, and vehicle or you are an",
"admin and are ACTIVELY doing admin related activities. Returning for no reason",
"after you were killed will result in a ban.",
"1f. No random Death Matching (DMing) or killing for another persons weapon.",
"1g. No locking a player into a room via a rented door.",
"1h. Abusing any profession could result in a blacklist from that profession.",
"1i. Do not sell a profession or hold a profession for a friend, use it or lose it.",
"1j. Do not spam in chat, on the mic, or talk normally using the /advert command.",
"1k. Refrain from talking in CAPS in OOC.",
"1l. Any exploitation of the map, props, server, and/or anything that falls within",
"the realm of exploitation will result in a ban. Includes cheating. (examples Speed",
"Hacks, Aimbotting, Xray, ESP/Radar/Wall Hacks, and anything which gives you an",
"advantage not incorporated into the RP.)",
"1m. Use common sense. If something you do is questionable, ask an admin. If you",
"do not, then common sense applies.",
"1n. If you build any door, or structure that acts like one, a public button MUST",
"placed ON the entrance of the door, easily in view",
"1o. Lying about something can increase your ban length.",
"1p. DO NOT TAKE MATTERS INTO YOUR OWN HANDS, contact an admin or collect evidence",
"which you can then post on the forums in the ban section www.caketoast.com",
"1q. Signs are considered props. All building rules apply to signs. Signs are to",
"be used in a proper RP manner, anything else, is bannable."
	},
"",
"2. Prop Rules", 
	{
"2a. Do not prop kill, prop block, prop surf, prop trap, prop push, prop spam, or",
"spawning exploding props in any shape or form. This includes making any prop",
"which can, will, or will function as a machine to prop trap/kill/push/etc.",
"2b. No using props or signs as shields during a raid, or any other time.",
	},
}
local helptext = [[

Welcome to Baseraiders!

This is a cooperative gamemode where you craft items and 
hold territory against enemy gangs.

CRAFTING
To craft items, use a crafting table, there is one at spawn.

FORAGING
You can speak with the main npc to get foraging tools.

GANGS
When you can afford a gang, you can begin capturing territories
]]


function CreateRulesTab()
	local RulesList = vgui.Create( "DPanelList" );
	RulesList:EnableVerticalScrollbar();
	RulesList:SetSpacing( 1 );
	RulesList:SetPadding( 7 );
	RulesList:EnableVerticalScrollbar(true)
	
	local pnl = vgui.Create("DPanel")
	RulesList:AddItem(pnl)
	pnl:SetTall(512)
	
	local welcomeText = Label("Baseraiders",pnl)
	welcomeText:SetFont("ScoreboardSub")
	welcomeText:SetPos(5,5)
	welcomeText:SizeToContents()
	welcomeText:SetTextColor(Color(200,0,0,255))
	
	local welcomeText = Label(helptext,pnl)
	welcomeText:SetFont("HUDBars")
	welcomeText:SetPos(5,35)
	welcomeText:SizeToContents()
	welcomeText:SetTextColor(Color(0,0,0,255))
	

	Panels["Menu"].Sheet:AddSheet( "Welcome", RulesList, "gui/silkicons/error",nil,nil,nil,1);


	local RulesList = vgui.Create( "DPanelList" );
	RulesList:EnableVerticalScrollbar();
	RulesList:SetSpacing( 1 );
	RulesList:SetPadding( 7 );

	local RuleNumberOffset = 0;
	for RuleKey, RuleValue in pairs( Rules ) do
		local RuleNumber = RuleKey + RuleNumberOffset;

		if( type( RuleValue ) == "table" ) then
			// Sub rule block
			local SubRuleNumberOffset = 0;
			for SubRuleKey, SubRuleValue in pairs( RuleValue ) do
				// Sub rule
				local SubRuleNumber = SubRuleKey + SubRuleNumberOffset;

				local Text = SubRuleValue;
				if( SubRuleValue[1] == "*" && SubRuleValue[2] == ")"  ) then
					Text = "     " .. RuleNumber .. string.char( SubRuleNumber + 96 ) .. ". " .. SubRuleValue;
				else
					SubRuleNumberOffset = SubRuleNumberOffset - 1;
				end
				local NewRule = Label( Text );

				NewRule:SetWrap( true );
				RulesList:AddItem( NewRule );
			end
		else
			// Main rule
			local Text = RuleValue;
			if( RuleValue[1] == "*" && RuleValue[2] == ")" ) then
				Text = RuleNumber .. ". " .. RuleValue;
			else
				RuleNumberOffset = RuleNumberOffset - 1;
			end
			local NewRule = Label( Text );

			NewRule:SetWrap( true );
			RulesList:AddItem( NewRule );
		end
	end

	Panels["Menu"].Sheet:AddSheet( "Server Rules", RulesList, "gui/silkicons/error",nil,nil,nil,4 );
	
	

end
hook.Add( "OnMenusCreated", "CreateRulesTab", CreateRulesTab );


