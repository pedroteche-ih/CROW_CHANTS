--- Subharmonic VCO
s = sequins
SUB = s{5/4, 4/3, 3/2, 7/4, 2}
SUB = s{2, 3, 3/2, 4/3}
function init()
	input[2].mode('change', 1, 0.3, 'rising')
end

function subh()
	freq = 55 * math.exp(0.6931 * (input[1].volts + 2))
	output[1](oscillate(freq, 5, 'sin'))
	f1 = SUB()
	output[2](oscillate(freq/f1, 5, 'sin'))
	f2 = SUB()
	output[3](oscillate(freq/f2, 5, 'sin'))
	f3 = SUB()
	output[4](oscillate(freq/f3, 5, 'sin'))
end

input[2].change = function(state)
	delay(subh, 0.005)
end
