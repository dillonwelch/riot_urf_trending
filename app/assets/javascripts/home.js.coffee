$(document).ready ->
  if $("#teemoKills")
    refresh =  () ->
      $.ajax(
        url: 'api/champions/Teemo/deaths'
        type: 'GET'
        success: (result) ->
          $("#teemoKills").html(result)
      )

    refresh()
    setInterval(refresh, 1000)
