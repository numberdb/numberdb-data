import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = "data/Polynomials/Number_theory/Modular_polynomials_for_Weber's_f-function/"

ell_range = prime_range(5,100)

R.<x,y> = QQ[]

polynomials = {}

for ell in ell_range:
	
	filename_ell = os.path.join(path, 'phi1_%s.new' % (ell,))
	p = R(0)
	with open(filename_ell, 'r') as file:
		for line in file.readlines():
			exponents, coeff = line.split(' ')
			exp_x, exp_y = exponents.strip('[]').split(',')
			monomial1 = ZZ(coeff) * x^ZZ(exp_x) * y^ZZ(exp_y)
			monomial2 = ZZ(coeff) * x^ZZ(exp_y) * y^ZZ(exp_x)
			if monomial1 == monomial2:
				p += monomial1
			else:
				p += monomial1 + monomial2			

	polynomials[str(ell)] = str(p)

filename = os.path.join(path, 'polynomials.yaml')
yaml.dump(polynomials, stream = open(filename, 'w'), sort_keys = False)
