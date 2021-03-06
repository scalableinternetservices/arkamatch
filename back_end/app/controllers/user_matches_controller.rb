class UserMatchesController < ApplicationController
  before_action :set_user_match, only: [:show, :edit, :update, :destroy]
  def execute_sql(sql)
    results = ActiveRecord::Base.connection.execute(sql)
    results.each do |res|
      puts res
    end
    return results
  end
  # GET /user_matches
  # GET /user_matches.json
  def index
    puts params
    if params['cached_matches']=="true"
      @user_matches = execute_sql("SELECT match, num_matches 
        FROM match_reports 
        WHERE username='#{current_user.username}' and match!='#{current_user.username}'
        ORDER BY  num_matches DESC").to_a
      else
        @user_matches=execute_sql("
          SELECT up1.name as name, up2.name as match, count(*) as num_matches
          FROM user_preferences up1
          JOIN user_preferences up2
          ON up1.name = '#{current_user.username}'
          AND up2.name != '#{current_user.username}'AND  up1.interest=up2.interest
          GROUP BY up1.name,up2.name
          ORDER BY num_matches DESC").to_a
    end

    if params['paginate']=="true"
    @paginable = Kaminari.paginate_array(@user_matches).page(params[:page]).per(2)
    end
  end

  # GET /user_matches/1
  # GET /user_matches/1.json
  def show
  end

  # GET /user_matches/new
  def new
    @user_match = UserMatch.new
  end

  # GET /user_matches/1/edit
  def edit
  end

  # POST /user_matches
  # POST /user_matches.json
  def create
    # @user_match = UserMatch.new(user_match_params)

    # respond_to do |format|
    #   if @user_match.save
    #     format.html { redirect_to @user_match, notice: 'User match was successfully created.' }
    #     format.json { render :show, status: :created, location: @user_match }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @user_match.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /user_matches/1
  # PATCH/PUT /user_matches/1.json
  def update
    # respond_to do |format|
    #   if @user_match.update(user_match_params)
    #     format.html { redirect_to @user_match, notice: 'User match was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @user_match }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @user_match.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /user_matches/1
  # DELETE /user_matches/1.json
  def destroy
    @user_match.destroy
    respond_to do |format|
      format.html { redirect_to user_matches_url, notice: 'User match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_match
      @user_match = UserMatch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_match_params
      params.require(:user_match).permit(:user, :match, :num_matches,:paginate,:cached_matches)
    end
end
