function AnIndexOf(t,val)
    for k,v in ipairs(t) do 
        if v == val then return k end
    end
end

--scale = {0, 2.769, 5.538, 7.384, 10.154}
--scale = {0, 2.669, 3.863, 6.532, 8.189, 9.688, 10.494}
--chord = sequins{0, 3.863, 9.688}
scale = {0, 1, 5, 7, 8}
chord = sequins{0, 5, 8}
start_index_1 = 1
start_index_2 = 2
scale_len = 5
melody = {start_index_1, start_index_2}
oct = {3, 3}
i = 1
cur_note = 0

function init()
	input[1].mode('change', 1, 0.3, 'rising')
	input[2].mode('change', 1, 0.3, 'rising')
	output[2].action = pulse(0.05, 5)
	output[3].scale(chord)
	output[4].action = ar(0.01, 2, 5)
end

input[1].change = function(state)
	output[3].volts = cur_note - 2
	output[4].volts = 4
end

input[2].change = function(state)

	if i > 2 then	
		len_m = #melody + 1
		delta = (oct[i-1] - oct[i-2]) * scale_len - (melody[i-2] - melody[i-1])
		new_deg1 = (melody[len_m-2] - 1 - delta) % scale_len + 1
		new_oct1 = oct[len_m-2] + math.floor((melody[len_m-2] - 1 - delta)/scale_len)
		--print(melody[i - 2], oct[i - 2])
		--print(melody[i - 1], oct[i - 1])
		--print(delta)

		new_deg2 = (melody[len_m-1] - 1 + delta) % scale_len + 1
		new_oct2 = oct[len_m-1] + math.floor((melody[len_m-1] - 1 + delta)/scale_len)
			
		melody[len_m] = new_deg1
		oct[len_m] = new_oct1
		melody[len_m + 1] = new_deg2
		oct[len_m + 1] = new_oct2
	end
	cur_note = scale[melody[i]]/12 + oct[i]
	output[1].volts = scale[melody[i]]/12 + oct[i]
	output[2]()
	--print(melody[i], oct[i])
	print(i)
	i = i + 1
	if i == 65 then 
		melody = {start_index_1, start_index_2}
		oct = {2, 2}
		i = 1
	end
end