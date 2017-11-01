# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$("table > tbody > tr > td.edit").on 'click','a#edit', (event) ->
  if ($("table > tbody > tr > td").find('#cancel').length > 0)
    toggle_cancel( $("table > tbody > tr > td").find('#cancel') )
  toggle_edit($(this))
# toggle item edit mode
toggle_edit = (el) ->
  id = el.parent().parent().attr("id")
  quant = $("tbody>#"+id+" .quantity").text()
  price = $("tbody>#"+id+" .price").text()
  q_select = int_select(quant)
  p_select = float_select(price)
  e_link = "<a id='save' href='#'>save</a> / <a id='cancel' href='#'>cancel</a>"
  $("tbody>#"+id+" .price").text("")
  $("tbody>#"+id+" .price").append(p_select)
  $("tbody>#"+id+" .quantity").text("")
  $("tbody>#"+id+" .quantity").append(q_select)
  $("tbody>#"+id+" .edit").text("")
  $("tbody>#"+id+" .edit").append(e_link)
  $(this).parent().addClass('save')
  $(this).parent().removeClass('edit')

# in table link element click eventListener
$("table > tbody > tr > td").on 'click', 'a#save', (event) ->
  changed = $(this).parent().parent().attr("changed")
  if (changed == "true")
    data = JSON.parse($(this).parent().parent().attr("data")).line_item
    order = $(this).parent().parent().attr("order")
    id = $(this).parent().parent().attr("id")
    data.qntity =  $(this).parent().parent().find(".quantity").attr("data")
    data.purchase_price =  $(this).parent().parent().find(".price").attr("data")

    $.ajax
      type: 'post'
      url: '/line_items/update',
      data: JSON.stringify(data)
      contentType: 'application/json; charset=utf-8'
      traditional: true
      success: (textStatus) ->
        return
# 'cancel' link eventListener
$("table > tbody > tr > td").on 'click', 'a#cancel', (event) ->
  toggle_cancel($(this))
# toggle cancel
toggle_cancel = (el) ->
  data = JSON.parse(el.parent().parent().attr("data"))
  id = el.parent().parent().attr("id")
  $("tbody>#"+id+" .price").attr("data", data.purchase_price)
  $("tbody>#"+id+" .quantity").attr("data", data.qntity)
  $("tbody>#"+id+" .price").children(':input').remove()
  $("tbody>#"+id+" .price").text("$"+data.line_item.purchase_price.toFixed(2))
  $("tbody>#"+id+" .quantity").children(':input').remove
  $("tbody>#"+id+" .quantity").text(data.line_item.qntity)
  $("tbody>#"+id+" .edit").children().remove()
  $("tbody>#"+id+" .edit").text("")
  $("tbody>#"+id+" .edit").append("<a id='edit'>Edit</a>")
  $(this).parent().parent().attr('changed', 'false')
  el.parent().addClass('edit')
  el.parent().removeClass('save')
# in table select element eventListener
$("table > tbody > tr > td").on 'click', "select", (event) ->
  data = JSON.parse($(this).parent().parent().attr("data"))
  field = $(this).attr('name')
  value = $(this).val()
  if (field == 'quant')
    $(this).parent().attr('data', value)
  else
    $(this).parent().attr('data', value.replace(/[$,]+/g,""))
  $(this).parent().parent().attr('changed', 'true')

# build int select
int_select = (sel_int) =>
  i_str = '<select name="quant">'
  for j in [1..25]
    if (""+j == sel_int)
      i_str += '<option value ="' + j + '" selected="selected">'+j+'</option>'
    else
      i_str += '<option value ="' + j + '">'+j+'</option>'
  return i_str

# build float select
float_select = (sel_flt) =>
  s = '<select name="price">'
  for i in [1..250]
    dstring = "$"+(i/10).toFixed(2)
    if ( dstring == sel_flt)
      s += '<option value ="' + dstring + '" selected="selected">'+dstring+'</option>'
    else
      s += '<option value ="' + dstring + '">'+dstring+'</option>'
  return s
