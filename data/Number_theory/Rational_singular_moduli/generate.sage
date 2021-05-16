import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string
from utils.utils import blur_real_interval

path = 'data/Number_theory/Rational_singular_moduli/'

prec10 = 100 #relative precision in base 10

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

Delta_js = [(d*f^2, j) for d, f, j in cm_j_invariants_and_orders(QQ)]
Delta_js.sort(key = lambda x: x[0])

numbers = {str(Delta): str(j) for Delta, j in Delta_js}

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
