s = sequins

subharm_seq = s{2, 3, 2, 4}

function init()
    input[2].mode('change', 1, 0.3, 'rising')
end

input[2].change = function()
    output[1].volts = input[1].volts
    output[2].volts = input[1].volts - (subharm_seq()-1)
end
