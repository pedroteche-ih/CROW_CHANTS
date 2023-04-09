function AnIndexOf(t,val)
    for k,v in ipairs(t) do 
        if v == val then return k end
    end
end

--scale = {0, 2.769, 5.538, 7.384, 10.154}
--scale = {0, 2.669, 3.863, 6.532, 8.189, 9.688, 10.494}
--chord = sequins{0, 3.863, 9.688}
scale = {0, 1.935, 3.09677, 5.03226, 6.96774, 8.12903, 10.06452}
chord = {0,3.09677,6.96774}

function init()
	input[2].mode('change', 1, 0.3, 'rising')
	output[1].scale(scale)
	output[2].action = pulse(0.05, 5)
	output[3].scale(chord)
	output[4].volts = 4
end

input[2].change = function(state)
	output[1].volts = input[1].volts*1.5
	output[3].volts = output[1].volts-1
	output[2]()
	print(output[1].volts, output[3].volts)
end