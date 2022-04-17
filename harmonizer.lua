MELODY_TABLE = {}
I = 0
function countMap(list)
    local counts = {}
    for _, value in ipairs(list) do
        local volts = math.floor(value*1000)/1000
        if counts[volts] then   
            -- 2nd or on time that we've seen this element
            counts[volts] = counts[volts] + 1
        else
            -- 1st time we've seen this element
            counts[volts] = 1
        end
    end
    return counts
end

-- returns a `key` such that `map[key]` is as large as possible
function keyLargest(map)
    local best = next(map) -- get an arbitrary key
    local second_best = best
    local third_best = best
    for key in pairs(map) do
        if map[best] < map[key] then
            third_best = second_best
            second_best = best
            best = key
        end
    end
    local chord = {best, second_best, third_best}
    return chord
end

function tint_down(volts, chord)
	local octave = math.floor(volts)
	local degree = (volts - octave) * 12
	local min_dist = 5000
	local distance = 0
	for i, chord_degree in ipairs(chord) do
		if degree - chord_degree > 0 then distance = degree-chord_degree
		else distance = degree - (chord_degree - 12) end

		if distance < min_dist then
			min_dist = distance
			tint_volts = (degree - distance)/12 + octave
		end
	end
    --print(input[1].volts, tint_volts)
	return tint_volts
end

function init()
	input[2].mode('change', 1, 0.3, 'rising')
end

input[2].change = function(state)
	table.insert(MELODY_TABLE, input[1].volts)
    I = I + 1
    if I > 50 then
        table.remove(MELODY_TABLE, 1)
        chord = keyLargest(countMap(MELODY_TABLE))
        output[1].volts = tint_down(input[1].volts, chord)
    else
        output[1].volts = input[1].volts
    end
end