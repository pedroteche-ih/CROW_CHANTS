-- Microtonal AM Quantizer
-- A simple quantizer with a twist: while outputs 1 & 2
-- are the quantized version of inputs 1 & 2 (1V/Oct & Gate),
-- outputs 3 & 4 output 1V/Oct & Gate calculated so that
-- using a VCO on this frequency as an amplitude modulator
-- for the first voice, the resulting AM signal will contain
-- sidebands @ DIFF_DEG relation to the original voice, i.e.:
-- current note is 20/17 & DIFF_DEG is 2, the AM signal will
-- contain sidebands 3/2 above the original frequency.
-- Hexany 3-4-5-9
SCALE = {1/1, 9/8, 5/4, 3/2, 5/3, 15/8}
SCALE_SIZE = 6
DIFF_DEG = 2
s = sequins
OUT_DRONE = s{1, 0, 0, 0, 0, 0, 0, 0}
degrees = s{1}

function init()
    input[1].mode('scale', SCALE, 'ji')
    input[2].mode('change', 0.5, 0.1, 'rising')
	output[1].scale(SCALE, 'ji')
	output[3].scale(SCALE, 'ji')
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
		output[3].volts = m_volts - 1
		output[4](pulse(0.5, 5))
	end
end

function tune()
	output[1].volts = 3
	output[2].volts = 5
	output[3].volts = 3
	output[4].volts = 5
end