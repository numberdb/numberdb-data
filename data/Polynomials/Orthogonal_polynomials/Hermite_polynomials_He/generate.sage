from utils.utils import numbers_to_yaml
import yaml
import os

path = 'data/Polynomials/Orthogonal_polynomials/Hermite_polynomials_He'

R.<x> = QQ[]


numbers = {int(n): str((hermite(n,x/sqrt(2))*2^(-n/2)).expand()) for n in [0..50]}

filename = os.path.join(path, 'polynomials.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
