class CardsController < ApplicationController
  skip_before_action :require_login, only: [:share]
  before_action :set_card, only: [:show, :edit, :update, :destroy]
  before_action :require_users_card, only: [:edit, :update, :destroy]
  before_action :require_admin_or_user, only: [:show]
  
  # play a card from a public template or user is member of private tmeplate
  # GET play/:token
  def new
    @template = Template.find_by(token: params[:token])
    @organization = @template.organization
    
    if @template.is_public || is_member?
      @card = @template.cards.build(user: current_user)
      CreateCircles.work(@card)
    else
      redirect_to :root, notice: "Sorry.  That is a private template."
    end
  end
  
  # POST play/:token  
  def create
    @template = Template.find_by(token: params[:token])
    @organization = @template.organization
    if @template.is_public || is_member?
      @card = Card.new(card_params)
      @card.user = current_user
      @card.template = @template
    else
       redirect_to :root, notice: "Sorry.  That is a private template."
       return
    end
    respond_to do |format|
      if @card.save
        CheckBingo.new(@card).work
        format.html { redirect_to @card, notice: 'Woot!  You have begun to play this bingo card.' }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # shows public card
  def share
    @card = Card.find_by(token: params[:token])
    render :show
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

  # GET /cards/1/edit
  def edit
  end
  
  #TODO - this is not returning the right value of rnumber of bingos
  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    respond_to do |format|
      #if you attempt to update circles here, you will duplicate
      @card.update(card_params)
      if @card.errors.blank?
        #this will update the card with the number of bingos
        CheckBingo.new(@card).work
        format.html { redirect_to @card, notice: 'Successfully updated.' }
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
      format.html { redirect_to cards_url, notice: 'You destroyed this card.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.includes(:circles, :template, :user).where(id: params["id"]).first
    end

    # it is safe to add 'id' to permitted nested params, as these are checked by active record
    # :id in nested params is needed as part of the update
    def card_params
      params.require(:card).permit(:is_public, circles_attributes: [:id, :position_x, :position_y, :question, :response])
    end
    
    def card_only_params
      params.require(:card).permit(:is_public)
    end

    def circles_only_params
      card_params["circles_attributes"]
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
    def require_admin_or_user
      unless admin_of_template? || users_card?
        redirect_to :back, :notice => "You do not have access to that page."
      end
    end
end
