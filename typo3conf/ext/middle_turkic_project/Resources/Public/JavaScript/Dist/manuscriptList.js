function loadContent(URI, $element, callback) {
    $element.hide(0, function() {
        $(this).siblings(".loader").fadeIn('fast');
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
            $(this).siblings(".loader").fadeOut('fast', function() {
                $element.fadeIn();
            });
            $('[data-toggle="tooltip"]').tooltip();
            if (typeof callback === 'function') {
                callback();
            }
        });
    });
};

function loadNavBar(msNav, msName, uniqueID, $element = $("#msComparisonFrame>#msComparisonContent")) {
    var navBarURI = "/msnavbar?msNav=" + msNav + "&msName=" + msName + "&uniqueID=" + uniqueID;
    $element.hide(0, function() {
        $(this).load(encodeURI(navBarURI), function(response, status, xhr) {
            if (status == "error") {
                var errorMessage = "";
                if (xhr.readyState == 0) {
                    errorMessage = "An error occured while fetching the Manuscript Navigation Bar. Check your Internet connection.";
                } else {
                    errorMessage = "An error occured while fetching the manuscript: " + xhr.status + " " + xhr.statusText;
                }
                $element.html(errorMessage);
            }
            $(this).siblings(".loader").fadeOut('fast', function() {
                $element.fadeIn();
            });
            var firstMaxChapter = $(".ms-selector-form select[id$='bookSelector'] option").first().data("chapternum");
            setChapterPars(firstMaxChapter);
            setL2NavWidth();
            $('.ms-nav-1st [data-toggle="pill"], .ms-nav-2nd [data-toggle="pill"]').tooltip();
        });
    });
};


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

function loadParallel(msNav, msName, msBook = -1, msChapter = -1, $element = $("#msParallelContent")) {
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
    transcriptURI += "&type=parallel";

    loadContent(transcriptURI, $element);
};

function loadComparisonContent(msNav, ms1Name, ms2Name, msBook = -1, msChapter = -1, $element = $("#msComparisonFrame>#msComparisonContent")) {
    var comparisonURI = "/mscomparison?msNav=" + msNav + "&ms1Name=" + ms1Name + "&ms2Name=" + ms2Name;
    if (msBook >= 0) {
        if (msBook == 0) {
            msBook = "000";
        }
        comparisonURI += "&msBook=" + msBook;
        if (msChapter >= 1) {
            comparisonURI += "&msChapter=" + msChapter;
        }
    }
    loadContent(comparisonURI, $element, function() {
        createSingleColumnTable();
        toggleComparisonView();
    });        
        //compare();
};

function loadComparison(msNav, ms1Name, ms2Name, msBook = -1, msChapter = -1, $element = $("#msComparisonFrame")) {
    loadNavBar(msNav, ms1Name, 'cmp', $element.children("#msNavBar"));
    loadComparisonContent(msNav, ms1Name, ms2Name, msBook, msChapter, $element.children("#msComparisonContent"));
};


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

function setL2NavWidth() {
    var $l2NavLinks = $("#manuscriptTabsContent>.tab-pane.show .tab-content>.tab-pane.active>.nav.ms-nav.ms-nav-2nd .nav-link");
    $l2NavLinks.each(function() {
        $(this).css("max-width", '');
        $(this).css("max-width", $(this).parent().find(".nav-link").first().outerWidth());
    });
}

function csvToArray(str, delimiter = ",") {
    var arr = [];
    const rows = str.split("\n");
    for (let row = 0; row < rows.length; row++) {
        const columns = rows[row].split(",");
        arr[row] = [];
        for (let column = 0; column < columns.length; column++) {
            arr[row][column] = columns[column];
        }
    }

    return arr;
}

function toggleComparisonView() {
    if ($("#toggleComparisonTable").is(":checked")) {
        $("#msComparisonTable").addClass("d-none");
        $("#msComparisonTableSingleColumn").removeClass("d-none");
    }
    else {
        $("#msComparisonTableSingleColumn").addClass("d-none");
        $("#msComparisonTable").removeClass("d-none");
    }
}


