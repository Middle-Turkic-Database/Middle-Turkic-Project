/*!
 * Middle Turkic Project v1.0.0 (http://middleturkic.lingfil.uu.se)
 * Copyright 2017-2020 Mohsen Emami
 * Licensed under the GPL-2.0-or-later license
 */

import * as msUtils from "./msUtils.js";
import * as loadContent from "./loadContent.js";
import { showToastr as showToastr } from "./showToastr.js";

let searchConfig = {
    query: '',
    msSet: '',
    msEditions: [],
    msBooks: [],
}

var datasetNames = ['Middle Karaim'];

if (typeof jQuery == 'undefined') {
    var headTag = document.getElementsByTagName("head")[0];
    var jqTag = document.createElement('script');
    jqTag.type = 'text/javascript';
    jqTag.src = 'jquery-3.6.0.min.js';
    jqTag.onload = myJQueryCode;
    headTag.appendChild(jqTag);
}

function loadSearchResults(pageNo = 1, $element = $("#searchResults")) {
    var searchURL = `/mssearch?q=${searchConfig.query}&page=${pageNo}`;
    if (searchConfig.msSet != '' && searchConfig.msSet != 'Any') {
        searchURL = `${searchURL}&msSet=${searchConfig.msSet}`;
    }

    // check if msSet is 'All Sets'
    if (searchConfig.msSet == 'All Sets') {
        // loop through the dataset names and add them to the URL
        for (var i = 0; i < datasetNames.length; i++) {
            searchURL = `${searchURL}&msSet=${datasetNames[i]}`;
            searchConfig.msSet = datasetNames[i]
        }
    }

    if (searchConfig.msEditions.length > 0) {
        searchURL = `${searchURL}&msEditions=[`;
        searchConfig.msEditions.forEach((edition, index) => {
            searchURL = `${searchURL}"${edition}"`;
            if (index < searchConfig.msEditions.length - 1) {
                searchURL = `${searchURL},`;
            }
        });
        searchURL = `${searchURL}]`
    }
    if (searchConfig.msBooks.length > 0) {
        searchURL = `${searchURL}&msBooks=[`;
        searchConfig.msBooks.forEach((book, index) => {
            searchURL = `${searchURL}${book}`;
            if (index < searchConfig.msBooks.length - 1) {
                searchURL = `${searchURL},`;
            }
        });
        searchURL = `${searchURL}]`;
    }
    loadContent.loadContent(searchURL, $element)
};

function disableEditionSelect($element = $("form#ms-search-form select#searchMsEditions")) {
    $element.prop("disabled", true);
    $element.html("<option select value='Any'>All Editions</options>");
};

function disableBookSelect($element = $("form#ms-search-form select#searchMsBooks")) {
    $element.prop("disabled", true);
    $element.html("<option select value='Any'>All Books</options>");
};

function loadEditionSelect($element = $("form#ms-search-form select#searchMsEditions")) {
    $.ajax({
        method: "GET",
        url: "/selectorhelper",
        data: { msSet: getMsSet() },
    })
        .done(function (editions) {
            if (editions.length > 0) {
                var optionsText = "";
                for (const edition in editions) {
                    const editionName = editions[edition];
                    optionsText = optionsText + `<option selected value="${editionName}">${editionName}</option>`;
                }
                $element.html(optionsText);
                $element.prop("disabled", false);
                $element.focus();
                enableFetchBooksBtn();
            }
            else {
                showToastr('info', 'Could not load editions or there are not editions for this manuscript set.');
            }
        })
        .fail(function () {
            showToastr('error', 'Could not load editions. Please try again!');
        });
};

function loadBookSelect($element = $("form#ms-search-form select#searchMsBooks")) {
    $.ajax({
        method: "GET",
        url: "/selectorhelper?msSet=" + getMsSet() + "&msEditions=" + JSON.stringify(getMsEditions()),
    })
        .done(function (books) {
            var optionText = "";
            for (const bookIt in books) {
                optionText = optionText + `<option selected value="${books[bookIt].bookNo}">${books[bookIt].bookName}</option>`
            }
            $element.html(optionText);
            $element.prop("disabled", false);
            $element.focus();
        })
};

function getMsSet($element = $("form#ms-search-form select#searchMsSet option:selected")) {
    return $element.val().toLowerCase();
}

function getMsEditions($element = $("form#ms-search-form select#searchMsEditions option:selected")) {
    let editions = [];
    $element.each(function () {
        editions.push(this.value);
    });
    return editions;
}

function getMsBooks($element = $("form#ms-search-form select#searchMsBooks option:selected")) {
    let books = [];
    $element.each(function () {
        books.push(this.value);
    });
    return books;
}

function disableFetchBooksBtn($element = $("form#ms-search-form button#btnFetchBooks")) {
    $element.prop("disabled", true);
}

function enableFetchBooksBtn($element = $("form#ms-search-form button#btnFetchBooks")) {
    $element.prop("disabled", false);
}

function disableSubmitBtn($element = $("form#ms-search-form button:submit")) {
    $element.prop("disabled", true);
}

function enableSubmitBtn($element = $("form#ms-search-form button:submit")) {
    $element.prop("disabled", false);
}

$(function () {
    $("form#ms-search-form select#searchMsSet").on('change', function (e) {
        if (this.value === "Any") {
            disableEditionSelect();
            disableBookSelect();
            disableFetchBooksBtn();
        }
        else {
            disableBookSelect();
            disableFetchBooksBtn();
            loadEditionSelect();
        }
    });

    $("form#ms-search-form select#searchMsEditions").on('change', function (e) {
        disableBookSelect();
    });

    $("form#ms-search-form button#btnFetchBooks").on('click', function (e) {
        loadBookSelect();
    });

    $("form#ms-search-form input#search-input").on('input', function (e) {
        if ($(this).val().length > 0) {
            enableSubmitBtn();
        }
        else {
            disableSubmitBtn();
        }
    });

    $("form#ms-search-form").on('submit', function (e) {
        e.preventDefault();
        if ($(this).find("#search-input").val().length > 0) {
            searchConfig.query = $(this).find("#search-input").val();
            searchConfig.msSet = getMsSet();
            searchConfig.msEditions = getMsEditions();
            searchConfig.msBooks = getMsBooks();
            loadSearchResults();
        }
    });

    $(document).on('click', 'nav#searchPaginationNav li.page-item a.page-link', function () {
        let target = $(this).data("target")
        switch (target) {
            case "first":
                loadSearchResults(1)
                break;
            case "previous":
                loadSearchResults($("nav#searchPaginationNav li.page-item.active a").data("target") - 1);
                break;
            case "previousset":
                loadSearchResults($("nav#searchPaginationNav li.page-item.active a").data("target") - 5);
                break;
            case "last":
                loadSearchResults(1000000);
                break;
            case "next":
                loadSearchResults($("nav#searchPaginationNav li.page-item.active a").data("target") + 1);
                break;
            case "nextset":
                loadSearchResults($("nav#searchPaginationNav li.page-item.active a").data("target") + 5);
                break;
            default:
                loadSearchResults(target);
        }

    });
});
