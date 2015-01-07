class TracksController < ApplicationController
  before_filter :current_user?
  before_action :set_track, only: [:edit, :update, :destroy]

  def index
    @users = User.all
    @tracks = Track.all
    render :layout => 'application'
  end

  def show
    #@coordinates = Track.find_all_by_user_id(params[:driver_id])
    @coordinates = Track.where(:user_id => params[:driver_id])
  end

  def last
    @last_coord = Track.where(:user_id => params[:driver_id]).last
    logger.debug "@last_coord.id = #{@last_coord.id}"
  end

  def all_last_point
    @user = User.all
    @coordinates = []
    @user.each do |user|
      last_coord = Track.where(:user_id => user.id).last
      if last_coord
        @coordinates << last_coord
      end
    end
    logger.debug "@coordinates.size = #{@coordinates.size}"
  end

  # POST /tracks
  # POST /tracks.json
  def show2
    driver_id = params[:driver_id]
    dt1 = params[:dt1]
    dt2 = params[:dt2]
    @coordinates = Track.where("(user_id = ?) AND (created_at BETWEEN ? AND ?)", driver_id, dt1, dt2)
  end

  # PATCH/PUT /tracks/1
  # PATCH/PUT /tracks/1.json
  def update
    respond_to do |format|
      if @track.update(track_params)
        format.html { redirect_to @track, notice: 'Track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    @track.destroy
    respond_to do |format|
      format.html { redirect_to tracks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_track
      @track = Track.find_by_user_id(params[:driver_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def track_params
      params[:track]
    end
end
