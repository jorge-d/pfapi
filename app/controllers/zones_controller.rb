class ZonesController < ApplicationController
  def new
    @zone = Zone.new
  end
end
