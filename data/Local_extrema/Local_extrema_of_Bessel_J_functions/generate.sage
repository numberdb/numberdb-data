import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/Local_extrema/Local_extrema_of_Bessel_J_functions/'

prec10 = 100 #relative precision in base 10

mpmath.mp.dps = prec10 * 1.5
alpha_range = [a/2 for a in [0..20]] #order of Bessel J-function
n_range = [1..50] #index of zero of J_alpha

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

numbers = {}
for alpha in alpha_range:
	print("alpha:",alpha)
	numbers_alpha = {}

	for n in n_range:
		number = mpmath.mp.besseljzero(alpha,n,derivative=1)
		number_str = real_interval_to_sage_string(
			RIFprec(number),
			max_digits = prec10,
		).replace('?','')

		'''
		if alpha == 1/2:
			#number = n*pi
			if n == 1:
				numbers_alpha[str(n)] = {
					'number': number_str,
					'equals': 'HREF{Pi}',
				}
				continue
		'''
		
		numbers_alpha[str(n)] = number_str

	numbers[str(alpha)] = numbers_alpha

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
