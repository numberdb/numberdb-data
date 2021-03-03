import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string

path = 'data/Combinatorics/Bernoulli_numbers/'

numbers = {}
for n in range(100+1):
	b_n = bernoulli(n)
	
	'''
	if b_n == 0:
		numbers[n] = {
			'equals': 'HREF{Zero}[0]',
			'number': str(b_n),
		continue
	'''
	
	numbers[n] = str(b_n)

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(
	numbers, 
	stream = open(filename, 'w'),
	sort_keys = False, 
	#Dumper=yaml.dumper.BaseDumper,
)
