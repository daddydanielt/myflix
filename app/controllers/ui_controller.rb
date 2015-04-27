class UiController < ApplicationController
  before_filter :only => [:index] do
    redirect_to :root if Rails.env.production?
  end
  layout "application"
end
