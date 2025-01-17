function ButtonMessage(text)

    BeginTextCommandScaleformString("STRING")

    AddTextComponentScaleform(text)

    EndTextCommandScaleformString()

end



function Button(ControlButton)

    N_0xe83a3e3557a56640(ControlButton)

end



function setupScaleform(scaleform)



    local scaleform = RequestScaleformMovie(scaleform)



    while not HasScaleformMovieLoaded(scaleform) do

        Citizen.Wait(1)

    end



    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")

    PopScaleformMovieFunctionVoid()

    

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")

    PushScaleformMovieFunctionParameterInt(200)

    PopScaleformMovieFunctionVoid()



    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")

    PushScaleformMovieFunctionParameterInt(4)

    Button(GetControlInstructionalButton(2, config.controls.goUp, true))

    ButtonMessage("Go Up")

    PopScaleformMovieFunctionVoid()



    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")

    PushScaleformMovieFunctionParameterInt(3)

    Button(GetControlInstructionalButton(2, config.controls.goDown, true))

    ButtonMessage("Go Down")

    PopScaleformMovieFunctionVoid()



    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")

    PushScaleformMovieFunctionParameterInt(2)

    Button(GetControlInstructionalButton(1, config.controls.turnRight, true))

    Button(GetControlInstructionalButton(1, config.controls.turnLeft, true))

    ButtonMessage("Turn Left/Right")

    PopScaleformMovieFunctionVoid()



    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")

    PushScaleformMovieFunctionParameterInt(1)

    Button(GetControlInstructionalButton(1, config.controls.goBackward, true))

    Button(GetControlInstructionalButton(1, config.controls.goForward, true))

    ButtonMessage("Go Forwards/Backwards")

    PopScaleformMovieFunctionVoid()



    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")

    PushScaleformMovieFunctionParameterInt(0)

    Button(GetControlInstructionalButton(2, config.controls.changeSpeed, true))

    ButtonMessage("Change Speed ("..config.speeds[index].label..")")

    PopScaleformMovieFunctionVoid()



    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")

    PopScaleformMovieFunctionVoid()



    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")

    PushScaleformMovieFunctionParameterInt(config.bgR)

    PushScaleformMovieFunctionParameterInt(config.bgG)

    PushScaleformMovieFunctionParameterInt(config.bgB)

    PushScaleformMovieFunctionParameterInt(config.bgA)

    PopScaleformMovieFunctionVoid()



    return scaleform

end