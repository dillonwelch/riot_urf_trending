$(document).ready ->
  ctx = $('#myChart').get(0).getContext('2d')
  options = {
    multiTooltipTemplate: "<%if (datasetLabel){%><%=datasetLabel%>: <%}%><%= value %>%"
  }
  # $('#legend').html(myLineChart.generateLegend())

  $.ajax(
    url: 'best_win_rate_with_history'
    type: 'GET'
    success: (result) ->
      debugger
      hours = result.Amumu
      data = {
          labels: ["6 hours", "5 hours", "4 hours", "3 hours", "2 hours", "1 hour"],
          datasets: [
              # {
              #     label: "Pick Rate",
              #     fillColor: "rgba(220,220,220,0.2)",
              #     strokeColor: "rgba(220,220,220,1)",
              #     pointColor: "rgba(220,220,220,1)",
              #     pointStrokeColor: "#fff",
              #     pointHighlightFill: "#fff",
              #     pointHighlightStroke: "rgba(220,220,220,1)",
              #     data: [59, 80, 81, 56, 55, 40]
              # },
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
  )
