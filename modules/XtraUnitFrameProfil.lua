----- Load Settings in Interface
function Xuf:LoadSettingsInUI()
	self:CheckIfProfilExist()
	self:GetNbProfilSaved()
	XUFMainSettingsEditBoxSaveProfil:SetText(XtraUnitFrameProfil)
	XUFMainSettingsSliderGrpVisible:SetValue(XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupSettings"]["NbGrpDisplayed"])
	self:LoadPlayerNameSaved(XUFMainSettingsSliderGrpSettings:GetValue())
	
	-----Load AutoReload & Lock/Unlock Settings
	if XtraUnitFrameExtraSettings["AutoReload"] == "enabled" then
		XUFMainSettingsCheckEnableXtra1:SetChecked(true)
		else 
		XUFMainSettingsCheckEnableXtra1:SetChecked(false)
	end
	if XtraUnitFrameExtraSettings["LockUnlockFrame"] == "enabled" then
		XUFMainSettingsCheckMoveFrame:SetChecked(true)
		else 
		XUFMainSettingsCheckMoveFrame:SetChecked(false)
	end
	if XtraUnitFrameExtraSettings["XufEnabled"] == "enabled" then
		XUFMainSettingsCheckEnabled:SetChecked(true)
		else 
		XUFMainSettingsCheckEnabled:SetChecked(false)
	end
	self:LoadPlayersFromProfil()
end


------ Load Player on SavedFiles in Interface UI
function Xuf:LoadPlayerNameSaved(Group)
	local PlayerEditBoxInterface = {XUFMainSettingsEditBoxPlayer1, XUFMainSettingsEditBoxPlayer2, XUFMainSettingsEditBoxPlayer3, XUFMainSettingsEditBoxPlayer4, XUFMainSettingsEditBoxPlayer5, XUFMainSettingsEditBoxPlayer6,XUFMainSettingsEditBoxPlayer7,XUFMainSettingsEditBoxPlayer8,XUFMainSettingsEditBoxPlayer9,XUFMainSettingsEditBoxPlayer10,XUFMainSettingsEditBoxPlayer11,XUFMainSettingsEditBoxPlayer12,XUFMainSettingsEditBoxPlayer13,XUFMainSettingsEditBoxPlayer14,XUFMainSettingsEditBoxPlayer15}
	for p = 1, 15 do
		if not XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupPlayer"][Group] then
			PlayerEditBoxInterface[p]:SetText("")
			elseif not XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupPlayer"][Group][p] then
			PlayerEditBoxInterface[p]:SetText("")
			else
			PlayerEditBoxInterface[p]:SetText(XtraUnitFrameSettings[XtraUnitFrameProfil]["GroupPlayer"][Group][p])
		end
	end
end

------ Save/Update a Group of Player in Current Profil
function Xuf:SaveGroupPlayer(profil)
	XtraUnitFrameSettings[profil]["GroupPlayer"][XUFMainSettingsSliderGrpSettings:GetValue()] = { 
		[1] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer1),
		[2] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer2),
		[3] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer3),
		[4] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer4),
		[5] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer5),
		[6] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer6),
		[7] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer7),
		[8] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer8),
		[9] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer9),
		[10] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer10),
		[11] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer11),
		[12] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer12),
		[13] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer13),
		[14] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer14),
		[15] = GetEditBoxPlayerValue(XUFMainSettingsEditBoxPlayer15),
	}
end

