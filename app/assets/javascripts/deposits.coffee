# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
  $("table > tbody > tr > td.edit").on 'click', 'a#edit', ->
    if ($("table > tbody > tr > td").find('#cancel').length > 0)
      toggle_cancel( $("table > tbody > tr > td").find('#cancel') )
    toggle_edit($(this))

  toggle_edit = (el) ->
    id = el.parent().parent().attr("id")
    amount = $("tbody>#"+id+" .amount").text()
    a_select = float_select(amount)
    e_link = "<a id='save' href='#'>save</a> / <a id='cancel' href='#'>cancel</a>"
    $("tbody>#"+id+" .amount").text("")
    $("tbody>#"+id+" .amount").append(a_select)
    $("tbody>#"+id+" .edit").text("")
    $("tbody>#"+id+" .edit").append(e_link)
    $(this).parent().addClass('save')
    $(this).parent().removeClass('edit')


  $("table > tbody > tr > td").on 'click', 'a#save', ->
    changed = $(this).parent().parent().attr("changed")
    if (changed == "true")
      id = $(this).parent().parent().attr("id")
      data = JSON.parse($(this).parent().parent().attr("data"))
      data.amount = $(this).parent().parent().find(".amount").attr("data")
      $.ajax
        type: 'post'
        url: '/deposits/update',
        data: JSON.stringify(data)
        contentType: 'application/json; charset=utf-8'
        traditional: true
        success: (textStatus) ->
          return

  $("table > tbody > tr > td").on 'click', 'a#cancel',  ->
    toggle_cancel($(this))

  toggle_cancel = (el) ->
    data = JSON.parse(el.parent().parent().attr("data"))
    id = el.parent().parent().attr("id")
    $("tbody>#"+id+" .amount").attr("data", data.amount)
    $("tbody>#"+id+" .amount").children(':input').remove()
    $("tbody>#"+id+" .amount").text( "$"+data.amount.toFixed(2) )
    $("tbody>#"+id+" .edit").children().remove()
    $("tbody>#"+id+" .edit").text("")
    $("tbody>#"+id+" .edit").append("<a id='edit'>Edit</a>")
    $(this).parent().parent().attr('changed', 'false')
    el.parent().addClass('edit')
    el.parent().removeClass('save')

  $("table > tbody > tr > td").on 'click', "select", ->
    value = $(this).val()
    data = parseFloat(value.replace(/[$,]+/g,""))
    $(this).parent().attr('data', JSON.stringify(data))
    $(this).parent().parent().attr('changed', 'true')

  float_select = (sel_flt) =>
    s = '<select name="amount">'
    for i in [1..99]
      dstring = "$"+i.toFixed(2)
      if ( dstring == sel_flt)
        s += '<option value ="' + dstring + '" selected="selected">'+dstring+'</option>'
      else
        s += '<option value ="' + dstring + '">'+dstring+'</option>'
    return s
