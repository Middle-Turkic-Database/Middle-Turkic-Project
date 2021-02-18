$(function() {
    $('.list-group-item').on('click', function() {
        $('.fa-angle-double-right,.fa-angle-double-down', this)
            .toggleClass('fa-angle-double-right')
            .toggleClass('fa-angle-double-down');
    });

});

$(document).ready(function() {
    $('#dtManuscriptList').DataTable({
        drawCallback: function() {
            // $('[data-toggle="tooltip"]').tooltip();
            $('table.dataTable tbody tr[data-href]').each(function() {
                $(this).css('cursor', 'pointer').click(function() {
                    document.location = $(this).attr('data-href');
                });
            });

        }
    });
    $('.dataTables_length').addClass('bs-select');
    if ($('#manuscriptTabs').length) {
        $('.manuscript-hero-image').parent().addClass('d-none');
    };

    var transcriptURI = "/mstranscript?msNav=" + $("#msTranscriptContent").data('msnav') + "&msName=" + $("#msTranscriptContent").data('msname');

    $("#msTranscriptContent").hide().load(encodeURI(transcriptURI), function(response, status, xhr) {
        if (status == "error") {
            var errorMessage = "";
            if (xhr.readyState == 0) {
                errorMessage = "An error occured while fetching the manuscript. Check your Internet connection.";
            } else {
                errorMessage = "An error occured while fetching the manuscript: " + xhr.status + " " + xhr.statusText;
            }
            $("#msTranscriptContent").html(errorMessage);
        }
        $('.loader').fadeOut('fast', function() {
            $("#msTranscriptContent").fadeIn();
        });
        $('[data-toggle="tooltip"]').tooltip()
    });
});

// Manuscript Navigation
$(function() {
    $('.ms-nav-1st [data-toggle="pill"], .ms-nav-2nd [data-toggle="pill"]').tooltip();
});

$(".ms-nav-1st .nav-link").on('show.bs.tab', function(event) {
    if (!$(".ms-nav-1st .nav-link").hasClass("latest-tab")) {
        $(event.relatedTarget).addClass("latest-tab");
    }
    $(this).removeClass("latest-tab");
});

$(".ms-nav-2nd .nav-link,.ms-nav-1st .nav-link:not(.dropdown-toggle)").on('show.bs.tab', function() {
    var transcriptURI = "/mstranscript?msNav=" + $("#msTranscriptContent").data('msnav') + "&msName=" + $("#msTranscriptContent").data('msname') + "&msBook=";
    if ($(this).closest(".nav").hasClass("ms-nav-1st")) {
        transcriptURI += $(this).data("bookno");
    } else {
        var tabID = $(this).closest(".tab-pane").attr("id");
        transcriptURI += $(".ms-nav-1st .nav-link[href='#" + tabID + "']").data('bookno');
        transcriptURI += "&msChapter=";
        transcriptURI += $(this).data("chapterno");
    }

    $("#msTranscriptContent").fadeOut(function() {
        $(".loader").fadeIn('fast');
        $("#msTranscriptContent").load(encodeURI(transcriptURI), function(response, status, xhr) {
            if (status == "error") {
                var errorMessage = "";
                if (xhr.readyState == 0) {
                    errorMessage = "An error occured while fetching the manuscript. Check your Internet connection.";
                } else {
                    errorMessage = "An error occured while fetching the manuscript: " + xhr.status + " " + xhr.statusText;
                }
                $("#msTranscriptContent").html(errorMessage);
            }
            $(".loader").fadeOut('fast', function() {
                $("#msTranscriptContent").fadeIn('');
            });
            $('[data-toggle="tooltip"]').tooltip()
        });
    });

    $(".ms-nav-2nd a.nav-link").removeClass("active");
    $(".ms-nav-1st .nav-link").removeClass("latest-tab");
});