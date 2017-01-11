# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$("table > tbody > tr > td.edit").on 'click','a#edit', (event) ->
  if ($("table > tbody > tr > td").find('#cancel').length > 0)
    toggle_cancel( $("table > tbody > tr > td").find('#cancel') )
  toggle_edit($(this))

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

$("table > tbody > tr > td").on 'click', 'a#cancel', (event) ->
  toggle_cancel($(this))

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

$("table > tbody > tr > td").on 'click', "select", (event) ->
  data = JSON.parse($(this).parent().parent().attr("data"))
  field = $(this).attr('name')
  value = $(this).val()
  if (field == 'quant')
    $(this).parent().attr('data', value)
  else
    $(this).parent().attr('data', value.replace(/[$,]+/g,""))
  $(this).parent().parent().attr('changed', 'true')


int_select = (sel_int) =>
  i_str = '<select name="quant">'
  for j in [1..25]
    if (""+j == sel_int)
      i_str += '<option value ="' + j + '" selected="selected">'+j+'</option>'
    else
      i_str += '<option value ="' + j + '">'+j+'</option>'
  return i_str


float_select = (sel_flt) =>
  s = '<select name="price">'
  for i in [1..250]
    dstring = "$"+(i/10).toFixed(2)
    if ( dstring == sel_flt)
      s += '<option value ="' + dstring + '" selected="selected">'+dstring+'</option>'
    else
      s += '<option value ="' + dstring + '">'+dstring+'</option>'
  return s

strip_dollar = (m) =>
  money = m.split('$')
  return money[1]

get_orders = () =>
  JSON.parse($('#order-total').attr('data-order'));

get_items = () =>
  snacks = $('form#snacks').serializeArray().filter((x) =>
    parseInt(x['value']) > 0)

add_item = (id, name, price) =>
  quantity_txt = $('body .jumbotron .container #quantity-text_'+id)
  cart = $('body nav .navbar .cart');
  orders = JSON.parse($('#order-total').attr('data-order'));
  id_array = orders.cart_items['id']
  index = id_array.indexOf(id+"")
  if ( index > -1)
    qntty = orders.cart_items['qntty'][index]
    orders.cart_items['qntty'][index] = (qntty + 1)
    quantity_txt.text(qntty + 1)
    cart.find('#qty #' + id).text(qntty + 1)
    cart.find('#price #' + id).text('$'+ (price * (qntty + 1)).toFixed(2))
  else
    cart_item = $('<li><\/li>')
    cart_item.text(name)
    cart_qty =  $('<li><\/li>')
    cart_qty.text("1")
    cart_price = $('<li><\/li>')
    cart_price.text(['$', price.toFixed(2)].join(''))
    cart_add = $('<li><\/li>')
    cart_add.attr('data-price', price)
    cart_add.attr('data-name', name)
    cart_sub = $('<li><\/li>')
    cart_sub.attr('data-price', price)
    cart_sub.attr('data-name', name)
    cart_item.attr('id', id)
    cart_qty.attr('id', id)
    cart_price.attr('id', id)
    cart_add.attr('id', id)
    cart_sub.attr('id', id)
    cart_add.attr('class', 'add')
    cart_sub.attr('class', 'remove')
    cart_item.appendTo(cart.find('#item'))
    cart_qty.appendTo(cart.find('#qty'))
    cart_price.appendTo(cart.find('#price'))
    cart_add.appendTo(cart.find('#add'))
    cart_sub.appendTo(cart.find('#remove'))
    img_add = $('<img src="../images/add.png">')
    img_add.appendTo(cart_add)
    img_rem = $('<img src="../images/subtract.png">')
    img_rem.appendTo(cart_sub)
    id_array = orders.cart_items['id'].concat(id)
    orders.cart_items['id'] = id_array
    ct_array = orders.cart_items['qntty']
    orders.cart_items['qntty'] = ct_array.concat(1)
    quantity_txt.text(1)
    if($('.cart-container').attr('toggle') == 'up')
      $('.cart-container').animate({height: '+=35px'}, 800, 'easeInOutExpo');

  $('#order-total').attr('data-order',JSON.stringify(orders));

remove_item = (id, price) =>
  quantity_txt = $('body .jumbotron .container #quantity-text_'+id)
  cart = $('body nav .navbar .cart');
  orders = JSON.parse($('#order-total').attr('data-order'))
  id_array = orders.cart_items['id']
  index = id_array.indexOf(id+"")
  if ( index > -1)
    qntty = (parseInt(orders.cart_items['qntty'][index]) - 1)
    if (qntty == 0 )
      orders.cart_items['id'].splice(index,1)
      orders.cart_items['qntty'].splice(index,1)
      quantity_txt.text(qntty)
      cart.find('#qty #' + id).remove()
      cart.find('#item #' + id).remove()
      cart.find('#price #' + id).remove()
      cart.find('#add #' + id).remove()
      cart.find('#remove #' + id).remove()
      if($('.cart-container').attr('toggle') == 'up')
        $('.cart-container').animate({height: '-=35px'}, 800, 'easeInOutExpo');
    else
      orders.cart_items['qntty'][index] = (qntty)
      quantity_txt.text(qntty)
      cart.find('#qty #' + id).text(qntty)
      cart.find('#price #' + id).text('$'+ (price * (qntty)).toFixed(2))
  $('#order-total').attr('data-order',JSON.stringify(orders))



update_price_total = (price) =>
  current_total = strip_dollar($("#order-total").html())
  current_float = parseFloat(current_total)
  new_total = price + current_float
  $("#order-total").html( "$" + new_total.toFixed(2) )


$('body .jumbotron .container #items .add-remove-control').on 'click',  'img', (event) ->
  choice = $(this).parent().attr("id")
  id = $(this).attr("id")
  price = $(event.target).data('price')
  name = $(event.target).data('name')
  orders = JSON.parse($('#order-total').attr('data-order'));
  id_array = orders.cart_items['id']
  index = id_array.indexOf(id+"")
  if (choice == 'item-add')
    update_price_total price
    add_item(id, name, price)
  else
    if (index > -1)
      update_price_total (0 - price)
      remove_item(id, price)
  return


$('#cart-contents').on 'click', 'img', (event) ->
  console.log($(event.target));
  choice = $(this).parent().attr("class")
  id = $(this).parent().attr("id")
  price = $(this).parent().data('price')
  name = $(this).parent().data('name')
  orders = JSON.parse($('#order-total').attr('data-order'));
  id_array = orders.cart_items['id']
  index = id_array.indexOf(id+"")
  if (choice == 'add')
    update_price_total price
    add_item(id, name, price)
  else
    if (index > -1)
      update_price_total (0 - price)
      remove_item(id, price)
  return





$('#reset').click ->
  window.location.href = "/";

$('#purchase').click ->
  $.ajax
    type: 'post'
    url: '/orders/purchase',
    data: JSON.stringify(get_orders())
    contentType: 'application/json; charset=utf-8'
    traditional: true
    success: (data) ->
      return

$('#order-total').click ->
  cart = $('body nav .navbar .cart');
  cart_h = 35 * (cart.find('#qty > li').length )
  if($('.cart-container').attr('toggle') == 'down')
    $('.cart-container').animate({height: '+=' + (60 + cart_h) + 'px'}, 800, 'easeInOutExpo');
    $('.cart-container').attr('toggle', 'up')
  else
    cart_h = $('.cart-container').height()
    $('.cart-container').animate({height: '-=' + (cart_h) + 'px'}, 800, 'easeInOutExpo');
    $('.cart-container').attr('toggle', 'down')
