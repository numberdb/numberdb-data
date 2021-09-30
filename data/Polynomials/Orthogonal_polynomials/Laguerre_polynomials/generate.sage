from utils.utils import numbers_to_yaml
import yaml
import os

path = 'data/Polynomials/Orthogonal_polynomials/Laguerre_polynomials'

R.<x> = QQ[]

numbers = {int(n): str(laguerre(n,x)) for n in [0..50]}

filename = os.path.join(path, 'polynomials.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
