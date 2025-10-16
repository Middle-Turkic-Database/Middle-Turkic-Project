/*!
 * Middle Turkic Project v1.0.0 (http://middleturkic.lingfil.uu.se)
 * Copyright 2017-2020 Mohsen Emami
 * Licensed under the GPL-2.0-or-later license
 */

import * as msUtils from "./msUtils.js";
import * as loadContent from "./loadContent.js"

if(typeof jQuery=='undefined') {
    var headTag = document.getElementsByTagName("head")[0];
    var jqTag = document.createElement('script');
    jqTag.type = 'text/javascript';
    jqTag.src = 'jquery-3.6.0.min.js';
    jqTag.onload = myJQueryCode;
    headTag.appendChild(jqTag);
}

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
                var firstMaxChapter = $(".ms-selector-form select[id$='bookSelector'] option").first().data("chapternum");
                msUtils.setChapterPars(firstMaxChapter);
                msUtils.setL2NavWidth();
            });
            
            $('.ms-nav-1st [data-toggle="pill"], .ms-nav-2nd [data-toggle="pill"]').tooltip();
        });
    });
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
    loadContent.loadContent(comparisonURI, $element, function() {
        createSingleColumnTable();
        toggleComparisonView();
    });        
};

function loadComparison(msNav, ms1Name, ms2Name, msBook = -1, msChapter = -1, $element = $("#msComparisonFrame")) {
    loadNavBar(msNav, ms1Name, 'cmp', $element.children("#msNavBar"));
    loadComparisonContent(msNav, ms1Name, ms2Name, msBook, msChapter, $element.children("#msComparisonContent"));
};

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
        $("#msComparisonTable").removeClass("d-block");
        $("#msComparisonTable").addClass("d-none");
        $("#msComparisonTableSingleColumn").addClass("d-block");
        $("#msComparisonTableSingleColumn").removeClass("d-none");
    }
    else {
        $("#msComparisonTableSingleColumn").removeClass("d-block");
        $("#msComparisonTableSingleColumn").addClass("d-none");
        $("#msComparisonTable").addClass("d-block");
        $("#msComparisonTable").removeClass("d-none");
    }
}

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
    const secondMsName = $comparisonTable.find("thead tr td:nth-child(4)").text();
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
        let firstMsCell_trimmed = trimWhiteSpace(leftMsCell.textContent);
        let secondMsCell_trimmed = trimWhiteSpace(rightMsCell.html());
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


$(function() {
    msUtils.initialize();

    $(document).on('click', ".ms-nav .nav-link", function() {
        let {msBook, msChapter} = msUtils.navLinkClicked(this);

        loadComparisonContent($("#msComparisonMSSet>option:selected").val(),
                        $("#msComparisonSelect1>option:selected").val(),
                        $("#msComparisonSelect2>option:selected").val(),
                        msBook,
                        msChapter);
    });
    
    $(document).on('submit', ".ms-selector-form", function(e) {
        let {bookNum, chapterNum} = msUtils.msSelectorFormSubmitted(this, e);

        loadComparisonContent($("#msComparisonMSSet>option:selected").val(),
                        $("#msComparisonSelect1>option:selected").val(),
                        $("#msComparisonSelect2>option:selected").val(),
                        bookNum,
                        chapterNum);
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
        var selectedValue = $(this).children("option:selected").val();
        var currentCmpMap = comparisonMap.get(selectedValue);
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

