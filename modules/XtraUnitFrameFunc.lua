----------------------------------------
----------GROUP (UI) FUNCTIONS----------
----------------------------------------

----- Hide All Groups
function Xuf:HideGroups()
	if(not getglobal(self.Group_Frame_Name[1])) then
		return
	end
	for s = 1, 10 do
		getglobal(self.Group_Frame_Name[s]):Hide()
	end
end

----- Show Specific Group
function Xuf:SelectGroupToShow(Nb)
	if(not UnitExists("raid1") and not ForceToDisplayOnJoiningRaid) then
		return
	end
	self:HideGroups()
	if(not getglobal(self.Group_Frame_Name[1])) then
		return
	end
	for s = 1, Nb do
		getglobal(self.Group_Frame_Name[s]):Show()
	end
end


------ Get Number of Group from Saved Profil
function Xuf:GetGroupLenght()
	if (XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupSettings"]["NbGrpDisplayed"] ~= nil) then
		return XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupSettings"]["NbGrpDisplayed"]
		else
		return 1
	end
end

------ Get Number of Player in Group from Saved Profil
function Xuf:GetGroupPlayerLenght(Group)
	if(getn(XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupPlayer"][Group]) == 0) then
		return 1
		else
		return getn(XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupPlayer"][Group])
	end
end

------ Get Player Name from Saved Profil
function Xuf:GetPNameSaved(Group, Number)
	if(XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupPlayer"][Group][Number] == nil) then
		return "Unknown"
		else
		return XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupPlayer"][Group][Number]
	end
end

------ Main Func for Load players & UI
function Xuf:LoadPlayersFromProfil(ForceToDisplayOnJoiningRaid)
	self:CheckIfProfilExist()
	
	if(XtraUnitFrameExtraSettings["XufEnabled"] ~= "enabled") then
		DEFAULT_CHAT_FRAME:AddMessage("|cffead454Xckbucl |rXtraUnitFrame |cfffbb034|||r XtraUnitFrame is Disabled, you need to Enabled it")
		if(getglobal(self.Group_Frame_Name[1])) then
			self:HideGroups()	
		end
		return
	end
	
	if(not getglobal(self.Group_Frame_Name[1])) then
		self:InitAllFrame()
	end
	
	if(not UnitExists("raid1") and not ForceToDisplayOnJoiningRaid) then
		DEFAULT_CHAT_FRAME:AddMessage("|cffead454Xckbucl |rXtraUnitFrame |cfffbb034|||r |cfffbb034You are not in Raid")
		return
	end
	
	Xuf:ResetAllFrame()
	for g =1, self:GetGroupLenght() do 
		for b =1, self:GetGroupPlayerLenght(g) do
			self:AddPlayer(getglobal(self.Group_Frame_Name[g]..self.Group_Bar_Frame_Name[b]), self:GetPNameSaved(g, b))
			getglobal(self.Group_Frame_Name[g]..self.Group_Bar_Frame_Name[b]):Show()
			self:registerEvents(getglobal(self.Group_Frame_Name[g]..self.Group_Bar_Frame_Name[b]))
			if (XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupPos"][g]) then
				getglobal(self.Group_Frame_Name[g]):ClearAllPoints()
				getglobal(self.Group_Frame_Name[g]):SetPoint("TOPLEFT", XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupPos"][g]["X"], XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupPos"][g]["Y"])	
			end
		end
		getglobal(self.Group_Frame_Name[g]):Show()
		getglobal(self.Group_Frame_Name[g]):SetHeight(10+  (self:GetGroupPlayerLenght(g) * 15))
	end
	self.XufIsVisible = "true"
end

----- Reset All Frame to Default
function Xuf:ResetAllFrame()
	if(not getglobal(self.Group_Frame_Name[1])) then
		DEFAULT_CHAT_FRAME:AddMessage("|cffead454Xckbucl |rXtraUnitFrame |cfffbb034|||r |cfffbb034Nothing to Hide")
		return
	end
	for i = 1, getn(self.Group_Frame_Name) do
		getglobal(self.Group_Frame_Name[i]):Hide()
		getglobal(self.Group_Frame_Name[i]):SetHeight(160)
		for p = 1, getn(self.Group_Bar_Frame_Name) do
			getglobal(self.Group_Frame_Name[i]..self.Group_Bar_Frame_Name[p]):SetID(0)
			getglobal(self.Group_Frame_Name[i]..self.Group_Bar_Frame_Name[p]):Hide()
			getglobal(self.Group_Frame_Name[i]..self.Group_BarText_Frame_Name[p]):SetText("Unknown")
		end
	end
	self:unregisterAllEvents()
	self.XufIsVisible = "false"
end


--------------------------------------
----------PROFIL FUNCTIONS------------
--------------------------------------


------ Get Total Profils Saved
function Xuf:GetNbProfilSaved()
	if(not XtraUnitFrameSettings) then
		return 0
	end
		self.ProfilNameSaved = {}
	for name, config in pairs(XtraUnitFrameSettings) do table.insert(self.ProfilNameSaved, name) end
	return getn(self.ProfilNameSaved)
end

------ Check Exisiting SavedProfil
function Xuf:CheckIfProfilExist()
	if not XtraUnitFrameProfil then
		XtraUnitFrameProfil = "Default"
		self:SaveDefaultProfil()
	end
end

------ Get Value of Player EditBox
function GetEditBoxPlayerValue(EditBoxP)
	if(EditBoxP:GetText() == "") then
		return nil
		else
		return EditBoxP:GetText()
	end
end

------ Check if Group Node Exist in Profil & retrun Value
function Xuf:CheckGroupExist(profil, Group)
	if not XtraUnitFrameSettings[profil] then
		return {}
		else
		return XtraUnitFrameSettings[profil]["GroupPlayer"][Group]
	end
end


------ Toggle Enable/Disable AutoReload & Lock/Unlock & Hard Refresj
function Xuf:XUFAutoReloadLockUnlockSettings()
	local AutoReload
	local LockUnlock
	local XufEnabled
	if XUFMainSettingsCheckEnableXtra1:GetChecked() then
		AutoReload = "enabled"
	end
	if XUFMainSettingsCheckMoveFrame:GetChecked() then
		LockUnlock = "disabled"
	end
	if XUFMainSettingsCheckEnabled:GetChecked() then
		XufEnabled = "enabled"
	end
	
	XtraUnitFrameExtraSettings = {["AutoReload"] = AutoReload, ["LockUnlockFrame"] =  LockUnlock, ["XufEnabled"] =  XufEnabled}
end

----- Save Position of Groups
function Xuf:SaveFramePos()
	for g = 1, 10 do
		local point, relativeTo, relativePoint, xOfs, yOfs = getglobal(self.Group_Frame_Name[g]):GetPoint()
		self.FrameGrpPosition[g] = {FrameName = self.Group_Frame_Name[g], X = xOfs, Y = yOfs}
	end
	XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupPos"] = self.FrameGrpPosition
end

----------------------------------------
----------SETTINGS FUNCTIONS------------
----------------------------------------


------ Toggle Sync On/Off
function Xuf:SyncToggle()
	if(self.SyncToggleActif == "false") then
		XTraUnitFrameBarEvent:RegisterEvent("CHAT_MSG_ADDON")
		self.SyncToggleActif = "true"
		DEFAULT_CHAT_FRAME:AddMessage("|cffead454Xckbucl |rXtraUnitFrame |cfffbb034|||r Sync Enable")
		else
		XTraUnitFrameBarEvent:UnregisterEvent("CHAT_MSG_ADDON")
		self.SyncToggleActif = "false"
		DEFAULT_CHAT_FRAME:AddMessage("|cffead454Xckbucl |rXtraUnitFrame |cfffbb034|||r Sync Disable")
	end
end

----- Enable Sync
function Xuf:EnableSync()
	XTraUnitFrameBarEvent:RegisterEvent("CHAT_MSG_ADDON")
	self.SyncToggleActif = "true"
end

------ Function Unlock XtraUnitFrame
function Xuf:UnlockFrame(FrameClick, FrameMoving)
	FrameMoving:SetMovable(true);
	FrameClick:EnableMouse(true)
	FrameClick:RegisterForDrag("LeftButton")
	
	FrameClick:SetScript("OnDragStart", function() FrameMoving:StartMoving() end)
    FrameClick:SetScript("OnDragStop", function() 
		FrameMoving:StopMovingOrSizing() 
		self:SaveFramePos()
	end)
end



----------------------------------------
-------------MISC FUNCTIONS-------------
----------------------------------------


------ Detect TabPressed on Editbox
function Xuf:SwitchEditBoxTabbEvent(BoxFocus, BoxNext)
	local PlayerEditBoxInterface = {XUFMainSettingsEditBoxPlayer1, XUFMainSettingsEditBoxPlayer2, XUFMainSettingsEditBoxPlayer3, XUFMainSettingsEditBoxPlayer4, XUFMainSettingsEditBoxPlayer5, XUFMainSettingsEditBoxPlayer6,XUFMainSettingsEditBoxPlayer7,XUFMainSettingsEditBoxPlayer8,XUFMainSettingsEditBoxPlayer9,XUFMainSettingsEditBoxPlayer10,XUFMainSettingsEditBoxPlayer11,XUFMainSettingsEditBoxPlayer12,XUFMainSettingsEditBoxPlayer13,XUFMainSettingsEditBoxPlayer14,XUFMainSettingsEditBoxPlayer15}
	
	PlayerEditBoxInterface[BoxFocus]:SetScript("OnTabPressed", function()
		PlayerEditBoxInterface[BoxFocus]:ClearFocus(); -- clears focus from editbox, (unlocks key bindings, so pressing W makes your character go forward.
		PlayerEditBoxInterface[BoxNext]:SetFocus(); -- if this is provided, previous line is not needed (opens chat frame)
	end)
end

------ Switch Editbox on TabPressed
function Xuf:SwitchEditBoxTabb()
	self:SwitchEditBoxTabbEvent(1,2)
	self:SwitchEditBoxTabbEvent(2,3)
	self:SwitchEditBoxTabbEvent(3,4)
	self:SwitchEditBoxTabbEvent(4,5)
	self:SwitchEditBoxTabbEvent(5,6)
	self:SwitchEditBoxTabbEvent(6,7)
	self:SwitchEditBoxTabbEvent(7,8)
	self:SwitchEditBoxTabbEvent(8,9)
	self:SwitchEditBoxTabbEvent(9,10)
	self:SwitchEditBoxTabbEvent(10,11)
	self:SwitchEditBoxTabbEvent(11,12)
	self:SwitchEditBoxTabbEvent(12,13)
	self:SwitchEditBoxTabbEvent(13,14)
	self:SwitchEditBoxTabbEvent(14,15)
	self:SwitchEditBoxTabbEvent(15,1)
end

------ Get Player Raid ID
function Xuf:GetRaidIDByName(PlayerName)
	local targetID;
	for i = 1, GetNumRaidMembers() do
		if UnitName("raid"..i) == PlayerName then
			targetID = i;
			break;
		end
	end
	return targetID
end

------ Get Player Health in %
function Xuf:GetPlayerHealthPercent(player)
	if(not player) then
	return 100
	end
	local PlayerHealth = UnitHealth(player)
	local PlayerMaxHealth = UnitHealthMax(player)
	return ceil(PlayerHealth / PlayerMaxHealth * 100)
end

------ Get Player Mana/Rage/Enery in %
function Xuf:GetPlayerPowerPercent(player)
	if(not player) then
	return 100
	end
	local PlayerManaP = ceil(UnitMana(player) / UnitManaMax(player) * 100)
	if(PlayerManaP < 1) then
		return 1
		else
		return PlayerManaP
	end
end

------ Get Class of Player
function Xuf:GetPlayerClass(player)
	class, classFileName = UnitClass(player)
	return classFileName
end

------ Get Color Class of Player
function Xuf:GetColorClass(PName)
	local player = PName
	if(not player) then
	player = "Unknown"
	end
	class, classFileName = UnitClass("raid"..player)
	if(classFileName == "HUNTER") then
		return 0.67,0.83,0.45
		elseif(classFileName == "PALADIN") then
		return 0.96,0.55,0.73
		elseif(classFileName == "PRIEST") then
		return 1,1,1
		elseif(classFileName == "DRUID") then
		return 1,0.49,0.04
		elseif(classFileName == "ROGUE") then
		return 1,0.96,0.41
		elseif(classFileName == "WARRIOR") then
		return 	0.78,0.61,0.43
		elseif(classFileName == "WARLOCK") then
		return 0.58,0.51,0.79	
		elseif(classFileName == "MAGE") then
		return 0.41,0.80,0.94
		elseif(classFileName == "SHAMAN") then
		return 0,0.44,0.87
		else
		return 1,1,1
	end
end


----------------------------------------
-------------SYNC FUNCTIONS-------------
----------------------------------------

------ Get Player Name from Sync Received
function Xuf:GetPlayerSync(playerN)
	if (self.XtraSyncSettingReceived[playerN+5] == nil) then
		return nil
		else
		return self.XtraSyncSettingReceived[playerN+5]
	end
end

------ Sync Profil to Raid
function Xuf:SendSyncToRaid()
	for i = 1, XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupSettings"]["NbGrpDisplayed"] do
		SendAddonMessage("XUFSync", "XUFSync "..UnitName("player").." "..XtraUnitFrameProfil.." "..XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupSettings"]["NbGrpDisplayed"].." "..i.." "..table.concat(XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupPlayer"][i], " "), "RAID")
	end
end


----------------------------------------
-------------MNMB FUNCTIONS-------------
----------------------------------------

------ MiniMapButton Drag Around the MiniMap
function Xuf:XUF_DragMMBOnUpdate(elapsed)
	if( self.XUF_MiniMapDrag == 1) then
		local xpos,ypos = GetCursorPosition();
		local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom();
		xpos = xmin-xpos/Minimap:GetEffectiveScale()+70;
		ypos = ypos/Minimap:GetEffectiveScale()-ymin-70;
		local angle = math.deg(math.atan2(ypos,xpos));
		XUF_MinimapButtonFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 53-(cos(angle)*81), -55+(sin(angle)*81));
	end
end

------ Load Saved MiniMapButton
function Xuf:XUF_LoadButtonPosition()
	if ( event == "VARIABLES_LOADED" ) then
		if not MMPButtonSettings then
			MMPButtonSettings = {}
			MMPButtonSettings["ButtonPos"] = self.XUF_DefaultOptions["ButtonPos"]
		end
		XUF_MinimapButtonFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", MMPButtonSettings["ButtonPos"][1], MMPButtonSettings["ButtonPos"][2]);
		XUFMBBFrame:UnregisterEvent("VARIABLES_LOADED")
	end
end

------ Load Variable For MiniMapButton Loading Pos
function Xuf:XUFMBBFrame_OnLoad()
	XUFMBBFrame:RegisterEvent("VARIABLES_LOADED")
end

------ Event MiniMapButton Click
function Xuf:XUF_OnClickButton(arg1)
	self:GetNbProfilSaved()
	if( arg1 == "RightButton" ) then
		local XufContextBtn = CreateFrame("Frame", "XUFMMBBtnContextMenuFrame", UIParent, "UIDropDownMenuTemplate");
		UIDropDownMenu_Initialize(XufContextBtn, nil, "MENU");
		ToggleDropDownMenu(1, nil, XUFMiniMapBtnContextMenu, "XUF_MinimapButtonFrame", -100, 0);
	end
end

------ Context MiniMap Button Menu Option
function XUFMiniMapButtonMenu_OnLoad()
	info            = {};
	info.text   = "XUF MiniMap Menu";
	info.isTitle = true
	UIDropDownMenu_AddButton(info);
	
	info            = {};
	info.text       = "Show UI";
	info.func = function() 
		Xuf:LoadPlayersFromProfil()
	end
	UIDropDownMenu_AddButton(info);
	
	info            = {};
	info.text       = "Hide UI";
	info.func = function() Xuf.SyncToggleActif = "true"
		Xuf:SyncToggle() Xuf:ResetAllFrame()
	end
	UIDropDownMenu_AddButton(info);
	
	info            = {};
	info.text       = "Sync Toggle";
	info.func = function() Xuf:SyncToggle() end
	UIDropDownMenu_AddButton(info);
	
	info            = {};
	info.text       = "Open Settings";
	info.func = function() XtraUnitFrameUI:Show();
	DefautMsgXuf() end
	UIDropDownMenu_AddButton(info);
	
	info            = {};
	info.text   = "Load & Sync Profil";
	info.isTitle = true
	UIDropDownMenu_AddButton(info);
	
	local info = {}
	info.func = LoadSyncP
	for k,v in pairs(Xuf.ProfilNameSaved) do
		info.text, info.arg1 = v, k
		UIDropDownMenu_AddButton(info)
	end
	
end	


function LoadSyncP(arg1)
	XtraUnitFrameProfil = Xuf.ProfilNameSaved[arg1]
	if UnitIsPartyLeader("player") or IsRaidOfficer() then
		Xuf:SendSyncToRaid()
		Xuf:LoadPlayersFromProfil()
		DEFAULT_CHAT_FRAME:AddMessage("|cffead454Xckbucl |rXtraUnitFrame |cfffbb034|||r Profil ["..Xuf.ProfilNameSaved[arg1].."] Loaded & Sync to Raid")
		else
		DEFAULT_CHAT_FRAME:AddMessage("|cffead454Xckbucl |rXtraUnitFrame |cfffbb034|||r Profil ["..Xuf.ProfilNameSaved[arg1].."] Loaded, You need privilege for Sync to Raid.")
	end
end
