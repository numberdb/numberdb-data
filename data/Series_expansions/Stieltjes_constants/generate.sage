import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string

path = 'data/Series_expansions/Stieltjes_constants/'

prec10 = 100 #relative precision in base 10
n_max = 500
n_range = [0..n_max]

print("n_max:",n_max)

prec2 = prec10 * 3.4 * 1.3
RIFprec = RealIntervalField(prec2)
RBFprec = RealBallField(prec2)


'''
numbers = {n:
	RIFprec(stieltjes(n).n(prec2))
	for n in n_range
}
'''
numbers = {}
for n in n_range:
	print("n:",n)
	numbers[n] = RIFprec(stieltjes(n).n(prec2))

numbers = {str(n):
	real_interval_to_sage_string(number,prec10).replace('?','')
	for n, number in numbers.items()
}

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
