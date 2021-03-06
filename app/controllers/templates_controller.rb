class TemplatesController < ApplicationController
  include TemplatesHelper
  skip_before_filter :require_login, only: [:show, :share]
  before_action :set_organization, except: [:share, :index]
  before_action :set_template, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]

  # GET organizations/1/templates/1
  # GET organizations/1/templates/1.json
  def show
    @shareable_link = shareable_link(@template)
    if logged_in? && is_admin?
      render :show_admin
    elsif @template.is_public || (logged_in? && is_member?)
      render :show
    else
      redirect_to :root, notice: "Sorry.  That is a private template."
    end
  end
  
  # GET organizations/1/templates/new
  def new
    @template = @organization.templates.build
    CreateSquares.work(@template)
    @ratings = Template.ratings
  end
  
  # enum Ratings collection not available in view
  # GET organizations/n/templates/1/edit
  def edit
    @ratings = Template.ratings
  end

  # POST organiztions/n/templates
  # POST organizations/n/templates.json
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

  # GET /templates
  def index
    @public_templates = Template.where(is_public: true)
    @group_templates = []
    if current_user
      for org in current_user.organizations 
        @group_templates.push(*org.templates)
      end
    end
  end

  # PATCH/PUT organizations/1/templates/1
  # PATCH/PUT organizations/1/templates/1.json
  def update
    #TODO - refactor this prettier
    respond_to do |format|
      @template.update(template_only_params)
      @errors = []
      if !squares_only_params.blank?
        squares_only_params.each_with_index do |square, x|
          @square = Square.find_by(position_x: square[1]["position_x"], position_y: square[1]["position_y"], template_id: @template.id)
          unless @square.update(question: square[1]["question"], free_space: square[1]["free_space"])
            @errors << @square.errors
          end
        end
      end
      if @template.errors.blank? && @errors.length == 0
        format.html { redirect_to organization_template_path(@organization, @template), notice: 'Successfully updated.' }
        format.json { render :show, status: :ok, location: @template }
      else
        @ratings = Template.ratings
        format.html { render :edit }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE organizations/1/templates/1
  # DELETE organizations/1/templates/1.json
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
      @template = Template.includes(:squares, :cards, :organization).where(id: params[:id]).first
      # @template.squares.sort! {|a, b| [a.position_x, a.position_y] <=> [b.position_x, b.position_y]}
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:organization_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      params.require(:template).permit(:size, :name, :is_public, :rating, :squares_attributes => [:question, :position_x, :position_y, :picture, :free_space])
    end
    
    def template_only_params
      params.require(:template).permit(:size, :name, :is_public, :rating)
    end
    
    def squares_only_params
      template_params["squares_attributes"]
    end
end
