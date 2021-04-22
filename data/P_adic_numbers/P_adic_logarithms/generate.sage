import yaml
import os
import mpmath

path = 'data/P_adic_numbers/P_adic_logarithms/'

prec10 = 50 #relative precision in base 10

p_range = prime_range(30)
i_range = [0..30] #k = 1 + i*p

numbers = {}
for p in p_range:
	print("p:",p)
	numbers_p = {}

	prec_p = ceil(prec10*log(10,p))
	Q_p = Qp(p, prec=prec_p, print_mode='val-unit')

	for i in i_range:
		k = 1 + i*p
		number = Q_p(k).log()
	
		number_str = str(number)
		numbers_p[str(k)] = number_str

	numbers[str(p)] = numbers_p

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
