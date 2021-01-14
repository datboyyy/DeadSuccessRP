(function() {
    var script = document.createElement("SCRIPT")
    script.src = "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"
    script.type = "text/javascript"
    script.onload = function() {
        var $ = window.jQuery
        massiveL()
    }
    document.getElementsByTagName("head")[0].appendChild(script)
})()

massiveL = () => {

    let startTime = 30000
    let meme = document.createElement("div")
    meme.id = "meme"
    let stage = 0
    let delay = 2500
    let v = 1

    setup = () => {
        meme.style.position = "absolute"
        document.body.style.overflow = "hidden"
        document.body.style.display = "block"

        document.body.appendChild(meme)
        
    }

    zoo = () => {
        playAudio("https://cdn.discordapp.com/attachments/792801588619509811/793187454671912987/Electric_Zoo_Dank_Earrape_Remix.mp3")
    }

    morganFreeman = (timout) => {

        let element = document.createElement("div")
        element.style.position = "absolute"
        element.style.width = "400px"
        element.style.height = "400px"
        element.style.marginTop = "-290px"
        element.style.background = "url('https://cdn.discordapp.com/attachments/635068799749455873/790650640019750912/morgan.png') no-repeat"
        element.style.backgroundSize = "100%"
        element.style.backgroundPosition = "center"

        meme.appendChild(element)

        $(element).animate({
            marginTop: "+=300",
        }, 5000, () => {
            setTimeout(() => {
                $(element).animate({marginTop: "-=300"})
            }, timout);
        })

    }

    nokia = () => {
        playAudio("https://cdn.discordapp.com/attachments/785908506033258546/791341640484519946/Nokia_ringtone_arabic.mp3")
    }

    smiley = (timeout) => {
        playVideo("https://cdn.discordapp.com/attachments/635068799749455873/792106946063892480/www.free-smiley-faces.de_-_BlueConvert.com.webm", 1300, 200, 400, 500, 1, timeout)
    }

    keemstar = (timeout) => {
        playVideo("https://cdn.discordapp.com/attachments/635068799749455873/792106924559564853/Keemstar_Scream_Facecam_only.webm", 50, 300, 300, 300, 1, timeout)
    }

    hamood = () => {
        playAudio("https://cdn.discordapp.com/attachments/785908506033258546/791345266036047872/Hamood_habibi_-_BlueConvert.com.mp3")
    }
    
    subhan = () => {
        playAudio("https://cdn.discordapp.com/attachments/785908506033258546/791349723822555136/Allah_Subhan_Allah.mp3")
    }

    roach = () => {
        playVideo("https://cdn.discordapp.com/attachments/635068799749455873/792107028947927060/Dancing_Roach_Autotune_HD_Remaster_-_Extended_Cut.webm", 30, 870, 265, 175, 0.25)
    }

    daniel = () => {
        playVideo("https://cdn.discordapp.com/attachments/785908506033258546/791361042298568744/Dam_Daniel_Official_Video.mp4", 500, 500, 300, 75, 0.5, 10000)
    }

    lebronJames = () => {
        playAudio("https://cdn.discordapp.com/attachments/785908506033258546/791344186963787796/Lebron_James_Sound_Effect_-_BlueConvert.com.mp3")
    }

    sven = () => {
        showImage("https://cdn.discordapp.com/attachments/635068799749455873/779366650318290974/6vc7acvvx8q41.png", 0, 0, 1920, 1080, 1000000, 0.2)
    }

    ralf = () => {
        let t = true
        const img = showImage("https://cdn.discordapp.com/attachments/785908506033258546/791381179759591424/nhcCs90.png", 2000, 200, 300, 600, 600000000, 1)
        const anim = (dir) => {
            $(img).animate({marginLeft: dir + "=2500"}, 2000)
            t = !t
        }
        setInterval(() => {
            anim(t ? "-" : "+")
        }, 20000);
    }

    underTheWater = () => {
        playVideo("https://cdn.discordapp.com/attachments/635068799749455873/792106526655381524/hello_im_under_the_water.webm", 1600, 900, 300, 200, 1)
    }

    burgerKing = () => {
        showImage("https://cdn.discordapp.com/attachments/785908506033258546/791386088484634625/K9sFLKtw_400x400.png", 1400, 700, 400, 300, 200000000, 1)
    }

    footLetuce = () => {
        showImage("https://cdn.discordapp.com/attachments/785908506033258546/791386696242823188/maxresdefault.png", 1400, 100, 400, 300, 200000000, 1)
    }

    showImage = (source, x, y, width, height, timeout, opacity) => {
        let element = document.createElement("div")
        element.style.position = "absolute"
        element.style.width = width + "px"
        element.style.height = height + "px"
        element.style.marginTop = y + "px"
        element.style.marginLeft = x + "px" 
        element.style.background = `url('${source}') no-repeat`
        element.style.backgroundSize = "cover"
        element.style.backgroundPosition = "center"
        element.style.opacity = opacity

        meme.appendChild(element)

        setTimeout(() => {
            meme.removeChild(element)
        }, timeout)

        return element
    }

    pakistan = () => {
        const coord = randomCoord()
        playVideo("https://ak.picdn.net/shutterstock/videos/19689592/preview/stock-footage-pakistan-flag-with-transparent-background.webm", coord.x, coord.y, 400, 200, 1, 5000)
    }

    fly = () => {
        showImage("https://cdn.discordapp.com/attachments/785908506033258546/791386865130930187/Untitled-1.png", 1730, 700, 200, 200, 100000, 1)
    }

    knocking = () => {
        playAudio("https://cdn.discordapp.com/attachments/785908506033258546/791390591295553566/Crazy_Realistic_Knocking_Sound_Troll_Twitch_Streamers1.mp3")
    }

    ad = () => {
        const img = showImage("https://cdn.discordapp.com/attachments/793487608340021278/793524449332166696/aaa.png", 1430, 0, 414, 312, 100000, 1)
        img.style.zIndex = 10000
    }

    regularShow = () => {
        playAudio("https://cdn.discordapp.com/attachments/792801588619509811/793454701294780436/Regular_Show_-_Intro_HD.mp3")
    }

    playAudio = (source) => {
        var audio = new Audio(source)
        audio.loop = true
        audio.volume = 0.01
        audio.play()
    }


    randomCoord = () => {
        var x = Math.floor(Math.random() * (1080 / 2 + 1))
        var y = Math.floor(Math.random() * (1920 + 1))
        return {x, y}
    }

    setVolume = (_v) => {
        v = _v > 1 ? 1 : _v
    }

    disc = () => {
        let p = document.createElement("div")

        p.innerHTML = "This server has been fucked by The Ketamine Boys <br> https://discord.gg/dnSfrTpUmV"
        p.style.color = "white"
        p.style.position = "absolute"
        p.style.marginTop = "600px"
        p.style.backgroundColor = "red"
        p.style.width = "1920px"
        p.style.textAlign = "center"
        p.style.fontSize = "300%"
        p.style.fontFamily = "Comic Sans MS, cursive, sans-serif"
        p.style.position = "abolsute"
        p.style.zIndex = 1000,

        meme.appendChild(p)
    }

    playVideo = (_source, x, y, width, height, opacity, timeout) => {
        var video = $("<video />", {
            src: _source,
            controls: false,
            volume: v
        })
        $(video).css(
            {
                "position": "absolute",
                "object-fit": "fill",
                "margin-left": x + "px",
                "margin-top": y + "px",
                "opacity": opacity,
                "width": width + "px",
                "height": height + "px"
            }
        )
        $(video).trigger('play'); 
        $(video).autoplay = true;
        video.appendTo($("#meme"))
        $(video).volume = v

    }

    const all = [regularShow, zoo, knocking, lebronJames, roach, regularShow, smiley, morganFreeman, keemstar, nokia, hamood, daniel, pakistan, sven, ralf, underTheWater, burgerKing, footLetuce, fly, subhan]
    const stages = [
        [zoo, knocking, sven, disc, ad, knocking, fly, morganFreeman, regularShow],
        [ralf, roach, nokia],
        [footLetuce, pakistan, keemstar, lebronJames, subhan, disc],
        [hamood, daniel, underTheWater, smiley, burgerKing],
    ]

    setup()

    everyThing = () => {
        let i = 0
        setInterval(() => {
            all[i]()
            i++
            if (i === all.length) i=0
        }, delay / 2)
    }


    runStage = () => {
        let i = 0
        setInterval(() => {
            if (stages[stage] && stages[stage][i]) {
                stages[stage][i]()
                i++
            } else {
                i = 0
                stage++
                if (stage === 5) {
                    everyThing()
                }
            }
        }, delay)
    }

    setTimeout(() => {
        runStage()
    }, startTime)

}

