import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string

path = 'data/Special_values/Special_values_of_the_Gamma_function/'

prec10 = 100 #relative precision in base 10
r = 30
b_range = [1..r]
a_range = [-r..r]

RIFprec = RealIntervalField(prec10 * 3.4 * 2)


numbers = {}
for b in b_range:
	for a in a_range:
		if gcd(a,b) != 1:
			continue
		if b == 1 and a <= 0:
			continue
		s = RIFprec(a)/RIFprec(b)
		s_str = str(QQ(a/b))
		n = gamma(s)
		n_str = real_interval_to_sage_string(n,max_digits = prec10).replace('?','')
		if b == 1:
			numbers[s_str] = {
				'equals': 'HREF{Factorial#%s}[%s!]' % (a-1, a-1),
				'proof': 'CITE{formula-factorial}',
				'number': n_str,
			}
		else:
			numbers[s_str] = n_str

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
