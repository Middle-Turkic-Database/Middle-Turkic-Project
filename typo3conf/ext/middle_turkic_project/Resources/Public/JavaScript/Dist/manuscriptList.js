function loadTranscript (URI, $element = $("#msTranscriptContent")) {
    $element.hide(0, function() {
        $(".loader").fadeIn('fast');
        $(this).load(encodeURI(URI), function (response, status, xhr) {
            if (status == "error") {
                var errorMessage = "";
                if (xhr.readyState == 0) {
                    errorMessage = "An error occured while fetching the manuscript. Check your Internet connection.";
                } else {
                    errorMessage = "An error occured while fetching the manuscript: " + xhr.status + " " + xhr.statusText;
                }
                $element.html(errorMessage);
            }
            $('.loader').fadeOut('fast', function() {
                $element.fadeIn();
            });
            $('[data-toggle="tooltip"]').tooltip()
        });
    });
};

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
    loadTranscript(transcriptURI, $("#msTranscriptContent"));
});

// Manuscript Navigation
$(function() {
    $('.ms-nav-1st [data-toggle="pill"], .ms-nav-2nd [data-toggle="pill"]').tooltip();
});

$(".ms-nav .nav-link").on('show.bs.tab', function() {
    $(".ms-nav-2nd a.nav-link").removeClass("active");

    var transcriptURI = "/mstranscript?msNav=" + $("#msTranscriptContent").data('msnav') + "&msName=" + $("#msTranscriptContent").data('msname') + "&msBook=";
    if ($(this).closest(".nav").hasClass("ms-nav-1st")) {
        transcriptURI += $(this).data("bookno");
        if ($(this).hasClass("dropdown-toggle")) {
            transcriptURI += "&msChapter=1";
            $("#" + $(this).attr('id') + "-tab .ms-nav-2nd .nav-link:first-child").tab('show');
        }
    } else {
        var tabID = $(this).closest(".tab-pane").attr("id");
        transcriptURI += $(".ms-nav-1st .nav-link[href='#" + tabID + "']").data('bookno');
        transcriptURI += "&msChapter=";
        transcriptURI += $(this).data("chapterno");
    }

    loadTranscript(transcriptURI, $("#msTranscriptContent"));
});