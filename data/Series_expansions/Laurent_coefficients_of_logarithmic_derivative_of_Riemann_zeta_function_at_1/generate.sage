#References:
#[0] M.W. Coffey, Relations and positivity results for the derivatives of the Riemann ξ function. J. Comput. Appl. Math., 166, 525-534 (2004)
#[1] B. Connon "A recurrence relation for the Li/Keiper constants in terms of the Stieltjes constants"

import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string
from utils.utils import blur_real_interval

path = 'data/Series_expansions/Laurent_coefficients_of_logarithmic_derivative_of_Riemann_zeta_function_at_1/'

prec10 = 100 #relative precision in base 10
n_max = 500
n_range = [0..n_max]

print("n_max:",n_max)

RIFprec = RealIntervalField(prec10 * 3.4 * 5)

#xi(s) = 1/2 * s*(s-1)*pi^(-s/2)*gamma(s/2)*zeta(s)

psi_n_3o2 = {}
for n in n_range:
	psi_n_3o2[n] = RIFprec(psi(n,3/2))

print("finished computing psi's")

binom = {}
for n in n_range:
	binom[n,0] = RIFprec(1)
	binom[n,n] = RIFprec(1)
for n in [1..n_max]:
	for k in [1..n-1]:
		binom[n,k] = binom[n-1,k-1] + binom[n-1,k]

print("finished computing pascal's triangle")

fact = {0: 1}
for n in n_range:
	if n>=1:
		fact[n] = n*fact[n-1]

print("finished computing factorials")

stiel = {}
for n in n_range:
	print("n:",n)
	stiel[n] = RIFprec(blur_real_interval(RIFprec(stieltjes(n).n(RIFprec.prec()+10))))
	#Blurring is done as stieltjes(n).n() might return an integer,
	#which is then interpreted by RIFprec as exact, 
	#which is wrong (though probably not an issue, but let's just be safe).

print("finished computing Stieltjes constants")

lamda = {}
eta = {}

for n in n_range:
	'''
	#(3.35) of [1]:
	lamda[n] = RIFprec(1/2*n*(euler_gamma-2*log(2)+2-log(pi)) + \
		sum(
			binom[n,j] / fact[j-1] *
			(1/2^j * psi_n_3o2[j-1] - fact[j-1]*eta[j-1])
			for j in range(2,n+1)
		)
	)
	'''

	#[0], see also (4.5) of [1]:
	eta[n] = (-1)^(n+1)*(n+1)/fact[n] * stiel[n] + \
		(-1)^(n+1) * sum( 
			(-1)^(k+1)/fact[n-k-1]*stiel[n-k-1] * eta[k]
			for k in range(n)
		)
		
numbers = {}

for expression in ['eta_n', 'eta_n/n']:
	expression_latex = '$\%s$' % (expression,)

	numbers_expression = {}
	for n in [-1] + n_range:
		n_str = str(n)

		if expression == 'eta_n':
			if n == -1:
				number = RIFprec(1)
			else:
				number = eta[n]	
		elif expression == 'eta_n/n':
			if n <= 0:
				continue
			number = eta[n]/n
		else:
			raise RuntimeError()
		
		numbers_expression[n_str] = real_interval_to_sage_string(
			number,
			max_digits = prec10,
		).replace('?','')

		if expression == 'eta_n/n' and n == 1:
			numbers_expression[n_str] = {
				'number': numbers_expression[n_str],
				'equals': 'HREF{#eta_n,1}',
			}
			
	numbers[expression] = {
		'param-latex': expression_latex,
		'numbers': numbers_expression,
	}

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
