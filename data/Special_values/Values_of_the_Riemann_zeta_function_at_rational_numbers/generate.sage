import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string

path = 'data/Special_values/Values_of_the_Riemann_zeta_function_at_rational_numbers/'

prec10 = 100 #relative precision in base 10
b_range = [1..20]
a_range = [-40..40]

RIFprec = RealIntervalField(prec10 * 3.4 * 2)


numbers = {}
for b in b_range:
	for a in a_range:
		if gcd(a,b) != 1:
			continue
		s = a/b
		if s == 1:
			continue
		s_str = str(s)
		n = zeta(s)
		if n in QQ:
			n_str = str(n)
		else:
			#n is so far symbolic
			n = RIFprec(n)
			n_str = real_interval_to_sage_string(n,max_digits = prec10).replace('?','')
		numbers[s_str] = n_str

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
