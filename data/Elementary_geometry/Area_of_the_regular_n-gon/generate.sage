import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string

path = 'data/Elementary_geometry/Area_of_a_regular_n-gon/'

prec10 = 100 #relative precision in base 10
n_max = 100
n_range = [3..n_max]

print("n_max:",n_max)

RIFprec = RealIntervalField(prec10 * 3.4 * 1.3)


numbers = {}
formulas = {
  's': lambda n: n/4 * cot(pi/n),
  'R': lambda n: n/2 * sin(2*pi/n),
  'r': lambda n: n   * tan(pi/n),
}

for unit in ['s','R','r']:
	expression_label = 'unit-%s' % (unit,)
	expression_latex = '$%s = 1$' % (unit,)

	numbers_unit = {}
	for n in n_range:
		number = RIFprec(formulas[unit](n))
		n_str = str(n)
		numbers_unit[n_str] = real_interval_to_sage_string(
			number,
			max_digits = prec10,
		).replace('?','')

	'''		
		if expression == 'a_n/n!' and n == 0:
			#number already appears as a_0: 
			numbers_expression[n_str] = {
				'equals': 'HREF{#a_n,0}',
				'number': numbers_expression[n_str],
			}
	'''
		 
	numbers[expression_label] = {
		'param-latex': expression_latex,
		'numbers': numbers_unit,
	}

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
