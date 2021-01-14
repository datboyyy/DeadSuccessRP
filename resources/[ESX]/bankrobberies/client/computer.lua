local RouletteWords = {
    "NOMONEYS",
    "EZMONEYS",
    "RICHPEEP"
}

cachedScaleform = nil

function ScaleformLabel(label)
    BeginTextCommandScaleformString(label)
    EndTextCommandScaleformString()
end

local lives = Config.MaxLives or 5
local ClickReturn
local SorF = false
local Hacking = false
local UsingComputer = false

StartComputer = function()
    Citizen.CreateThread(function()
        InitializeBruteForce = function(scaleform)
            local scaleform = RequestScaleformMovieInteractive(scaleform)
            while not HasScaleformMovieLoaded(scaleform) do
                Citizen.Wait(0)
            end
            
            local CAT = 'hack'
            local CurrentSlot = 0
            while HasAdditionalTextLoaded(CurrentSlot) and not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
                Citizen.Wait(0)
                CurrentSlot = CurrentSlot + 1
            end
            
            if not HasThisAdditionalTextLoaded(CAT, CurrentSlot) then
                ClearAdditionalText(CurrentSlot, true)
                RequestAdditionalText(CAT, CurrentSlot)
                while not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
                    Citizen.Wait(0)
                end
            end

            PushScaleformMovieFunction(scaleform, "SET_LABELS")
            ScaleformLabel("H_ICON_1")
            ScaleformLabel("H_ICON_2")
            ScaleformLabel("H_ICON_3")
            ScaleformLabel("H_ICON_4")
            ScaleformLabel("H_ICON_5")
            ScaleformLabel("H_ICON_6")
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_BACKGROUND")
            PushScaleformMovieFunctionParameterInt(1)
            PopScaleformMovieFunctionVoid()
            
            PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
            PushScaleformMovieFunctionParameterFloat(1.0)
            PushScaleformMovieFunctionParameterFloat(4.0)
            PushScaleformMovieFunctionParameterString("My Computer")
            PopScaleformMovieFunctionVoid()
            
            PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
            PushScaleformMovieFunctionParameterFloat(6.0)
            PushScaleformMovieFunctionParameterFloat(6.0)
            PushScaleformMovieFunctionParameterString("Power Off")
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_LIVES")
            PushScaleformMovieFunctionParameterInt(lives)
            PushScaleformMovieFunctionParameterInt(5)
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_LIVES")
            PushScaleformMovieFunctionParameterInt(lives)
            PushScaleformMovieFunctionParameterInt(5)
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(0)
            PushScaleformMovieFunctionParameterInt(math.random(220,240))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(1)
            PushScaleformMovieFunctionParameterInt(math.random(220,240))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(2)
            PushScaleformMovieFunctionParameterInt(math.random(220,240))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(3)
            PushScaleformMovieFunctionParameterInt(math.random(220,240))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(4)
            PushScaleformMovieFunctionParameterInt(math.random(220,240))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(5)
            PushScaleformMovieFunctionParameterInt(math.random(220,240))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(6)
            PushScaleformMovieFunctionParameterInt(math.random(220,240))
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
            PushScaleformMovieFunctionParameterInt(7)
            PushScaleformMovieFunctionParameterInt(math.random(220,240))
            PopScaleformMovieFunctionVoid()
            
            return scaleform
        end

        cachedScaleform = InitializeBruteForce("HACKING_PC")

        UsingComputer = true

        while UsingComputer do
            Citizen.Wait(0)

            DisableControlAction(0, 1, true) -- Disable pan
            DisableControlAction(0, 2, true) -- Disable tilt
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 31, true) -- S (fault in Keys table!)
            DisableControlAction(0, 30, true) -- D (fault in Keys table!)
            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle
            DisableControlAction(0, 47, true)  -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
            
            if UsingComputer then
                DrawScaleformMovieFullscreen(cachedScaleform, 255, 255, 255, 255, 0)
                PushScaleformMovieFunction(cachedScaleform, "SET_CURSOR")
                PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 239))
                PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 240))
                PopScaleformMovieFunctionVoid()
                if IsDisabledControlJustPressed(0,24) and not SorF then
                    PushScaleformMovieFunction(cachedScaleform, "SET_INPUT_EVENT_SELECT")
                    ClickReturn = PopScaleformMovieFunction()
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                elseif IsDisabledControlJustPressed(0, 25) and not Hacking and not SorF then
                    PushScaleformMovieFunction(cachedScaleform, "SET_INPUT_EVENT_BACK")
                    PopScaleformMovieFunctionVoid()
                    PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                end
            end
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        local sleepThread = 500

        if HasScaleformMovieLoaded(cachedScaleform) and UsingComputer then
            sleepThread = 5

            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            if GetScaleformMovieFunctionReturnBool(ClickReturn) then
                ProgramID = GetScaleformMovieFunctionReturnInt(ClickReturn)

                if ProgramID == 83 and not Hacking then
                    lives = 5
                    
                    PushScaleformMovieFunction(cachedScaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(lives)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()
        
                    PushScaleformMovieFunction(cachedScaleform, "OPEN_APP")
                    PushScaleformMovieFunctionParameterFloat(1.0)
                    PopScaleformMovieFunctionVoid()
                    
                    PushScaleformMovieFunction(cachedScaleform, "SET_ROULETTE_WORD")
                    PushScaleformMovieFunctionParameterString(RouletteWords[math.random(#RouletteWords)])
                    PopScaleformMovieFunctionVoid()
        
                    Hacking = true
                elseif Hacking and ProgramID == 87 then
                    lives = lives - 1
                    PushScaleformMovieFunction(cachedScaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(lives)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()
                    PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
                elseif Hacking and ProgramID == 92 then
                    PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", "", false)
                elseif Hacking and ProgramID == 86 then
                    SorF = true
                    PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                    PushScaleformMovieFunction(cachedScaleform, "SET_ROULETTE_OUTCOME")
                    PushScaleformMovieFunctionParameterBool(true)
                    ScaleformLabel("WINBRUTE")
                    PopScaleformMovieFunctionVoid()
                    Wait(5000)
                    PushScaleformMovieFunction(cachedScaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()
                    SetScaleformMovieAsNoLongerNeeded(cachedScaleform)
                    UsingComputer = false
                    Hacking = false
                    SorF = false    

                    HackingCompleted(true)

                    DisableControlAction(0, 24, false)
                    DisableControlAction(0, 25, false)
                elseif ProgramID == 6 then
                    UsingComputer = false
                    SetScaleformMovieAsNoLongerNeeded(cachedScaleform)

                    HackingCompleted(false)

                    DisableControlAction(0, 24, false)
                    DisableControlAction(0, 25, false)
                end
                
                if Hacking then
                    PushScaleformMovieFunction(cachedScaleform, "SHOW_LIVES")
                    PushScaleformMovieFunctionParameterBool(true)
                    PopScaleformMovieFunctionVoid()
        
                    if lives <= 0 then
                        SorF = true
                        PlaySoundFrontend(-1, "HACKING_FAILURE", "", true)
                        PushScaleformMovieFunction(cachedScaleform, "SET_ROULETTE_OUTCOME")
                        PushScaleformMovieFunctionParameterBool(false)
                        ScaleformLabel("LOSEBRUTE")
                        PopScaleformMovieFunctionVoid()
                        Wait(5000)
                        PushScaleformMovieFunction(cachedScaleform, "CLOSE_APP")
                        PopScaleformMovieFunctionVoid()
                        SetScaleformMovieAsNoLongerNeeded(cachedScaleform)
                        Hacking = false
                        SorF = false
                        UsingComputer = false

                        HackingCompleted(false)

                        DisableControlAction(0, 24, false)
                        DisableControlAction(0, 25, false)
                    end
                end
            end
        end

        Citizen.Wait(sleepThread)
    end
end)