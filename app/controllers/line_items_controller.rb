class LineItemsController < ApplicationController
  include OrderHelper
  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    item = LineItem.find(params['id'])
    order = Order.find(item.order_id)
    item.destroy
    if (LineItem.where(order_id: order.id).blank?)
      order.destroy
    end
  	respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Item was successfully removed.' }
      format.json { head :no_content }
    end
  end

  def update
    puts(params.inspect)
    item = LineItem.find(params['id'])
    item.qntity = params['qntity']
    item.purchase_price = params['purchase_price']
    @order = Order.find item.order_id
    if item.save
      respond_to do |format|
        format.html { redirect_to "/orders/?id=#{@order.id}" , notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      end
    else
      respond_to do |format|
        format.html { redirect_to @order, notice: 'Update failed.' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
end
