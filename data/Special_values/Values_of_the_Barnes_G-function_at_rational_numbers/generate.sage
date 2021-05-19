import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string

path = 'data/Special_values/Values_of_the_Barnes_G-function_at_rational_numbers/'

prec10 = 100 #relative precision in base 10
r = 30
b_range = [1..r]
a_range = [-r..r]

mpmath.mp.dps = prec10 * 2
RIFprec = RealIntervalField(prec10 * 3.4 * 2)


numbers = {}
for b in b_range:
	for a in a_range:
		if gcd(a,b) != 1:
			continue
		if a <= 0 and b == 1:
			continue
		s = RIFprec(a)/RIFprec(b)
		s_str = str(QQ(a/b))
		if b == 1:
			n = prod(factorial(k) for k in [0..ZZ(s)-2])
		else:
			n = mpmath.barnesg(s)
		n_str = real_interval_to_sage_string(n,max_digits = prec10).replace('?','')
		numbers[s_str] = n_str

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
