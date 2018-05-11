--Configuration du Menu en jeu
SLASH_XUF1, SLASH_XUF2 = "/XtraUnitFrame", "/Xuf"
SlashCmdList["XUF"] = function(message)
	local cmd = { }
	for c in string.gfind(message, "[^ ]+") do
		table.insert(cmd, string.lower(c))
	end
	if cmd[1] == "config" then
		XtraUnitFrameUI:Show();
		DefautMsgXuf()
		elseif cmd[1] == "show" then
		Xuf:LoadPlayersFromProfil()
		Xuf.SyncToggleActif = "false"
		Xuf:SyncToggle()
		elseif cmd[1] == "hide" then
		Xuf.SyncToggleActif = "true"
		Xuf:SyncToggle() 
		Xuf:ResetAllFrame()
		elseif cmd[1] == "sync" then
		Xuf:SyncToggle()
		elseif cmd[1] == "launchersync" then
		Xuf:LoadLauncherData()
		else
		if not XtraUnitFrameProfil then
			XtraUnitFrameProfil = "Default"
			Xuf:SaveDefaultProfil()
		end
		DefautMsgXuf()
	end
end


------AFFICHAGE MESSAGE ADDON
function DefautMsgXuf()
	DEFAULT_CHAT_FRAME:AddMessage("|cfffbb034<|r|cffead454Xckbucl XtraUnitFrame|r Made by Xckbucl on K2 & Elysium PVP")
	DEFAULT_CHAT_FRAME:AddMessage("|cfffbb034<|rAvailable Commands|r|cfffbb034>")
	DEFAULT_CHAT_FRAME:AddMessage("UI Config Menu |cff49C0C0/xuf config|r || |cff49C0C0/XtraUnitFrame config|r || |cff49C0C0/xuf|r || |cff49C0C0/xuf show|r || |cff49C0C0/xuf hide|r || |cff49C0C0/xuf sync")
    DEFAULT_CHAT_FRAME:AddMessage("|cffead454Xckbucl |rXtraUnitFrame |cfffbb034|||r |cff49C0C0Use wheel mouse on player for switch Health<->Power")
end		