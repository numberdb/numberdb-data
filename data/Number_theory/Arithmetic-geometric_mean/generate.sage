import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/Number_theory/Arithmetic-geometric_mean/'

prec10 = 100 #relative precision in base 10

a_range = [1..45]
b_range = [1..45]

RIFprec = RealIntervalField(prec10 * 3.4 * 2)
RBFprec = RealBallField(RIFprec.prec())

numbers = {}
for a in a_range:
	numbers_a = {}
	
	for b in b_range:
		if b <= a:
			continue
		
		number = RBFprec(a).agm(b)

		number_str = real_interval_to_sage_string(
			RIFprec(number),
			max_digits = prec10,
		).replace('?','')

		numbers_a[str(b)] = number_str
	
	if len(numbers_a) > 0:
		numbers[str(a)] = numbers_a

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
