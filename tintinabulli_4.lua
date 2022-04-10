function AnIndexOf(t,val)
    for k,v in ipairs(t) do 
        if v == val then return k end
    end
end

--scale = {0, 2.769, 5.538, 7.384, 10.154}
--scale = {0, 2.669, 3.863, 6.532, 8.189, 9.688, 10.494}

--scale = {0, 2.669, 3.863, 6.532, 8.189, 9.688, 10.494}
--chord = sequins{0, 3.863, 9.688}
--chord = {2.669, 6.532, 9.688}
--p1 = sequins{4, 3, 4, 2, 3, 1, 2, 2, 2}
--p2 = sequins{4, 4, 5, 4, 3, 2, 1, 3, 4, 3, 2}
--p3 = sequins{-1, 1, 2, 2, 1, 3, 4, 3, 2, 2}
--melody = sequins{4, 3, 4, 2, 3, 1, 2, 2, 2,
--				 4, 4, 5, 4, 3, 2, 1, 3, 4, 3, 2,
--				 -1, 1, 2, 2, 1, 3, 4, 3, 2, 2}

--scale = {0, 1.935, 3.09677, 5.03226, 6.96774, 8.12903, 10.06452}
--chord = {0,3.09677,6.96774}
-- scale = {0, 2, 4, 5, 7, 9, 11}
scale = {0, 2, 3, 5, 7, 8, 10}

-- melody = sequins{7, 7, 5, 6, 4, 4, 2, 1, 3, 0}
melody = sequins{2, 0, 1, 0, -1, 0, 
				 2, 2, 1, 0, -1, 1, 1, 0,
				 4, 4, 3, 2, 0, 1, -1, 2, 1, 1, 0
				}
chord_table = sequins{{0,3,7}, {0, 3, 8}, {0,3,7}}

melody_size = 14
max_melody = 7

scale_size = #scale 
i = 0
function init()
	input[2].mode('change', 1, 0.3, 'rising')
	output[2].action = pulse(0.1, 5)
	output[4].volts = 4
end

input[2].change = function(state)
	local current_iter = math.floor(i / melody_size)
	local oct_start = 3
	if current_iter % 2 == 1 then
		melody:step(-1)
	else
		melody:step(1)
	end

	if current_iter % 8 < 4 then
		note = melody()
	else
		note = melody() * -1 + melody_size + 1
	end

	if i % melody_size == 0 then
		if current_iter % 2 == 0 then
			chord = chord_table()
			print(chord[1], chord[2], chord[3])
		end
	end

	local note_volts = degree_to_volts(note, scale, oct_start)

	if current_iter % 9 <3 then
		print('1')
		local tint_volts = tint_down(note_volts, chord)
	elseif current_iter % 9 < 6 then
		print('2')
		if i % 2 == 0 then
			local tint_volts = tint_down(note_volts, chord)
		else
			local tint_volts = tint_up(note_volts, chord)	
		end
	else
		print('3')
		local tint_volts = tint_up(note_volts, chord)
	end
	output[1].volts = note_volts
	output[3].volts = tint_volts
	output[2]()
	i = i + 1
end

function tint_down(volts, chord)
	local octave = math.floor(volts)
	local degree = (volts - octave) * 12
	local min_dist = 5000
	local distance = 0
	for i, chord_degree in ipairs(chord) do
		if degree - chord_degree > 0 then distance = degree-chord_degree
		else distance = degree - (chord_degree - 12) end

		if distance < min_dist then
			min_dist = distance
			tint_volts = (degree - distance)/12 + octave
		end
	end
	return tint_volts
end

function tint_up(volts, chord)
	local octave = math.floor(volts)
	local degree = (volts - octave) * 12
	local min_dist = 5000
	local distance = 0
	for i, chord_degree in ipairs(chord) do
		if chord_degree - degree > 0 then distance = chord_degree - degree
		else distance = (chord_degree + 12) - degree end

		if distance < min_dist then
			min_dist = distance
			tint_volts = (degree + distance)/12 + octave
		end
	end
	return tint_volts
end

function byte2bin(n)
	local t = {}
	local var_deg = 0
	
	for i=7,0,-1 do
		t[#t+1] = math.floor(n / 2^i)
		n = n % 2^i
	end
	t_num = tostring(tonumber(table.concat(t)))
	for i = 1, #t_num do
		local c = t_num:sub(i,i)
		if c == '1' then var_deg = var_deg + 1
		else var_deg = var_deg * -1 end
	end

	return var_deg
end

function infinite_series(n)
	local degree = {}
	for i=0,n-1,1 do
		degree[#degree + 1] = byte2bin(i)
	end
	return degree
end

function degree_to_volts(degree, scale, oct)
	local scale_size = #scale
	local volt_degree = scale[(degree % scale_size) + 1]/12
	local volt_oct = oct + math.floor(degree/scale_size)
	return volt_degree + volt_oct
end