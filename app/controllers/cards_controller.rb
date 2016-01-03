class CardsController < ApplicationController
  skip_before_action :require_login, only: [:share]
  before_action :set_card, only: [:show, :edit, :update, :destroy]
  
  # play a public card
  # GET play/:token
  def play
    @template = Template.find_by(token: params[:token])
    @organization = @template.organization
    
    if @template.is_public || is_member?
      @card = @template.cards.build
      @card.user = current_user
    else
      redirect_to :root, notice: "Sorry.  That is a private template."
    end
  end
  
  def share
    @card = Card.find_by(token: params[:token])
  end
  
  # GET /cards
  # GET /cards.json
  def index
    @cards = current_user.cards
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = Card.new(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect_to @card, notice: 'Card was successfully created.' }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url, notice: 'Card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:template_id, :user_id, :token, :is_public, :num_bingos)
    end

    # checks if current user owns this card
    #
    # returns boolean
    def users_card?
      @card.user == current_user
    end
    
    # checks if current user is admin of the template associated with this card
    #
    # returns boolean
    def admin_of_template?
      @organization = @card.template.organization
      current_user.role(@organization) == Role.admin
    end
    
    # checks if current user belongs to @organization and if not redirects them
    #
    # returns an boolean
    def require_users_card
      unless users_card?
        redirect_to :back, :notice => "You do not have access to that page."
      end
    end    
    
    # checks if current_user is an admin and if not redirects them
    #
    # returns an boolean
    def require_admin_of_card_template
      unless admin_of_template?
        redirect_to :back, :notice => "You do not have access to that page."
      end
    end
end
