local EventFrame = CreateFrame("Frame");
EventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
EventFrame:RegisterEvent("COMBAT_LOG_EVENT");
EventFrame:RegisterEvent("PLAYER_DEAD");

local oofCount = 0;

function EventFrame:OnEvent(event, ...)
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
	end
end

function OofKill_QueueSound(num)
	oofCount = oofCount + 1;
	C_Timer.After(oofCount * 0.1, OofKill_Sounds);
end

function OofKill_Sounds() 
	PlaySoundFile("Interface/Addons/OOF_Kill/roblox-death-sound.mp3")
	oofCount = oofCount - 1;
	if oofCount < 0 then
		oofCount = 0;
	end
end

EventFrame:SetScript("OnEvent", EventFrame.OnEvent);

SLASH_OOFTEST1 = "/ooftest";

SlashCmdList["OOFTEST"] = OofKill_QueueSound;