function loadContent(URI, $element) {
    $element.hide(0, function() {
        $(".loader").fadeIn('fast');
        $(this).load(encodeURI(URI), function(response, status, xhr) {
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
}

function loadTranscript(msNav, msName, msBook = -1, msChapter = -1, $element = $("#msTranscriptContent")) {
    var transcriptURI = "/mstranscript?msNav=" + msNav + "&msName=" + msName;
    if (msBook >= 0) {
        if (msBook == 0) {
            msBook = "000";
        }
        transcriptURI += "&msBook=" + msBook;
        if (msChapter >= 1) {
            transcriptURI += "&msChapter=" + msChapter;
        }
    }

    loadContent(transcriptURI, $element);
};

function loadTranslation(msNav, msName, msBook = -1, msChapter = -1, $element = $("#msTranslationContent")) {
    var transcriptURI = "/mstranscript?msNav=" + msNav + "&msName=" + msName;
    if (msBook >= 0) {
        if (msBook == 0) {
            msBook = "000";
        }
        transcriptURI += "&msBook=" + msBook;
        if (msChapter >= 1) {
            transcriptURI += "&msChapter=" + msChapter;
        }
    }
    transcriptURI += "&type=translation";

    loadContent(transcriptURI, $element);
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
    loadTranslation($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'));
});

// Manuscript Navigation
$(function() {
    $('.ms-nav-1st [data-toggle="pill"], .ms-nav-2nd [data-toggle="pill"]').tooltip();
});

function setChapterPars(maxChapter = 0, $formToChange = null) {
    var $chapterNumInputs;
    if ($formToChange === null) {
     $chapterNumInputs = $(".ms-selector-form input[type='number'][id$='chapterNum']");
    }
    else {
      $chapterNumInputs = $formToChange.closest(".ms-selector-form").find("input[type='number'][id$='chapterNum']");
    }
    if (maxChapter < 1) {
        $(".ms-selector-form [id$='chapterFormGroup'").addClass("d-none");
        $chapterNumInputs.attr('min', maxChapter);
        $chapterNumInputs.val(maxChapter);
    } else {
        $(".ms-selector-form [id$='chapterFormGroup'").removeClass("d-none");
        $chapterNumInputs.attr('min', 1);
    }
    $chapterNumInputs.attr('max', maxChapter);
    $chapterNumInputs.attr('size', Math.floor(Math.log10(maxChapter)) + 1)
};

$(".ms-nav .nav-link").on('click', function() {
    $(".ms-nav-2nd a.nav-link").removeClass("active");

    var msBook = -1;
    var msChapter = -1;
    if ($(this).closest(".nav").hasClass("ms-nav-1st")) {
        msBook = $(this).data("bookno");
        if ($(this).hasClass("dropdown-toggle")) {
            msChapter = 1;
        }
        $(".ms-nav .nav-link[id$='" + $(this).attr('id').match(/pills(.*)$/gm) + "']").tab('show');
        $("[id$='" + $(this).attr('id').match(/pills(.*)$/gm) + "-tab'] .ms-nav-2nd .nav-link:first-child").tab('show');
    } else {
        var tabID = $(this).closest(".tab-pane").attr("id");
        msBook = $(".ms-nav-1st .nav-link[href='#" + tabID + "']").data('bookno');
        msChapter = $(this).data("chapterno");
      
      $(".ms-nav-2nd .nav-link[data-chapterno=" + $(this).data("chapterno") + "]").tab('show');
    }
    loadTranscript($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), msBook, msChapter);
    loadTranslation($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), msBook, msChapter);

    var $bookSelectorInputs = $(".ms-selector-form select[id$='bookSelector']");
    var $chapterNumInputs = $(".ms-selector-form input[id$='chapterNum']");
    if (msBook !== -1 & msBook != $bookSelectorInputs.val()) {
        $bookSelectorInputs.val(msBook);
        $bookSelectorInputs.change();
    }
    if (msChapter !== -1 && msChapter != $chapterNumInputs.val()) {
        $chapterNumInputs.val(msChapter);
    }
});

$(".ms-selector-form select[id$='bookSelector']").change(function() {
    setChapterPars($("option:selected", this).data("chapternum"), $(this));
    var $chapterNum = $(":input[name='chapterNum']", this.closest("form.ms-selector-form"));
    $($chapterNum).val($($chapterNum).attr('min'));
});

$(".ms-selector-form").on("submit", function(e) {
    e.preventDefault();
    var $bookSelector = $(":input[name='bookSelector']", $(this));
    var bookNum = $(":selected", $bookSelector).val();
    var chapterNum = $(":input[name='chapterNum']", $(this)).val();
    
    $(":input[name='bookSelector']").val(bookNum);
    $(":input[name='chapterNum']").val(chapterNum);
    setChapterPars($("option:selected", $bookSelector).data("chapternum"));
  
    $(".ms-nav-1st .nav-link[data-bookno='" + bookNum + "']").tab("show");
    if (chapterNum != '' && chapterNum > 0) {
        var $secondTabEl = $(".ms-nav-1st a[data-bookno='" + bookNum + "']");
        $("[id$='" + $secondTabEl.attr('id').match(/pills(.*)$/gm) + "-tab'] .ms-nav-2nd .nav-link:nth-child(" + chapterNum + ")").tab("show");
    }
    loadTranscript($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), bookNum, chapterNum);
    loadTranslation($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), bookNum, chapterNum);
});

$(".ms-selector-form input[id$='chapterNum'][type='number']").on("input", function() {
    var value = $(this).val();

    if (value !== "" && value.indexOf(".") === -1) {
        $(this).val(
            Math.max(Math.min(value, $(this).attr("max")), $(this).attr("min"))
        );
    }
});

$('.ms-selector-form input[type="number"]').on("click", function() {
    $(this).select();
});

$(function() {
    var firstMaxChapter = $(".ms-selector-form select[id$='bookSelector'] option").first().data("chapternum");
    setChapterPars(firstMaxChapter);
});

function setL2NavWidth() {
    var $l2NavLinks = $("#manuscriptTabsContent>.tab-pane.show .tab-content>.tab-pane.active>.nav.ms-nav.ms-nav-2nd .nav-link");
    $l2NavLinks.each(function() {
        $(this).css("max-width", '');
        $(this).css("max-width", $(this).parent().find(".nav-link").first().outerWidth());
    });
}

$(function() {
    setL2NavWidth();
});

$(".ms-nav.ms-nav-1st .nav-link,#manuscriptTabs .nav-link").on('shown.bs.tab', function() {
    if ($(this).tab().is(":visible")) {
        setL2NavWidth();
    }
});

$(window).resize(function() {
    setL2NavWidth();
});