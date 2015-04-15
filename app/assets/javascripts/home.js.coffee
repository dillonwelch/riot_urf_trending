$(document).ready ->
  teemoKills = $("#teemoKills")
  totalMatches = $("#totalMatches")
  totalKills = $("#totalKills")
  totalDeaths = $("#totalDeaths")
  wait_time = 1

  if teemoKills.length
    # If we have a hardcoded value, use it!
    defaultValTeemo = teemoKills.data('val')
    if defaultValTeemo
      # Allow odometer to load first
      setTimeout( (->
        teemoKills.html(defaultValTeemo)
      ), wait_time)
    else
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
    defaultVal = totalMatches.data('val')
    if defaultVal
      setTimeout( (->
        totalMatches.html(defaultVal)
      ), wait_time)
    else
      totalMatches.parent().toggleClass('loading')
      $.ajax(
        url: 'api/matches/total'
        type: 'GET'
        success: (result) ->
          totalMatches.html(result)
          totalMatches.parent().toggleClass('loading')
      )

  if totalKills.length && totalDeaths.length
    defaultValKills = totalKills.data('val')
    defaultValDeaths = totalDeaths.data('val')
    if defaultValKills && defaultValDeaths
      setTimeout( (->
        totalKills.html(defaultValKills)
        totalDeaths.html(defaultValDeaths)
      ), wait_time)
    else
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
