-- Microtonal quantizer
-- Input 1: V/Oct
-- Input 2: Gate

-- Output 1: V/oct
-- Output 2: Gate

-- INTENSE DIATONIC
-- SCALE = {1/1, 20/19, 20/17, 4/3, 3/2, 30/19, 30/17}
-- PROMETHEAN
SCALE = {1/1, 9/8, 5/4, 7/5, 5/3, 7/4}
-- Hexany 3-4-5-9
-- SCALE = {1/1, 10/9, 5/4, 4/3, 3/2, 5/3}
-- Hexany 1-3-5-7 
-- I
-- SCALE = {1/1, 7/6, 5/4, 35/24, 5/3, 7/4}
-- II
-- SCALE = {1/1, 21/20, 6/5, 7/5, 3/2, 7/4}
-- MOS Viggo Brun C:0.4421 B:0.5198 A:1
-- SCALE = {0, 2.39999968, 5.56251848, 6.43747687, 8.83747602}

SCALE_SIZE = 5
DIFF_DEG = 2
s = sequins
OUT_DRONE = s{1, 0, 0, 0, 0}
degrees = s{1}

function init()
    input[2].mode('change', 0.5, 0.1, 'rising')
    input[1].mode('scale', SCALE, 'ji')
    --output[1].scale(SCALE, 'ji')
    degrees:settable(SCALE)
end

input[2].change = function(state)
	delay(delay_grab, 0.01)
end

input[1].scale = function(state)
    cur_note = state['index']
    cur_volts = state['volts']
end

function delay_grab()
	-- Delays grabbing the 1v/Oct
	local m_volts = cur_volts
	local cur_out = OUT_DRONE()
	output[1].volts = m_volts
	output[2](pulse(0.01, 5))

end

function tune()
	output[1].volts = 3
	output[2].volts = 5
	output[3].volts = 3
	output[4].volts = 5
end