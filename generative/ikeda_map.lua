function ikeda_map(x, y)
    -- Define constants for the Ikeda Map
    local alpha = 6.24579
    local beta = 0.76819
    local gamma = 3.86806

    -- Calculate new values for x and y
    local xn = 1 + beta * (x*math.cos(y))
    local yn = gamma + alpha * x * math.sin(y)

    -- Update outputs with the new values
    output[1].volts = xn
    output[2].volts = yn
end

function init()
    input[1].mode('change', 0.5, 0.1, 'both')
    output[1].volts = 0
    output[2].volts = 0.5
end

input[1].change = function()
    ikeda_map(output[1].volts, output[2].volts)
end