import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/Polynomials/Number_theory/Modular_polynomials_for_j-invariant/'

n_range = [1..12]

R.<x,y> = QQ[]

polynomials = {}

for n in n_range:
	
	filename_n = os.path.join(path, 'phi_j_%s.txt' % (n,))
	p = R(0)
	with open(filename_n, 'r') as file:
		for line in file.readlines():
			exponents, coeff = line.split(' ')
			exp_x, exp_y = exponents.strip('[]').split(',')
			monomial1 = ZZ(coeff) * x^ZZ(exp_x) * y^ZZ(exp_y)
			monomial2 = ZZ(coeff) * x^ZZ(exp_y) * y^ZZ(exp_x)
			if monomial1 == monomial2:
				p += monomial1
			else:
				p += monomial1 + monomial2			

	polynomials[str(n)] = str(p)

filename = os.path.join(path, 'polynomials.yaml')
yaml.dump(polynomials, stream = open(filename, 'w'), sort_keys = False)
