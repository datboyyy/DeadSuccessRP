$(function () {
    let height = 25.5
    window.addEventListener('message', function (event) {
        if (event.data.type == "updateStatusHudstate") {
            $("body").css("display", event.data.show ? "block" : "none");

            widthHeightSplit(event.data.varSetHunger, $("#varSetHunger").find(".progressBar"))
            widthHeightSplit(event.data.varSetThirst, $("#varSetThirst").find(".progressBar"))
            widthHeightSplit(event.data.varSetStress, $("#varSetStress").find(".progressBar"))

            if (event.data.hasParachute == true) {
                $("#parachute").removeClass("hidden")
            } else {
                $("#parachute").addClass("hidden")
            }



            changeColor($("#varSetHunger"), event.data.varSetHunger, false)
            changeColor($("#varSetThirst"), event.data.varSetThirst, false)
            changeColor($("#varSetStress"), event.data.varSetStress, true)

            if (event.data.varSetArmor <= 0) {
                $("#varSetArmor").find(".barIcon").removeClass("danger")
            }

            if (event.data.colorblind === true) {
                $(".progressBar").addClass("colorBlind")
            }
            else {
                $(".progressBar").removeClass("colorBlind")
            }
        }
        if (event.data.type == "updateStatusHud") {
            $("body").css("display", event.data.show ? "block" : "none");

            $("#varSetHealth").find(".progressBar").attr("style", "width: " + event.data.varSetHealth + "%;")
            $("#varSetArmor").find(".progressBar").attr("style", "width: " + event.data.varSetArmor + "%;")

            widthHeightSplit(event.data.varSetOxy, $("#varSetOxy").find(".progressBar"))

            let voice = event.data.varSetVoice
            $(".voice1").addClass("hidden")
            $(".voice2").addClass("hidden")
            $(".voice3").addClass("hidden")
            $(".dev").addClass("hidden")
            $(".devDebug").addClass("hidden")
            if (voice == 1) {
                $(".voice1").removeClass("hidden")
            }
            if (voice == 2) {
                $(".voice2").removeClass("hidden")
                $(".voice3").removeClass("hidden")
            }
            if (voice == 3) {
                $(".voice1").removeClass("hidden")
                $(".voice2").removeClass("hidden")
                $(".voice3").removeClass("hidden")
            }
            if (event.data.varDev == true) {
                $(".dev").removeClass("hidden")
            }
            if (event.data.varDevDebug == true) {
                $(".devDebug").removeClass("hidden")
            }


            changeColor($("#varSetHealth"), event.data.varSetHealth, false)
            changeColor($("#varSetArmor"), event.data.varSetArmor, false)
            changeColor($("#varSetOxy"), event.data.varSetOxy, false)
            if (event.data.varSetArmor <= 0) {
                $("#varSetArmor").find(".barIcon").removeClass("danger")
            }

            if (event.data.colorblind === true) {
                $(".progressBar").addClass("colorBlind")
            }
            else {
                $(".progressBar").removeClass("colorBlind")
            }
        }
        if (event.data.type == "radiostatus") {
            if (event.data.radiotalk) {
                $(".voice").addClass("radiotalk");
            } else {
                $(".voice").removeClass("radiotalk");
            }
        }
        if (event.data.type == "phonestatus") {
            if (event.data.phonetalk) {
                $(".voice").addClass("phonetalk");
            } else {
                $(".voice").removeClass("phonetalk");
            }
        }
        if (event.data.type == "talkingStatus") {
            if (event.data.is_talking) {
                $(".voice").addClass("talking");
            } else {
                $(".voice").removeClass("talking");
            }
        
        }
        })

    function widthHeightSplit(value, ele) {
        let eleHeight = (value / 100) * height;
        let leftOverHeight = height - eleHeight;

        ele.attr("style", "height: " + eleHeight + "px; top: " + leftOverHeight + "px;")
    }

    function changeColor(ele, value, flip) {
        let add = false
        if (flip) {
            if (value > 25) {
                add = true
            }
        }
        else {
            if (value < 25) {
                add = true
            }
        }

        if (add) {
            // ele.find(".barIcon").addClass("danger")
            ele.find(".progressBar").addClass("dangerGrad")
        }
        else {
            // ele.find(".barIcon").removeClass("danger")
            ele.find(".progressBar").removeClass("dangerGrad")
        }
    }
})
