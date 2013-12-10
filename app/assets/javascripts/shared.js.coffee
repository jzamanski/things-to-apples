# Trigger 'page:change' event on DOM ready event
# Used to overcome turbolinks not triggering DOM ready event when replacing pages
# Scripts that would normally wait for DOM ready should wait for page:change instead
$ ->
  $(document).trigger "page:change"