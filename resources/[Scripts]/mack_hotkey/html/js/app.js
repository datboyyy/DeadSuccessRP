var debug = false

window.addEventListener('message', function (event) {
    ShowHotKey(event.data);
});

function ShowHotKey(data) {
    if (data.exit == false) {
        // hotkey-container
        var container = document.createElement("div");
        container.id = `hotkey-container-${data.id}`;
        container.class = "hotkey-container";
        document.getElementById("body").appendChild(container);
        // key
        var key = document.createElement("div");
        key.id = `key-${data.id}`;
        key.class = "key";
        document.getElementById(`hotkey-container-${data.id}`).appendChild(key);
        // text
        var text = document.createElement("p");
        text.id = `text-${data.id}`;
        text.class = "text";
        document.getElementById(`hotkey-container-${data.id}`).appendChild(text);

        // change values
        document.getElementById(`hotkey-container-${data.id}`).style =   "border-radius: 3px;width: fit-content;position: absolute;right: 15%;display: flex;flex-flow: row;flex-wrap: wrap;background:#212732;";
        document.getElementById(`text-${data.id}`).innerHTML = data.text;
        document.getElementById(`text-${data.id}`).style = "color: #fff;padding: 6px;width: fit-content;border-radius: 5px;margin: 5px;font: verdana;font-size: 14px;font-weight: bold;";
        //$("#hotkey-container").fadeIn();
        document.getElementById(`hotkey-container-${data.id}`).style.display = "flex";
        if (debug == true) {
            console.log(data.id)
            console.log(data.text)
            console.log(data.hotkey)
            console.log(container.id)
        }
    } else {
        //$("#hotkey-container").fadeOut();
        hotkeycontainer = document.getElementById(`hotkey-container-${data.id}`)
        if (hotkeycontainer != null) {
        hotkeycontainer.style.display = "none";
        document.getElementById(`text-${data.id}`).innerHTML = "";
        }
        if (debug == true) {
            console.log(data.id)
        }
    }
}