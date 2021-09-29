from utils.utils import numbers_to_yaml
import yaml
import os

path = 'data/Polynomials/Chebyshev_polynomials_of_the_second_kind'

R.<x> = QQ[]

numbers = {int(n): str(chebyshev_U(n,x)) for n in [0..100]}

filename = os.path.join(path, 'polynomials.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
