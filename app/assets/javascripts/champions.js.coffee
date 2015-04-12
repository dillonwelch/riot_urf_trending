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

  # if $('.js-champions-index').length
    # canvases = $('canvas.js-win-rate')
    # $.each(canvases, () ->
    #   canvas = $(this)
    #   chart = canvas.get(0).getContext('2d')
    #   win_rate = canvas.data('win-rate')
    #   data = [
    #     {
    #       value: win_rate
    #       color: 'rgba(151,187,205,1)'
    #       highlight: 'black'
    #     },
    #     {
    #       value: 100 - win_rate
    #       color: 'rgba(151,187,205,0.2)'
    #     }
    #   ]
    #   pie_chart = new Chart(chart).Pie(data, { showTooltips: false })
    # )
    # canvases = $('canvas.js-pick-rate')
    # $.each(canvases, () ->
    #   canvas = $(this)
    #   chart = canvas.get(0).getContext('2d')
    #   pick_rate = canvas.data('pick-rate')
    #   data = [
    #     {
    #       value: pick_rate
    #       color: 'rgba(151,187,205,1)'
    #       highlight: 'black'
    #     },
    #     {
    #       value: 100 - pick_rate
    #       color: 'rgba(151,187,205,0.2)'
    #     }
    #   ]
    #   pie_chart = new Chart(chart).Pie(data, { showTooltips: false })
    # )
