from utils.utils import numbers_to_yaml
import yaml
import os

path = 'data/Combinatorics/Factorial/'

numbers = {int(n): int(n.factorial()) for n in [0..100]}

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
