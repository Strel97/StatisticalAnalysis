# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@calculation_click = () ->
    $.ajax({
      url: "/correlation/calculate",
      data: { metrics: "<%= params[:metrics] %>" },
      dataType: "json",
    }).done (html) ->
      $("#correlation .container").append html
      $('html, body').animate({
        scrollTop: $("#correlation").offset().top
      }, 2000)