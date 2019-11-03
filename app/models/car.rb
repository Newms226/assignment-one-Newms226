# require 'pry'

class Car < ApplicationRecord
  belongs_to :make
  has_and_belongs_to_many :parts

  validates :vin, presence: true, numericality: true, uniqueness: true
  validates :model, presence: true
  validates :make_id, presence: true
  # validates :part_ids, presence: true

  def Car.query(params={})
    r = Car.sort(Car.split_on_part(params), params)
    # binding.pry
    r
  end

  def Car.index(params={})
    query = Car.select('cars.*, makes.name').joins(:make).distinct
    r = Car.sort(query, params)
    # binding.pry
    r
  end

  private
    def Car.split_on_part(params={})
      # binding.pry
      if  params[:part] == '' || (not params[:part])
        # puts '\n\nFOUND NOOOOO PART\n\n'
        Car.no_part_query(params)
      else
        # puts '\n\nFOUND PART\n\n'
        Car.with_part_query(params)
      end
    end

    def Car.no_part_query(params={})
      Car.select('cars.*, makes.name')
          .joins(:make).distinct
          .where('makes.name like ?
                  AND cars.vin like ?
                  AND cars.model like ?',
                 "%#{params[:make]}%",
                 "%#{params[:vin]}%",
                 "%#{params[:model]}%")

    end

    def Car.with_part_query(params={})
      Car.select('cars.*, makes.name, parts.name')
          .joins(:make, :parts).distinct
          .where('parts.name like ?
                  AND makes.name like ?
                  AND cars.vin like ?
                  AND cars.model like ?',
                 "%#{params[:part]}%",
                 "%#{params[:make]}%",
                 "%#{params[:vin]}%",
                 "%#{params[:model]}%")

          # .order('makes.name').uniq
    end

    # BE VERY CAREFUL HERE! This method assumes that you have already
    # joined with makes and that makes.name is available!
    def Car.sort(query, params={})
      if params[:order] == 'vin'
        query.order(:vin).page params[:page]
      elsif params[:order] == 'model'
        query.order(:model, 'makes.name', :vin).page params[:page]
      else
        query.order('makes.name', :model, :vin).page params[:page]
      end
    end




  # def Car.query2(params)
  #   .joins("INNER JOIN makes ON makes.id = #{make.id} AND cars.make_id = #{make.id}")
  # end

    # model = params[:model] == '' ? nil : "%#{params[:model]}%"
    # # should prove to be equal statements, as nil != ''
    # make = params[:make] == '' ? nil : "%#{params[:make]}%"
    #
    # print "MAKE: #{make}"
    # print "MODEL: #{model}"
    #
    # # by_make = Car.find_by()
    #
    # cars = []
    # if make
    #
    #   Car.joins('INNER JOIN makes ON makes.id = 1 AND cars.make_id = 1').where('model = ?', 'Q5')
    # end
    # cars = []
    #
    # if params[:make] && params[:make] != ''
    #   make_id = Make.find_by_name(params[:make])
    #   print "FOUND MAKE ID #{make_id.id}\n"


    # car = []
    # if make_id and params[:model] && params[:model] != ''
    #   print 'route a'
    #   car.append Car.find_by_make_id_and_model(make_id.id, params[:model])
    # elsif params[:model] && params[:model] != ''
    #   print 'route b'
    #   car.append Car.find_by_model(params[:model])
    # else
    #   print 'no vars'
    #   car = Car.all
    # end

    # print "RETURNING CARS: #{car}"
    # car
    # ''
  # end
end
