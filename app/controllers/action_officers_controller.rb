class ActionOfficersController < ApplicationController
  before_action :authenticate_user!, PQUserFilter
  before_action :set_action_officer, only: [:show, :edit, :update, :destroy]
  before_action :prepare_dropdowns

  def index
    @action_officers = ActionOfficer.all.joins(:deputy_director => :division).order('lower(divisions.name)').order('lower(action_officers.name)')
  end

  def new
    @action_officer = ActionOfficer.new
  end

  def find
    @results = ActionOfficer.by_name(params[:q]).select(:id, :name)
    render json: @results
  end

  def create
    begin
    @action_officer = ActionOfficer.new(action_officer_params)
    if @action_officer.save
      flash[:success] = 'Action officer was successfully created.'
      redirect_to action_officers_path
      return
    end
    rescue => err
      @action_officer.errors[:base] << handle_db_error(err)
    end
    render action: 'new'
  end

  def update
    begin
    if @action_officer.update(action_officer_params)
      flash[:success] = 'Action officer was successfully updated.'
      redirect_to @action_officer 
      return
    end
    rescue => err
      @action_officer.errors[:base] << handle_db_error(err)
    end
    render action: 'edit'
  end

  private

  def set_action_officer
    @action_officer = ActionOfficer.find(params[:id])
  end

  def action_officer_params
    params.require(:action_officer).permit(:name, :email, :group_email, :phone, :deleted, :deputy_director_id, :press_desk_id)
  end

  def prepare_dropdowns
    @deputy_directors = DeputyDirector.active
    @press_desks = PressDesk.active
  end

  def handle_db_error(err)
    if err.message.include?('index_action_officers_on_email_and_deputy_director_id')
      "An action officer with this email address(#{@action_officer.email}) is already assigned to #{@action_officer.deputy_director.name}"
    else
      err
    end
  end
end
