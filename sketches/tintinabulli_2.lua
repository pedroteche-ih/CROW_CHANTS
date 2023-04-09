function AnIndexOf(t,val)
    for k,v in ipairs(t) do 
        if v == val then return k end
    end
end

--scale = {0, 2.769, 5.538, 7.384, 10.154}
--scale = {0, 2.669, 3.863, 6.532, 8.189, 9.688, 10.494}
--chord = sequins{0, 3.863, 9.688}
scale = {0, 0.629, 1.1173, 4.98044, 7.01955, 7.64915, 8.13686, 12}
chord = {0,4.98044, 7.64915}
melody = sequins{8, 7, 5, 6, 4, 4, 2, 1, 3, 1}
melody_size = 10
scale_size = #scale
i = 0
function init()
	input[2].mode('change', 1, 0.3, 'rising')
	output[2].action = pulse(0.05, 5)
	output[4].volts = 4
end

input[2].change = function(state)
	oct = 3
	current_iter = math.floor(i/melody_size)

	if current_iter % 3 == 0 then
		melody:step(1)
	else
		melody:step(-1)
	end

	if current_iter % 5 == 1 then
		print('Tintin up!')
		tint_func = tint_up
	else
		tint_func = tint_down
	end

	if current_iter % 2 == 0 then
		note = scale[melody()]
	--	print(note)
	else
		note = scale[melody() * -1 + scale_size + 1]
	--	print(note)
	end

	note_volts = note/12 + oct
	tint_volts = tint_func(note_volts, chord)
	output[1].volts = note_volts
	output[3].volts = tint_volts
	output[2]()
	i = i + 1
	print(current_iter, note_volts, tint_volts)
end

function tint_down(volts, chord)
	octave = math.floor(volts)
	degree = (volts - octave) * 12
	min_dist = 5000
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
	octave = math.floor(volts)
	degree = (volts - octave) * 12
	min_dist = 5000
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
	local num_zero = 0
	
	for i=7,0,-1 do
		t[#t+1] = math.floor(n / 2^i)
		n = n % 2^i
	end
	
	for i, num in ipairs(t) do
		if num == 0 then num_zero = num_zero + 1
		else var_deg = var_deg + 1 end
	end
	
	if num_zero % 2 == 0 then return var_deg
	else return var_deg*-1 end
end

function infinite_series(n)
	local degree = {}
	for i=0,n-1,1 do
		degree[#degree + 1] = byte2bin(i)
	end
	
	return degree
end