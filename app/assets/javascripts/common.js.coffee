$(document).ready ->
  $('[data-toggle="tooltip"]').tooltip()

  # http://twitter.github.io/typeahead.js/examples/
  champions = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: 10,
    prefetch: {
      url: '/api/champions/names.json',
      filter: (list) ->
        debugger
        $.map(list, (champion) ->
          { name: champion }
        )
    }
  })

  champions.initialize()

  $('.js-search .typeahead').typeahead(
    {
      hint: false,
      highlight: true,
      minLength: 1
    },
    {
      name: 'champions',
      displayKey: 'name',
      source: champions.ttAdapter()
    }
  )

  $('.tt-dropdown-menu').on 'click', () ->
    $('.js-submit').trigger 'click'
