function AnIndexOf(t,val)
    for k,v in ipairs(t) do 
        if v == val then return k end
    end
end 



i = 0
t_min = 0
tb_time = {}
tb_rate = {}
function init()
	input[2].mode('change', 1, 0.3, 'rising')
	output[1].action = loop{
		to(5, dyn{time_rise = 1}, 'log'),
		to(2, dyn{time_fall = 1}, 'exp'),
	}
	output[1]()
	
	output[2].action = loop{
		to(5, dyn{time_rise = 1}, 'log'),
		to(2, dyn{time_fall = 1}, 'exp'),
	}
	output[2]()

	output[3].action = loop{
		to(5, dyn{time_rise = 1}, 'log'),
		to(2, dyn{time_fall = 1}, 'exp'),
	}
	output[3]()

	output[4].action = loop{
		to(5, dyn{time_rise = 1}, 'log'),
		to(2, dyn{time_fall = 1}, 'exp'),
	}
	output[4]()
end

input[2].change = function(state)

	t_cur = time()
	cur_mod = math.max(1, v_to_rate(volts, 5, 3) + 1)
	if i > 64 then 
		i = 0
		tb_time[i] = t_cur
	elseif i == 0 then
		tb_time[i] = t_cur
		i = i + 1
	else
		tb_time[i] = t_cur
		tb_rate[i-1] = tb_time[i] - tb_time[i-1]
		output[1].dyn.time_rise = (tb_rate[i-1] * 1)/1000 * cur_mod
		output[1].dyn.time_fall = (tb_rate[i-1] * 1)/1000 * cur_mod

		output[2].dyn.time_rise = (tb_rate[i-1] * 2)/1000 * cur_mod
		output[2].dyn.time_fall = (tb_rate[i-1] * 2)/1000 * cur_mod

		output[3].dyn.time_rise = (tb_rate[i-1] * 3)/1000 * cur_mod
		output[3].dyn.time_fall = (tb_rate[i-1] * 3)/1000 * cur_mod

		output[4].dyn.time_rise = (tb_rate[i-1] * 4)/1000 * cur_mod
		output[4].dyn.time_fall = (tb_rate[i-1] * 4)/1000 * cur_mod

		i = i + 1
		print(cur_mod)
	end

end

function v_to_rate(volts, offset, scale)
	c_v = (input[1].volts + offset)/scale
	return math.floor(c_v)	
end	