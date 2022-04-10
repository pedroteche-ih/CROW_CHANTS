--- Subharmonic VCO

function init()
	input[2].mode('change', 1, 0.3, 'rising')
end

function subh()
	freq = 55 * math.exp(0.6931 * input[1].volts)
	output[1](oscillate(freq, 5))
	output[2](oscillate(freq/2, 5))
	output[3](oscillate(freq/3, 5))
	output[4](oscillate(freq/4, 5))
end

input[2].change = function(state)
	delay(subh, 0.05)
end
