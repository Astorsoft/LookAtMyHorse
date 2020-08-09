local _, class, _ = UnitClass("Player")

if class == "PALADIN" then
    print("|cFF00FFFFLookAtMyHorse:|r Type |cFFFF00FF/horse|r to start crackin! |TInterface\\AddOns\\LookAtMyHorse\\Textures\\horse:24:24|t")
    local horses = {
        "Interface\\AddOns\\LookAtMyHorse\\Sounds\\horse1.mp3",
        "Interface\\AddOns\\LookAtMyHorse\\Sounds\\horse2.mp3",
        "Interface\\AddOns\\LookAtMyHorse\\Sounds\\horse3.mp3",
        "Interface\\AddOns\\LookAtMyHorse\\Sounds\\horse4.mp3",
        "Interface\\AddOns\\LookAtMyHorse\\Sounds\\horse5.mp3",
    }
    local index = 0
    SLASH_HORSE1 = "/lamh"
    SLASH_HORSE2 = "/horse"
    SlashCmdList["HORSE"] = function(msg)
        if not LookAtMyHorseDB then LookAtMyHorseDB = { enabled = true, mode = "full", chat = false, always = true} end
        if msg == "" then
            LookAtMyHorseDB.enabled = not LookAtMyHorseDB.enabled
            if LookAtMyHorseDB.enabled then
                PlaySoundFile("Interface\\AddOns\\LookAtMyHorse\\Sounds\\horse_on.mp3", "master")
                print("Look at my horse on! |TInterface\\AddOns\\LookAtMyHorse\\Textures\\horse:24:24|t")
            else
                PlaySoundFile("Interface\\AddOns\\LookAtMyHorse\\Sounds\\horse_off.mp3", "master")
                print("Look at my horse off :(")
            end
        elseif msg == "mono" then
            LookAtMyHorseDB.mode=  "mono"
            print("Mono mode: Only use the \"Look at my horse, my horse is amazing\" sample")
        elseif msg == "full" then
            LookAtMyHorseDB.mode = "full"
            index = 0
            print("Full mode: Use all samples, looping between them (default on)")
        elseif msg == "random" then
            LookAtMyHorseDB.mode = "random"
            print("Random mode: Use all samples, randomly")
        elseif msg == "chat" then
            LookAtMyHorseDB.chat = not LookAtMyHorseDB.chat
            if LookAtMyHorseDB.chat then print("Send chat message when in instance (default on)") else print("Ok, I won't say a word") end
        elseif msg == "sometimes" then
            LookAtMyHorseDB.always = false
            print("Samples will only be used every now and then")
        elseif msg == "always" then
            LookAtMyHorseDB.always = true
            print("Samples will use each time you divine steed")
        elseif msg == "status" then
            if LookAtMyHorseDB.enabled then print("LookAtMyHorse enabled") else print("LookAtMyHorse disabled") end
            print("LookAtMyHorse mode " .. LookAtMyHorseDB.mode)
            if LookAtMyHorseDB.chat then print("LookAtMyHorse chatmode on") else print("LookAtMyHorse chatmode off") end
            if LookAtMyHorseDB.always then print("LookAtMyHorse always on") else print("LookAtMyHorse sometimes on") end
        else
            print("Look At My Horse help:")
            print(" /horse help: Show this message")
            print(" /horse mono: Only use the \"Look at my horse, my horse is amazing\" sample")
            print(" /horse full: Use all samples, looping between them (default on)")
            print(" /horse random: Use all samples, randomly")
            print(" /horse sometimes: Samples will only be used every now and then")
            print(" /horse always: Samples will use each time you divine steed")
            print(" /horse chat: Send chat message when in instance (default on, only works in instances)")
            print(" /horse status: shows current config)")
            print(" /horse: Enable/disable the addon")
        end
    end 
    local CastTracker = CreateFrame("Frame")
    CastTracker = CreateFrame("Frame", nil, UIParent)
    CastTracker:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

    CastTracker:SetScript("OnEvent", function (_,e, ...)
        local spellid = select(3, ...)
        if spellid ~= 190784 then return end
        local who = select(1, ...)
        if who ~= "player" then return end
        if not LookAtMyHorseDB then LookAtMyHorseDB = { enabled = true, mode = "full", chat = true, always = true} end
        if not LookAtMyHorseDB.always and (random(1,3) ~= 1) then 
            return
        end
        if LookAtMyHorseDB.enabled then -- divine steed 
            if LookAtMyHorseDB.mode == "full" then
                PlaySoundFile(horses[index % 5 + 1], "Master")
                index = index + 1
            elseif LookAtMyHorseDB.mode == "random" then
                PlaySoundFile(horses[random(1,5)], "Master")
            else -- mono
                PlaySoundFile(horses[1], "Master")
            end
            if chat then SendChatMessage("Look at my horse! My horse is amazing!" ,"SAY") end
        end
    end)
end
