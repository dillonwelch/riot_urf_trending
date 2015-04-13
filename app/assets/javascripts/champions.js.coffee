$(document).ready ->
  if $('.show canvas').length
    $.ajax(
      url: "#{$('h1').text()}/last_day"
      type: 'GET'
      success: (result) ->
        canvas = $('.show canvas').get(0).getContext('2d')
        win_rates = []
        pick_rates = []
        total = []
        labels = []
        $.each result, (key, value) ->
          win_rates.push(value.win_rate.toFixed(2))
          pick_rates.push(value.pick_rate.toFixed(2))
          total.push(value.total_victories + value.total_losses)
          labels.push("#{value.month}/#{value.day}")

        options = {
          multiTooltipTemplate: "<%if (datasetLabel){%><%=datasetLabel%>: <%}%><%= value %>"
          scaleOverride: true
          scaleStartValue: 0
          scaleSteps: 10
          scaleStepWidth: 10
          scaleFontColor: "#fff"
          scaleGridLineColor: "#406976"
        }

        data = {
            labels: labels
            datasets: [
                {
                    label: "Win Rate",
                    fillColor: "rgba(151,187,205,0.2)",
                    strokeColor: "rgba(151,187,205,1)",
                    pointColor: "rgba(151,187,205,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(151,187,205,1)",
                    data: win_rates
                },
                {
                    label: "Pick Rate",
                    fillColor: "rgba(151,187,205,0.2)",
                    strokeColor: "rgba(151,187,205,1)",
                    pointColor: "rgba(151,187,205,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(151,187,205,1)",
                    data: pick_rates
                },
                {
                    label: "Total wins and losses",
                    fillColor: "rgba(0,0,0,0)",
                    strokeColor: "rgba(0,0,0,0)",
                    pointColor: "rgba(0,0,0,0)",
                    pointStrokeColor: "rgba(0,0,0,0)",
                    pointHighlightFill: "rgba(0,0,0,0)",
                    pointHighlightStroke: "rgba(0,0,0,0)",
                    data: total
                },
            ]
        }
        chart = new Chart(canvas).Line(data, options)
    )

  $('.js-sort-champions button').on 'click', ->
    button = $(this)
    button.attr('disabled', true)
    buttons = $('.js-sort-champions button')
    $.each buttons.not(button), (_key, button) ->
      button = $(button)
      span = button.find('span')
      button.attr('disabled', true)
      button.removeClass('active')
      span.removeClass('glyphicon-chevron-down')
      span.removeClass('glyphicon-chevron-up')

    order = button.attr('value')
    span = button.find('span')
    button.addClass('active')

    asc = false
    if span.hasClass('glyphicon-chevron-down')
      asc = true

    if asc == true
      span.addClass('glyphicon-chevron-up')
      span.removeClass('glyphicon-chevron-down')
    else
      span.removeClass('glyphicon-chevron-up')
      span.addClass('glyphicon-chevron-down')


    $('.content table').css('opacity', 0.5)
    $('.js-loading').removeClass('hideme')
    $.ajax(
      url: "/champions?order=#{order}&asc=#{asc}"
      dataType: 'text'
      type: 'GET'
      success: (html) ->
        $('.content main').replaceWith(html)
        $('.js-loading').addClass('hideme')
        $.each buttons, (_key, button) ->
          $(button).removeAttr('disabled')
    )
