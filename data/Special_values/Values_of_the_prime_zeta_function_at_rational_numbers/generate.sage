import yaml
import os
from mpmath import mp, mpc, mpf
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string
from utils.utils import complex_interval_to_sage_string


path = 'data/Special_values/Values_of_the_prime_zeta_function_at_rational_numbers/'

prec10 = 100 #relative precision in base 10
b_range = [1..30]
a_range = [1..50]

mp.dps = prec10 * 2
RIFprec = RealIntervalField(mp.prec)
CIFprec = ComplexIntervalField(mp.prec)

numbers = {}
for b in b_range:
	for a in a_range:
		if gcd(a,b) != 1:
			continue
		s = a/b
		if s == 1:
			continue
		if a == 1 and b.is_squarefree():
			#primezeta has pole at s
			continue
		print("s:",s)
		s_str = str(s)
		n = mp.primezeta(s)
		
		if isinstance(n,mpf):
			n = RIFprec(n)
			n_str = real_interval_to_sage_string(n,max_digits = prec10).replace('?','')
		else:
			n = CIFprec(RIFprec(n.real), RIFprec(n.imag))
			n_str = complex_interval_to_sage_string(n,max_digits = prec10).replace('?','')
				
		numbers[s_str] = n_str

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
