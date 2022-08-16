/*!
 * Middle Turkic Project v1.0.0 (http://middleturkic.lingfil.uu.se)
 * Copyright 2017-2020 Mohsen Emami
 * Licensed under the GPL-2.0-or-later license
 */

import * as msUtils from './msUtils.js';

if(typeof jQuery=='undefined') {
    var headTag = document.getElementsByTagName("head")[0];
    var jqTag = document.createElement('script');
    jqTag.type = 'text/javascript';
    jqTag.src = 'jquery-3.6.0.min.js';
    jqTag.onload = myJQueryCode;
    headTag.appendChild(jqTag);
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

    msUtils.loadContent(transcriptURI, $element);
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

    msUtils.loadContent(transcriptURI, $element);
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

    msUtils.loadContent(transcriptURI, $element);
};

function toNaturalNo(str) {
    if (typeof(str) != 'string') return false;

    let number = parseInt(str);
    if (!isNaN(str) && !isNaN(number) && number >=0) {
        return number;
    }
    else {
        return false;
    }
}

function validateBookChapter(bookNo = "-1", chapterNo = "-1") {
    bookNo = toNaturalNo(bookNo);
    let arrayBookNos = $(".ms-nav-1st:first .nav-link").map(function() {
        return $(this).data("bookno");
    }).get();
    if (!bookNo || $.inArray(bookNo, arrayBookNos) == -1) {
        return {bookNo : -1, chapterNo : -1};
    }
    
    let maxChapterNo = $(".tab-pane[id|='trc'],[id|='trl'],[id|='prl']").filter("[id$='pills-" + bookNo + "-tab']").find(".ms-nav-2nd>.nav-link:last").data("chapterno");
    chapterNo = toNaturalNo(chapterNo);
    if (!chapterNo || chapterNo > maxChapterNo) {
        chapterNo = -1;
    }

    return {bookNo, chapterNo}
}

function changeMsTab(docType) {
    if (docType !== 'description' && docType !== 'transcription' && docType !== 'translation' && docType !== 'parallel') return;
    
    $("#" + docType + "-tab.nav-link").tab("show");
}

$(function() {
    msUtils.initialize();

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

    const params = new URLSearchParams(window.location.search);
    var manuscriptBook = params.get('msBook');
    var manuscriptChapter = params.get('msChapter');
    var docType = params.get('type');

    let {bookNo, chapterNo} = validateBookChapter(manuscriptBook, manuscriptChapter)
    loadTranscript($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), bookNo, chapterNo);
    loadTranslation($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), bookNo, chapterNo);
    loadParallel($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), bookNo, chapterNo);
    msUtils.updateNavigation(bookNo, chapterNo);

    if (docType === 'transcription' || docType === 'translation' || docType === 'parallel') {
        changeMsTab(docType);
    }

    msUtils.enableNavBarTooltip();
    var firstMaxChapter = $(".ms-selector-form select[id$='bookSelector'] option").first().data("chapternum");
    msUtils.setChapterPars(firstMaxChapter);
    msUtils.setL2NavWidth();

    $(document).on('click', ".ms-nav .nav-link", function() {
        let {msBook, msChapter} = msUtils.navLinkClicked(this);
        
        loadTranscript($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), msBook, msChapter);
        loadTranslation($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), msBook, msChapter);
        loadParallel($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), msBook, msChapter);
    });
    
    $(document).on('submit', ".ms-selector-form", function(e) {
        let {bookNum, chapterNum} = msUtils.msSelectorFormSubmitted(this, e);
        
        loadTranscript($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), bookNum, chapterNum);
        loadTranslation($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), bookNum, chapterNum);
        loadParallel($("#msTranscriptContent").data('msnav'), $("#msTranscriptContent").data('msname'), bookNum, chapterNum);
    });
});