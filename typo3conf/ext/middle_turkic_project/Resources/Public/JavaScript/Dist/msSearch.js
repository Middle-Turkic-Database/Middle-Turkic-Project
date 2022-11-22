/*!
 * Middle Turkic Project v1.0.0 (http://middleturkic.lingfil.uu.se)
 * Copyright 2017-2020 Mohsen Emami
 * Licensed under the GPL-2.0-or-later license
 */

import * as msUtils from "./msUtils.js";

let searchConfig = {
    query : ''
}

if(typeof jQuery=='undefined') {
    var headTag = document.getElementsByTagName("head")[0];
    var jqTag = document.createElement('script');
    jqTag.type = 'text/javascript';
    jqTag.src = 'jquery-3.6.0.min.js';
    jqTag.onload = myJQueryCode;
    headTag.appendChild(jqTag);
}

function loadSearchResults(pageNo = 1, $element = $("#searchResults")) {
    msUtils.loadContent("/mssearch?q=" + searchConfig.query + "&page=" + pageNo, $element)
};

$(function() {
    $("#ms-search-form").on('submit', function(e) {
        e.preventDefault();
        searchConfig.query = $(this).find("#search-input").val();
        loadSearchResults();
    });

    $(document).on('click', 'nav#searchPaginationNav li.page-item a.page-link', function() {
        let target = $(this).data("target")
        switch(target) {
            case "first":
                console.log($(this).data("target"));
                break;
            case "previous":
                console.log($(this).data("target"));
                break;
            case "previousset":
                console.log($(this).data("target"));
                break;
            case "last":
                console.log($(this).data("target"));
                break;
            case "next":
                console.log($(this).data("target"));
                break;
            case "nextset":
                console.log($(this).data("target"));
                break;
            default:
                loadSearchResults(target);
        }

    });
});