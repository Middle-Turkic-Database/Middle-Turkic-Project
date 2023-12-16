/*!
 * Middle Turkic Project v1.0.0 (http://middleturkic.lingfil.uu.se)
 * Copyright 2017-2020 Mohsen Emami
 * Licensed under the GPL-2.0-or-later license
 */

//import * as msUtils from "./msUtils.js";
import * as loadContent from "./loadContent.js";
import { showToastr as showToastr } from "./showToastr.js";
import * as findDesc from "./msSearchAdvanced.js"

let searchConfig = {
    query: '',
    msSet: '',
    msEditions: [],
    msBooks: [],
    urls : []
}

let checkboxesSelected = {}
let check = false;

if (typeof jQuery == 'undefined') {
    var headTag = document.getElementsByTagName("head")[0];
    var jqTag = document.createElement('script');
    jqTag.type = 'text/javascript';
    jqTag.src = 'jquery-3.6.0.min.js';
    jqTag.onload = myJQueryCode;
    headTag.appendChild(jqTag);
}

function loadDescriptionResults( $element = $("#searchResults")){

    let uniqueURLs = new Set ()

    for (const { msSet, msEdition } of searchConfig.urls) {
        const descURL = `/manuscripts/${msSet.replace(/\s+/g, "-")}/${msEdition}`;
        const xmlFilePath = `/fileadmin/user_upload/manuscripts/${msSet}/${msEdition}.xml`;
          fetchAndParseXML(xmlFilePath, descURL, uniqueURLs)
        };

        loadContent.loadContent(uniqueURLs, $element, 1, true);
}

function fetchAndParseXML(xmlFilePath,descURL, uniqueURLs) {
    const xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
      if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
            const xmlString = xhr.responseText;
            const parser = new DOMParser();
            const xmlDoc = parser.parseFromString(xmlString, 'text/xml');
            for (const key in checkboxesSelected) {
                if (Object.hasOwnProperty.call(checkboxesSelected, key)) {
                    if (key.includes('_')) {
                        // If the key contains '_', split into node name and attribute name
                        const [nodeName, attributeName] = key.split('_');
                        const nodes = xmlDoc.getElementsByTagName(nodeName);
        
                        for (let i = 0; i < nodes.length; i++) {
                            let attributeValue = nodes[i].getAttribute(attributeName);
                            if (attributeValue && checkboxesSelected[key].includes(attributeValue)) {
                                uniqueURLs.add(descURL)
                            }
                        }
                    } else if (key.includes('-')) {
                        // If the key contains '-', split into parent node name and target node name
                        const [nodeName, targetName] = key.split('-');
                        const nodes = xmlDoc.getElementsByTagName(nodeName);
          
                        for (let i = 0; i < nodes.length; i++) {
                          const targetElements = nodes[i].getElementsByTagName(targetName);
                      
                          for (let j = 0; j < targetElements.length; j++) {
                            let targetValue = targetElements[j].textContent;
                            if (targetValue && checkboxesSelected[key].includes(targetValue)) {
                                uniqueURLs.add(descURL)
                            }
                          }
                        }
                      } else {
                        // Standard handling for non-nested elements
                        const nodeList = xmlDoc.getElementsByTagName(key);
        
                        for (let i = 0; i < nodeList.length; i++) {
                            let nodeValue = nodeList[i].textContent;
                            if (checkboxesSelected[key].includes(nodeValue)) {
                                uniqueURLs.add(descURL)
                            }
                        }
                    }
                }
            }
        } else {
          console.error(`Error fetching ${xmlFilePath}. Status code: ${xhr.status}`);
        }
      }
    };
  
    xhr.open('GET', xmlFilePath, true);
    xhr.send();
  }

