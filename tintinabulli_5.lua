function AnIndexOf(t,val)
    for k,v in ipairs(t) do 
        if v == val then return k end
    end
end

--scale = {0, 2.769, 5.538, 7.384, 10.154}
--scale = {0, 2.669, 3.863, 6.532, 8.189, 9.688, 10.494}

--scale = {0, 2.669, 3.863, 6.532, 8.189, 9.688, 10.494}
--chord = sequins{0, 3.863, 9.688}
--chord = {2.669, 6.532, 9.688}
--p1 = sequins{4, 3, 4, 2, 3, 1, 2, 2, 2}
--p2 = sequins{4, 4, 5, 4, 3, 2, 1, 3, 4, 3, 2}
--p3 = sequins{-1, 1, 2, 2, 1, 3, 4, 3, 2, 2}
--melody = sequins{4, 3, 4, 2, 3, 1, 2, 2, 2,
--				 4, 4, 5, 4, 3, 2, 1, 3, 4, 3, 2,
--				 -1, 1, 2, 2, 1, 3, 4, 3, 2, 2}

--scale = {0, 1.935, 3.09677, 5.03226, 6.96774, 8.12903, 10.06452}
--chord = {0,3.09677,6.96774}
-- Olympos Pentatonic
--scale = {0, 2.6687, 4.9804, 5.8251, 7.0196, 9.6882}
--chord = {0, 4.9804, 9.6882}
-- Enharmonic
--scale = {0, 0.6296, 1.1173, 4.98, 7.019, 7.649, 8.1368}
--chord = {0, 4.98, 7.649}
-- Chromatic
scale = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
-- chord = {0, 4 , 9}
-- Minor
--scale = {0, 2, 4, 5, 7, 9, 11}
chord = {0, 4 , 7}
m_volts = 0
m_deg = 0
m_oct = 0
function init()
	input[1].mode('scale', scale)
	input[2].mode('change', 1, 0.3, 'rising')
	--output[1].scale({})
	--output[2].scale({})
	output[3].action = pulse(0.05, 5)
end

input[1].scale = function(v)
	m_volts = v['volts']
	m_deg = v['index']
	m_oct = v['octave']
end

input[2].change = function(state)
	print('gate')
	--delay(function() tint(input[1].volts,chord, 'lower') end, 0.006)
	delay(tint, 0.009)
end

function tint()
	local t_volts = calc_tint_down(m_deg, m_oct, chord) + math.floor(m_volts)
	if t_volts > m_volts then
		t_volts = t_volts - 1
	end
	print(m_volts, t_volts)
	output[1].volts = m_volts + 1
	output[2].volts = t_volts + 1
	output[3]()
	--print(m_note, t_note)
end
	
function calc_tint_down(m_index, m_oct, chord)
	local m_degree = m_index - 1
	local min_dist = 5000
	local t_degree = 0
	for i, chord_degree in ipairs(chord) do
		print(chord_degree, m_degree)
		if m_degree > chord_degree then
			distance = m_degree - chord_degree
			oct_dif = 0
		else
			distance = m_degree - (chord_degree - 12)
			oct_dif = -1
		end

		if distance < min_dist then 
			min_dist = distance 
			t_degree = chord_degree
		end
	end
	print(t_degree, m_degree)
	return t_degree/12
end 

function calc_tint_up(volts, chord)
	local octave = math.floor(volts)
	local degree = (volts - octave) * 12
	local min_dist = 5000
	local distance = 0
	for i, chord_degree in ipairs(chord) do
		if chord_degree - degree > 0 then distance = chord_degree - degree
		else distance = (chord_degree + 12) - degree end

		if distance < min_dist then
			min_dist = distance
			tint_volts = (degree + distance)/12 + octave
		end
	end
	return tint_volts
end

function byte2bin(n)
	local t = {}
	local var_deg = 0
	
	for i=7,0,-1 do
		t[#t+1] = math.floor(n / 2^i)
		n = n % 2^i
	end
	t_num = tostring(tonumber(table.concat(t)))
	for i = 1, #t_num do
		local c = t_num:sub(i,i)
		if c == '1' then var_deg = var_deg + 1
		else var_deg = var_deg * -1 end
	end

	return var_deg
end

function infinite_series(n)
	local degree = {}
	for i=0,n-1,1 do
		degree[#degree + 1] = byte2bin(i)
	end
	return degree
end

function degree_to_volts(degree, scale, oct)
	local scale_size = #scale
	local volt_degree = scale[(degree % scale_size) + 1]/12
	local volt_oct = oct + math.floor(degree/scale_size)
	return volt_degree + volt_oct
end