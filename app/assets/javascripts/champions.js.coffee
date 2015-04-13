$(document).ready ->
  if $(".charts").length
    $.ajax(
      url: '/api/champions/best_win_rate_with_history'
      type: 'GET'
      success: (result) ->
        position = 1
        $.each result, (name, hours) ->
          display_name = name.replace(" ", '')
          bad_images = ['Fiddlesticks', 'Bard', 'Wukong']
          if display_name == "Kog'Maw"
            display_name = "KogMaw"
          else if display_name == "Kha'Zix"
            display_name = "Khazix"
          else if display_name == "Rek'Sai"
            display_name = "RekSai"
          else if display_name == "Dr.Mundo"
            display_name = "DrMundo"
          else if display_name == "Cho'Gath"
            display_name = "Chogath"
          else if display_name == "LeBlanc"
            display_name = "Leblanc"
          else if display_name == "Vel'Koz"
            display_name = "Velkoz"
          else if $.inArray(display_name, bad_images) != -1
            display_name = "Teemo"

          $("#title#{position}").text("##{position}: #{name}")
          $("#image#{position}").attr('src', "http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/#{display_name}.png")
          ctx = $("#chart#{position}").get(0).getContext('2d')
          options = {
            multiTooltipTemplate: "<%if (datasetLabel){%><%=datasetLabel%>: <%}%><%= value %>%"
            scaleOverride: true
            scaleStartValue: 0
            scaleSteps: 10
            scaleStepWidth: 10
            scaleFontColor: "#fff"
            scaleGridLineColor : "#406976"
          }
          data = {
              labels: ["6 hours", "5 hours", "4 hours", "3 hours", "2 hours", "1 hour"],
              datasets: [
                  {
                      label: "Win Rate",
                      fillColor: "rgba(151,187,205,0.2)",
                      strokeColor: "rgba(151,187,205,1)",
                      pointColor: "rgba(151,187,205,1)",
                      pointStrokeColor: "#fff",
                      pointHighlightFill: "#fff",
                      pointHighlightStroke: "rgba(151,187,205,1)",
                      data: [hours[6], hours[5], hours[4], hours[3], hours[2], hours[1]]
                  }
              ]
          }
          myLineChart = new Chart(ctx).Line(data, options)
          position += 1
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


    $('.content main').css('opacity', 0.5)
    $('.js-loading').toggleClass('hidden')
    $.ajax(
      url: "/champions?order=#{order}&asc=#{asc}"
      dataType: 'text'
      type: 'GET'
      success: (html) ->
        $('.content main').replaceWith(html)
        $('.js-loading').toggleClass('hidden')
        $.each buttons, (_key, button) ->
          $(button).removeAttr('disabled')
    )
