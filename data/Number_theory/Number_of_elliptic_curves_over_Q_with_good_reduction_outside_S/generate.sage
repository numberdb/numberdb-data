#The data is taken from:
#
# https://github.com/bmatschke/s-unit-equations/tree/master/elliptic-curve-tables/

import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string
from sage.schemes.elliptic_curves.ell_egros import *


path = 'data/Number_theory/Number_of_elliptic_curves_over_Q_with_good_reduction_outside_S'

prec10 = 100 #relative precision in base 10
num_digits_m = 100

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

#For testing, take:
#data = load("https://github.com/bmatschke/s-unit-equations/raw/master/elliptic-curve-tables/good-reduction-away-from-first-primes/K_deg_1/js_K_1.1.1.1_S_2_3_5.sobj")

data = load("https://github.com/bmatschke/s-unit-equations/raw/master/elliptic-curve-tables/good-reduction-away-from-first-primes/K_deg_1/js_K_1.1.1.1_S_2_3_5_7_11_13_17_19.sobj")

S = [prod(ZZ(p) for p in fp) for fp in data[1][0][1]]
js = [QQ(j) for j in data[1][0][2]]

from sage.schemes.elliptic_curves.ell_egros import egros_from_j

radNs = prod(S).divisors()

count_js = {radN: 0 for radN in radNs}
#count_curves = {radN: 0 for radN in radNs}

for i,j in enumerate(js):
	if i % 1000 == 0:
		print('i:',i)
	E = EllipticCurve_from_j(j,minimal_twist=True).minimal_model()
	rs = [E.quadratic_twist(d).conductor().radical() 
			for d in [1,-1,2,-2,3,-3,6,-6]]
	radN = gcd(rs)
	assert(radN in rs)
	count_js[radN] += 1
	
	#for E in egros_from_j(j,S):
	#	radN = E.discriminant().radical()
	#	count_curves[radN] += 1
	
#print('count_curves:',count_curves)
print('count_js:',count_js)


count_js_sum = {
	radN: sum(count_js[r] for r in radN.divisors()) 
	for radN in radNs
}
#count_curves_sum = {
#	radN: sum(count_curves[r] for r in radN.divisors()) 
#	for radN in radNs
#}


print('count_js_sum:',count_js_sum)


count_curves_sum = {radN: 0 for radN in radNs}

for radN in radNs:
	cj = count_js_sum[radN]
	w = len(radN.prime_factors())
	if radN % 2 == 0:
		if radN % 3 == 0:
			cc = (cj-2)*2^(w+1) + 2 * 4^w + 2 * 6^w
		else:
			cc = (cj-1)*2^(w+1) + 2 * 4^w
	else:
		if radN % 3 == 0:
			cc = (cj-1)*2^w + 6^w
		else:
			cc = (cj-0)*2^w
	count_curves_sum[radN] = cc


print('count_curves_sum:',count_curves_sum)

#Convert data to numberdb-format:

numbers = {}

for word in Words([0,1],len(S)):
	Sword = [p for wi,p in zip(reversed(word),S) if wi == 1]
	radN = prod(Sword)

	numbers_radN = {}
	numbers_radN['Q'] = {
		'param-latex': '$\mathbb{Q}$',
		'number': str(count_curves_sum[radN]),
	}
	numbers_radN['Qbar'] = {
		'param-latex': '$\overline{\mathbb{Q}}$',
		'number': str(count_js_sum[radN]),
	}

	numbers[str(radN)] = {
		'param_latex': '$\{%s\}$' % (', '.join([str(p) for p in Sword]),),
		'numbers': numbers_radN,
	}
	
filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
