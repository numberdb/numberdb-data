#Not used a the moment due to numerical issues with evaluating the integrals for d >= 4.

import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string

path = "data/Probability_theory/Polya's_random_walk_constant/"

prec10 = 100 #relative precision in base 10
d_max = 10
d_range = [1..d_max]

print("d_max:",d_max)

RIFprec = RealIntervalField(prec10 * 3.4 * 1.3)


numbers = {}

for d in d_range:
	if d <= 2:
		number = 1
	elif d == 3:
		u = RIFprec(sqrt(6)/(32*pi^3)*gamma(1/24)*gamma(5/24)*gamma(7/24)*gamma(11/24))
		number = 1-1/u
	else:
		t = var('t')
		f(t) = bessel_I(0,t/d)^d * exp(-t)
		u = integral_numerical(f,0,oo) # doesn't work
		number = 1-1/u
		
	d_str = str(d)
	numbers[d_str] = real_interval_to_sage_string(
		number,
		max_digits = prec10,
	).replace('?','')

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
