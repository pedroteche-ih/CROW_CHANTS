-- Microtonal quantizer
-- Input 1: V/Oct
-- Input 2: Gate

-- Output 1: V/oct
-- Output 2: Gate

-- Hexany 3-4-5-9
-- SCALE = {1/1, 10/9, 5/4, 4/3, 3/2, 5/3}
-- Hexany 1-3-5-7 
-- I
SCALE = {1/1, 7/6, 5/4, 35/24, 5/3, 7/4}
-- II
-- SCALE = {1/1, 21/20, 6/5, 7/5, 3/2, 7/4}
-- MOS Viggo Brun C:0.4421 B:0.5198 A:1
-- SCALE = {0, 2.39999968, 5.56251848, 6.43747687, 8.83747602}

CEIL = 3
FLOOR = 2

function init()
    input[1].mode('scale', SCALE, 'ji')
    input[2].mode('scale', SCALE, 'ji')
    output[1].scale(SCALE, 'ji')
    output[3].scale(SCALE, 'ji')
end

input[1].scale = function(state)
    local cur_note = state['index']
    local cur_volts = state['volts']
    output[1].volts = (math.sin(cur_volts/(math.pi * 3)) + FLOOR) * (CEIL/FLOOR)
    output[2](pulse())
end

input[2].scale = function(state)
    local cur_note = state['index']
    local cur_volts = state['volts']
    output[3].volts = (math.sin(cur_volts/(math.pi * 3)) + FLOOR) * (CEIL/FLOOR) - 2
    output[4](pulse())
end

function tune()
	output[1].volts = 3
	output[2].volts = 5
	output[3].volts = 3
	output[4].volts = 5
end