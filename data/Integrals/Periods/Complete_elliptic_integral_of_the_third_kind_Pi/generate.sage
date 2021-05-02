import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/Integrals/Periods/Complete_elliptic_integral_of_the_third_kind_Pi/'

prec10 = 100 #relative precision in base 10

n_range = [a/b for b, a in cartesian_product(([1..10],[0..10]))
			if gcd(a,b) == 1 and a/b < 1]
m_range = [a/b for b, a in cartesian_product(([1..10],[0..10]))
			if gcd(a,b) == 1 and a/b < 1]

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

numbers = {}
for n in n_range:
	numbers_n = {}
		
	if n == 0:
		numbers_n = {
			'equals': 'HREF{Complete_elliptic_integral_of_the_first_kind_K}',		
		}
		
	else:
		for m in m_range:
			print("n,m:",n,m)

			number = elliptic_pi(n,pi/2,m)
			print("number.n():",number.n())

			number_str = real_interval_to_sage_string(
				RIFprec(number),
				max_digits = prec10,
			).replace('?','')

			numbers_n[str(m)] = number_str


	numbers[str(n)] = numbers_n

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
