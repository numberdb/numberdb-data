#The data is taken from:
#
# - Paper by Bennett--Yazdani
# - LMFDB (Cremona's DB of elliptic curves with N <= 500000):
#   https://lmfdb.org
# - Matschke's elliptic curve tables:
#   https://github.com/bmatschke/s-unit-equations/tree/master/elliptic-curve-tables/bounded-rad2N/K_1.1.1.1*

#Need to install Cremona's db to run script below:
#sage -i database_cremona_ellcurve

import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/Number_theory/Large_Szpiro-ratios_of_elliptic_curves_over_Q'

prec10 = 100 #relative precision in base 10
num_digits_m = 100

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

Es = []

def szpiro_ratio(E):
	D = E.minimal_model().discriminant()
	N = E.conductor()
	return RIFprec(log(D.abs())/log(N))

#Curves from Cremona's DB / LMFDB:

cremona_labels = ['1290h1',
	'9510e1',
	'9690m2',
	'3990ba1',
	'32658b1',
	'858k2',
	'28530v1',
	'128310bw4',
	'3870u1',
	'97974g1',
	'29070bb2',
]

for label in cremona_labels:
	E = EllipticCurve(label).minimal_model()
	Es.append(E)

#Curves from [Bennett-Yazdani]:
	
def E2(a,b):
	return EllipticCurve([0,a,0,b,0])

def E2p(a,b):
	return EllipticCurve([0,-2*a,0,a^2-4*b,0])

def E3(a,b):
	return EllipticCurve([0,a^2/4,b,a*b/2,0])

def E3p(a,b):
	return EllipticCurve([0,a^2/4,b,-9*a*b/2,-b*(a^3+7*b)])

def E5(a,b):
	return EllipticCurve([a-b,-a*b,-a^2*b,0,0])

def E5p(a,b):
	return EllipticCurve([a-b,-a*b,-a^2*b,5*a*b*(a^2-2*a*b-b^2),a*b*(a^4-15*a^3*b+5*a^2*b^2-10*a*b^3-b^4)])

def E7(a,b):
	return EllipticCurve([-(a^2-a*b-b^2),-a^2*b*(a-b),-a^2*b^3*(a-b),0,0])

def E7p(a,b):
	return EllipticCurve([-(a^2-a*b-b^2),-a^2*b*(a-b),-a^2*b^3*(a-b),-5*a*b*(a-b)*(a^2-a*b+b^2)*(a^3+2*a^2*b-5*a*b^2+b^3),-a*b*(a-b)*(a^9+9*a^8*b-37*a^7*b^2+70*a^6*b^3-132*a^5*b^4+211*a^4*b^5-182*a^3*b^6+76*a^2*b^7-18*a*b^8+b^9)])

def E22(a,b):
	return EllipticCurve([0,b-a,0,-a*b,0])

def E22p(a,b):
	return EllipticCurve([0,2*(a+b),0,(a-b)^2,0])

#NOTE: The two curves that are commented out could not be reproduced! (From Bennett--Yazdani)
#Presumably there is a small typo somewhere.

Es.append(E3p(-2*5*107*191, -2^36*29^2*127))
Es.append(E22p(-13*19^6, 2^30*5))
Es.append(E2(-2*1087*3187, 3^17*17^3*19)) #-a instead of a!!!
Es.append(E7p(-3^2, 2))
Es.append(E3p(-2*5*107*191, -2^36*29^2*127).quadratic_twist(-7))
Es.append(E2p(-2^4*5*17^2*2127165978817991, 2^77*17^4*101^2*491))
Es.append(E22p(2^10*5^2*7^15, 3^18*23*2269))
Es.append(E3(-2*5*107*191, -2^36*29^2*127))
Es.append(E22p(-13*19^6, 2^30*5).quadratic_twist(-3))
Es.append(E3p(-2*5*107*191, -2^36*29^2*127).quadratic_twist(13))
Es.append(E3p(2*811*3089, -2^8*41^8*1069))
Es.append(E22p(2^10*5^2*7^15, 3^18*23*2269).quadratic_twist(-3))
Es.append(E3p(-2*5*107*191, -2^36*29^2*127).quadratic_twist(-19))
Es.append(E2p(-2^4*5*17^2*2127165978817991, 2^77*17^4*101^2*491).quadratic_twist(-3))
Es.append(E22p(-2^7*23^8, 19^9*857^2))
#Es.append(E22p(3^22*13*47^2, 2^7*23^8)) #?
Es.append(E22p(-13*19^6, 2^30*5).quadratic_twist(5))
Es.append(E22p(5^14*19, -2^5*3*7^13))
Es.append(E22p(2^10*5^2*7^15, 3^18*23*2269).quadratic_twist(5)) #5 not -5!!!
#Es.append(E3p(2*811*3089, -2^8*41^8*1069).quadratic_twist(29)) #?
Es.append(E2(-2*1087*3187, 3^17*17^3*19).quadratic_twist(-3)) #-a instead of a!!!
Es.append(E22p(-2^4*5^16*97*919, 7^3*29^5*151^2))
Es.append(E22p(2^10*5^2*7^15, 3^18*23*2269).quadratic_twist(-7))

	
#Curve from [Matschke]:

Es.append(EllipticCurve([1,0,1,-42413566018206735,-437446811311705073280446]))

c4c6s = set()
Nc4c6sigmas = []

for E0 in Es:
	E = E0.minimal_model()
	if (E.c4(),E.c6()) in c4c6s:
		continue
	c4c6s.add((E.c4(),E.c6()))
	Nc4c6sigmas.append((
		E.conductor(),
		E.c4(),
		E.c6(),
		szpiro_ratio(E),
	))
	print("szpiro_ratio(E):",RIF(szpiro_ratio(E)))
	#print("E.is_semistable():",E.is_semistable())
	#E2 = EllipticCurve_from_j(E.j_invariant())
	#print("szpiro_ratio(E2):",RIF(szpiro_ratio(E2)))
	

Nc4c6sigmas.sort(key = lambda x: -x[-1])

#Convert data to numberdb-format:

numbers = {}

for N, c4, c6, sigma in Nc4c6sigmas:

	sigma_str = real_interval_to_sage_string(
		RIFprec(sigma),
		max_digits = num_digits_m,
	).replace('?','')

	s = sigma_str[:6]

	numbers_s = {}
	numbers_s['sigma'] = {
		'param-latex': '$\sigma$',
		'number': sigma_str,
	}
	numbers_s['N'] = {
		'param-latex': '$N$',
		'number': str(N),
	}
	numbers_s['c4'] = {
		'param-latex': '$c_4$',
		'number': str(c4),
	}
	numbers_s['c6'] = {
		'param-latex': '$c_6$',
		'number': str(c6),
	}

	numbers[str(s)] = numbers_s
	
assert(len(numbers) == len(Nc4c6sigmas))

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
