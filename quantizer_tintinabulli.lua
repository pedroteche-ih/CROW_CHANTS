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

function degree_to_volts(degree, scale, oct)
	local scale_size = #scale
	local volt_degree = scale[(degree % scale_size) + 1]/12
	local volt_oct = oct + math.floor(degree/scale_size)
	return volt_degree + volt_oct
end

function delay_grab()
	-- Delays grabbing the 1v/Oct
	local m_volts = input[1].volts
	output[1].volts = m_volts
    output[2](pulse(0.1, 5))
end

function delay_tint()
    -- Delays playing tintinabulli note
    local m_volts = output[1].volts
    t_volts = tint_down(m_volts, CHORD)
    output[3].volts = t_volts - OCT_SEQ()
	output[4](pulse(0.1, 5))
end

--- Global parameters
-- CHORD is the Tintinabulli chord defined in pitch class (0 through 11 in tradtional 12-ET)
SCALE = {0, 2, 3, 5, 7, 8, 10}
CHORD = {0, 3, 7}
OCT_SEQ = s{-1, 0, 1}

function init()
	input[1].mode('scale', SCALE)
	input[2].mode('change', 1, 0.3, 'rising')
    output[1].scale(SCALE)
    output[3].scale(SCALE)
end

input[1].scale = function(state)
    delay(delay_grab, 0.01)
end

input[2].change = function(state)
	delay(delay_tint, 0.01)
end

function tune()
    output[1].volts = 3
    output[3].volts = 3
end