$(document).ready ->
  upIcon = 'fa-caret-up'
  downIcon = 'fa-caret-down'

  $('.js-sort-champions button').on 'click', ->
    button = $(this)
    button.attr('disabled', true)
    buttons = $('.js-sort-champions button')
    $.each buttons.not(button), (_key, button) ->
      button = $(button)
      icon = button.find('i')
      button.attr('disabled', true)
      button.removeClass('active')
      icon.removeClass(downIcon)
      icon.removeClass(upIcon)

    order = button.attr('value')
    icon = button.find('i')
    button.addClass('active')

    role = $('.js-role').data('role')
    if role == undefined
      role = ''
    rated = $('.js-rated').data('rated')
    if rated == undefined
      rated = ''

    asc = false
    if icon.hasClass(downIcon)
      asc = true

    if asc == true
      icon.addClass(upIcon)
      icon.removeClass(downIcon)
    else
      icon.removeClass(upIcon)
      icon.addClass(downIcon)

    $('.content .card').css('opacity', 0.5)
    $('.js-loading').removeClass('hideme')
    $.ajax(
      url: "/champions?order=#{order}&asc=#{asc}&role=#{role}&rated=#{rated}"
      dataType: 'text'
      type: 'GET'
      success: (html) ->
        $('.content main').replaceWith(html)
        $('.js-loading').addClass('hideme')
        $.each buttons, (_key, button) ->
          $(button).removeAttr('disabled')
    )
