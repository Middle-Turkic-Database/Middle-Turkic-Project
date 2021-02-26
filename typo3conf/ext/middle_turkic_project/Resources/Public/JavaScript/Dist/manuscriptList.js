function loadTranscript(msNav, msName, msBook = -1, msChapter = -1, $element = $("#msTranscriptContent")) {
    var transcriptURI = "/mstranscript?msNav=" + msNav + "&msName=" + msName;
    if (msBook >= 0) {
        transcriptURI += "&msBook=" + msBook;
        if (msChapter >= 1) {
            transcriptURI += "&msChapter=" + msChapter;
        }
    }
    
    $element.hide(0, function() {
        $(".loader").fadeIn('fast');
        $(this).load(encodeURI(transcriptURI), function(response, status, xhr) {
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

    loadTranscript($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'));
});

// Manuscript Navigation
$(function() {
    $('.ms-nav-1st [data-toggle="pill"], .ms-nav-2nd [data-toggle="pill"]').tooltip();
});

function setChapterPars(maxChapter = 0) {
    var $chapterNum = $('#chapterNum');
    if (maxChapter < 1) {
        $("#chapterFormGroup").addClass("d-none");
        $chapterNum.attr('min', maxChapter);
        $chapterNum.val(maxChapter);
    } else {
        $("#chapterFormGroup").removeClass("d-none");
        $chapterNum.attr('min', 1);
    }
    $('#maxChapterLabel').html(maxChapter);
    $chapterNum.attr('max', maxChapter);
};

$(".ms-nav .nav-link").on('click', function() {
    $(".ms-nav-2nd a.nav-link").removeClass("active");

    var msBook = -1;
    var msChapter = -1;
    if ($(this).closest(".nav").hasClass("ms-nav-1st")) {
        msBook = $(this).data("bookno");
        if ($(this).hasClass("dropdown-toggle")) {
            msChapter = 1;
            $("#" + $(this).attr('id') + "-tab .ms-nav-2nd .nav-link:first-child").tab('show');
        }
    } else {
        var tabID = $(this).closest(".tab-pane").attr("id");
        msBook = $(".ms-nav-1st .nav-link[href='#" + tabID + "']").data('bookno');
        msChapter = $(this).data("chapterno");
    }

    loadTranscript($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), msBook, msChapter);

    var $bookSelector = $(".ms-selector-form select#bookSelector");
    var $chapterNum = $(".ms-selector-form input#chapterNum");
    if (msBook !== -1 & msBook != $bookSelector.val()) {
        $bookSelector.val(msBook);
        $bookSelector.change();
    }
    if (msChapter !== -1 && msChapter != $chapterNum.val()) {
        $chapterNum.val(msChapter);
    }
});

$(".ms-selector-form select#bookSelector").change(function() {
    setChapterPars($("option:selected", this).data("chapternum"));
    var $chapterNum = $('#chapterNum');
    $($chapterNum).val($($chapterNum).attr('min'));
});

$(".ms-selector-form").on("submit", function(e) {
    e.preventDefault();
    var $bookSelector = $(":input[name='bookSelector']");
    var bookNum = $(":selected", $bookSelector).val();
    var chapterNum = $("#chapterNum", $(this)).val();
    $(".ms-nav-1st .nav-link[data-bookno='" + bookNum + "']").tab("show");
    if (chapterNum != '' && chapterNum > 0) {
        var $secondTabEl = $(".ms-nav-1st a[data-bookno='" + bookNum + "']");
        $("#" + $($secondTabEl).attr('id') + "-tab .ms-nav-2nd .nav-link:nth-child(" + chapterNum + ")").tab("show");
    }
    loadTranscript($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), bookNum, chapterNum);
});

$('.ms-selector-form input#chapterNum[type="number"]').on("input", function() {
    var value = $(this).val();

    if (value !== "" && value.indexOf(".") === -1) {
        $(this).val(
            Math.max(Math.min(value, $(this).attr("max")), $(this).attr("min"))
        );
    }
});

$(function() {
    var firstMaxChapter = $(".ms-selector-form select#bookSelector option").first().data("chapternum");
    setChapterPars(firstMaxChapter);
});