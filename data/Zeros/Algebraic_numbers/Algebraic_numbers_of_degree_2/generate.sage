import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string
from utils.utils import complex_interval_to_sage_string


path = 'data/Zeros/Algebraic_numbers/Algebraic_numbers_of_degree_2'

prec10 = 100 #relative precision in base 10

mpmath.mp.dps = prec10 * 1.5

n_max = 5
as_range = cartesian_product([
	[1..n_max],
	[-n_max..n_max],
	[-n_max..n_max]
]) 
R.<x> = ZZ[]

RIFprec = RealIntervalField(prec10 * 3.4 * 1.3)
CIFprec = ComplexIntervalField(RIFprec.prec())

numbers = {}

for a2, a1, a0 in as_range:
	f = a2*x^2 + a1*x + a0
	if not f.is_irreducible():
		continue
	print("f:",f)
	
	f_str = "%s, %s, %s" % (a2, a1, a0)

	numbers_f = {}
	if f.disc() < 0:
		#complex roots, order by imaginary part:
		roots = f.roots(CIFprec,multiplicities=False)
		roots.sort(key = lambda root: root.imag())
	else:
		#real roots, order by real part:
		roots = f.roots(RIFprec,multiplicities=False)
		roots.sort(key = lambda root: root.real())

	for n0, root in enumerate(roots):
		n = n0 + 1 #shift index, such that 1 <= n <= deg(f)
		number_str = complex_interval_to_sage_string(
			root,
			max_digits = prec10,
		).replace('?','')
		
		numbers_f[str(n)] = number_str

	numbers[f_str] = numbers_f

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
