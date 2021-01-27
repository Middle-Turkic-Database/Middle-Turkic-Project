window.onload = function() {
    var url_string = window.location.href; //window.location.href
    var url = new URL(url_string);
    var contactUsFormSuccess = url.searchParams.get("contactUsFormSuccess");

    if (contactUsFormSuccess == "true") {
        toastr.options = {
            "closeButton": false,
            "debug": false,
            "newestOnTop": false,
            "progressBar": true,
            "positionClass": "toast-bottom-full-width",
            "preventDuplicates": true,
            "onclick": null,
            "showDuration": "300",
            "hideDuration": "1000",
            "timeOut": "5000",
            "extendedTimeOut": "1000",
            "showEasing": "swing",
            "hideEasing": "linear",
            "showMethod": "fadeIn",
            "hideMethod": "fadeOut"
        };

        toastr["success"]("Your message has been successfully sent. We will respond as soon as possible.", "Thank you for getting in touch with us.");

    }
}