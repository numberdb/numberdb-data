import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string
from utils.utils import complex_interval_to_sage_string


path = 'data/Zeros/Algebraic_numbers/Roots_of_unity'

prec10 = 100 #relative precision in base 10

mpmath.mp.dps = prec10 * 1.5

n_range = [1..50]

RIFprec = RealIntervalField(prec10 * 3.4 * 1.3)
CIFprec = ComplexIntervalField(RIFprec.prec())

numbers = {}

for n in n_range:
	
	numbers_n = {}
	
	for k in [0..n-1]:
		if gcd(k,n) != 1:
			continue

		number = exp(2*pi*i*k/n)
		
		
		if number == 1:
			numbers_n[str(k)] = {
				'number': str(number),
				'equals': 'HREF{One}',
			}
			continue
		if number == -1:
			numbers_n[str(k)] = {
				'number': str(number),
				'equals': 'HREF{Integers#-1}',
			}
			continue
		if number in [i,-i]:
			numbers_n[str(k)] = {
				'number': str(number).lower(),
			}
			continue


		number_str = complex_interval_to_sage_string(
			CIFprec(number),
			max_digits = prec10,
		).replace('?','')
		
		numbers_n[str(k)] = number_str

	numbers[str(n)] = numbers_n

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
