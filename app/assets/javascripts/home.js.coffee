$(document).ready ->
  teemoKills = $("#teemoKills")
  totalMatches = $("#totalMatches")
  totalKills = $("#totalKills")
  totalDeaths = $("#totalDeaths")

  if teemoKills.length
    parent = teemoKills.parent()
    teemoKills.parent().toggleClass('loading')
    $.ajax(
      url: 'api/champions/Teemo/deaths'
      type: 'GET'
      success: (result) ->
        teemoKills.html(result)
        teemoKills.parent().toggleClass('loading')
    )

  if totalMatches.length
    totalMatches.parent().toggleClass('loading')
    $.ajax(
      url: 'api/matches/total'
      type: 'GET'
      success: (result) ->
        totalMatches.html(result)
        totalMatches.parent().toggleClass('loading')
    )

  if totalKills.length && totalDeaths.length
    totalKills.parent().toggleClass('loading')
    totalDeaths.parent().toggleClass('loading')
    $.ajax(
      url: 'api/champions/total_kills_and_deaths'
      type: 'GET'
      success: (result) ->
        totalKills.html(result.kills)
        totalDeaths.html(result.deaths - result.kills)
        totalKills.parent().toggleClass('loading')
        totalDeaths.parent().toggleClass('loading')
    )
