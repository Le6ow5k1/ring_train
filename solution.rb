require_relative "ring_train"

def lenght(train)
	@breakpoint = nil
	count = 1
	dirs = [:left, :right]
	dir = dirs.cycle

	# Ходим, то в одну, то в другую сторону на определенное количество шагов.
	# Идя влево свет выключаем, идя вправо свет включаем. Ходим пока не найдем брейкпоинт.
	while @breakpoint.nil?
		2.times do
			@breakpoint = visit(train, dir.next, count)
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

def visit(train, direction, destination)
	i = 1
	car = train.start
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


train1 = Train.new(10)
train2 = Train.new(7)
train3 = Train.new(1)

p lenght(train1)
p lenght(train2)
p lenght(train3)