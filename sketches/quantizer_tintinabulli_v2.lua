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
	local degree = (volts - octave)
    local tint_volts = 0
	local min_dist = 5000
	local distance = 0
    local chord_volts = 0

	for i, chord_degree in ipairs(chord) do
        chord_volts = chord_degree - 1
		if degree - chord_volts > 0 then distance = degree-chord_volts
		else distance = degree - (chord_volts - 1) end

		if distance < min_dist then
			min_dist = distance
			tint_volts = (degree - distance) + octave
		end
	end
    print(octave, degree, tint_volts - octave)
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
	output[1].volts = m_volts +2
    output[2](pulse(0.01, 5))
end

function delay_tint()
    -- Delays playing tintinabulli note
    local m_volts = output[1].volts
    t_volts = tint_down(m_volts, CHORD)
    output[3].volts = t_volts
	output[4](pulse(0.01, 5))
end

--- Global parameters
-- CHORD is the Tintinabulli chord defined in pitch class (0 through 11 in tradtional 12-ET)
SCALE = {1/1, 16/15, 77/64, 4/3, 64/45, 8/5, 16/9}
CHORD = {1/1, 77/64, 64/45}
OCT_SEQ = s{-1, 0, 1}

function init()
--	input[1].mode('scale', SCALE, 'ji')
	input[2].mode('change', 1, 0.3, 'rising')
    output[1].scale(SCALE, 'ji')
    output[3].scale(CHORD, 'ji')
end

--input[1].scale = function(state)
--    delay(delay_grab, 0.01)
--end

input[2].change = function(state)
    delay(delay_grab, 0.01)
	delay(delay_tint, 0.01)
end

function tune()
    output[1].volts = 5
    output[2].volts = 5
    output[3].volts = 5
    output[4].volts = 5
end