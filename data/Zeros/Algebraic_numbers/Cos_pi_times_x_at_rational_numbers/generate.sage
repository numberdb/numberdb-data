import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/Zeros/Algebraic_numbers/Cos_pi_times_x_at_rational_numbers'

prec10 = 100 #relative precision in base 10

mpmath.mp.dps = prec10 * 1.5

b_range = [1..55]

RIFprec = RealIntervalField(prec10 * 3.4 * 1.3)

numbers = {}

for b in b_range:
	
	for a in [0..b]:
		if gcd(a,b) != 1:
			continue
			
		x = a/b

		number = cos(pi*x)
		
		if number == 1:
			numbers[str(x)] = {
				'number': str(number),
				'equals': 'HREF{One}',
			}
			continue
		if number == 0:
			numbers[str(x)] = {
				'number': str(number),
				'equals': 'HREF{Zero}',
			}
			continue
		if number == -1:
			numbers[str(x)] = {
				'number': str(number),
				'equals': 'HREF{Integers#-1}',
			}
			continue
		
		if number in QQ:
			number_str = str(number)
		else:
			number_str = real_interval_to_sage_string(
				RIFprec(number),
				max_digits = prec10,
			).replace('?','')
		
		numbers[str(x)] = number_str


filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
