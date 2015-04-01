$(document).ready ->
  ctx = $('#myChart').get(0).getContext('2d')
  data = {
      labels: ["30 Minutes", "25 Minutes", "20 Minutes", "15 Minutes", "10 Minutes", "5 Minutes"],
      datasets: [
          {
              label: "Pick Rate",
              fillColor: "rgba(220,220,220,0.2)",
              strokeColor: "rgba(220,220,220,1)",
              pointColor: "rgba(220,220,220,1)",
              pointStrokeColor: "#fff",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(220,220,220,1)",
              data: [59, 80, 81, 56, 55, 40]
          },
          {
              label: "Win Rate",
              fillColor: "rgba(151,187,205,0.2)",
              strokeColor: "rgba(151,187,205,1)",
              pointColor: "rgba(151,187,205,1)",
              pointStrokeColor: "#fff",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(151,187,205,1)",
              data: [48, 40, 19, 86, 27, 90]
          }
      ]
  }
  options = {
    multiTooltipTemplate: "<%if (datasetLabel){%><%=datasetLabel%>: <%}%><%= value %>%"
  }
  myLineChart = new Chart(ctx).Line(data, options)
  # $('#legend').html(myLineChart.generateLegend())
