function AnIndexOf(t,val)
    for k,v in ipairs(t) do 
        if v == val then return k end
    end
end

--scale = {0, 2.769, 5.538, 7.384, 10.154}
--scale = {0, 2.669, 3.863, 6.532, 8.189, 9.688, 10.494}
--chord = sequins{0, 3.863, 9.688}
scale = {0, 1.935, 3.09677, 5.03226, 6.96774, 8.12903, 10.06452}
chord = {0,3.09677,6.96774}
melody = sequins{7, 7, 5, 6, 4, 4, 2, 1, 3, 1}
melody_size = 10
i = 0
function init()
	input[2].mode('change', 1, 0.3, 'rising')
	output[2].action = pulse(0.05, 5)
	output[4].volts = 4
end

input[2].change = function(state)
	current_iter = math.floor(i/melody_size)
	if current_iter % 2 == 0 then
		note = scale[melody()]
	else
		note = scale[melody() * -1 + 8]
	end

	if current_iter % 3 == 0 then
		melody:step(1)
	else
		melody:step(-1)
	end

	note_volts = note/12 + 3
	tint_volts = tint_down(note/12 + 3, chord)
	output[1].volts = note_volts
	output[3].volts = tint_volts
	output[2]()
	i = i + 1
	print(math.floor(i/melody_size) % 2, note_volts, tint_volts)
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