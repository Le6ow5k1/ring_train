# Объекты этого класса представляют вагоны в кольцевом поезде
class Car
	attr_accessor :prev, :next, :light

	def initialize(prev=nil, next_=nil, light=false)
		@prev = prev
		@next = next_
		@light = light
	end

	def turn_on
		light = true
	end

	def turn_off
		light = false
	end

	def print
		p self.light
	end
end

class Train
	attr_reader :size, :start

	def initialize(size)
		@size = size
		build(@size)
	end

	def build(size)
		def inner(size, train)
			if size != 0
				if train.nil?
					@start = Car.new
					inner(size-1, @start)
				else
					new_car = Car.new(train, nil, [true,false].sample)
					train.next = new_car
					inner(size-1, new_car)
				end
			else
				raise Exeption.new('Can\'t build train from zero cars') unless train
				train.next = @start
			end
		end

		inner(size, nil)
	end

	def print
		def inner(car)
			if car != @start
				car.print
				inner(car.next)
			else
				car.print
			end
		end

		inner(@start.next)
	end
end

a = Train.new(10)

a.print