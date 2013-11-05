# Объекты этого класса представляют вагоны в кольцевом поезде
class Car
	attr_accessor :prev, :next
	attr_reader :light

	def initialize(prev=nil, next_=nil, light=false)
		@prev = prev
		@next = next_
		@light = light
	end

	def turn_on
		@light = true
	end

	def turn_off
		@light = false
	end
end

# Класс представляющий кольцевой поезд
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
					@start = Car.new # первый вагон в поезде
					inner(size-1, @start)
				else
					# цепляем новый вагон
					new_car = Car.new(train, nil, [true,false].sample)
					train.next = new_car
					inner(size-1, new_car)
				end
			else
				raise Exception.new('Can\'t build train from zero cars') unless train
				train.next = @start # замыкаем поезд в кольцо
				@start.prev = train
			end
		end

		inner(size, nil)
	end

	def each
		i = @size
		car = @start
		while i > 0
			yield car
			car = car.next
			i -= 1
		end
	end
end