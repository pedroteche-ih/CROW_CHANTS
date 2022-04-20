-- Ikeda Map
-- Input 1: Gate

-- Output 1: Chaotic LFO (Ikeda Map x)
-- Output 2: Chaotic LFO (Ikeda Map y)
U = 0.9

function ikeda(x, y, t)
    new_x = 1 + U * (x * math.cos(t) - y * math.sin(t))
    new_y = U * (x * math.sin(t) + y * math.cos(t))
    new_t = 0.4 - (6/(1 + math.pow(new_x, 2) + math.pow(new_y, 2)))
    return {new_x, new_y, new_t}
end

function init()
    cur_pos = {1, 0, -2.6}
    input[1].mode('change', 1, 0.3, 'rising')
end

input[1].change = function(state)
    new_pos = ikeda(table.unpack(cur_pos))
    print(new_pos[1])
    output[1].volts = new_pos[1]
    output[2].volts = new_pos[2]
    output[3].volts = new_pos[3]
    cur_pos = new_pos
end