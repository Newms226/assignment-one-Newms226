class CarsController < ApplicationController
  before_action :set_car, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  autocomplete :car, :model, full_search: true

  # GET /cars
  # GET /cars.json
  def index
    if params[:order] == 'vin' || params[:order] == 'model'
      @cars = Car.all.order(params[:order], :model).page params[:page]
    else
      @cars = Car.select('cars.*, makes.name').joins(:make).order('makes.name').page params[:page]
    end
    # @cars = Car.select('cars.*, ')
  end

  def parse_order_param
    return params[:order] if params[:order] == 'vin' || params[:order] == 'model'

  end

  # GET /cars/1
  # GET /cars/1.json
  def show
  end

  # GET /cars/new
  def new
    @car = Car.new
    @parts = Part.all
    @makes = Make.all
  end

  # GET /cars/1/edit
  def edit
    @parts = Part.all
    @makes = Make.all
  end

  # POST /cars
  # POST /cars.json
  def create
    @car = Car.new(car_params)
    @makes = Make.all
    @parts = Part.all

    respond_to do |format|
      if @car.save
        format.html { redirect_to @car, notice: 'Car was successfully created.' }
        format.json { render :show, status: :created, location: @car }
      else
        format.html { render :new }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cars/1
  # PATCH/PUT /cars/1.json
  def update
    @makes = Make.all
    @parts = Part.all
    respond_to do |format|
      if @car.update(car_params)
        format.html { redirect_to @car, notice: 'Car was successfully updated.' }
        format.json { render :show, status: :ok, location: @car }
      else
        format.html { render :edit }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.json
  def destroy
    @car.destroy
    respond_to do |format|
      format.html { redirect_to cars_url, notice: 'Car was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /cars/search
  def search
    cars = Car.query params
    @cars = Kaminari.paginate_array(cars).page params[:page]
    render :index
    # # TODO: Move to model? by seperation of MVC?
    # if params.key? :make && params[:make] != ""
    #   print "MAKE NOT EMPTY"
    #   make_id = Make.where("name like ?", "%#{params[:make]}%" )
    #   cars = []
    #   make_id.each do |id|
    #     cars.append(Cars.where("model_id = ?", id))
    #   end
    #   @cars = cars
    # end
    #
    # @cars.append(Car.where("model like ?", "%#{params[:model]}%"))
    #
    # render :index

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_params
      params.require(:car).permit(:make_id, :model, :vin, :part_ids => [])
    end
end