function loadAllSetsResults(pageNo, $element){
    var msAllSets = $("form#ms-search-form select#searchMsSet option:not(:first-child)").map(function() {
        return $(this).val().toLowerCase();
    }).get();
;
    var searchURL = `/mssearch?q=${searchConfig.query}&page=${pageNo}&msSet=[`;

        msAllSets.forEach((set, index) => {
            searchURL = `${searchURL}"${set}"`;
            if (index < msAllSets.length - 1) {
                searchURL = `${searchURL},`;
            }
        });
        searchURL = `${searchURL}]`


        if (searchConfig.msEditions.length > 0) {
            searchURL += `&msEditions=[`;
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
        
        loadContent.loadContent(searchURL, $element);
}

function loadSearchResults(pageNo = 1, $element = $("#searchResults")) {
    if (searchConfig.msSet === 'any') {
        loadAllSetsResults(pageNo, $element)

    } else {
        var searchURL = `/mssearch?q=${searchConfig.query}&page=${pageNo}`;

        if (searchConfig.msSet !== '') {
            searchURL += `&msSet=${searchConfig.msSet}`;
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

        loadContent.loadContent(searchURL, $element);
    }
};


function disableBookSelect($element = $("form#ms-search-form select#searchMsBooks")) {
    $element.prop("disabled", true);
    $element.html("<option select value='Any'>All Books</options>");
};

// We load all the editions in the 'Editions' box in the search functionality
function loadAllEditions($element = $("form#ms-search-form select#searchMsEditions")) {
    // Get an array of all available msSet values from the dropdown menu
    var msSets = $("form#ms-search-form select#searchMsSet option:not(:first-child)").map(function() {
        return $(this).val().toLowerCase();
    }).get();

    // Send an AJAX request for each msSet value
    var remaining = msSets.length;
    var allOptionsText = [];

    msSets.forEach(function (msSet) {
        $.ajax({
            method: "GET",
            url: "/selectorhelper",
            data: { msSet: msSet },
        })
        .done(function (editions) {
            if (editions.length > 0) {
                var optionsText = "";
                for (const edition of editions) {
                    const editionName = edition;
                    optionsText = optionsText + `<option selected value="${editionName}">${editionName}</option>`;
                }
                allOptionsText.push(optionsText);
            }

            // Reduce the remaining count and update the select element when all requests are complete
            if (--remaining === 0) {
                $element.html(allOptionsText.join(''));
                $element.prop("disabled", false);
                $element.focus();
                enableFetchBooksBtn();
            }
        })
        .fail(function () {
            // Handle failures if needed
            showToastr('error', 'Could not load editions. Please try again!');
        });
    }
    );
}

function loadEditionSelect($element = $("form#ms-search-form select#searchMsEditions")) {
    // Get the current value of the msSet dropdown
    var msSet = getMsSet();

    // If msSet is "Any", fetch editions for all available msSets
    if (msSet === "any") {
        loadAllEditions($element)
    }
    // Otherwise, fetch editions for the selected msSet value
    else {
        $.ajax({
            method: "GET",
            url: "/selectorhelper",
            data: { msSet: msSet },
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
    }
}



function loadBookSelect($element = $("form#ms-search-form select#searchMsBooks")) {
    var msSetBook = getMsSet()
    if (msSetBook == 'any') {
        var msSetsBooks = $("form#ms-search-form select#searchMsSet option:not(:first-child)").map(function () {
            return $(this).val().toLowerCase();
        }).get();

        var optionText = "";
        msSetsBooks.forEach((set) => {
            var url = "/selectorhelper?msSet=" + set + "&msEditions=" + JSON.stringify(getMsEditions());

            $.ajax({
                method: "GET",
                url: url,
            })
                .done(function (books) {
                    for (const bookIt in books) {
                        optionText += `<option selected value="${books[bookIt].bookNo}">${books[bookIt].bookName}</option>`
                    }
                    $element.html(optionText);
                    $element.prop("disabled", false);
                    $element.focus();
                })
        })

    } else {
        var url = "/selectorhelper?msSet=" + msSetBook + "&msEditions=" + JSON.stringify(getMsEditions());

        $.ajax({
            method: "GET",
            url: url,
        })
            .done(function (books) {
                var optionText = "";
                for (const bookIt in books) {
                    optionText += `<option selected value="${books[bookIt].bookNo}">${books[bookIt].bookName}</option>`
                }
                $element.html(optionText);
                $element.prop("disabled", false);
                $element.focus();
            })
    }
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
    loadAllEditions()
    findDesc.findDesc().then((dataUrls) => {
        searchConfig.urls = dataUrls;
      });

    $(document).on('change', '#filtersMetaCollapse .custom-select', function(e) {
        const selectedOptions = $(this).val(); // Get an array of selected option values
        
        if (selectedOptions.length > 0) {
            check = true;
            enableSubmitBtn();
            $('#search-input').prop('readonly', true);
            $('#search-input').val('');
        } else {
            check = false;
            disableSubmitBtn();
            $('#search-input').prop('readonly', false);
        }
        
        // const allText = $(this).siblings('label').text().trim();
        const allText = $(this).siblings('label').attr('for').replace('Options', '');

        
        // Update the checkboxesSelected object based on option changes
        if (selectedOptions.length > 0) {
            checkboxesSelected[allText] = selectedOptions;
        } else {
            delete checkboxesSelected[allText];
        }
    });

    // what happens when we deselect all -> checkboxes are empty 
    $(document).ready(function() {
        // Add a click event listener to the Deselect All button
        $('#filtersMetaCollapse').on('click', '.btn-deselect-all', function() {
            // Loop through each multi-select element within the same collapsible section (Advanced filters)
            $(this)
                .closest('.collapse')
                .find('.custom-select')
                .each(function() {
                    $(this).val([]); // Deselect all options
                    $(this).trigger('change'); // Trigger the change event
                });
        });
    });

    

    $("form#ms-search-form select#searchMsSet").on('change', function (e) {
        disableBookSelect();
        disableFetchBooksBtn();
        loadEditionSelect();

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

    $("form#ms-search-form").on('submit', function(e) {
        e.preventDefault();
        if ($(this).find("#search-input").val().length > 0) {
            searchConfig.query = $(this).find("#search-input").val();
            searchConfig.msSet = getMsSet();
            searchConfig.msEditions = getMsEditions();
            searchConfig.msBooks = getMsBooks();
            loadSearchResults();
        }
        else if (check) {
            searchConfig.msSet = getMsSet();
            searchConfig.msEditions = getMsEditions();
            searchConfig.msBooks = getMsBooks();
            loadDescriptionResults()
        }
    });

    // create new url for the search functionality
    $(document).ready(function () {
        $('#searchResults').on('click', '.card-header, .card-title a', function (event) {
            // Prevent the default link behavior
            event.preventDefault();
            // Get the href attribute of the clicked element
            var url = $(this).attr('href');
            // Find the card-text element that contains the search word
            var cardText = $(this).closest('.card').find('.card-text:contains(' + searchConfig.query + ')');
            // Get the text content of the card-text element
            var cardTextContent = cardText.text();
            // Split the text content into an array of words
            var words = cardTextContent.split(/\s+/);
            // Find the index of the search word in the array of words
            var searchWordIndex = words.indexOf(searchConfig.query);
            const numStr1 = words[searchWordIndex + 2].match(/\d+/) ? words[searchWordIndex + 2].match(/\d+/)[0] : '';
            const num1 = numStr1 ? parseInt(numStr1, 10) : 0;
            const numStr2 = words[searchWordIndex + 1].match(/\d+/) ? words[searchWordIndex + 1].match(/\d+/)[0] : '';
            const num2 = numStr2 ? parseInt(numStr2, 10) : 0;

            // if the search word is the second from last word, so one token only follows
            if (searchWordIndex >= 0 && searchWordIndex + 3 === words.length) {
                var followingWord = words[searchWordIndex + 1]
                var prevWord = words[searchWordIndex - 1]
                url += '?search=' + encodeURIComponent(searchConfig.query) + '&prev=' + encodeURIComponent(prevWord) + '&following=' + encodeURIComponent(followingWord)
            } // if we extract two words and the second is not a number
            else if (searchWordIndex >= 0 && searchWordIndex + 2 < words.length && !num1 && !num2) {
                // Extract the two words following the search word
                var followingWords = words[searchWordIndex + 1] + ' ' + words[searchWordIndex + 2];
                // Append the query parameter to the URL, including the following words
                url += '?search=' + encodeURIComponent(searchConfig.query) + '&following=' + encodeURIComponent(followingWords);
            } // if we extract two words and the second is a number: prev & following url
            else if (searchWordIndex >= 0 && searchWordIndex + 2 < words.length && num1) {
                var followingWord = words[searchWordIndex + 1]
                var prevWord = words[searchWordIndex - 1]
                url += '?search=' + encodeURIComponent(searchConfig.query) + '&prev=' + encodeURIComponent(prevWord) + '&following=' + encodeURIComponent(followingWord)
            }
            else if (searchWordIndex >= 0 && searchWordIndex + 1 < words.length && num2) {
                var previousWords = words[searchWordIndex - 2] + ' ' + words[searchWordIndex - 1];
                url += '?search=' + encodeURIComponent(searchConfig.query) + '&prev=' + encodeURIComponent(previousWords);
                // If the search word is not found or there are no words following it, append only the search query parameter and prev word
            } else {
                url += '?search=' + encodeURIComponent(searchConfig.query) + '&prev=' + encodeURIComponent(prevWord);
            }

            // Open the new URL in a new tab
            var newWindow = window.open(url);
        });
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