------ Save/Update Current Profil
function Xuf:SaveSettingsProfil(profil)
	if(profil == "") then
		DEFAULT_CHAT_FRAME:AddMessage("|cFFFF8000You need to name the Profil.")
		else
		if(self:GetNbProfilSaved() >= 25) then
			DEFAULT_CHAT_FRAME:AddMessage("|cfffbb034You have too many Profils saved, Please delete some!(25 max)")
			return
		end
		self:SaveFramePos()
		local PlayerEditBoxInterface = {XUFMainSettingsEditBoxPlayer1, XUFMainSettingsEditBoxPlayer2, XUFMainSettingsEditBoxPlayer3, XUFMainSettingsEditBoxPlayer4, XUFMainSettingsEditBoxPlayer5, XUFMainSettingsEditBoxPlayer6,XUFMainSettingsEditBoxPlayer7,XUFMainSettingsEditBoxPlayer8,XUFMainSettingsEditBoxPlayer9,XUFMainSettingsEditBoxPlayer10,XUFMainSettingsEditBoxPlayer11,XUFMainSettingsEditBoxPlayer12,XUFMainSettingsEditBoxPlayer13,XUFMainSettingsEditBoxPlayer14,XUFMainSettingsEditBoxPlayer15}
		local PlayerList = {}
		for i = 1, 5 do
			PlayerList[1] = { [i] = PlayerEditBoxInterface[i]:GetText()}
		end
		XtraUnitFrameSettings[profil] =  {
			["GroupSettings"] = {["NbGrpDisplayed"] = XUFMainSettingsSliderGrpVisible:GetValue()},
			["GroupPos"] = {} ,
			["GroupPlayer"] = {
				[1] = self:CheckGroupExist(profil, 1),
				[2] = self:CheckGroupExist(profil, 2),
				[3] = self:CheckGroupExist(profil, 3),
				[4] = self:CheckGroupExist(profil, 4),
				[5] = self:CheckGroupExist(profil, 5),
				[6] = self:CheckGroupExist(profil, 6),
				[7] = self:CheckGroupExist(profil, 7),
				[8] = self:CheckGroupExist(profil, 8),
				[9] = self:CheckGroupExist(profil, 9),
				[10] = self:CheckGroupExist(profil, 10),
			},
		}
		self:XUFAutoReloadLockUnlockSettings()
		XtraUnitFrameSettings[profil]["GroupPos"] = self.FrameGrpPosition
		self:SaveGroupPlayer(profil)
		XtraUnitFrameProfil = profil
		DEFAULT_CHAT_FRAME:AddMessage("|cffead454Xckbucl |rXtraUnitFrame |cfffbb034|||r XtraUnitFrame Profil [|cfffbb034".. XUFMainSettingsEditBoxSaveProfil:GetText() .."|r] Saved.")
		self:LoadSettingsInUI()
	end
end

------ Save Default Profil if none Exist
function Xuf:SaveDefaultProfil()
	XtraUnitFrameExtraSettings = {["AutoReload"] = "enabled", ["LockUnlockFrame"] =  "disabled", ["XufEnabled"] =  "enabled"}
	XtraUnitFrameSettings = {["Default"] = {
		["GroupSettings"] = {["NbGrpDisplayed"] = 1, [1]= nil, [2]= nil, [3]= nil},
		["GroupPos"] ={},
		["GroupPlayer"] = {
			[1] = {},
			[2] = {},
			[3] = {},
			[4] = {},
			[5] = {},
			[6] = {},
			[7] = {},
			[8] = {},
			[9] = {},
			[10] = {},
		},
	}
	}
end

------ Delete Profil Saved
function Xuf:DeleteProfil(profilName)
	if(UIDropDownMenu_GetSelectedID(XUFMainSettingsDropDownProfils) == nil) then
		DEFAULT_CHAT_FRAME:AddMessage("|cFFFF7F0000No Profil Selected.")
		elseif (XtraUnitFrameProfil == self.ProfilNameSaved[UIDropDownMenu_GetSelectedID(XUFMainSettingsDropDownProfils)]) then
		DEFAULT_CHAT_FRAME:AddMessage("|cFF7F0000You Can't Delete a Profil Loaded. Choose Another one & Try Again.")
		else
		XtraUnitFrameSettings[profilName] = nil
		DEFAULT_CHAT_FRAME:AddMessage("|cffead454Xckbucl |rXtraUnitFrame |cfffbb034|||r XtraUnitFrame Profil [|cfffbb034"..profilName.."|r] Deleted.")
	end
end				