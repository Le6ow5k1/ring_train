require 'pp'
require 'debugger'

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

	def visit(direction, destination)
		i = 1
		car = @start
		return 0 if car.next == car # поезд из одного вагона

		case direction
		when :left then
			car = car.prev
			while i <= destination
				return i if i==(destination-1) and car.light # ага, в этом вагоне свет включили мы, когда шли в обратном направлении
				car.turn_off if i==destination # идя влево, выключаем свет
				car = car.prev
				i += 1
			end
		when :right then
			car = car.next
			while i <= destination
				return i if i==(destination-1) and !car.light # ага, в этом вагоне свет выключили мы, когда шли в обратном направлении
				car.turn_on if i==destination # идя вправо, включаем свет
				car = car.next
				i += 1
			end
		else raise Exception.new('Expecting a :right or :left direction')
		end
	end

	def lenght
		@breakpoint = nil
		count = 1
		dirs = [:left, :right]
		dir = dirs.cycle

		# Ходим, то в одну, то в другую сторону на определенное количество шагов.
		# Идя влево свет выключаем, идя вправо свет включаем. Ходим пока не найдем брейкпоинт.
		while @breakpoint.nil?
			2.times do
				@breakpoint = self.visit(dir.next, count)
				break if @breakpoint
			end
			count += 1
		end

		# Если мы остановились, идя в противоположном направлении от начального,
		# то тогда кол-во вагонов равно - кол-ву пройденных до брейкпойнта вагонов * 2 + 1.
		# Иначе кол-ву пройденных до брейкпойнта вагонов * 2.
		case dir.peek
		when :left then @breakpoint * 2 + 1
		when :right then
			if @breakpoint==0 then 1
			else
				@breakpoint * 2
			end
		end
	end
end

a = Train.new(1)
p a.lenght