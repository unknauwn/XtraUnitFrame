----------------------------------------
----------FRAME UI FUNCTION-------------
----------------------------------------

if ( GetLocale() == "frFR" ) then
	
	XUF_SelfJoiningRaid = "Vous avez rejoint un groupe de raid";
	XUF_SelfLeavingRaid = "Vous avez quitté le groupe de raid";
	XUF_PlayerJoinedRaid = "rejoint le groupe de raid";
	XUF_PlayerJoinedRaid_GetName = "(.+) a rejoint le groupe de raid";
	
	else
	
	XUF_SelfJoiningRaid = "You have joined a raid group";
	XUF_SelfLeavingRaid = "You have left the raid group";
	XUF_PlayerJoinedRaid = "has joined the raid group";
	XUF_PlayerJoinedRaid_GetName = "(.+) has joined the raid group";
end

Xuf = {
	
	Group_Frame_Name = { "XufGroup1","XufGroup2","XufGroup3","XufGroup4","XufGroup5","XufGroup6","XufGroup7","XufGroup8","XufGroup9",
	"XufGroup10"},
	Group_Bar_Frame_Name = { "Player1","Player2","Player3","Player4","Player5","Player6","Player7","Player8","Player9",
	"Player10", "Player11", "Player12", "Player13", "Player14","Player15"},
	Group_BarText_Frame_Name = { "PlayerText1","PlayerText2","PlayerText3","PlayerText4","PlayerText5","PlayerText6","PlayerText7","PlayerText8","PlayerText9",
	"PlayerText10","PlayerText11","PlayerText12","PlayerText13","PlayerText14","PlayerText15"},
	
	--UNIT_AURA
	mainEvents    = { "UNIT_HEALTH",
		"UNIT_MANA", "UNIT_AURA", "UNIT_MAXHEALTH",
	},
	
	XtraSyncSettingReceived = {},
	--XtraUnitFrameSettings = {},
	ProfilNameSaved = {},
	FrameGrpPosition = {},
	
	XufIsVisible = "false",
	ProfilIsSaved = "false",
	SyncToggleActif = "false",
	
	HealthBarN = 1,
	ManaBarN= 2,
	OfflineBarN = 3,
	DeadBarN = 4,
	ErrorBarN= 5,
	
	XUF_MiniMapDrag = 0,
	XUF_DefaultOptions = {
		["ButtonPos"] = {22, -130},
	},
}

-- register Events
function Xuf:registerEvents(frameName)
	for e = 1, getn(self.mainEvents) do
		frameName:RegisterEvent(self.mainEvents[e]); 
	end
end

-- unregister events
function Xuf:unregisterAllEvents()
	for i = 1, getn(self.Group_Frame_Name) do
		for p = 1, getn(self.Group_Bar_Frame_Name) do
			for e = 1, getn(self.mainEvents) do
				getglobal(self.Group_Frame_Name[i]..self.Group_Bar_Frame_Name[p]):UnregisterEvent(self.mainEvents[e]); 
			end
		end
	end
end

function Xuf:InitAllFrame()
	for i = 1, getn(self.Group_Frame_Name) do
		self:createGroupFrame(self.Group_Frame_Name[i]);
		for p = 1, getn(self.Group_Bar_Frame_Name) do
			self:createBarsFrame(self.Group_Bar_Frame_Name[p], p, i);
		end
	end
	self:EnableSync()
end

-- Frame Creator
function Xuf:createGroupFrame(name)
	frame = CreateFrame("Frame", name, UIParent)
	frame:SetWidth(110)
	frame:SetHeight(17)
	frame:SetPoint("CENTER", UIParent)
	frame:SetBackdrop({
		bgFile   = "Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg", tile = true, tileSize = 16,
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 12,
		insets = { left = 3, right = 3, top = 3, bottom = 3, },
	})
	frame:Hide()
end

