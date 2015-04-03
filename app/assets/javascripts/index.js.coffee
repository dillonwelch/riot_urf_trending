$(window).load ->
  $.ajax(
    url: 'best_win_rate_with_history'
    type: 'GET'
    success: (result) ->
      position = 1
      $.each result, (name, hours) ->
        ctx = $("#chart#{position}").get(0)
        options = {
          multiTooltipTemplate: "<%if (datasetLabel){%><%=datasetLabel%>: <%}%><%= value %>%"
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
