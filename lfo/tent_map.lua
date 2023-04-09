-- Tent Map
-- Implements a clocked/slewed version of the Tent Map
-- a chaotic, 1-dimensional discrete dynamical system.
-- Input 1: clock input

U = 1.9999
START_POS = 0.4
MAX_I = 32
GATE_TIMES = {}

function init()
    input[1].mode('change', 0.5, 0.1, 'rising')
    output[1].shape = 'over'
    output[2].shape = 'over'
    CUR_POS = START_POS
    I = 1
    GATE_TIMES[I] = time()
end

input[1].change = function(state)
    if I <= MAX_I then
        I = I + 1
        GATE_TIMES[I] = time()
        CUR_SLEW = (GATE_TIMES[I] - GATE_TIMES[I-1])/1000
    else
        I = 1
        GATE_TIMES[I] = time()

    end
    output[1].slew = CUR_SLEW/2
    output[2].slew = CUR_SLEW/2
    if CUR_POS < 0.5 then
        NEW_POS = U * CUR_POS
    else
        NEW_POS = U * (1-CUR_POS)
    end
    CUR_POS = NEW_POS
    -- 0v to 5v Output
    output[1].volts = CUR_POS * 5
    -- -5v to 5v Output
    output[2].volts  = (CUR_POS * 10) - 5
end


