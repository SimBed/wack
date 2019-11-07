class RelationshipPsController < ApplicationController
  before_action :set_rel, only: [:edit, :update, :destroy]
  ##  before_action :admin_user,     only: [:new, :edit, :update, :destroy]

  def index
    @problems = current_user.problems
  end

  def new
    @relationship_ps = RelationshipP.new
  end

  def edit
  end

  # POST /problems
  # POST /problems.json
  def create
    if params[:commit] == 'Follow'
         @problem = Problem.find(params[:problem_id])
    current_user.probfollow(@problem)
    flash[:success] = "Problem followed!"
            redirect_to problems_path
    else
   @relationship_ps = RelationshipP.new(rel_params)
       if @relationship_ps.save
        redirect_to relationship_ps_path
        flash[:success] = "New problem followed! Edit from My Problems."
       else
       render :new 
       end
    end
 

  
  end
  
  def update
      if @relationship_ps.update(rel_params)
        redirect_to relationship_ps_path
        flash[:success] = "Problem updated"
      else
        render :edit
      end
  end
  
  def destroy
    #@user = Relationship.find(params[:id]).followed
    #current_user.unfollow(@user)
    
    @relationship_ps.destroy
    flash[:success] = "Problem no longer followed"
    redirect_to relationship_ps_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rel
      @relationship_ps = RelationshipP.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rel_params
      #params.require(:relationship_p).permit(:suggestedgrade, :highpoint, :dohp, :firsttry, :rating)
       params.require(:relationship_p).permit(:user_id, :problem_id, :suggestedgrade, :highpoint, :dohp, :firsttry, :rating)
    end
    
end