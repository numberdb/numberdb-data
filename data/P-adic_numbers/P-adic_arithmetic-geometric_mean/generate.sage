import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/P-adic_numbers/P-adic_arithmetic-geometric_mean/'

prec10 = 50 #relative precision in base 10

p_range = prime_range(20)
a_max = 23
b_max = a_max

numbers = {}
for p in p_range:

	numbers_p = {}
	
	prec_p = ceil(prec10*log(10,p))
	Q_p = Qp(p, prec=prec_p, print_mode='val-unit')
	Q_p_prec = Qp(p, prec=prec_p+20, print_mode='val-unit')

	if p == 2:
		#expand range because for p=2 agm_p(a,b) converges for less values of a and b
		a_range = [-3*a_max..3*a_max] 
		b_range = [-3*b_max..3*b_max]
	else:
		a_range = [-a_max..a_max]
		b_range = [-b_max..b_max]

	for a in a_range:

		numbers_pa = {}
		
		for b in b_range:
			if b <= a:
				continue
			if b % p == 0:
				continue
			if p == 2:
				if mod(a,16)/mod(b,16) != mod(1,16):
					continue
			else:
				if mod(a,p)/mod(b,p) != mod(1,p):
					continue			
			
			number = Q_p(pari.agm(Q_p_prec(a),Q_p_prec(b)))

			number_str = str(number)

			numbers_pa[str(b)] = number_str
		
		if len(numbers_pa) > 0:
			numbers_p[str(a)] = numbers_pa
	
	numbers[str(p)] = numbers_p

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
