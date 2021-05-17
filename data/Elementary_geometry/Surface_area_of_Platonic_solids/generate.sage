import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string

path = 'data/Elementary_geometry/Surface_area_of_Platonic_solids/'

prec10 = 100 #relative precision in base 10
n_max = 100
n_range = [3..n_max]

print("n_max:",n_max)

RIFprec = RealIntervalField(prec10 * 3.4 * 1.3)


numbers = {}

phi = (1+sqrt(5))/2
xi = sqrt((5-sqrt(5))/2)

solids = {
  'tetrahedron': {
    'a': 2,
    'r': 1/sqrt(6),
    r'\rho': 1/sqrt(2),
    'R': sqrt(3/2),
    'A': 4*sqrt(3),
    'V': sqrt(8)/3,
  },
  'cube': {
    'a': 2,
    'r': 1,
    r'\rho': sqrt(2),
    'R': sqrt(3),
    'A': 24,
    'V': 8,
  },
  'octahedron': {
    'a': 2,
    'r': sqrt(2/3),
    r'\rho': 1,
    'R': sqrt(2),
    'A': 8*sqrt(3),
    'V': sqrt(128)/3,
  },
  'dodecahedron': {
    'a': 2,
    'r': phi^2/xi,
    r'\rho': phi^2,
    'R': sqrt(3)*phi,
    'A': 12*sqrt(25+10*sqrt(5)),
    'V': 20*phi^3/xi^2,
  },
  'icosahedron': {
    'a': 2,
    'r': phi^2/sqrt(3),
    r'\rho': phi,
    'R': xi*phi,
    'A': 20*sqrt(3),
    'V': 20*phi^2/3,
  },
}

dimension = {
  'a': 1,
  'r': 1,
  r'\rho': 1,
  'R': 1,
  'A': 2,
  'V': 3,
}

for unit in ['a','r',r'\rho','R','V']:
	expression_label = 'unit-%s' % (unit.strip('\\'),)
	expression_latex = '$%s = 1$' % (unit,)

	numbers_unit = {}
	for solid, formulas in solids.items():
		number = RIFprec(formulas['A']) / RIFprec(formulas[unit])^RIFprec(dimension['A']/dimension[unit])
		#number = formulas['A'] / formulas[unit]^(dimension['A']/dimension[unit])
		#number = RIFprec(number)
		
		if solid == 'cube' and unit == r'\rho':
		    number = 12
		elif solid == 'cube' and unit == 'R':
		    number = 8
		elif solid == 'cube' and unit == 'V':
		    number = 6
		
		
		print('number:',number)
		
		numbers_unit[solid] = real_interval_to_sage_string(
			number,
			max_digits = prec10,
		).replace('?','')

	'''		
		if ...:
			numbers_unit[n_str] = {
				'equals': 'HREF{Zero}',
				'number': numbers_expression[n_str],
			}
	'''
		 
	numbers[expression_label] = {
		'param-latex': expression_latex,
		'numbers': numbers_unit,
	}

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
