class Paper::CardsController < ApplicationController
  before_action :set_paper_card, only: %i[ show edit update destroy ]

  # GET /paper/cards or /paper/cards.json
  def index
    @paper_cards = Paper::Card.all
  end

  # GET /paper/cards/1 or /paper/cards/1.json
  def show
  end

  # GET /paper/cards/new
  def new
    @paper_card = Paper::Card.new
  end

  # GET /paper/cards/1/edit
  def edit
  end

  # POST /paper/cards or /paper/cards.json
  def create
    @paper_card = Paper::Card.new(paper_card_params)

    respond_to do |format|
      if @paper_card.save
        format.html { redirect_to paper_card_url(@paper_card), notice: "Card was successfully created." }
        format.json { render :show, status: :created, location: @paper_card }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @paper_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /paper/cards/1 or /paper/cards/1.json
  def update
    respond_to do |format|
      if @paper_card.update(paper_card_params)
        format.html { redirect_to paper_card_url(@paper_card), notice: "Card was successfully updated." }
        format.json { render :show, status: :ok, location: @paper_card }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @paper_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paper/cards/1 or /paper/cards/1.json
  def destroy
    @paper_card.destroy!

    respond_to do |format|
      format.html { redirect_to paper_cards_url, notice: "Card was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paper_card
      @paper_card = Paper::Card.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def paper_card_params
      params.require(:paper_card).permit(:image,
                                         :name, :title, :tel, :mobile, :email,
                                         :zip_code, :address, :qr)
    end
end
