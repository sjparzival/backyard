class AnalyticsController < ApplicationController
  before_action :authenticate_user

  def index
    @analytics_results = {
      most_triggered: Analytics.most_triggered(current_user),
      average_rating: Analytics.average_rating(current_user),
      average_ice: Analytics.average_ice(current_user),
      average_fire: Analytics.average_fire(current_user)
    }
    json_response(@analytics_results)
  end
end