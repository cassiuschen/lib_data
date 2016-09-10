class SurveysController < ApplicationController
  before_action :set_university
  def index
  end

  def new
    @survey = @university.surveys.new
  end

  def create
    @result = {
      q1: params[:q1] || 0,
      q2: params[:q2] || 0,
      q3: params[:q3] || 0,
      q4: params[:q4] || 0,
      q5: [],
      q6: params[:q6] || 0,
      q7: params[:q7] || 0,
      q8: params[:q8] || 0
    }
    (1..8).each {|i| @result[:q5] << i if params["q5_#{i}".to_sym] }
    @survey = @university.surveys.create(answer: @result)
    redirect_to university_survey_path(@university, @survey)
  end

  def show
    @survey = Survey.find(params[:id])
  end

  private
  def set_university
  	@university = University.find_by_code(params[:university_id])
  end
end
