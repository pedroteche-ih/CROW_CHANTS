function rule30(str)
  local next_str = ""
  for i = 1, #str do
    -- determine left, center, and right values for each cell
    if i == 1 then
        l, c, r = tonumber(string.sub(str, i-2,i-2)) or 0, tonumber(string.sub(str,i,i)) or 0, tonumber(string.sub(str,i+1,i+1)) or 0
    else
        l, c, r = tonumber(string.sub(str, i-1,i-1)) or 0, tonumber(string.sub(str,i,i)) or 0, tonumber(string.sub(str,i+1,i+1)) or 0
    end
    
    -- apply rule 30 to determine next state of cell
    local next_c = l ~ (c | r)
    
    next_str = next_str .. tostring(next_c)
    -- print(l, c, r, next_c)
  end
  return next_str
end

STATE = "000010000"
SCALE = {1, 15/14, 5/4, 10/7, 3/2, 12/7}
function init()
    input[1].mode("change", 2, 0.1, "rising")
    output[1].scale(SCALE, 'ji')
end

input[1].change = function()
    STATE = rule30(STATE)
    local state_volts = tonumber(STATE, 2)/79
    print(state_volts)
    output[1].volts = state_volts/3 + 3
    output[2](pulse())
end
