-- Hexanic Wanderer
--
s = sequins
-- Hexany 1-3-5-7
MASTER_SCALE = {1, 15/14, 5/4, 10/7, 3/2, 12/7}
HARM = {}
HARM[1] = {1, 3/2, 5/4, 1, 12/7, 10/7}
HARM[15/14] = {15/14, 10/7, 5/4, 15/14, 12/7, 3/2}
HARM[5/4] = {5/4, 1, 3/2, 5/4, 10/7, 15/14}
HARM[10/7] = {10/7, 15/14, 5/4, 10/7, 12/7, 1}
HARM[3/2] = {3/2, 1, 5/4, 3/2, 12/7, 15/14}
HARM[12/7] = {12/7, 15/14, 3/2, 12/7, 10/7, 1}

SUBHARM = {}
SUBHARM[1] = {1, 3/2, 12/7, 1, 5/4, 10/7}
SUBHARM[15/14] = {15/14, 10/7, 12/7, 15/14, 5/4, 3/2}
SUBHARM[5/4] = {5/4, 1, 10/7, 5/4, 3/2, 15/14}
SUBHARM[10/7] = {10/7, 15/14, 12/7, 10/7, 5/4, 1}
SUBHARM[3/2] = {3/2, 1, 12/7, 3/2, 5/4, 15/14}
SUBHARM[12/7] = {12/7, 15/14, 10/7, 12/7, 3/2, 1}


CHORD_HARM = {}
CHORD_HARM[12/7] = {}
CHORD_HARM[12/7][15/14] = 3/2
CHORD_HARM[12/7][3/2] = 15/14
CHORD_HARM[12/7][10/7] = 1
CHORD_HARM[12/7][1] = 10/7
CHORD_HARM[10/7] = {}
CHORD_HARM[10/7][15/14] = 5/4
CHORD_HARM[10/7][5/4] = 15/14
CHORD_HARM[10/7][12/7] = 1
CHORD_HARM[10/7][1] = 12/7
CHORD_HARM[1] = {}
CHORD_HARM[1][3/2] = 5/4
CHORD_HARM[1][5/4] = 3/2
CHORD_HARM[1][12/7] = 10/7
CHORD_HARM[1][10/7] = 12/7
CHORD_HARM[15/14] = {}
CHORD_HARM[15/14][10/7] = 5/4
CHORD_HARM[15/14][5/4] = 10/7
CHORD_HARM[15/14][12/7] = 3/2
CHORD_HARM[15/14][3/2] = 12/7
CHORD_HARM[3/2] = {}
CHORD_HARM[3/2][1] = 5/4
CHORD_HARM[3/2][5/4] = 1
CHORD_HARM[3/2][12/7] = 15/14
CHORD_HARM[3/2][15/14] = 12/7
CHORD_HARM[5/4] = {}
CHORD_HARM[5/4][1] = 3/2
CHORD_HARM[5/4][3/2] = 1
CHORD_HARM[5/4][10/7] = 15/14
CHORD_HARM[5/4][15/14] = 10/7
CHORD_SUBHARM = {}
CHORD_SUBHARM[12/7] = {}
CHORD_SUBHARM[12/7][15/14] = 10/7
CHORD_SUBHARM[12/7][10/7] = 15/14
CHORD_SUBHARM[12/7][3/2] = 1
CHORD_SUBHARM[12/7][1] = 3/2
CHORD_SUBHARM[10/7] = {}
CHORD_SUBHARM[10/7][15/14] = 12/7
CHORD_SUBHARM[10/7][12/7] = 15/14
CHORD_SUBHARM[10/7][5/4] = 1
CHORD_SUBHARM[10/7][1] = 5/4
CHORD_SUBHARM[1] = {}
CHORD_SUBHARM[1][3/2] = 12/7
CHORD_SUBHARM[1][12/7] = 3/2
CHORD_SUBHARM[1][5/4] = 10/7
CHORD_SUBHARM[1][10/7] = 5/4
CHORD_SUBHARM[15/14] = {}
CHORD_SUBHARM[15/14][10/7] = 12/7
CHORD_SUBHARM[15/14][12/7] = 10/7
CHORD_SUBHARM[15/14][5/4] = 3/2
CHORD_SUBHARM[15/14][3/2] = 5/4
CHORD_SUBHARM[3/2] = {}
CHORD_SUBHARM[3/2][1] = 12/7
CHORD_SUBHARM[3/2][12/7] = 1
CHORD_SUBHARM[3/2][5/4] = 15/14
CHORD_SUBHARM[3/2][15/14] = 5/4
CHORD_SUBHARM[5/4] = {}
CHORD_SUBHARM[5/4][1] = 10/7
CHORD_SUBHARM[5/4][10/7] = 1
CHORD_SUBHARM[5/4][3/2] = 15/14
CHORD_SUBHARM[5/4][15/14] = 3/2



TYPE = s{HARM, SUBHARM}
TYPE_CHORD = s{CHORD_HARM, CHORD_SUBHARM}

function init()
    input[2].mode('change', 0.5, 0.1, 'both')
    CUR_NOTE = 1/1
    CUR_NODE = CUR_NOTE - math.floor(CUR_NOTE) + 1
    CUR_TETRADS = TYPE()
    CUR_CHORDS = TYPE_CHORD()
    SCALE = CUR_TETRADS[CUR_NODE]
    CHANGE = {}
    SIZE = 32
    for it = 1, SIZE do
        CHANGE[it] = 0
    end
    I = 1
    input[1].mode('scale', SCALE, 'ji')
    output[1].scale(SCALE, 'ji')
	output[3].scale(SCALE, 'ji')
    output[4].scale(SCALE, 'ji')
end

input[1].scale = function(state)
    CUR_DEGREE = state['index']
end

input[2].change = function(state)
    if state then
	    delay(delay_grab, 0.001)
        output[2].volts = 5
    else
        output[2].volts = 0
    end
end

function delay_grab()
	-- Delays grabbing the 1v/Oct
    CUR_NOTE = input[1].volts
    -- 
    local num_changes = 0
    for it = 1, SIZE do
        num_changes = num_changes + CHANGE[it]
    end
    local prob = 0.2 - 0.02 * num_changes
    print(string.format("Current status: p = %f, # of changes = %d", prob, num_changes))
    if math.random() < prob then
        CUR_NODE = SCALE[CUR_DEGREE]
        SCALE = CUR_TETRADS[CUR_NODE]
        output[1].scale(SCALE, 'ji')
	    output[3].scale(SCALE, 'ji')
        output[4].scale(SCALE, 'ji')
        CHANGE[I] = 1
    else
        CHANGE[I] = 0
    end

    local third_degree = CUR_CHORDS[SCALE[CUR_DEGREE]][CUR_NODE]
    output[1].volts = CUR_NOTE + 2
    output[3].volts = justvolts(CUR_NODE)

    if type(third_degree) == "number" then
        output[4].volts = justvolts(third_degree) + 1
    else
        output[4].volts = CUR_NOTE
    end

    if I < 32 then
        I = I + 1
    else
        I = 1
        CUR_TETRADS = TYPE()
        CUR_CHORDS = TYPE_CHORD()
    end
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