import yaml
import os
import mpmath

path = 'data/P_adic_numbers/Teichmueller_representatives_in_Zp/'

prec10 = 50 #relative precision in base 10

p_range = prime_range(100)

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

numbers = {}
for p in p_range:
	print("p:",p)
	numbers_p = {}

	prec_p = ceil(prec10*log(10,p))
	Q_p = Qp(p, prec=prec_p, print_mode='val-unit')

	if p == 2:
		k_range = [1,-1]
		Ts = Q_p.roots_of_unity()
		assert(Ts[0] == 1)
	else:
		k_range = [1..p-1]
		Ts = Q_p.teichmuller_system()
	
	for i, k in enumerate(k_range):
		number = Ts[i]
		assert((number - k).valuation() > 0)
	
		number_str = str(number)
		numbers_p[str(k)] = number_str

	numbers[str(p)] = numbers_p

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
