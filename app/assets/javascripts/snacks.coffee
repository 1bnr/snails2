# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# strip dollar sign from string
strip_dollar = (m) =>
  money = m.split('$')
  return money[1]

# get order data
get_orders = () =>
  JSON.parse($('#order-total').attr('data-order'));

# get items from snacks form
get_items = () =>
  snacks = $('form#snacks').serializeArray().filter((x) =>
    parseInt(x['value']) > 0)

# decrease number of selected item in cart by one
remove_item = (id, price) =>
  cart = $('body nav .navbar .cart');
  orders = JSON.parse($('#order-total').attr('data-order'))
  id_array = orders.cart_items['id']
  index = id_array.indexOf(id+"")
  if ( index > -1)
    qntty = (parseInt(orders.cart_items['qntty'][index]) - 1)
    qntty_input = $('body .jumbotron .container .row #items #item_'+id+' input')
    qntty_input.val(qntty+"")
    qntty_input.trigger('change')

# increase number of selected item in cart by one
add_item = (id, name, price) =>
  cart = $('body nav .navbar .cart');
  orders = JSON.parse($('#order-total').attr('data-order'))
  id_array = orders.cart_items['id']
  index = id_array.indexOf(id+"")
  qntty = 1
  if ( index > -1)
    qntty = (parseInt(orders.cart_items['qntty'][index]) + 1)
  qntty_input = $('body .jumbotron .container .row #items #item_'+id+' input')
  qntty_input.val(qntty+"")
  qntty_input.trigger('change')

# add an new item to the cart
add_item_to_cart = (id, name, price, qtty) =>
  quantity_txt = $('body .jumbotron .container #quantity-text_'+id)
  cart = $('body nav .navbar .cart');
  orders = JSON.parse($('#order-total').attr('data-order'));
  cart_item = $('<li><\/li>')
  cart_item.text(name)
  cart_qty =  $('<li><\/li>')
  cart_qty.text(qtty+"")
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
  id_array = orders.cart_items['id'].concat(id+"")
  orders.cart_items['id'] = id_array
  ct_array = orders.cart_items['qntty']
  orders.cart_items['qntty'] = ct_array.concat(qtty+"")
  quantity_txt.text(1)
  if($('.cart-container').attr('toggle') == 'up')
    $('.cart-container').animate({height: '+=35px'}, 800, 'easeInOutExpo');

# item input onChange eventListener
$('body .jumbotron .container .row #items .item').on 'change', 'input', (event) ->
  qntty = parseInt($(this).val())
  id = $(this).attr("id").slice(9, $(this).attr("id").length)
  price = $(event.target).data('price')
  name = $(event.target).data('name')
  set_item_quantity_in_cart(id, name, price, qntty)

# set the quantity of item in cart; if not present addes item to cart
# if reduced to 0, removes item from cart
set_item_quantity_in_cart = (id, name, price, qntty) =>
  quantity_txt = $('body .jumbotron .container #quantity-text_'+id)
  cart = $('body nav .navbar .cart');
  orders = JSON.parse($('#order-total').attr('data-order'));
  id_array = orders.cart_items['id']
  index = id_array.indexOf(id+"")
  prev_qntty = 0
  if ( index > -1)
    prev_qntty = orders.cart_items['qntty'][index]
    if (qntty == 0)
      orders.cart_items['id'].splice(index,1)
      orders.cart_items['qntty'].splice(index,1)
      quantity_txt.text(qntty+"")
      cart.find('#qty #' + id).remove()
      cart.find('#item #' + id).remove()
      cart.find('#price #' + id).remove()
      cart.find('#add #' + id).remove()
      cart.find('#remove #' + id).remove()
      if($('.cart-container').attr('toggle') == 'up')
        $('.cart-container').animate({height: '-=35px'}, 800, 'easeInOutExpo');
    else
      orders.cart_items['qntty'][index] = (qntty)
      quantity_txt.text(qntty + 1)
      cart.find('#qty #' + id).text(qntty)
      cart.find('#price #' + id).text('$'+ (price * (qntty)).toFixed(2))
  else
    cart = $('body nav .navbar .cart');
    orders = JSON.parse($('#order-total').attr('data-order'));
    cart_item = $('<li><\/li>')
    cart_item.text(name)
    cart_qty =  $('<li><\/li>')
    cart_qty.text(qntty+"")
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
    id_array = orders.cart_items['id'].concat(id+"")
    orders.cart_items['id'] = id_array
    ct_array = orders.cart_items['qntty']
    orders.cart_items['qntty'] = ct_array.concat(qntty+"")
    quantity_txt.text(1)
    if($('.cart-container').attr('toggle') == 'up')
      $('.cart-container').animate({height: '+=35px'}, 800, 'easeInOutExpo');
  update_price_total(price * (qntty - prev_qntty))
  $('#order-total').attr('data-order',JSON.stringify(orders))

# update the cart cost total
update_price_total = (price) =>
  current_total = strip_dollar($("#order-total").html())
  current_float = parseFloat(current_total)
  new_total = price + current_float
  $("#order-total").html( "$" + new_total.toFixed(2) )

# in main display item add-remove-control; can decrease or increase item by 1
$('body .jumbotron .container #items .add-remove-control').on 'click',  'img', (event) ->
  choice = $(this).parent().attr("id")
  id = $(this).attr("id")
  price = $(event.target).data('price')
  name = $(event.target).data('name')
  orders = JSON.parse($('#order-total').attr('data-order'));
  id_array = orders.cart_items['id']
  index = id_array.indexOf(id+"")
  if (choice == 'item-add')
    add_item(id, name, price)
  else
    if (index > -1)
      remove_item(id, price)
  return

# in-cart item count add-remove-control; can decrease or increase item by 1
$('#cart-contents').on 'click', 'img', (event) ->
  choice = $(this).parent().attr("class")
  id = $(this).parent().attr("id")
  price = $(this).parent().data('price')
  name = $(this).parent().data('name')
  orders = JSON.parse($('#order-total').attr('data-order'));
  id_array = orders.cart_items['id']
  index = id_array.indexOf(id+"")
  if (choice == 'add')
    add_item(id, name, price)
  else
    if (index > -1)
      remove_item(id, price)
  return

# toggle ui between text and image
$('span.navbar > #ui_toggle').click ->
  elements = $('span.item')
  for e in elements
    elms = $(e).children()
    for c in elms
      element = $(c)
      if (element.hasClass('shown'))
        element.removeClass('shown')
        element.addClass('hidden')
      else
        element.removeClass('hidden')
        element.addClass('shown')

# reload the page; removes pending purchases
$('#reset').click ->
  window.location.href = "/";

# submit purchase
$('#purchase').click ->
  $.ajax
    type: 'post'
    url: '/orders/purchase',
    data: JSON.stringify(get_orders())
    contentType: 'application/json; charset=utf-8'
    traditional: true
    success: (data) ->
      return

# show/hide cart contents
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

# search button click eventListener
$('.search button').click ->
  item_search()

item_search = () =>
  pattern = $('#snack-search').val()
  items = $('#items>div')
  for child in items
    metadata = child.dataset.meta
    if metadata.includes(pattern)
      $(child).removeClass("hidden")
      $(child).addClass("shown")
    else
      $(child).removeClass("shown")
      $(child).addClass("hidden")

$(document).on "keydown", "#snack-search", (event) ->
  console.log(event.which)
  if event.which == 13
    item_search()
    event.preventDefault()
