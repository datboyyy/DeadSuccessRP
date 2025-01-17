var CurrentTwitterTab = "twitter-home"
var HashtagOpen = false;
var MinimumTrending = 100;
let url;

$(document).on('click', '.twitter-header-tab', function (e) {
    e.preventDefault();

    var PressedTwitterTab = $(this).data('twittertab');
    var PreviousTwitterTabObject = $('.twitter-header').find('[data-twittertab="' + CurrentTwitterTab + '"]');

    if (PressedTwitterTab !== CurrentTwitterTab) {
        $(this).addClass('selected-twitter-header-tab');
        $(PreviousTwitterTabObject).removeClass('selected-twitter-header-tab');

        $("." + CurrentTwitterTab + "-tab").css({
            "display": "none"
        });
        $("." + PressedTwitterTab + "-tab").css({
            "display": "block"
        });

        if (PressedTwitterTab === "twitter-mentions") {
            $.post('http://MI-phone/ClearMentions');
        }

        if (PressedTwitterTab == "twitter-home") {

            $.post('http://MI-phone/GetTweets', JSON.stringify({}), function (Tweets) {
                MI.Phone.Notifications.LoadTweets(Tweets);

            });

        }
        if (PressedTwitterTab == "twitter-self") {
            $.post('http://MI-phone/GetSelfTweets', JSON.stringify({}), function (selfdata) {
                MI.Phone.Notifications.LoadSelfTweets(selfdata)
            })

        }



        CurrentTwitterTab = PressedTwitterTab;

        if (HashtagOpen) {
            event.preventDefault();

            $(".twitter-hashtag-tweets").css({
                "left": "30vh"
            });
            $(".twitter-hashtags").css({
                "left": "0vh"
            });
            $(".twitter-new-tweet").css({
                "display": "block"
            });
            $(".twitter-hashtags").css({
                "display": "block"
            });
            HashtagOpen = false;
        }
    } else if (CurrentTwitterTab == "twitter-hashtags" && PressedTwitterTab == "twitter-hashtags") {
        if (HashtagOpen) {
            event.preventDefault();

            $(".twitter-hashtags").css({
                "display": "block"
            });
            $(".twitter-hashtag-tweets").animate({
                left: 30 + "vh"
            }, 150);
            $(".twitter-hashtags").animate({
                left: 0 + "vh"
            }, 150);
            HashtagOpen = false;
        }
    } else if (CurrentTwitterTab == "twitter-home" && PressedTwitterTab == "twitter-home") {
        event.preventDefault();

        $.post('http://MI-phone/GetTweets', JSON.stringify({}), function (Tweets) {
            MI.Phone.Notifications.LoadTweets(Tweets);
        });
    } else if (CurrentTwitterTab == "twitter-mentions" && PressedTwitterTab == "twitter-mentions") {
        event.preventDefault();

        $.post('http://MI-phone/GetMentionedTweets', JSON.stringify({}), function (MentionedTweets) {
            MI.Phone.Notifications.LoadMentionedTweets(MentionedTweets)
        })
    } else if (CurrentTwitterTab == "twitter-self" && PressedTwitterTab == "twitter-self") {
        event.preventDefault();

        $.post('http://MI-phone/GetSelfTweets', JSON.stringify({}), function (selfTweets) {
            MI.Phone.Notifications.LoadSelfTweets(selfTweets)
        })
    }


});


$(document).on('click', '.twitter-new-tweet', function (e) {
    e.preventDefault();
    MI.Phone.Animations.TopSlideDown(".twitter-new-tweet-tab", 450, 0);
});

