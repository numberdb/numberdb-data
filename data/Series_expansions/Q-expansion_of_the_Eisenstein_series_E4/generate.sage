import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string
from utils.utils import blur_real_interval

path = 'data/Series_expansions/Q-expansion_of_the_Eisenstein_series_E4/'

prec10 = 100 #relative precision in base 10
n_max = 1000
n_range = [0..n_max]

print("n_max:",n_max)

prec2 = prec10 * 3.4 + 20
RIFprec = RealIntervalField(prec2)
RBFprec = RealBallField(prec2)

E4_q_expansion = eisenstein_series_qexp(4,n_max+1,normalization='constant')

numbers = {str(n): str(E4_q_expansion[n]) for n in n_range}

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
