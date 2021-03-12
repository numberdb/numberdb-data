import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/Integrals/Periods/Complete_elliptic_integral_of_the_second_kind_E/'

prec10 = 100 #relative precision in base 10

m_range = [a/b for b, a in cartesian_product(([1..50],[0..50]))
			if gcd(a,b) == 1 and a/b <= 1]

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

numbers = {}
for m in m_range:
	print("m:",m)

	number = elliptic_ec(m)

	number_str = real_interval_to_sage_string(
		RIFprec(number),
		max_digits = prec10,
	).replace('?','')

	numbers[str(m)] = number_str

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
