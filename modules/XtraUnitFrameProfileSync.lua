------ Variable Local Group Frame Position
local TempGroupPos = {}

------ Check if Group Position exist in Current Profil Received
function Xuf:CheckGroupPosExist(profil)
	if XtraUnitFrameSettings[profil] and XtraUnitFrameSettings[profil]["GroupPos"] then
		TempGroupPos = XtraUnitFrameSettings[profil]["GroupPos"]
		else
		TempGroupPos = {}
	end
end

------ Save/Update a Group of Player in Current Sync Profil
function Xuf:SaveSyncGroupPlayer(profil, Group)
	XtraUnitFrameSettings[profil]["GroupPlayer"][Group] = { 
		[1] = self:GetPlayerSync(1),
		[2] = self:GetPlayerSync(2),
		[3] = self:GetPlayerSync(3),
		[4] = self:GetPlayerSync(4),
		[5] = self:GetPlayerSync(5),
		[6] = self:GetPlayerSync(6),
		[7] = self:GetPlayerSync(7),
		[8] = self:GetPlayerSync(8),
		[9] = self:GetPlayerSync(9),
		[10] = self:GetPlayerSync(10),
		[11] = self:GetPlayerSync(11),
		[12] = self:GetPlayerSync(12),
		[13] = self:GetPlayerSync(13),
		[14] = self:GetPlayerSync(14),
		[15] = self:GetPlayerSync(15),
	}
end

------ Load & Save the Profil Sync Received
function Xuf:LoadReceiveSync(myText)
	self.XtraSyncSettingReceived = {}
	if(myText ~= nil) then
		local i = 1;
		for s in string.gfind(myText, "(%w+)") do
			self.XtraSyncSettingReceived[i] = s;
			i = i + 1;
		end
		if(self:GetNbProfilSaved() >= 25) then
			DEFAULT_CHAT_FRAME:AddMessage("|cfffbb034You have too many Profils saved, Please delete some!(25 max)")
			return
		end
		if (self.XtraSyncSettingReceived[2] ~= UnitName("player")) then
			local profil = self.XtraSyncSettingReceived[3]
			self:CheckGroupPosExist(profil)
			XtraUnitFrameSettings[profil] = {
				["GroupSettings"] = {["NbGrpDisplayed"] = tonumber(self.XtraSyncSettingReceived[4])},
				["GroupPos"] = TempGroupPos,
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
			--XtraUnitFrameExtraSettings = {["AutoReload"] = "enabled", ["LockUnlockFrame"] =  "disabled", ["XufEnabled"] =  "enabled"}

			self:SaveSyncGroupPlayer(profil, tonumber(self.XtraSyncSettingReceived[5]))
			XtraUnitFrameProfil = profil
			self:LoadPlayersFromProfil()
			DEFAULT_CHAT_FRAME:AddMessage("XtraUnitFrame Sync Received from |cfffbb034"..self.XtraSyncSettingReceived[2].."|r : Profil [|cfffbb034"..self.XtraSyncSettingReceived[3].."|r] Groupe [|cfffbb034"..self.XtraSyncSettingReceived[5].."|r] Loaded.")
		end
	end
end