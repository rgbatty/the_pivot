class ReservationsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def create
    space = Space.find(params[:space_id], active: true)
    reservation = Reservation.new(space_id: space.id, start_date: params[:start_date], end_date: params[:end_date])
    if reservation.valid?
      @cart.add_reservation(space.id, space.price, params[:start_date], params[:end_date])
      session[:cart] = @cart.contents
      flash[:success] = "You have added a booking for #{space.name}."
      redirect_to space_path(space)
    else
      flash[:notice] = "That date range is invalid."
      redirect_to space_path(space)
    end
  end

  def show
    @reservations = @cart.reservations
  end

  def destroy
    space = Space.find_by(id: params[:id], active: true)
    @cart.remove_reservation(space.id)
    link = %Q[<a href="/spaces/#{space.slug}"> #{space.name}</a>]
    flash[:success] = "Successfully removed #{link} from your cart."
    redirect_to "/cart"
  end

  def update
    space = Space.find_by(id: params[:id], active: true)
    @cart.update_quantity(space.id, params[:direction])
    redirect_to "/cart"
  end
end
