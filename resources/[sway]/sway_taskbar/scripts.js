$(document).ready(function(){
  
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var curTask = 0;
  var processed = []
  function openMain() {
    $(".divwrap").fadeIn(10);
  }

  function closeMain() {
    $(".divwrap").css("display", "none");
  }  

  window.addEventListener('message', function(event){

    var item = event.data;
    if(item.runProgress === true) {
      openMain();

      $('#progress-bar').css("width","0%");
      $(".nicesexytext").empty();
      $('.nicesexytext').append(item.name);
    }

    if(item.runUpdate === true) {

      var percent = "" + item.Length + "%"
      $('#progress-bar').css("width",percent);

      $(".nicesexytext").empty();
      $('.nicesexytext').append(item.name);
    }

    if(item.closeFail === true) {
      closeMain()
      $.post('http://sway_taskbar/taskCancel', JSON.stringify({tasknum: curTask}));
    }

    if(item.closeProgress === true) {
      closeMain();
    }

    

  });
  window.addEventListener('message', function(event) {
    if (event.data["Action"] == "SHOW_DELAYED_FUNCTION") {
        const loadingInformation = event.data["Data"]

        $('.overlay').show()
        $('#loading-label').html(loadingInformation["title"])
        $('#loading-animation').animate({
            width: '100%'
        }, loadingInformation["time"], function() {
            $('#loading-animation').css({
                'width': '0%'
            })
            $('.overlay').hide()

            emit_client_event("delayed_function_complete", loadingInformation)
        })
    }

    emit_client_event = (event, data) => {
        const pipe = {
            event: event,
            data: data
        }

        $.post("http://sway_taskbar/event_handler", JSON.stringify(pipe))
      }
    });
    
});