MI.Phone.Notifications.LoadTweets = function (Tweets) {
    Tweets = Tweets.reverse();

    if (Tweets !== null && Tweets !== undefined && Tweets !== "" && Tweets.length > 0) {
        $(".twitter-home-tab").html("");
        $.each(Tweets, function (i, Tweet) {
            let TwtMessage = Tweet.message;
            let today = new Date();
            let TweetTime = new Date(Tweet.time);
            let diffMs = (today - TweetTime);
            let diffDays = Math.floor(diffMs / 86400000);
            let diffHrs = Math.floor((diffMs % 86400000) / 3600000);
            let diffMins = Math.round(((diffMs % 86400000) % 3600000) / 60000);
            let diffSeconds = Math.round(diffMs / 1000);
            let TimeAgo = diffSeconds + ' s';
            if (diffMins > 0) {
                TimeAgo = diffMins + ' m';
            } else if (diffHrs > 0) {
                TimeAgo = diffHrs + ' h';
            } else if (diffDays > 0) {
                TimeAgo = diffDays + ' d';
            }
            let TwitterHandle = Tweet.firstName + ' ' + Tweet.lastName
            let PictureUrl = "./img/default.png"
            if (Tweet.picture !== "default") {
                PictureUrl = Tweet.picture
            }

            if (Tweet.url == "" && Tweet.message != "") {
                let TweetElement = '<div class="twitter-tweet" data-twtid = "' + Tweet.id + '" data-twthandler="@' + TwitterHandle.replace(" ", "_") + '">' +
                    '<div class="tweet-tweeter">' + Tweet.firstName + ' ' + Tweet.lastName + ' &nbsp;<span>@' + TwitterHandle.replace(" ", "_") + ' &middot; ' + TimeAgo + '</span></div>' +
                    '<div class="tweet-message">' + Tweet.message + '</div>' +
                    '<div class="twt-img" style="top: 1vh;"><img src="' + PictureUrl + '" class="tweeter-image"></div>' +
                    '<div class="tweet-reply"><i class="fas fa-reply"></i></div>'
                '</div>';
                $(".twitter-home-tab").append(TweetElement);
            } else if (Tweet.url != "" && Tweet.message == "") {
                let TweetElement = '<div class="twitter-tweet" data-twtid = "' + Tweet.id + '" data-twthandler="@' + TwitterHandle.replace(" ", "_") + '">' +
                    '<div class="tweet-tweeter">' + Tweet.firstName + ' ' + Tweet.lastName + ' &nbsp;<span>@' + TwitterHandle.replace(" ", "_") + ' &middot; ' + TimeAgo + '</span></div>' +
                    '<div class="tweet-message">' + Tweet.message + '</div>' +
                    '<img class="image" src= "' + Tweet.url + '" style = " border-radius:2px; width: 70%; position:relative; z-index: 1; left:52px; margin:.6rem .5rem .6rem 1rem;height: auto;">' +
                    '<div class="twt-img" style="top: 1vh;"><img src="' + PictureUrl + '" class="tweeter-image"></div>' +
                    '<div class="tweet-reply"><i class="fas fa-reply"></i></div>'
                '</div>';
                $(".twitter-home-tab").append(TweetElement);
            } else if (Tweet.url != "" && Tweet.message != "") {
                let TweetElement = '<div class="twitter-tweet" data-twtid = "' + Tweet.id + '" data-twthandler="@' + TwitterHandle.replace(" ", "_") + '">' +
                    '<div class="tweet-tweeter">' + Tweet.firstName + ' ' + Tweet.lastName + ' &nbsp;<span>@' + TwitterHandle.replace(" ", "_") + ' &middot; ' + TimeAgo + '</span></div>' +
                    '<div class="tweet-message">' + Tweet.message + '</div>' +
                    '<img class="image" src= "' + Tweet.url + '" style = " border-radius:2px; width: 70%; position:relative; z-index: 1; left:52px; margin:.6rem .5rem .6rem 1rem;height: auto;">' +
                    '<div class="twt-img" style="top: 1vh;"><img src="' + PictureUrl + '" class="tweeter-image"></div>' +
                    '<div class="tweet-reply"><i class="fas fa-reply"></i></div>'
                '</div>';
                $(".twitter-home-tab").append(TweetElement);
            }

        });
    } else {
        let html = `<div class="twitter-no-tweets"><p>There is no tweet you posted.</p></div>`
        $(".twitter-home-tab").html(html);

    }

}


