#The table of elliptic curves was taken from the LMFDB (originally computed by Cremona):
#
# https://lmfdb.org
#
'''
#To extract MW-bases from the LMFDB, we could run on LMFBD's server legendre
#the following sage script:

from lmfdb import db
Es = list(db.ec_curves.search({'conductor':{'$lte':6000},'rank':2}))
EsMW = list(db.ec_mwbsd.search({'conductor':{'$lte':6000},'ngens':2}))
'''

import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string
from utils.utils import blur_real_interval

path = 'data/Number_theory/Regulators_of_elliptic_curves_over_Q_of_rank_2'

prec10 = 100 #relative precision in base 10

RIFprec = RealIntervalField(prec10 * 3.4 * 2)


#load curves into global variable 'data':
load(os.path.join(path,'ec_Nmax_6000_rank_2.sage')) 

Es = [EllipticCurve(a_invs).minimal_model() for a_invs in data]
Es.sort(key = lambda E: E.cremona_label())
Es.sort(key = lambda E: E.conductor())

Ns = sorted(set(E.conductor() for E in Es))
lmfdb_url = 'https://www.lmfdb.org/EllipticCurve/Q/{}'

numbers = {str(N): {} for N in Ns}

for E in Es:

	N = E.conductor()
	N_str = str(N)
	c4, c6 = E.c_invariants()
	c4c6_str = '%s, %s' % (c4,c6)
	
	
	number = E.regulator(proof=True,precision = RIFprec.prec())

	number_str = real_interval_to_sage_string(
		blur_real_interval(RIFprec(number)),
		max_digits = prec10,
	).replace('?','')

	numbers[N_str][c4c6_str] = {
		'number': number_str,
		'comment': 'HREF{%s}[Curve in LMFDB]' % (lmfdb_url.format(E.cremona_label()),),
	}

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
