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

  if totalKills.length && totalDeaths.length
    refresh = () ->
      $.ajax(
        url: 'api/champions/total_kills_and_deaths'
        type: 'GET'
        success: (result) ->
          totalKills.html(result.kills)
          totalDeaths.html(result.deaths - result.kills)
      )

    refresh()
    setInterval(refresh, refreshRate)