MI.Phone.Notifications.LoadSelfTweets = function (Tweets) {
    Tweets = Tweets.reverse();

    if (Tweets !== null && Tweets !== undefined && Tweets !== "" && Tweets.length > 0) {
        $(".twitter-self-tab").html("");
        $.each(Tweets, function (i, Tweet) {
            let today = new Date();

            let TweetTime = new Date(Tweet.time);
            let diffMs = (today - TweetTime);
            let diffDays = Math.floor(diffMs / 86400000);
            let diffHrs = Math.floor((diffMs % 86400000) / 3600000);
            let diffMins = Math.round(((diffMs % 86400000) % 3600000) / 60000);
            let diffSeconds = Math.round(diffMs / 1000);
            let TimeAgo = diffSeconds + ' s';
            if (diffMins > 0) {
                TimeAgo = diffMins + ' m';
            } else if (diffHrs > 0) {
                TimeAgo = diffHrs + ' h';
            } else if (diffDays > 0) {
                TimeAgo = diffDays + ' d';
            }
            let TwitterHandle = Tweet.firstName + ' ' + Tweet.lastName
            let PictureUrl = "./img/default.png"
            if (Tweet.picture !== "default") {
                PictureUrl = Tweet.picture
            }


            if (Tweet.url == "" && Tweet.message != "") {
                let TweetElement = '<div class="twitter-tweet" data-twtid = "' + Tweet.id + '" data-twthandler="@' + TwitterHandle.replace(" ", "_") + '">' +
                    '<div class="tweet-tweeter">' + Tweet.firstName + ' ' + Tweet.lastName + ' &nbsp;<span>@' + TwitterHandle.replace(" ", "_") + ' &middot; ' + TimeAgo + '</span></div>' +
                    '<div class="tweet-message">' + Tweet.message + '</div>' +
                    '<div class="twt-img" style="top: 1vh;"><img src="' + PictureUrl + '" class="tweeter-image"></div>' +
                    '<div class="tweet-delete"><i class="fas fa-trash-alt"></i></div>'
                '</div>';
                $(".twitter-self-tab").append(TweetElement);
            } else if (Tweet.url != "" && Tweet.message == "") {
                let TweetElement = '<div class="twitter-tweet" data-twtid = "' + Tweet.id + '" data-twthandler="@' + TwitterHandle.replace(" ", "_") + '">' +
                    '<div class="tweet-tweeter">' + Tweet.firstName + ' ' + Tweet.lastName + ' &nbsp;<span>@' + TwitterHandle.replace(" ", "_") + ' &middot; ' + TimeAgo + '</span></div>' +
                    '<div class="tweet-message">' + Tweet.message + '</div>' +
                    '<img class="image" src= "' + Tweet.url + '" style = " border-radius:2px; width: 70%; position:relative; z-index: 1; left:52px; margin:.6rem .5rem .6rem 1rem;height: auto;">' +
                    '<div class="twt-img" style="top: 1vh;"><img src="' + PictureUrl + '" class="tweeter-image"></div>' +
                    '<div class="tweet-delete"><i class="fas fa-trash-alt"></i></div>'
                '</div>';
                $(".twitter-self-tab").append(TweetElement);
            } else if (Tweet.url != "" && Tweet.message != "") {
                let TweetElement = '<div class="twitter-tweet" data-twtid = "' + Tweet.id + '" data-twthandler="@' + TwitterHandle.replace(" ", "_") + '">' +
                    '<div class="tweet-tweeter">' + Tweet.firstName + ' ' + Tweet.lastName + ' &nbsp;<span>@' + TwitterHandle.replace(" ", "_") + ' &middot; ' + TimeAgo + '</span></div>' +
                    '<div class="tweet-message">' + Tweet.message + '</div>' +
                    '<img class="image" src= "' + Tweet.url + '" style = " border-radius:2px; width: 70%; position:relative; z-index: 1; left:52px; margin:.6rem .5rem .6rem 1rem;height: auto;">' +
                    '<div class="twt-img" style="top: 1vh;"><img src="' + PictureUrl + '" class="tweeter-image"></div>' +
                    '<div class="tweet-delete"><i class="fas fa-trash-alt"></i></div>'
                '</div>';
                $(".twitter-self-tab").append(TweetElement);
            }

        });
    } else {
        let html = `<div class="twitter-no-tweets"><p>There is no tweet you posted.</p></div>`
        $(".twitter-self-tab").html(html);

    }

}

