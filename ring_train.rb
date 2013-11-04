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

	def print
		p @light
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
					@start = Car.new
					inner(size-1, @start)
				else
					new_car = Car.new(train, nil, [true,false].sample)
					train.next = new_car
					inner(size-1, new_car)
				end
			else
				raise Exception.new('Can\'t build train from zero cars') unless train
				train.next = @start
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
		i = 0
		car = @start

		case direction
		when :left then
			while i <= destination
				car.turn_off if i==destination # идя влево, выключаем свет
				car = car.prev
				i += 1
			end
		when :right then
			while i <= destination
				return i if i==(destination-1) and destination!=0 and (not car.light) # ага, в этом вагоне свет выключили мы, когда шли в обратном направлении
				car.turn_on if i==destination # идя вправо, включаем свет
				car = car.next
				i += 1
			end
		else raise Exception.new('Expecting a :right or :left direction')
		end
	end

	def lenght
		@result = nil
		count = 1
		dirs = [:right, :left]
		dir = dirs.cycle

		while @result.nil?
			2.times do
				@result = self.visit(dir.next, count)
			end
			count += 1
		end
		p @result
	end
end

a = Train.new(5)
a.lenght

# dirs = [:right, :left]
# 		dir = dirs.cycle
#  2.times do
# 	@result = a.visit(dir.next, 3)
# end
# p @result
# a.each {|car| p car.light}
# a.visit(:right, 3)
# p ''
# a.each {|car| p car.light}