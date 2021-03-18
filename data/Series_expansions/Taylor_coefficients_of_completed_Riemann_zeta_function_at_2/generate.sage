import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string

path = 'data/Series_expansions/Taylor_coefficients_of_completed_Riemann_zeta_function_at_2/'

prec10 = 100 #relative precision in base 10
n_max = 250
n_range = [0..n_max]

print("n_max:",n_max)

RIFprec = RealIntervalField(prec10 * 3.4 * 10)

#xi(s) = 1/2 * s*(s-1)*pi^(-s/2)*gamma(s/2)*zeta(s)
#We will compute separate series for each factor:
#For zeta we use sage's algorithm, which is based on mpmath.
#For gamma we use a formula by Masayuki Ui that uses Bell polynomials.
#Sage's implementation of Bell polynomials is slow for large parameters.
#Instead we use a recurrence relation for Bell polynomials,
#which we use for their evaluations at the arguments we are interested in. 
#(Computing these Bell polynomials explicitly would require too much memory.)

s = var('s')
s0 = 2 #avoid the pole by taking s0=0 instead of s0=1.
xi_factors = (
	1/2 * s,
	zeta(s),
	s-1,
	pi^(-s/2),
	gamma(s/2),
)
P.<t> = PowerSeriesRing(RIFprec)

'''
RX = PolynomialRing(QQ,'x',n_max)
bell = {}
for n in n_range:
	if n == 0:
		bell[0,0] = RX(1)
	else:
		bell[n,0] = RX(0)
		bell[0,n] = RX(0)
for n in [1..n_max]:
	for k in [1..n]:
		print("n,k:",n,k)
		bell[n,k] = sum(
			binomial(n-1,i-1)*RX.gen(i-1)*bell[n-i,k-1]
			for i in [1..n-k+1]
		)

print('finished computing bell polynomials')
'''

psi_n_s0_over_2 = [
	RIFprec(psi(n,s0/2))
	for n in n_range
]

print('finished computing psi(n,s0/2)')

binom = {}
for n in n_range:
	binom[n,0] = RIFprec(1)
	binom[n,n] = RIFprec(1)
for n in [1..n_max]:
	for k in [1..n-1]:
		binom[n,k] = binom[n-1,k-1] + binom[n-1,k]

print("finished computing pascal's triangle")

bell_evaluated = {}
for n in n_range:
	if n == 0:
		bell_evaluated[0,0] = RIFprec(1)
	else:
		bell_evaluated[n,0] = RIFprec(0)
		bell_evaluated[0,n] = RIFprec(0)
for n in [1..n_max]:
	for k in [1..n]:
		print("n,k:",n,k)
		bell_evaluated[n,k] = sum(
			binomial(n-1,i-1)*psi_n_s0_over_2[i-1]*bell_evaluated[n-i,k-1]
			for i in [1..n-k+1]
		)

series_gamma_s0_over_2 = P([
	gamma(s0/2) * sum(
		#RX(bell_polynomial(n,k))(psi_n_s0_over_2[:n]+[0 for i in range(n,n_max)])
		bell_evaluated[n,k]
		for k in [0..n]
	) / n.factorial()
		for n in n_range
]).add_bigoh(n_max+1)

print('finished computing series of gamma')

series_factors = []
for f in xi_factors:
	print("f:",f)
	if f == gamma(s/2):
		#d^n/dx^n (g(c*x)) |x=x0 = c^n d^n/dy^n g(y) |y=c*x0 
		sf = P([
			series_gamma_s0_over_2[n] / 2^n
				for n in n_range
		]).add_bigoh(n_max+1)
	else:
		sf = P([
			RIFprec(f.derivative(s,n)(s=s0)) / n.factorial()
				for n in n_range
		]).add_bigoh(n_max+1)
	series_factors.append(sf)


	
series = prod(series_factors)
coeffs = [series[n] for n in n_range]
ans = [coeff * ZZ(n).factorial() for n, coeff in enumerate(coeffs)]

numbers = {}

for expression in ['a_n', 'a_n/n!']:
	expression_latex = '$%s$' % (expression,)
	numbers_expression = {}
	for n in n_range:
		if expression == 'a_n':
			number = ans[n]
		else:
			#if n > 100:
			#	continue
			number = coeffs[n]
		n_str = str(n)
		numbers_expression[n_str] = real_interval_to_sage_string(
			number,
			max_digits = prec10,
		).replace('?','')
		
		if expression == 'a_n/n!' and n == 0:
			#number already appears as a_0: 
			numbers_expression[n_str] = {
				'equals': 'HREF{#a_n,0}',
				'number': numbers_expression[n_str],
			}
			 
	numbers[expression] = {
		'param-latex': expression_latex,
		'numbers': numbers_expression,
	}

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