$(document).on('click', '.tweet-reply', function (e) {
    e.preventDefault();
    var TwtName = $(this).parent().data('twthandler');
    var text = $(this).parent().data();
    $("#tweet-new-message").val(TwtName + " @" + text + "");
    MI.Phone.Animations.TopSlideDown(".twitter-new-tweet-tab", 450, 0);
});

$(document).on('click', '.tweet-delete', function (e) {
    e.preventDefault();
    var id = $(this).parent().data('twtid');
    console.log(id)
    $.post('http://MI-phone/DeleteTweet', JSON.stringify({
        id: id,
    }));

    $.post('http://MI-phone/GetSelfTweets', JSON.stringify({}), function (tweets) {
        MI.Phone.Notifications.LoadSelfTweets(tweets);
    });
    $.post('http://MI-phone/GetTweets', JSON.stringify({}), function (tweets) {
        MI.Phone.Notifications.LoadTweets(tweets);
    });


});



let clicked = false;
let photos = [];
$(document).on('click', '.image', function (e) {
    if (!clicked) {
        let n = $(this).clone()

        $(n).appendTo('.tt')
        $(n).css({
            "position": "absolute",
            "width": "500px",
            "height": "auto",
            "left": "-520px",
            "top": "-10px",

            "border-radius": "1rem"
        })
        clicked = true;
        photos.push(n)
    } else {
        for (let i = 0; i < photos.length; i++) {
            photos[i].remove()
        }
        clicked = false;
    }
});







MI.Phone.Notifications.LoadMentionedTweets = function (Tweets) {
    Tweets = Tweets.reverse();
    if (Tweets.length > 0) {
        $(".twitter-mentions-tab").html("");
        $.each(Tweets, function (i, Tweet) {
            var TwtMessage = Tweet.message;
            var today = new Date();
            var TweetTime = new Date(Tweet.time);
            var diffMs = (today - TweetTime);
            var diffDays = Math.floor(diffMs / 86400000);
            var diffHrs = Math.floor((diffMs % 86400000) / 3600000);
            var diffMins = Math.round(((diffMs % 86400000) % 3600000) / 60000);
            var diffSeconds = Math.round(diffMs / 1000);
            var TimeAgo = diffSeconds + ' sn';

            if (diffSeconds > 60) {
                TimeAgo = diffMins + ' dk';
            } else if (diffMins > 60) {
                TimeAgo = diffHrs + ' s';
            } else if (diffHrs > 24) {
                TimeAgo = diffDays + ' d';
            }

            var TwitterHandle = Tweet.firstName + ' ' + Tweet.lastName
            var PictureUrl = "./img/default.png";
            if (Tweet.picture !== "default") {
                PictureUrl = Tweet.picture
            }

            var TweetElement =
                '<div class="twitter-tweet">' +
                '<div class="tweet-tweeter">' + Tweet.firstName + ' ' + Tweet.lastName + ' &nbsp;<span>@' + TwitterHandle.replace(" ", "_") + ' &middot; ' + TimeAgo + '</span></div>' +
                '<div class="tweet-message">' + TwtMessage + '</div>' +
                '<div class="twt-img" style="top: 1vh;"><img src="' + PictureUrl + '" class="tweeter-image"></div></div>';

            $(".twitter-mentioned-tweet").css({
                "background-color": "#F5F8FA"
            });
            $(".twitter-mentions-tab").append(TweetElement);
        });
    }
}

MI.Phone.Functions.FormatTwitterMessage = function (TwitterMessage) {
    var TwtMessage = TwitterMessage;
    var res = TwtMessage.split("@");
    var tags = TwtMessage.split("#");
    var InvalidSymbols = [
        "[",
        "?",
        "!",
        "@",
        "#",
        "]",
    ]

    for (i = 1; i < res.length; i++) {
        var MentionTag = res[i].split(" ")[0];
        if (MentionTag !== null && MentionTag !== undefined && MentionTag !== "") {
            TwtMessage = TwtMessage.replace("@" + MentionTag, "<span class='mentioned-tag' data-mentiontag='@" + MentionTag + "' style='color: rgb(27, 149, 224);'>@" + MentionTag + "</span>");
        }
    }

    for (i = 1; i < tags.length; i++) {
        var Hashtag = tags[i].split(" ")[0];

        for (i = 1; i < InvalidSymbols.length; i++) {
            var symbol = InvalidSymbols[i];
            var res = Hashtag.indexOf(symbol);

            if (res > -1) {
                Hashtag = Hashtag.replace(symbol, "");
            }
        }

        if (Hashtag !== null && Hashtag !== undefined && Hashtag !== "") {
            TwtMessage = TwtMessage.replace("#" + Hashtag, "<span class='hashtag-tag-text' data-hashtag='" + Hashtag + "' style='color: rgb(27, 149, 224);'>#" + Hashtag + "</span>");
        }
    }

    return TwtMessage
}

