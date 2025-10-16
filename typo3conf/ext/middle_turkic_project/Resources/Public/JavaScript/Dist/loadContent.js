export function loadContent(URI, $element, callback, advanced = false) {
   
    if (advanced){
        loadURIs(URI, $element, callback);
        return;
    }
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

function loadURIs(uriSet, $element, callback) {
    // Hide the element, show the loader
    $element.slideUp('slow', function() {
        $(this).siblings(".loader").fadeIn('fast');

        // Get the count of URIs in the set
        const uriCount = uriSet.size;

        // Create an array to hold the HTML for each URI in the set
        const uriHTML = Array.from(uriSet).map(URI => {
            const uriParts = URI.split('/'); // Split the URI by "/"
            const lastPart = uriParts.pop(); // Retrieve the last part
            let secondLastPart = uriParts.pop(); // Retrieve the second last part
            
            // Replace dashes with whitespace and capitalize first letter of each word
            secondLastPart = secondLastPart.replace(/-/g, ' ')
                                           .replace(/\b\w/g, c => c.toUpperCase());
            
            const title = `<a href="${URI}" target="_blank">${secondLastPart}, ${lastPart}</a>`;                             

            return `<p class="border border-light">Manuscript:  ${title}</p>`;
        }).join('');

        // Create the results count element
        const res = uriCount > 1 ? 'results' : 'result'
        const resultsCountHTML = `<p class="text-muted mb-3 small">Showing ${uriCount} ${res}</p>`;

        // Combine the results count element with the URI HTML
        const combinedHTML = resultsCountHTML + uriHTML;

        // Set the HTML of the element to display all URIs
        $element.html(combinedHTML);

        // After updating the HTML, fade out the "loader" element and slide down $element
        $(this).siblings(".loader").fadeOut('fast', function() {
            $element.slideDown('slow');
        });

        $('[data-toggle="tooltip"]').tooltip();

        if (typeof callback === 'function') {
            callback();
        }
    });
};





