--- Tintinabulli Melody
--
--
-- output 1: Volts for M-Notes
-- output 2: Volts for T-Notes
-- output 3: Gate for M-Notes & T-Notes
-- output 4:
s = sequins

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

function degree_to_volts(degree, scale, oct)
	local scale_size = #scale
	local volt_degree = scale[(degree % scale_size) + 1]/12
	local volt_oct = oct + math.floor(degree/scale_size)
	return volt_degree + volt_oct
end

--- Global parameters
-- MELODY is a sequins defined in terms of degrees of a scale
-- RHYTHM is a sequins defined in terms of numbers of beats
-- CHORD is the Tintinabulli chord defined in pitch class (0 through 11 in tradtional 12-ET)
-- SCALE is the scale over which the melody and chord are defined


SCALE = {0, 2, 3, 5, 7, 8, 10} -- minor scale

MELODY = s{
	1, 5, 3, 
	2, 6, 4, 
	1
}

RHYTHM = s{
	1.25, 1/4, 1/4, 
	1/4, 1, 1/4, 
	1/2, 1/4
}

CHORD = {
	0, 3, 7
}

TINT_FUNCTION = s{tint_down, tint_up}

function init()
	clock_c = clock.run(function ()
		while true do
			output[4](pulse(0.1, 5))
			clock.sync(1/8)
		end
	end)
end

function play_melody(tempo)
	clock.tempo = tempo
	melody_c = clock.run(function ()
		while true do
			local cur_note_deg = MELODY()
			local cur_beat = RHYTHM()
			if cur_beat == 1.25 then
				tint_func = TINT_FUNCTION()
			end
			local m_volt = degree_to_volts(cur_note_deg, SCALE, 3)
			local t_volt = tint_func(m_volt, CHORD)
			
			local beat_sec = clock.get_beat_sec()
			local rand_gate = math.random() *0.2 + 0.1
			output[1].volts = m_volt
			output[2].volts = t_volt
			if cur_beat == 1.25 then
				output[3](pulse(beat_sec * cur_beat * 0.8, 5))
			else
				output[3](pulse(beat_sec * cur_beat * rand_gate, 5))
			end
			clock.sync(cur_beat)
		end
	end)
end

