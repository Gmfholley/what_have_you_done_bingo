class TemplatesController < ApplicationController
  skip_before_filter :require_login, only: [:show]
  before_action :set_organization
  before_action :set_template, only: [:show, :edit, :update, :destroy]
  before_action :handle_if_not_authorized, only: [:new, :create, :edit, :update, :destroy]

  # GET /templates/1
  # GET /templates/1.json
  def show
    if is_admin?
      render :show_admin
    elsif belongs_to_organization? || @template.is_public?
      render :show
    else
      redirect_to :root, notice: "Sorry.  That is a private template."
    end
  end
  
  # GET play/:token
  def share
    @template = Template.find_by(token: params[:token])
    if @template.is_public?
      render :show
    else
      redirect_to :root, notice: "Sorry.  That is a private template."
    end
  end

  # GET /templates/new
  def new
    @template = Organization.templates.build
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = Organization.templates.create(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to @template, notice: 'Cool card created!' }
        format.json { render :show, status: :created, location: @template }
      else
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
        format.html { redirect_to @template, notice: 'Successfully updated.' }
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
      @organization = Template.find(params[:organization_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      params.require(:template).permit(:size, :name, :rating, :is_public)
    end
end