$(function() {
    $('.list-group-item').on('click', function() {
        $('.fa-angle-double-right,.fa-angle-double-down', this)
            .toggleClass('fa-angle-double-right')
            .toggleClass('fa-angle-double-down');
    });
    
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
    loadParallel($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'));

    $('.ms-nav-1st [data-toggle="pill"], .ms-nav-2nd [data-toggle="pill"]').tooltip();

    var firstMaxChapter = $(".ms-selector-form select[id$='bookSelector'] option").first().data("chapternum");
    setChapterPars(firstMaxChapter);

    setL2NavWidth();

    $(document).on('click', ".ms-nav .nav-link", function() {
        $(".ms-nav-2nd a.nav-link").removeClass("active");
    
        var msBook = -1;
        var msChapter = -1;
        if ($(this).closest(".nav").hasClass("ms-nav-1st")) {
            msBook = $(this).data("bookno");
            if ($(this).hasClass("dropdown-toggle")) {
                msChapter = 1;
            }
            $(".ms-nav .nav-link[id$='" + $(this).attr('id').match(/pills(.*)$/gm) + "']").each(function() {
                $(this).tab("show");
            });
            $("[id$='" + $(this).attr('id').match(/pills(.*)$/gm) + "-tab'] .ms-nav-2nd .nav-link:first-child").each(function() {
                $(this).tab("show");
            });
        } else {
            var tabID = $(this).closest(".tab-pane").attr("id");
            msBook = $(".ms-nav-1st .nav-link[href='#" + tabID + "']").data('bookno');
            msChapter = $(this).data("chapterno");
          
          $(".ms-nav-2nd .nav-link[data-chapterno=" + $(this).data("chapterno") + "]").each(function() {
            $(this).tab("show");
          });
        }
        loadTranscript($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), msBook, msChapter);
        loadTranslation($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), msBook, msChapter);
        loadParallel($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), msBook, msChapter);
        loadComparisonContent($("#msComparisonMSSet>option:selected").val(),
                        $("#msComparisonSelect1>option:selected").val(),
                        $("#msComparisonSelect2>option:selected").val(),
                        msBook,
                        msChapter);
    
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
    
    $(document).on('change', ".ms-selector-form select[id$='bookSelector']", function() {
        setChapterPars($("option:selected", this).data("chapternum"), $(this));
        var $chapterNum = $(":input[name='chapterNum']", this.closest("form.ms-selector-form"));
        $($chapterNum).val($($chapterNum).attr('min'));
    });
    
    $(document).on('submit', ".ms-selector-form", function(e) {
        e.preventDefault();
        $(".ms-nav-2nd a.nav-link").removeClass("active");
        var $bookSelector = $(":input[name='bookSelector']", $(this));
        var bookNum = $(":selected", $bookSelector).val();
        var chapterNum = $(":input[name='chapterNum']", $(this)).val();
        
        $(":input[name='bookSelector']").val(bookNum);
        $(":input[name='chapterNum']").val(chapterNum);
        setChapterPars($("option:selected", $bookSelector).data("chapternum"));
      
        $(".ms-nav-1st .nav-link[data-bookno='" + bookNum + "']").each(function() {
            $(this).tab("show");
        });
        if (chapterNum != '' && chapterNum > 0) {
            var $secondTabEl = $(".ms-nav-1st a[data-bookno='" + bookNum + "']");
            $("[id$='" + $secondTabEl.attr('id').match(/pills(.*)$/gm) + "-tab'] .ms-nav-2nd .nav-link:nth-child(" + chapterNum + ")").each(function() {
                $(this).tab("show");
            });
        }
        loadTranscript($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), bookNum, chapterNum);
        loadTranslation($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), bookNum, chapterNum);
        loadParallel($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), bookNum, chapterNum);
        loadComparisonContent($("#msComparisonMSSet>option:selected").val(),
                        $("#msComparisonSelect1>option:selected").val(),
                        $("#msComparisonSelect2>option:selected").val(),
                        bookNum,
                        chapterNum);
    });
    
    $(document).on('input', ".ms-selector-form input[id$='chapterNum'][type='number']", function() {
        var value = $(this).val();
    
        if (value !== "" && value.indexOf(".") === -1) {
            $(this).val(
                Math.max(Math.min(value, $(this).attr("max")), $(this).attr("min"))
            );
        }
    });
    
    $(document).on('click', '.ms-selector-form input[type="number"]', function() {
        $(this).select();
    });
    
    $(document).on('shown.bs.tab', ".ms-nav.ms-nav-1st .nav-link,#manuscriptTabs .nav-link", function() {
        if ($(this).tab().is(":visible")) {
            setL2NavWidth();
        }
    });
    
    $(window).resize(function() {
        setL2NavWidth();
    });
    
    var comparisonMap = new Map();
    if (typeof comparisonMatrix !== 'undefined') {
        comparisonMatrix = JSON.parse(comparisonMatrix.replace(/\n/g, '\\n'));
        for (let msSet in comparisonMatrix) {
            comparisonMap.set(msSet, new Map());
            var msSetCmpMatrix = csvToArray(comparisonMatrix[msSet]);
            for (let row = 0; row < msSetCmpMatrix.length; row++) {
                for (let column = 0; column < msSetCmpMatrix[0].length; column++) {
                    if (row === 0) {
                        comparisonMap.get(msSet).set(msSetCmpMatrix[row][column], []);
                    }
                    else if (msSetCmpMatrix[row][column] == 1) {
                        comparisonMap.get(msSet).get(msSetCmpMatrix[0][row - 1]).push(msSetCmpMatrix[0][column]);
                    }
                }
            }
        }
    }

    $("#msComparisonMSSet").change(function() {
        $(this).closest('form').find(':submit').prop('disabled', true);
        var currentCmpMap = comparisonMap.get($(this).children("option:selected").val());
        var optionText = "<option selected disabled>Choose...</option>";
        $("#msComparisonSelect2").html(optionText);
        if (typeof(currentCmpMap) !== 'undefined') {
            currentCmpMap.forEach((relatedEditions, editionName) => {
                optionText += "<option value='" + editionName + "'>" + editionName + "</option>";
            });
            $("#msComparisonSelect1").html(optionText);
            $("#msComparisonBookSelect").removeClass("d-none");
        }
        else {
            $("#msComparisonBookSelect").addClass("d-none");
        }
    });

    $("#msComparisonSelect1").change(function() {
        $(this).closest('form').find(':submit').prop('disabled', true);
        var permitted2ndEditions = comparisonMap.get($("#msComparisonMSSet").children("option:selected").val()).get($(this).children("option:selected").val());
        var optionText = "<option selected disabled>Choose...</option>";
        if (permitted2ndEditions) {
            permitted2ndEditions.forEach(editionName => {
                optionText += "<option value='" + editionName + "'>" + editionName + "</option>";
            });
        }
        $("#msComparisonSelect2").html(optionText);
    });

    $("#msComparisonSelect2").change(function() {
        $(this).closest('form').find(':submit').prop('disabled', false);
    })

    $("#ms-comparison-form").on("submit", function(e) {
        e.preventDefault();

        $("#msComparisonFrame").addClass("border");
        $("#msTitle").html($("form#ms-comparison-form select#msComparisonMSSet").children("option:selected").html());
        $(".loader").removeClass("d-none");
        loadComparison($("form#ms-comparison-form select#msComparisonMSSet").children("option:selected").val(),
                        $("form#ms-comparison-form select#msComparisonSelect1").children("option:selected").val(),
                        $("form#ms-comparison-form select#msComparisonSelect2").children("option:selected").val());
    });

    $("#toggleComparisonTable").change(function() {
        toggleComparisonView();
    });
});

