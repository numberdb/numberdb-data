import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/Simple_expressions/Rational_multiples_of_pi/'

prec10 = 100 #relative precision in base 10

s_range = [a/b for b, a in cartesian_product(([1..10],[-25..25]))
			if gcd(a,b) == 1]

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

numbers = {}
for s in s_range:
	print("s:",s)

	number = RIFprec(s*pi)

	number_str = real_interval_to_sage_string(
		RIFprec(number),
		max_digits = prec10,
	).replace('?','')
	
	if s == 1:
		numbers[str(s)] = {
			'number': number_str,
			'equals': 'HREF{Pi}',
		}
		continue
		
	numbers[str(s)] = number_str

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
