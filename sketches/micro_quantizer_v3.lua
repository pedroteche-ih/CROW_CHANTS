-- Microtonal quantizer
-- Input 1: V/Oct
-- Input 2: Gate

-- Output 1: V/oct
-- Output 2: Gate

--INTENSE DIATONIC
--SCALE = {1/1, 20/19, 20/17, 4/3, 3/2, 30/19, 30/17}
--PROMETHEAN
--SCALE = {1/1, 9/8, 5/4, 7/5, 5/3, 7/4}
-- Hexany 1-3-5-7 I
SCALE = {1/1, 7/6, 5/4, 35/24, 5/3, 7/4}

function init()
    input[1].mode('scale', SCALE, 'ji')
	input[2].mode('scale', SCALE, 'ji')
    output[1].scale(SCALE, 'ji')
	output[3].scale(SCALE, 'ji')
end

input[1].scale = function(state)
	delay(delay_grab_1, 0.01)
end

input[2].scale = function(state)
	delay(delay_grab_2, 0.01)
end

function delay_grab_1()
	-- Delays grabbing the 1v/Oct
	local m_volts = input[1].volts
	output[1].volts = m_volts
	output[2](pulse(0.01, 5))
end

function delay_grab_2()
	-- Delays grabbing the 1v/Oct
	local m_volts = input[2].volts
	output[3].volts = m_volts
	output[4](pulse(0.01, 5))
end

function tune()
	output[1].volts = 3
	output[2].volts = 5
	output[3].volts = 3
	output[4].volts = 5
end