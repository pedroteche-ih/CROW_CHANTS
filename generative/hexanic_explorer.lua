-- Hexanic Explorer
--
s = sequins
-- Hexany 9-2-3-5
SCALE = {1, 10/9, 5/4, 4/3, 3/2, 5/3}
HARM = {}
HARM[1] = s{1, 4/3, 10/9, 1, 3/2, 5/4}
HARM[10/9] = s{10/9, 5/4, 5/3, 10/9, 1, 4/3}
HARM[5/4] = s{5/4, 10/9, 5/3, 5/4, 1, 3/2}
HARM[4/3] = s{4/3, 3/2, 5/3, 4/3, 1, 10/9}
HARM[3/2] = s{3/2, 4/3, 5/3, 3/2, 1, 5/4}
HARM[5/3] = s{5/3, 5/4, 10/9, 5/3, 3/2, 4/3}

SUBHARM = {}
SUBHARM[1] = s{1, 4/3, 3/2, 1, 10/9, 5/4}
SUBHARM[10/9] = s{10/9, 5/4, 1, 10/9, 5/3, 4/3}
SUBHARM[5/4] = s{5/4, 10/9, 1, 5/4, 5/3, 3/2}
SUBHARM[4/3] = s{4/3, 3/2, 1, 4/3, 5/3, 10/9}
SUBHARM[3/2] = s{3/2, 4/3, 1, 3/2, 5/3, 5/4}
SUBHARM[5/3] = s{5/3, 5/4, 3/2, 5/3, 10/9, 4/3}

OCT = s{2, 2, 2, 2, 3}

function init()
    input[1].mode('change', 0.5, 0.1, 'both')
    input[2].mode('change', 0.5, 0.1, 'rising')
	output[1].scale(SCALE, 'ji')
	output[3].scale(SCALE, 'ji')
    output[4].scale(SCALE, 'ji')
    cur_node = 1/1
    cur_note = 1/1
    cur_type = TYPE()
end

input[1].change = function(state)
    if state then
	    delay(delay_grab, 0.001)
        output[2].volts = 5
    else
        output[2].volts = 0
    end
end

input[2].change = function(state)
	cur_node = cur_note
    if math.random() < 0.2 then
        cur_type = TYPE()
        print('Trocando otonalidade!')
    end
end

function delay_grab()
	-- Delays grabbing the 1v/Oct
	local cur_tetrad = cur_type[cur_node]
    local last_note = cur_note
    if math.random() < 0.2 then
        cur_type[cur_node]:step(-1)
    end

    cur_note = cur_tetrad()
    octave = OCT()
    output[1].volts = justvolts(cur_note) + octave

    output[3].volts = justvolts(cur_node)
    output[4].volts = justvolts(last_note) +1
end

function tune(volts)
    output[1].scale('none')
	output[3].scale('none')
    output[4].scale('none')
    output[1].volts = volts
    output[2].volts = 5
    output[3].volts = volts
    output[4].volts = volts
end    