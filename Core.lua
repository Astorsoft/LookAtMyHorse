local _, class, _ = UnitClass("Player")

if class == "PALADIN" then
    local horses = {
        "Interface\\AddOns\\LookAtMyHorse\\Sounds\\horse1.mp3",
        "Interface\\AddOns\\LookAtMyHorse\\Sounds\\horse2.mp3",
        "Interface\\AddOns\\LookAtMyHorse\\Sounds\\horse3.mp3",
        "Interface\\AddOns\\LookAtMyHorse\\Sounds\\horse4.mp3",
        "Interface\\AddOns\\LookAtMyHorse\\Sounds\\horse5.mp3",
    }
    local enabled = false
    local chat = true
    local mode = "full"
    local index = 0
    SLASH_HORSE1 = "/lamh"
    SLASH_HORSE2 = "/horse"
    SlashCmdList["HORSE"] = function(msg)
        if msg == "" then
            enabled = not enabled
            if enabled then
                print("Look at my horse on!")
            else
                print("Look at my horse off :(")
            end
        elseif msg == "mono" then
            mode=  "mono"
            print("Mono mode: Only use the \"Look at my horse, my horse is amazing\" sample")

        elseif msg == "full" then
            mode = "full"
            index = 0
            print("Full mode: Use all samples, looping between them (default on)")
        elseif msg == "random" then
            mode = "random"
            print("Random mode: Use all samples, randomly")
        elseif msg == "chat" then
            chat = not chat
            if chat then print("Send chat message when in instance (default on)") else print("Ok, I won't say a word") end
        else
            print("Look At My Horse help:")
            print(" /horse help: Show this message")
            print(" /horse mono: Only use the \"Look at my horse, my horse is amazing\" sample")
            print(" /horse full: Use all samples, looping between them (default on)")
            print(" /horse random: Use all samples, randomly")
            print(" /horse chat: Send chat message when in instance (default on, only works in instances)")
            print(" /horse: Enable/disable the addon")
        end
    end 
    local CastTracker = CreateFrame("Frame")
    CastTracker = CreateFrame("Frame", nil, UIParent)
    CastTracker:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

    CastTracker:SetScript("OnEvent", function (_,e, ...) 
        local spellid = select(3, ...)
        if enabled and spellid == 190784 then -- divine steed 
            if mode == "full" then
                PlaySoundFile(horses[index % 5 + 1], "Master")
                index = index + 1
            elseif mode == "random" then
                PlaySoundFile(horses[random(1,5)], "Master")
            else -- mono
                PlaySoundFile(horses[1], "Master")
            end
            if chat then SendChatMessage("Look at my horse! My horse is amazing!" ,"SAY") end
        end
    end)
end
