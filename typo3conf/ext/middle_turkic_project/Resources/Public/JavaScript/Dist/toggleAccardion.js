$(function() {
    $('[data-toggle="tooltip"]').tooltip()
})

$(".btn-ExpCollAllAccard").click(function() {

    if ($(this).data("closedAll")) {
        $(".accordion-collapse").collapse("show");
        $(this).html('<i class="fas fa-times-circle"></i>');
    } else {
        $(".accordion-collapse").collapse("hide");
        $(this).html("<i class='fas fa-plus-circle'></i>");
    }

    // save last state
    $(this).data("closedAll", !$(this).data("closedAll"));
});

// init with all closed
$(".btn-ExpCollAllAccard").data("closedAll", true);