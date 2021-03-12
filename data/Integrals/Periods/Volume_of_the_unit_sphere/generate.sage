import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/Integrals/Periods/Volume_of_the_unit_sphere/'

prec10 = 100 #relative precision in base 10

d_range = [-1..500]

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

numbers = {}
for d in d_range:
	print("d:",d)

	number = RIFprec(2*pi^((d+1)/2)/gamma((d+1)/2))

	number_str = real_interval_to_sage_string(
		RIFprec(number),
		max_digits = prec10,
	).replace('?','')

	numbers[str(d)] = number_str

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
