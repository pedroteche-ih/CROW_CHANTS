--#region
-- SCALE = {1, 15/14, 5/4, 10/7, 3/2, 12/7}
-- SCALE = {1/1, 10/9, 5/4, 4/3, 3/2, 5/3}
-- SCALE = {1/1, 8/7, 64/49, 49/32, 7/4}
SCALE = {1/1, 7/6, 5/4, 35/24, 5/3, 7/4}

function init()
    input[2].mode('change', 1, 0.1, 'both')
    output[1].scale(SCALE, 'ji')
	output[3].scale(SCALE, 'ji')
    output[4].scale(SCALE, 'ji')
end

input[2].change = function(state)
    if state then
        delay(delay_grab, 0.005)
        delay(delay_gate, 0.005)
    else
        output[2].volts = 0
    end
end

function delay_grab()
	-- Delays grabbing the 1v/Oct
    output[1].volts = input[1].volts + 1
    if math.random() < 0.1 then
        output[3].volts = input[1].volts -2
    end
end

function delay_gate()
	-- Delays gate onset
    output[2].volts = 5
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