function Xuf:createBarsFrame(name, BarNum, GroupNum)
	frame1 = CreateFrame("StatusBar", self.Group_Frame_Name[GroupNum]..name, getglobal(self.Group_Frame_Name[GroupNum]))
	frame1:EnableMouse(true)
	frame1:EnableMouseWheel(true)
	
	self:UnlockFrame(frame1, frame1:GetParent())
	self:UnlockFrame(frame1:GetParent(), frame1:GetParent())
	frame1:SetPoint("TOPLEFT", 5, 10-(BarNum*15))
	frame1:SetHeight(15)
	frame1:SetWidth(100)
	frame1:SetStatusBarTexture("Interface\\AddOns\\XtraUnitFrame\\textures\\Minimalist")
	frame1:SetStatusBarColor(32/255, 32/255, 32/255)
	--PlayerName
	frame1.value = frame1:CreateFontString(self.Group_Frame_Name[GroupNum]..self.Group_BarText_Frame_Name[BarNum], "OVERLAY")
	frame1.value:SetPoint("LEFT", frame1, "LEFT", 2, 0)
	frame1.value:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
	frame1.value:SetJustifyH("CENTER")
	frame1.value:SetText("Unknown")
	frame1:SetScript("OnMouseWheel", function() if(this:GetID() == self.ManaBarN) then this:SetID(self.HealthBarN) this:SetStatusBarColor(10/192, 100/192, 10/192) DEFAULT_CHAT_FRAME:AddMessage("|cffead454Xckbucl |rXtraUnitFrame |cfffbb034|||r Switched to HealthBar") else this:SetID(self.ManaBarN) this:SetStatusBarColor(0/255,102/255,204/255) DEFAULT_CHAT_FRAME:AddMessage("|cffead454Xckbucl |rXtraUnitFrame |cfffbb034|||r Switched to PowerBar") end  end)
	local _,_,PlayerName = string.find(frame1.value:GetText(),"(%a+)")
	frame1:SetScript("OnEvent", function() 
		self:UpdatePlayersBars(event, this)
	end)
end

----- Update Players Infos by Events Trigger
function Xuf:UpdatePlayersBars(Event, BarFrame)
	local PlayerPercent
	local _,_,PlayerName = string.find(BarFrame.value:GetText(),"(%a+)")
	
	if (Event == "UNIT_HEALTH" or Event == "UNIT_MANA") then
		if BarFrame:GetID() == self.HealthBarN then
			PlayerPercent = self:GetPlayerHealthPercent("raid"..self:GetRaidIDByName(PlayerName))
			BarFrame.value:SetText(PlayerName.." - "..PlayerPercent.."%")
			BarFrame:SetWidth(PlayerPercent)
			BarFrame.value:SetTextColor(self:GetColorClass(self:GetRaidIDByName(PlayerName)))
			elseif BarFrame:GetID() == self.ManaBarN then
			PlayerPercent = self:GetPlayerPowerPercent("raid"..self:GetRaidIDByName(PlayerName))
			BarFrame.value:SetText(PlayerName.." - "..PlayerPercent.."%")
			BarFrame:SetWidth(PlayerPercent)
			BarFrame.value:SetTextColor(self:GetColorClass(self:GetRaidIDByName(PlayerName)))
		end
		else
		if self:GetRaidIDByName(PlayerName) == nil then
			BarFrame.value:SetText(PlayerName.." - Err")
			BarFrame:SetWidth(100)
			BarFrame:SetStatusBarColor(32/255, 32/255, 32/255)
			--BarFrame.value:SetTextColor(1,1,1)
			BarFrame:SetID(self.ErrorBarN)
			elseif UnitIsDeadOrGhost("raid"..self:GetRaidIDByName(PlayerName)) ~= nil then
			BarFrame.value:SetText(PlayerName.." - DEAD")
			BarFrame:SetWidth(100)
			BarFrame:SetStatusBarColor(204/255,0/255,0/255)
			BarFrame.value:SetTextColor(self:GetColorClass(self:GetRaidIDByName(PlayerName)))
			BarFrame:SetID(self.DeadBarN)
			elseif UnitIsConnected("raid"..self:GetRaidIDByName(PlayerName)) == nil then
			BarFrame.value:SetText(PlayerName.." - Offline")
			BarFrame:SetWidth(100)
			BarFrame:SetStatusBarColor(128/255, 128/255, 128/255)
			BarFrame:SetID(self.OfflineBarN)
			else
			if  BarFrame:GetID() == self.HealthBarN or self:GetPlayerClass("raid"..self:GetRaidIDByName(PlayerName)) == "WARRIOR" then
				PlayerPercent = self:GetPlayerHealthPercent("raid"..self:GetRaidIDByName(PlayerName))
				BarFrame.value:SetText(PlayerName.." - "..PlayerPercent.."%")
				BarFrame:SetWidth(PlayerPercent)
				BarFrame:SetStatusBarColor(10/192, 100/192, 10/192)
				BarFrame.value:SetTextColor(self:GetColorClass(self:GetRaidIDByName(PlayerName)))
				BarFrame:SetID(self.HealthBarN)
				else
				PlayerPercent = self:GetPlayerPowerPercent("raid"..self:GetRaidIDByName(PlayerName))
				BarFrame.value:SetText(PlayerName.." - "..PlayerPercent.."%")
				BarFrame:SetWidth(PlayerPercent)
				BarFrame:SetStatusBarColor(0/255,102/255,204/255)
				BarFrame.value:SetTextColor(self:GetColorClass(self:GetRaidIDByName(PlayerName)))
				BarFrame:SetID(self.ManaBarN)
			end
		end
	end
