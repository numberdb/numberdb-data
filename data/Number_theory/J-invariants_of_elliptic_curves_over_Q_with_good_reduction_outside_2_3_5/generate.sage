#The table of j-invariants of elliptic curves was taken from:
#
# https://github.com/bmatschke/s-unit-equations/blob/master/elliptic-curve-tables/good-reduction-away-from-first-primes/K_deg_1/js_K_1.1.1.1_S_2_3_5.sobj
#

import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string
from utils.utils import blur_real_interval

path = 'data/Number_theory/J-invariants_of_elliptic_curves_over_Q_with_good_reduction_outside_2_3_5'

prec10 = 100 #relative precision in base 10

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

js = load(os.path.join(path,'js_K_1.1.1.1_S_2_3_5.sobj'))[1][0][2]

numbers = list(str(j) for j in js)


filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
