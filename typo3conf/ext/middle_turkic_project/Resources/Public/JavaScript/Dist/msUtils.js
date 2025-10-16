export function setChapterPars(maxChapter = 0, $formToChange = null) {
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
    $chapterNumInputs.attr('placeholder', 1);
    $chapterNumInputs.attr('size', Math.floor(Math.log10(maxChapter)) + 1)
};

export function enableNavBarTooltip() {
    $('.ms-nav-1st [data-toggle="pill"], .ms-nav-2nd [data-toggle="pill"]').tooltip();
}

export function setL2NavWidth() {
    var $l2NavLinks = $("#msNavBar .nav.ms-nav.ms-nav-2nd .nav-link");
    $l2NavLinks.each(function() {
        $(this).css("max-width", '');
        $(this).css("max-width", $(this).parent().find(".nav-link").first().outerWidth());
    });
}

export function updateNavigation(msBook = -1, msChapter = -1) {
    if (msBook < 0) return;
    $(".ms-nav-2nd a.nav-link").removeClass("active");
    $(".ms-nav-1st .nav-link[id|='trc-pills'],[id|='trl-pills'],[id|='prl-pills'],[id|='cmp-pills']").filter("[id$='-" + msBook + "']").tab("show");
    if (msChapter > 0) {
        $(".tab-pane.active>.ms-nav-2nd .nav-link[data-chapterno='" + msChapter + "']").tab("show");
    }

    var $bookSelectorInputs = $(".ms-selector-form select[id$='bookSelector']");
    var $chapterNumInputs = $(".ms-selector-form input[id$='chapterNum']");
    if (msBook > -1 & msBook != $bookSelectorInputs.val()) {
        $bookSelectorInputs.val(msBook);
        $bookSelectorInputs.change();
    }
    if (msChapter > 0 && msChapter != $chapterNumInputs.val()) {
        $chapterNumInputs.val(msChapter);
    }
}

export function navLinkClicked(element) {
    $(".ms-nav-2nd a.nav-link").removeClass("active");
    var msBook = -1;
    var msChapter = -1;
    if ($(element).closest(".nav").hasClass("ms-nav-1st")) {
        msBook = $(element).data('bookno');
        if ($(element).hasClass("dropdown-toggle")) {
            msChapter = 1;
        }
    } else {
        var tabID = $(element).closest(".tab-pane").attr("id");
        msBook = $(".ms-nav-1st .nav-link[href='#" + tabID + "']").data('bookno');
        msChapter = $(element).data("chapterno");
    }
    updateNavigation(msBook, msChapter);
    return {msBook, msChapter};
}

function bookSelectorChanged(element) {
    setChapterPars($("option:selected", element).data("chapternum"), $(element));
    var $chapterNum = $(":input[name='chapterNum']", element.closest("form.ms-selector-form"));
    $($chapterNum).val($($chapterNum).attr('min'));
}

export function msSelectorFormSubmitted (element, e) {
    e.preventDefault();
    var $bookSelector = $(":input[name='bookSelector']", $(element));
    var bookNum = $(":selected", $bookSelector).val();
    var chapterNum = $(":input[name='chapterNum']", $(element)).val();
    
    updateNavigation(bookNum, chapterNum);

    return {bookNum, chapterNum};
}

export function msSelectorFormInput (element) {
    var value = $(element).val();
    
    if (value !== "" && value.indexOf(".") === -1) {
        $(element).val(
            Math.max(Math.min(value, $(element).attr("max")), $(element).attr("min"))
        );
    }
}

export function msSelectorFormInputClicked (element) {
    $(element).select();
}

export function navLink1Shown (element) {
    if ($(element).tab().is(":visible")) {
        setL2NavWidth();
    }
}

export function windowResized() {
    setL2NavWidth();
}

export function initialize() {
    $(document).on('change', ".ms-selector-form select[id$='bookSelector']", function() {
        bookSelectorChanged(this);
    });

    $(document).on('input', ".ms-selector-form input[id$='chapterNum'][type='number']", function() {
        msSelectorFormInput(this);
    });

    $(document).on('click', '.ms-selector-form input[type="number"]', function() {
        msSelectorFormInputClicked(this);
    });

    $(document).on('shown.bs.tab', ".ms-nav.ms-nav-1st .nav-link,#manuscriptTabs .nav-link", function() {
        navLink1Shown (this);
    });

    $(window).resize(function() {
        windowResized();
    });
}