function trimWhiteSpace(str) {
    const regText = "\\s{2,}";
    const reg = new RegExp(regText, 'gm');
    return str.replace(reg, ' ');
}

function createSingleColumnTable($comparisonTable = $("table#msComparisonTable")) {
    if ($comparisonTable.length < 1) {
        return;
    }
    var leftFragment = document.createDocumentFragment();
    var rightFragment = document.createDocumentFragment();
    var singleColumnTableFragment = document.createDocumentFragment();
    var singleColumnTableElement = document.createElement('table');
    var singleColumnTheadElement = document.createElement('thead');
    var singleColumnHeadRowElement = document.createElement('tr');
    var singleColumnFirstHeadColumnElement = document.createElement('th');
    var singleColumnSecondHeadColumnElement = document.createElement('th');
    var singleColumnFirstHeadFlexElement = document.createElement('div');
    var singleColumnSecondHeadFlexElement = document.createElement('div');
    var singleColumnTbodyElement = document.createElement('tbody');
    var el = Array.from($comparisonTable.find("tbody td.left-column"));
    
    singleColumnTableElement.id = 'msComparisonTableSingleColumn';
    singleColumnTableElement.classList.add("table", "table-borderless", "table-sm", "table-striped", "d-none");
    singleColumnFirstHeadColumnElement.classList.add("align-middle", "five-percent-width");
    singleColumnFirstHeadColumnElement.scope = "col";
    singleColumnFirstHeadColumnElement.appendChild(document.createTextNode('#'));
    singleColumnHeadRowElement.appendChild(singleColumnFirstHeadColumnElement);
    singleColumnSecondHeadColumnElement.classList.add("d-flex", "flex-wrap");
    singleColumnFirstHeadFlexElement.classList.add("pr-4");
    singleColumnFirstHeadFlexElement.style.color = "limegreen";
    const firstMsName = $comparisonTable.find("thead tr td:nth-child(2)").text();
    const secondMsName = $comparisonTable.find("thead tr td:nth-child(3)").text();
    singleColumnFirstHeadFlexElement.appendChild(document.createTextNode(firstMsName));
    singleColumnSecondHeadColumnElement.appendChild(singleColumnFirstHeadFlexElement);
    singleColumnSecondHeadFlexElement.classList.add("pr-4");
    singleColumnSecondHeadFlexElement.style.color = "red";
    singleColumnSecondHeadFlexElement.appendChild(document.createTextNode(secondMsName));
    singleColumnSecondHeadColumnElement.appendChild(singleColumnSecondHeadFlexElement);
    singleColumnHeadRowElement.appendChild(singleColumnSecondHeadColumnElement);
    singleColumnTheadElement.appendChild(singleColumnHeadRowElement);
    singleColumnTableElement.appendChild(singleColumnTheadElement);
    var dmp = new diff_match_patch();
    el.forEach((leftMsCell) => {
        var rightMsCell = $(leftMsCell).siblings("td.right-column")
        firstMsCell_trimmed = trimWhiteSpace(leftMsCell.textContent);
        secondMsCell_trimmed = trimWhiteSpace(rightMsCell.html());
        var diff = dmp.diff_main(firstMsCell_trimmed, secondMsCell_trimmed);
        var rowElement = document.createElement('tr');
        var indexColumnElement = document.createElement('td');
        var compareTextElement = document.createElement('td');
        var index = leftMsCell.previousElementSibling.textContent;
        indexColumnElement = leftMsCell.previousElementSibling.cloneNode(true);
        rowElement.appendChild(indexColumnElement);
        dmp.diff_cleanupSemantic(diff);
        diff.forEach((part) => {
            if (part[0] === -1) {
                var span = document.createElement('span');
                span.style.color = 'limegreen';
                span.appendChild(document.createTextNode(part[1]));
                leftFragment.appendChild(span);
                compareTextElement.appendChild(span.cloneNode(true));
            }
            else if (part[0] === 1) {
                var span = document.createElement('span');
                span.style.color = 'red';
                span.appendChild(document.createTextNode(part[1]));
                rightFragment.append(span);
                compareTextElement.appendChild(span.cloneNode(true));
            } else {
                leftFragment.appendChild(document.createTextNode(part[1]));
                rightFragment.appendChild(document.createTextNode(part[1]));
                compareTextElement.appendChild(document.createTextNode(part[1]));
            }
        })

        leftMsCell.replaceChildren(leftFragment);
        rightMsCell.html(rightFragment);
        rowElement.appendChild(compareTextElement);
        singleColumnTbodyElement.appendChild(rowElement);
    })
    singleColumnTableElement.appendChild(singleColumnTbodyElement);
    singleColumnTableFragment.appendChild(singleColumnTableElement);
    $comparisonTable.after(singleColumnTableFragment);

    const hebrewLetters = "ְֱֲֳִֵֶַָֹֺֻּֽ֑֖֛֢֣֤֥֦֧֪֚֭֮֒֓֔֕֗֘֙֜֝֞֟֠֡֨֩֫֬֯־ֿ׀ׁׂ׃ׅׄ׆ׇאבגדהוזחטיךכלםמןנסעףפץצקרשתװױײ׳״"
    const startingSpan = '<span style="color: limegreen">'
    var regText = "([" +
        hebrewLetters +
        "][" +
        hebrewLetters +
        " ]*)"
    const reg = new RegExp(regText, 'gm');
    document.getElementById("msComparisonTable").innerHTML = document.getElementById("msComparisonTable").innerHTML.replace(reg, '<span style="unicode-bidi: embed;">$1</span>');
    $('[data-toggle="tooltip"]').tooltip();
}