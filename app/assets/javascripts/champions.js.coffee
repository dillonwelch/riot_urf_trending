$(document).ready ->
  show = $('.show')
  canvas = show.find('canvas')

  if canvas.length
    page = show.data('page')
    if page == 'champion'
      url = "/api/champions/#{$('#js-champion-name').text().replace('.', '').trim()}/overall"
    else if page == 'role'
      url = "/api/roles/#{$('#js-role-name').text().trim()}/overall"

    $.ajax(
      url: url
      type: 'GET'
      success: (result) ->
        canvas = canvas.get(0).getContext('2d')
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
                    fillColor: "rgba(0,0,0,0)",
                    strokeColor: "rgba(0,0,0,0)",
                    pointColor: "rgba(0,0,0,0)",
                    pointStrokeColor: "rgba(0,0,0,0)",
                    pointHighlightFill: "rgba(0,0,0,0)",
                    pointHighlightStroke: "rgba(0,0,0,0)",
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
