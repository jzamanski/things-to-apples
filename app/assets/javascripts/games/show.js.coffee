$(document).on "page:change", ->
  if $('div.waiting').length
    setTimeout('location.reload(true)', 5000);
