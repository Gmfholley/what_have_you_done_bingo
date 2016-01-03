class TemplatesController < ApplicationController
  skip_before_filter :require_login, only: [:show, :share]
  before_action :set_organization, except: [:share]
  before_action :set_template, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]

  # GET /templates/1
  # GET /templates/1.json
  def show
    if logged_in? && is_admin?
      render :show_admin
    elsif @template.is_public || (logged_in? && is_member?)
      render :show
    else
      redirect_to :root, notice: "Sorry.  That is a private template."
    end
  end
  
  # GET play/:token
  def share
    @template = Template.find_by(token: params[:token])
    @organization = @template.organization
    if @template.is_public
      render :show
    else
      redirect_to :root, notice: "Sorry.  That is a private template."
    end
  end

  # GET /templates/new
  def new
    @template = @organization.templates.build
    CreateSquares.work(@template)
    @ratings = Template.ratings
  end
  
  # enum Ratings collection not available in view
  # GET /templates/1/edit
  def edit
    @ratings = Template.ratings
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = @organization.templates.create(template_params)
    respond_to do |format|
      if @template.save
        format.html { redirect_to organization_template_path(@organization, @template), notice: 'Cool card created!' }
        format.json { render :show, status: :created, location: @template }
      else
        @ratings = Template.ratings
        format.html { render :new }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to organization_template_path(@organization, @template), notice: 'Successfully updated.' }
        format.json { render :show, status: :ok, location: @template }
      else
        format.html { render :edit }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template.destroy
    respond_to do |format|
      format.html { redirect_to organization_path(@organization.id), notice: 'The template was deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:organization_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      params.require(:template).permit(:size, :name, :is_public, :rating, :squares_attributes => [:question, :position_x, :position_y, :picture, :free_space])
    end
end
