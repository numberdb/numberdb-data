import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string

path = 'data/Special_values/Values_of_the_Hurwitz_zeta_function_at_pairs_of_rational_numbers/'

prec10 = 100 #relative precision in base 10
b_range = [1..10]
a_range = [-10..10]

d_range = [1..5]
c_range = [1..5]


RIFprec = RealIntervalField(prec10 * 3.4 * 2)


numbers = {}
for d in d_range:
	for c in c_range:
		if gcd(c,d) != 1:
			continue
		x = c/d
		if x > 1:
			continue
		if x == 1:
			numbers_x = {
				#'equals': 'HREF{T14}',
				'equals': 'HREF{Values_of_the_Riemann_zeta_function_at_rational_numbers}',
			}
		else:
			numbers_x = {}
			for b in b_range:
				for a in a_range:
					if gcd(a,b) != 1:
						continue
					s = a/b
					if s == 1:
						continue

					if s == 0:
						n = 1/2 - x #use this as hurwitz_zeta returns a real, not an integer...
					else:
						n = hurwitz_zeta(s,x)
					
					if n in QQ:
						n_str = str(n)
					else:
						#n is so far symbolic
						n = RIFprec(n)
						n_str = real_interval_to_sage_string(n,max_digits = prec10).replace('?','')
					numbers_x[str(s)] = n_str
		numbers[str(x)] = numbers_x

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
