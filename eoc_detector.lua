-- EoC Detector

function init()
    input[1].mode('window', {0.5, 2.5, 4.5})
    input[2].mode('window', {0.5, 2.5, 4.5})
end

input[1].window = function(state)
    if state == 1 then
        output[1](pulse())
    end
    if state == 4 then
        output[2](pulse())
    end
end

input[2].window = function(state)
    if state == 1 then
        output[3](pulse())
    end
    if state == 4 then
        output[4](pulse())
    end
end