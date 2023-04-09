-- Microtonal AM Quantizer
-- A simple quantizer with a twist: while outputs 1 & 2
-- are the quantized version of inputs 1 & 2 (CV & Gate),
-- outputs 3 & 4 
--INTENSE DIATONIC
SCALE = {1/1, 20/19, 20/17, 4/3, 3/2, 30/19, 30/17}
SCALE_SIZE = 6
DIFF_DEG = 2
s = sequins
OUT_DRONE = s{1, 0, 0, 0, 0, 
			  0, 0, 0, 0, 0, 
			  0, 0, 0}
degrees = s{1}

function init()
    input[1].mode('scale', SCALE, 'ji')
    input[2].mode('change', 0.5, 0.1, 'rising')
    degrees:settable(SCALE)
end

input[2].change = function(state)
	delay(delay_grab, 0.01)
end

input[1].scale = function(state)
    cur_note = state['index']
end

function delay_grab()
	-- Delays grabbing the 1v/Oct
	local m_volts = input[1].volts
	local cur_out = OUT_DRONE()
	output[1].volts = m_volts
	output[2](pulse(0.01, 5))
	if cur_out == 1 then
        if cur_note > (SCALE_SIZE - DIFF_DEG) then
            cur_deg = cur_note + DIFF_DEG - SCALE_SIZE
            prop = SCALE[cur_deg]
            beta = math.log(1 - 1/(cur_deg*2))/math.log(2)
        else
            cur_deg = cur_note + DIFF_DEG
            prop = SCALE[cur_deg]
            beta = math.log(1 - 1/(cur_deg*2))/math.log(2)
        end
		output[3].volts = m_volts + beta - 1
		output[4](pulse(0.5, 5))
	end
end

function tune()
	output[1].volts = 3
	output[2].volts = 5
	output[3].volts = 3
	output[4].volts = 5
end