Stash = {}
Stash.Functions = {}

Stash.Functions.OpenPinpad = function() {
    $(".container").fadeIn(300);
}

Stash.Functions.ClosePinpad = function() {
    $(".container").fadeOut(300);
    $.post('http://sway_stash/PinpadClose');
}

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            Stash.Functions.ClosePinpad();
            break;
        case 49:
            Stash.Functions.AddNumber(1);
            break;
        case 50:
            Stash.Functions.AddNumber(2);
            break;
        case 51:
            Stash.Functions.AddNumber(3);
            break;
        case 52:
            Stash.Functions.AddNumber(4);
            break;
        case 53:
            Stash.Functions.AddNumber(5);
            break;
        case 54:
            Stash.Functions.AddNumber(6);
            break;
        case 55:
            Stash.Functions.AddNumber(7);
            break;
        case 56:
            Stash.Functions.AddNumber(8);
            break;
        case 57:
            Stash.Functions.AddNumber(9);
            break;
        case 48:
            Stash.Functions.AddNumber(0);
            break;
        case 13:
            var v = $("#PINbox").val();
            if (v == "") {
                $.post('http://sway_stash/ErrorMessage', JSON.stringify({
                    message: "Vul een code in!"
                }))
            } else {
                data = {
                    pin: v
                }
                $("#PINbox").val("");
                $.post('http://sway_stash/EnterPincode', JSON.stringify({
                    pin: data.pin
                }))
                Stash.Functions.ClosePinpad();
            };
            break;
    }
});

$(document).ready(function(){
    window.addEventListener('message', function(event){
        switch(event.data.action) {
            case "open":
                Stash.Functions.OpenPinpad(event.data);
                break;
            case "close":
                Stash.Functions.ClosePinpad(event.data);
                break;
        }
    });
});


$( "#PINcode" ).html(
	"<form action='' method='' name='PINform' id='PINform' autocomplete='off' draggable='true'>" +
		"<input id='PINbox' type='password' value='' name='PINbox' disabled />" +
		"<br/>" +
		"<input type='button' class='PINbutton' name='1' value='1' id='1' onClick=addNumber(this); />" +
		"<input type='button' class='PINbutton' name='2' value='2' id='2' onClick=addNumber(this); />" +
		"<input type='button' class='PINbutton' name='3' value='3' id='3' onClick=addNumber(this); />" +
		"<br>" +
		"<input type='button' class='PINbutton' name='4' value='4' id='4' onClick=addNumber(this); />" +
		"<input type='button' class='PINbutton' name='5' value='5' id='5' onClick=addNumber(this); />" +
		"<input type='button' class='PINbutton' name='6' value='6' id='6' onClick=addNumber(this); />" +
		"<br>" +
		"<input type='button' class='PINbutton' name='7' value='7' id='7' onClick=addNumber(this); />" +
		"<input type='button' class='PINbutton' name='8' value='8' id='8' onClick=addNumber(this); />" +
		"<input type='button' class='PINbutton' name='9' value='9' id='9' onClick=addNumber(this); />" +
		"<br>" +
		"<input type='button' class='PINbutton clear' name='-' value='clear' id='-' onClick=clearForm(this); />" +
		"<input type='button' class='PINbutton' name='0' value='0' id='0' onClick=addNumber(this); />" +
		"<input type='button' class='PINbutton enter' name='+' value='enter' id='+' onClick=submitForm(PINbox); />" +
	"</form>"
);

function addNumber(e){
	var v = $("#PINbox").val();
	$("#PINbox").val(v + e.value);
}

Stash.Functions.AddNumber = function(num) {
	var v = $("#PINbox").val();
	$("#PINbox").val(v + num);
}

function clearForm(e){
	$("#PINbox").val("");
}

function submitForm(e) {
	if (e.value == "") {
		$.post('http://sway_stash/ErrorMessage', JSON.stringify({
            message: "Vul een code in!"
        }))
	} else {
        $.post('http://sway_stash/EnterPincode', JSON.stringify({
            pin: e.value
        }))
        $("#PINbox").val("");
        Stash.Functions.ClosePinpad();
	};
};