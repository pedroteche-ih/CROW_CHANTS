-- LFO for Krell-like patch

function init()
    output[1].action = ar(1, 1)
    output[1]()
    output[2].action = ar(1, 1)
    output[2]()

    input[1].mode( 'window', {0, 0.1}, 0.15) 
end

output[1].done = function ()
    output[1].action = ar(5 + math.random() * 2, 5+ math.random() * 2)
    output[1]()
end

output[2].done = function ()
    output[2].action = ar(5 + math.random() * 2, 5 + math.random() * 2)
    output[2]()
end

input[1].window = function(state)
    if state == 2 then
        output[3](pulse())
    end
end