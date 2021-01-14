//autoplay activated in html
var play = true;
var Audio = document.getElementById("audio");

//standard volume
Audio.volume = 0.4;

function onKeyDown(event) {
        switch (event.keyCode) {
            case 32: //SpaceBar                    
                if (play) {
                    Audio.pause();
                    play = false;
                } else {
                    Audio.play();
                    play = true;
                }
                break;
            case 38: //ArrowUp
                event.preventDefault();
                    if (Audio.volume!=1) {
                      try {
                          Audio.volume = Audio.volume + 0.1;
                      }
                      catch(err) {
                          Audio.volume = 1;
                      }       
                    }        
                break;
            case 40: //ArrowDown
                event.preventDefault();
                    Audio.volume = Audio.volume;
                    if (Audio.volume!=0.1) {
                      try {
                          Audio.volume = Audio.volume - 0.1;
                      }
                      catch(err) {
                          Audio.volume = 0.1;
                      }        
                    }        
                break;
        }
  return false;
}

window.addEventListener("keydown", onKeyDown, false);

