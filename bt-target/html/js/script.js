let targetActive = false

window.addEventListener('message', function(event) {
    let item = event.data;

    if (item.response == 'openTarget') {
        $(".target-label").html("");
        
        $('.target-wrapper').show();

        $(".target-icon").css("color", "black");
    } else if (item.response == 'closeTarget') {
        $(".target-label").html("");

        $('.target-wrapper').hide();
    } else if (item.response == 'validTarget') {
        $(".target-label").html("");

        $(".target-label").append('<i class="icon '+item.icon+'"></i><div class="target-label" data-event="'+item.event+'" <p>'+item.label+'</p></div>');

        $(".target-icon").css("color", "rgb(30,144,255)");

        targetActive = true
    } else if (item.response == 'leftTarget') {
        $(".target-label").html("");

        $(".target-icon").css("color", "black");

        targetActive = false
    }
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            $(".target-label").html("");

            $('.target-wrapper').hide();
            $.post('http://bt-target/closeTarget');
            break;
    }
});

$(document).on('click', '.target-label', function(evt){
    evt.preventDefault();

    var event = $(this).data('event');

    if (event == undefined) {
        return
    }

    $.post('http://bt-target/selectTarget', JSON.stringify({
        event: event,
    }));
    
    $(".target-label").html("");
    $('.target-wrapper').hide();
});