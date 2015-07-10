# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@start = () ->
  $.ajax(url: "/metrics/index").done (html) ->
    $("#calculations .container").append html
    $('html, body').animate({
      scrollTop: $("#calculations").offset().top
    }, 2000)