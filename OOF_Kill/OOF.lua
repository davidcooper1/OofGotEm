OofKill_OptionsPanel:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
OofKill_OptionsPanel:RegisterEvent("COMBAT_LOG_EVENT");
OofKill_OptionsPanel:RegisterEvent("PLAYER_DEAD");
OofKill_OptionsPanel:RegisterEvent("ADDON_LOADED");

local oofCount = 0;
local soundChannels = { "Master", "SFX", "Music", "Ambience", "Dialog" };

function OofKill_OptionsPanel:OnEvent(event, arg1, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, eventType, _, sourceGUID, _, _, _, _, destinationName, _, _, _, swingOverkill, _, _, spellOverkill = CombatLogGetCurrentEventInfo();
		if eventType == "PARTY_KILL" then
			if sourceGUID == UnitGUID("player") then
				OofKill_QueueSound(0);
			end
		elseif eventType == "SPELL_DAMAGE" then
			if sourceGUID == UnitGUID("pet") and spellOverkill ~= nil and spellOverkill >= 0 then
				OofKill_QueueSound(0);
			end
		elseif eventType == "SWING_DAMAGE" then
			if sourceGUID == UnitGUID("pet") and swingOverkill ~= nil and swingOverkill >= 0 then
				OofKill_QueueSound(0);
			end
		end
	elseif event == "PLAYER_DEAD" then
		OofKill_QueueSound(0);
	elseif (event == "ADDON_LOADED" and arg1 == "OOF_Kill") then
		if (not OofKill_Settings or OofKill_Previous_Version ~= GetAddOnMetadata("OOF_Kill", "Version")) then
			OofKill_Settings = {};
			OofKill_Settings.SoundChannel = "Master";
			OofKill_Previous_Version = GetAddOnMetadata("OOF_Kill", "Version");
		end
		OofKill_AddOptionsPanel(OofKill_OptionsPanel);
		OofKill_SoundChannelDropdown_RegisterScripts();
	end
end

function OofKill_QueueSound(num)
	oofCount = oofCount + 1;
	C_Timer.After(oofCount * 0.1, OofKill_Sounds);
end

function OofKill_Sounds() 
	PlaySoundFile("Interface/Addons/OOF_Kill/roblox-death-sound.mp3", OofKill_Settings.SoundChannel);
	oofCount = oofCount - 1;
	if oofCount < 0 then
		oofCount = 0;
	end
end

function OofKill_AddOptionsPanel(panel) 
	panel.name = 'OOF Kill';
	panel.okay = function(self) end;
	panel.cancel = function(self) end;
	InterfaceOptions_AddCategory(panel);
end

function OofKill_SoundChannelDropdown_RegisterScripts()
	UIDropDownMenu_SetWidth(OofKill_SoundChannelDropdown, 200);
	OofKill_SoundChannelDropdown_OnLoad(OofKill_SoundChannelDropdown);
	OofKill_SoundChannelDropdown:SetScript("OnLoad", OofKill_SoundChannelDropdown_OnLoad);
	OofKill_SoundChannelDropdown:SetScript("OnClick", OofKill_SoundChannelDropdown_OnClick);
end

function OofKill_SoundChannelDropdown_OnLoad(self)
	UIDropDownMenu_Initialize(self, OofKill_SoundChannelDropdown_Populate);
end

function OofKill_SoundChannelDropdown_Populate(dropDown)
	UIDropDownMenu_SetText(dropDown, OofKill_Settings.SoundChannel);
	local info = UIDropDownMenu_CreateInfo();
	for _, v in pairs(soundChannels) do 
		info.text = v;
		info.value = v;
		info.checked = OofKill_Settings.SoundChannel == v and 1 or nil;
		info.func = function(self, arg1, arg2, checked)
			OofKill_Settings.SoundChannel = self:GetText();
			UIDropDownMenu_SetSelectedName(dropDown, self:GetText(), true);
		end;
		UIDropDownMenu_AddButton(info);
	end
end

function OofKill_SoundChannelDropdown_OnClick(self)
	ToggleDropDownMenu(1, nil, self, "OofKill_SoundChannelDropdown", 0, 0);
end

OofKill_OptionsPanel:SetScript("OnEvent", OofKill_OptionsPanel.OnEvent);

SLASH_OOFTEST1 = "/ooftest";

SlashCmdList["OOFTEST"] = OofKill_QueueSound;