end

----- AddPlayer to UI
function Xuf:AddPlayer(BarFrame, PlayerName)
	local PlayerPercent
	if self:GetRaidIDByName(PlayerName) == nil then
		BarFrame.value:SetText(PlayerName.." - Err")
		BarFrame:SetWidth(100)
		BarFrame:SetStatusBarColor(32/255, 32/255, 32/255)
		--BarFrame.value:SetTextColor(1,1,1)
		BarFrame:SetID(self.ErrorBarN)
		elseif UnitIsDeadOrGhost("raid"..self:GetRaidIDByName(PlayerName)) ~= nil then
		BarFrame.value:SetText(PlayerName.." - DEAD")
		BarFrame:SetWidth(100)
		BarFrame:SetStatusBarColor(204/255,0/255,0/255)
		--BarFrame.value:SetTextColor(self:GetColorClass("raid"..self:GetRaidIDByName(PlayerName)))
		BarFrame:SetID(self.DeadBarN)
		elseif UnitIsConnected("raid"..self:GetRaidIDByName(PlayerName)) == nil then
		BarFrame.value:SetText(PlayerName.." - Offline")
		BarFrame:SetWidth(100)
		BarFrame:SetStatusBarColor(128/255, 128/255, 128/255)
		BarFrame:SetID(self.OfflineBarN)
		elseif self:GetPlayerClass("raid"..self:GetRaidIDByName(PlayerName)) == "WARRIOR" then
		PlayerPercent = self:GetPlayerHealthPercent("raid"..self:GetRaidIDByName(PlayerName))
		BarFrame.value:SetText(PlayerName.." - "..PlayerPercent.."%")
		BarFrame:SetWidth(PlayerPercent)
		BarFrame:SetStatusBarColor(10/192, 100/192, 10/192)
		--BarFrame.value:SetTextColor(self:GetColorClass("raid"..self:GetRaidIDByName(PlayerName)))
		BarFrame:SetID(self.HealthBarN)
		else
		PlayerPercent = self:GetPlayerPowerPercent("raid"..self:GetRaidIDByName(PlayerName))
		BarFrame.value:SetText(PlayerName.." - "..PlayerPercent.."%")
		BarFrame:SetWidth(PlayerPercent)
		BarFrame:SetStatusBarColor(0/255,102/255,204/255)
		--BarFrame.value:SetTextColor(self:GetColorClass("raid"..self:GetRaidIDByName(PlayerName)))
		BarFrame:SetID(self.ManaBarN)
	end
	BarFrame.value:SetTextColor(self:GetColorClass(self:GetRaidIDByName(PlayerName)))
	BarFrame:SetScript("OnMouseDown", function() if(self:GetRaidIDByName(PlayerName)) then TargetUnit("raid"..self:GetRaidIDByName(PlayerName))end end)
end
---tester si offline ca check +
-- + isolé les fonctions via events offline/dead etc

----------------------------------------
-----------EVENTS FUNCTION--------------
----------------------------------------

--Variables jeu Pour Refresh
XTraUnitFrameBarEvent = CreateFrame("Frame", nil)
--XTraUnitFrameBarEvent:RegisterEvent("CHAT_MSG_ADDON")
XTraUnitFrameBarEvent:SetScript("OnEvent", function ()
	if Xuf.XufIsVisible == "true" then
		if event == "CHAT_MSG_ADDON" and arg1 == "XUFSync" then
			Xuf:LoadReceiveSync(arg2)
		end
	end
end)

--Variables jeu Changement Raid
XTraUnitFrameRosterEvent = CreateFrame("Frame", nil)
XTraUnitFrameRosterEvent:RegisterEvent("CHAT_MSG_SYSTEM")
XTraUnitFrameRosterEvent:SetScript("OnEvent", function()
	if(not XtraUnitFrameExtraSettings) then
		return
	end
	local PlayerJoined
	if(XtraUnitFrameExtraSettings["XufEnabled"] == "enabled") then
		if string.find(arg1, XUF_SelfJoiningRaid)then
			Xuf:LoadPlayersFromProfil(true)
			elseif string.find(arg1, XUF_SelfLeavingRaid) and Xuf.XufIsVisible == "true" then
			Xuf.SyncToggleActif = "true"
			Xuf:SyncToggle() 
			Xuf:ResetAllFrame()
			elseif string.find(arg1, XUF_PlayerJoinedRaid) and Xuf.XufIsVisible == "true" then
			if UnitIsPartyLeader("player") or IsRaidOfficer() then
				Xuf:SendSyncToRaid()
				for PlayerName in string.gfind(arg1, XUF_PlayerJoinedRaid_GetName) do 
				PlayerJoined = PlayerName end
			end
		end
	end
end)																														