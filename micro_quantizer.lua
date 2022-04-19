-- Microtonal quantizer
-- Input 1: V/Oct
-- Input 2: Gate

-- Output 1: V/oct
-- Output 2: Gate

--INTENSE DIATONIC
--SCALE = {1/1, 20/19, 20/17, 4/3, 3/2, 30/19, 30/17}
--PROMETHEAN
SCALE = {1/1, 9/8, 5/4, 7/5, 5/3, 7/4}
function init()
    input[2].mode('change', 1, 0.3, 'rising')
    output[1].scale(SCALE, 'ji')
end

input[2].change = function(state)
	delay(delay_grab, 0.01)
end

function delay_grab()
	-- Delays grabbing the 1v/Oct
	local m_volts = input[1].volts
	output[1].volts = m_volts+1
	output[2](pulse(0.1, 5))
    output[3].volts = m_volts+1
	output[4](pulse(0.1, 5))
end