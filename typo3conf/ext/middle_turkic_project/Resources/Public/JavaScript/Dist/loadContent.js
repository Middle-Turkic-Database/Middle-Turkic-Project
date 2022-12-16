export function loadContent(URI, $element, callback) {
    $element.slideUp('slow', function() {
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
                $element.slideDown('slow');
            });
            $('[data-toggle="tooltip"]').tooltip();
            if (typeof callback === 'function') {
                callback();
            }
        });
    });
};