$(document).on('click', '#send-tweet', function (e) {
    e.preventDefault();

    var TweetMessage = $("#tweet-new-message").val();
    var TweetUrl = $("#tweet-new-url").val();

    if (TweetMessage != "" || TweetUrl != "") {
        let CurrentDate = new Date();
        $.post('http://MI-phone/PostNewTweet', JSON.stringify({
            Message: TweetMessage,
            Date: CurrentDate,
            url: TweetUrl,
            Picture: MI.Phone.Data.MetaData.profilepicture
        }), function (Tweets) {
            MI.Phone.Notifications.LoadTweets(Tweets)


        });

        $.post('http://MI-phone/GetHashtags', JSON.stringify({}), function (Hashtags) {
            MI.Phone.Notifications.LoadHashtags(Hashtags)
        })

        MI.Phone.Animations.TopSlideUp(".twitter-new-tweet-tab", 450, -120);
        $('#tweet-new-url').val("")
        $("#tweet-new-message").val("");
    } else {
        MI.Phone.Notifications.Add("fab fa-twitter", MI.Phone.Functions.Lang("TWITTER_TITLE"), MI.Phone.Functions.Lang("TWITTER_ENTER_MSG"), "#1DA1F2");
    }
});


$(document).on('click', '#send-photo', function (e) {
    e.preventDefault();

    $.post('http://MI-phone/PostNewImage', JSON.stringify({}),
        function (url) {
            $('#tweet-new-url').val(url)

        },
    );



    MI.Phone.Functions.Close();

});

$(document).on('click', '#cancel-tweet', function (e) {
    e.preventDefault();
    $('#tweet-new-url').val("")
    $("#tweet-new-message").val("");
    MI.Phone.Animations.TopSlideUp(".twitter-new-tweet-tab", 450, -120);
});

$(document).on('click', '.mentioned-tag', function (e) {
    e.preventDefault();
    CopyMentionTag(this);
});

$(document).on('click', '.hashtag-tag-text', function (e) {
    e.preventDefault();
    if (!HashtagOpen) {
        var Hashtag = $(this).data('hashtag');
        var PreviousTwitterTabObject = $('.twitter-header').find('[data-twittertab="' + CurrentTwitterTab + '"]');

        $("#twitter-hashtags").addClass('selected-twitter-header-tab');
        $(PreviousTwitterTabObject).removeClass('selected-twitter-header-tab');

        $("." + CurrentTwitterTab + "-tab").css({
            "display": "none"
        });
        $(".twitter-hashtags-tab").css({
            "display": "block"
        });

        $.post('http://MI-phone/GetHashtagMessages', JSON.stringify({
            hashtag: Hashtag
        }), function (HashtagData) {
            MI.Phone.Notifications.LoadHashtagMessages(HashtagData.messages);
        });

        $(".twitter-hashtag-tweets").css({
            "display": "block",
            "left": "30vh"
        });
        $(".twitter-hashtag-tweets").css({
            "left": "0vh"
        });
        $(".twitter-hashtags").css({
            "left": "-30vh"
        });
        $(".twitter-hashtags").css({
            "display": "none"
        });
        HashtagOpen = true;

        CurrentTwitterTab = "twitter-hashtags";
    }
});

function CopyMentionTag(elem) {
    var $temp = $("<input>");
    $("body").append($temp);
    $temp.val($(elem).data('mentiontag')).select();
    MI.Phone.Notifications.Add("fab fa-twitter", MI.Phone.Functions.Lang("TWITTER_TITLE"), $(elem).data('mentiontag') + " Kopyalandı!", "rgb(27, 149, 224)", 1250);
    document.execCommand("copy");
    $temp.remove();
}

