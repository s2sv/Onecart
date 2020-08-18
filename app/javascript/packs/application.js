// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.




require("@rails/ujs").start()

require("@rails/activestorage").start()
require("channels")
require("jquery")
require("turbolinks").start()

require("packs/autocomplete")




// JS libraries
import "jquery"
import "@fortawesome/fontawesome-free/js/all";
// import "jquery-ujs"


import "bootstrap"


import "geocoder"

import flatpickr from 'flatpickr'




document.addEventListener("turbolinks:load", () => {
    flatpickr("[data-behaviour='flatpickr']", {
        enableTime:      true,
        altInput:        true,
        minDate:         "today",
        altFormat:       "F j, Y at h:i K",
        dateFormat:      "Y-m-d H:i",
        defaultHour:     23,
        defaultMinute:   59,
        minuteIncrement: 1
    })
})


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
