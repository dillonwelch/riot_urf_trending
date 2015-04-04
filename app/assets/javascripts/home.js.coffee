$(document).ready ->
  refreshRate = 5000
  teemoKills = $("#teemoKills")
  totalMatches = $("#totalMatches")
  totalKills = $("#totalKills")
  totalDeaths = $("#totalDeaths")

  if teemoKills.length
    refresh = () ->
      $.ajax(
        url: 'api/champions/Teemo/deaths'
        type: 'GET'
        success: (result) ->
          teemoKills.html(result)
      )

    refresh()
    setInterval(refresh, refreshRate)

  if totalMatches.length
    refresh = () ->
      $.ajax(
        url: 'api/matches/total'
        type: 'GET'
        success: (result) ->
          totalMatches.html(result)
      )

    refresh()
    setInterval(refresh, refreshRate)

  if totalKills.length
    refresh = () ->
      $.ajax(
        url: 'api/champions/total_kills'
        type: 'GET'
        success: (result) ->
          totalKills.html(result)
      )

    refresh()
    setInterval(refresh, refreshRate)

  if totalDeaths.length
    refresh = () ->
      $.ajax(
        url: 'api/champions/total_deaths'
        type: 'GET'
        success: (result) ->
          totalDeaths.html(result)
      )

    refresh()
    setInterval(refresh, refreshRate)
