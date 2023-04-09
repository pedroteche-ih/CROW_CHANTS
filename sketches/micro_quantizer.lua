-- Microtonal quantizer
-- Input 1: V/Oct
-- Input 2: Gate

-- Output 1: V/oct
-- Output 2: Gate

--INTENSE DIATONIC
--SCALE = {1/1, 20/19, 20/17, 4/3, 3/2, 30/19, 30/17}
--PROMETHEAN
SCALE = {1/1, 9/8, 5/4, 7/5, 5/3, 7/4}
-- Hexany 1-3-5-7 I
-- SCALE = {1/1, 7/6, 5/4, 35/24, 5/3, 7/4}
-- MOS Viggo Brun C:0.4421 B:0.5198 A:1
-- SCALE = {0, 2.39999968, 5.56251848, 6.43747687, 8.83747602}

s = sequins
OUT_DRONE = sequins{1, 0, 0, 0, 0, 
					0, 0, 0, 0, 0, 
					0, 0, 0}
function init()
    input[2].mode('change', 0.5, 0.1, 'rising')
    output[1].scale(SCALE, 'ji')
	output[3].scale(SCALE, 'ji')
	--output[1].scale(SCALE)
end

input[2].change = function(state)
	delay(delay_grab, 0.01)
end

function delay_grab()
	-- Delays grabbing the 1v/Oct
	local m_volts = input[1].volts
	local cur_out = OUT_DRONE()
	output[1].volts = m_volts+2
	output[2](pulse(0.01, 5))
	
	if cur_out == 1 then
		print('Change')
		output[3].volts = m_volts
		output[4](pulse(0.5, 5))
	end
end

function tune()
	output[1].volts = 3
	output[2].volts = 5
	output[3].volts = 3
	output[4].volts = 5
end