MI.Phone.Notifications.LoadHashtags = function (hashtags) {
    if (hashtags !== null) {
        $(".twitter-hashtags").html("");
        console.log(JSON.stringify(hashtags));
        $.each(hashtags, function (i, hashtag) {
            var Elem = '';
            var TweetHandle = "Tweet";
            if (hashtag.messages.length > 1) {
                TweetHandle = "Tweets";
            }
            if (hashtag.messages.length >= MinimumTrending) {
                Elem = '<div class="twitter-hashtag" id="tag-' + hashtag.hashtag + '"><div class="twitter-hashtag-status">Trending</div> <div class="twitter-hashtag-tag">#' + hashtag.hashtag + '</div> <div class="twitter-hashtag-messages">' + hashtag.messages.length + ' ' + TweetHandle + '</div> </div>';
            } else {
                Elem = '<div class="twitter-hashtag" id="tag-' + hashtag.hashtag + '"><div class="twitter-hashtag-status">Not Trending</div> <div class="twitter-hashtag-tag">#' + hashtag.hashtag + '</div> <div class="twitter-hashtag-messages">' + hashtag.messages.length + ' ' + TweetHandle + '</div> </div>';
            }

            $(".twitter-hashtags").append(Elem);
            $("#tag-" + hashtag.hashtag).data('tagData', hashtag);
        });
    }
}

MI.Phone.Notifications.LoadHashtagMessages = function (Tweets) {
    Tweets = Tweets.reverse();
    if (Tweets !== null && Tweets !== undefined && Tweets !== "" && Tweets.length > 0) {
        $(".twitter-hashtag-tweets").html("");
        $.each(Tweets, function (i, Tweet) {
            var TwtMessage = MI.Phone.Functions.FormatTwitterMessage(Tweet.message);
            var today = new Date();
            var TweetTime = new Date(Tweet.time);
            var diffMs = (today - TweetTime);
            var diffDays = Math.floor(diffMs / 86400000);
            var diffHrs = Math.floor((diffMs % 86400000) / 3600000);
            var diffMins = Math.round(((diffMs % 86400000) % 3600000) / 60000);
            var diffSeconds = Math.round(diffMs / 1000);
            var TimeAgo = diffSeconds + ' sn';

            if (diffSeconds > 60) {
                TimeAgo = diffMins + ' dk';
            } else if (diffMins > 60) {
                TimeAgo = diffHrs + ' s';
            } else if (diffHrs > 24) {
                TimeAgo = diffDays + ' d';
            }

            var TwitterHandle = Tweet.firstName + ' ' + Tweet.lastName
            var PictureUrl = "./img/default.png"
            if (Tweet.picture !== "default") {
                PictureUrl = Tweet.picture
            }

            var TweetElement =
                '<div class="twitter-tweet">' +
                '<div class="tweet-tweeter">' + Tweet.firstName + ' ' + Tweet.lastName + ' &nbsp;<span>@' + TwitterHandle.replace(" ", "_") + ' &middot; ' + TimeAgo + '</span></div>' +
                '<div class="tweet-message">' + TwtMessage + '</div>' +
                '<div class="twt-img" style="top: 1vh;"><img src="' + PictureUrl + '" class="tweeter-image"></div></div>';

            $(".twitter-hashtag-tweets").append(TweetElement);
        });
    }
}

$(document).on('click', '.twitter-hashtag', function (event) {
    event.preventDefault();

    var TweetId = $(this).attr('id');
    var TweetData = $("#" + TweetId).data('tagData');

    MI.Phone.Notifications.LoadHashtagMessages(TweetData.messages);

    $(".twitter-hashtag-tweets").css({
        "display": "block",
        "left": "30vh"
    });
    $(".twitter-hashtag-tweets").animate({
        left: 0 + "vh"
    }, 150);
    $(".twitter-hashtags").animate({
        left: -30 + "vh"
    }, 150, function () {
        $(".twitter-hashtags").css({
            "display": "none"
        });
    });
    HashtagOpen = true;
});