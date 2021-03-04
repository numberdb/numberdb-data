import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string

path = 'data/Series_expansions/Taylor_coefficients_of_completed_Riemann_zeta_function_at_1_over_2/'

prec10 = 100 #relative precision in base 10
n_max = 30
n_range = [0..n_max]

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

#xi(s) = 1/2 * s*(s-1)*pi^(-s/2)*gamma(s/2)*zeta(s)

s = var('s')
s0 = 1/2
xi_factors = (
	1/2 * s,
	zeta(s) * (s-1), #remove pole for simplicity
	pi^(-s/2),
	gamma(s/2),
)
P = PowerSeriesRing(RIFprec,'t')
'''
series_factors = [
	P([
		RIFprec(f.derivative(s,n)(s=s0)) / n.factorial()
			for n in n_range
	]).add_bigoh(n_max+1)	
	for f in xi_factors
]'''
series_factors = []
for f in xi_factors:
	print("f:",f)
	series_factors.append(
		P([
		RIFprec(f.derivative(s,n)(s=s0)) / n.factorial()
			for n in n_range
		]).add_bigoh(n_max+1)
	)
	
series = prod(series_factors)
assert(all(series[n].contains_zero() for n in n_range if n % 2 == 1))
coeffs = [series[n] if n % 2 == 0 else 0 for n in n_range]
ans = [coeff * ZZ(n).factorial() for n, coeff in enumerate(coeffs)]

numbers = {}

for expression in ['a_n', 'a_n/n!']:
	expression_latex = '$%s$' % (expression,)
	numbers_expression = {}
	for n in n_range:
		if expression == 'a_n':
			number = ans[n]
		else:
			number = coeffs[n]
		n_str = str(n)
		numbers_expression[n_str] = real_interval_to_sage_string(
			number,
			max_digits = prec10,
		).replace('?','')
		
		if expression == 'a_n/n!' and n == 0:
			#number already appears as a_0: 
			numbers_expression[n_str] = {
				'equals:': 'HREF{#a_n,0}',
				'number:': numbers_expression[n_str],
			}
			 
	numbers[expression] = {
		'param-latex': expression_latex,
		'numbers': numbers_expression,
	}

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
