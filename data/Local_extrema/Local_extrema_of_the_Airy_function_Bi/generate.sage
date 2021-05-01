import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/Local_extrema/Local_extrema_of_the_Airy_function_Bi/'

prec10 = 100 #relative precision in base 10

mpmath.mp.dps = prec10 * 1.5
n_range = [1..1000] #index of zero

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

numbers = {}
for n in n_range:
	print("n:",n)
	number = mpmath.mp.airybizero(n,derivative=1)
	number_str = real_interval_to_sage_string(
		RIFprec(number),
		max_digits = prec10,
	).replace('?','')

	numbers[str(n)] = number_str

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
