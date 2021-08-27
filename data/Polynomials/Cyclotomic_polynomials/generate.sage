from utils.utils import numbers_to_yaml
import yaml
import os

path = 'data/Polynomials/Cyclotomic_polynomials'

numbers = {int(n): str(cyclotomic_polynomial(n)) for n in [1..100]}

filename = os.path.join(path, 'polynomials.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
