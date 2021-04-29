import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string
from utils.utils import complex_interval_to_sage_string

path = 'data/Combinatorics/Generalized_Bernoulli_numbers/'

q_range = [1..11]
k_range = [0..40]

prec10 = 100 #relative precision in base 10
RIFprec = RealIntervalField(prec10 * 3.4 * 1.3)
CIFprec = ComplexIntervalField(RIFprec.prec())

numbers = {}
for q in q_range:

	numbers_q = {}

	D = DirichletGroup(q)
	chis = [chi for chi in D]
	chis.sort(key = lambda chi: chi.conrey_number())
	for chi in chis:

		if q == 1:
			numbers_q['1'] = {
				'equals': 'HREF{Bernoulli_numbers}',
				'comment': '$\chi = 1$',
			}
			continue

		numbers_qn = {}

		n = chi.conrey_number()

		for k in k_range:
		
			b_k_chi = chi.bernoulli(k)
			if not b_k_chi in QQ:
				b_k_chi = CIFprec(b_k_chi)
				print("b_k_chi:",b_k_chi)
				b_k_chi = complex_interval_to_sage_string(
					b_k_chi,
					max_digits = prec10,
				).replace('?','')
			
			'''
			if b_n == 0:
				numbers[n] = {
					'equals': 'HREF{Zero}[0]',
					'number': str(b_n),
				continue
			'''
			
			numbers_qn[str(k)] = str(b_k_chi)

		numbers_q[str(n)] = numbers_qn

	numbers[str(q)] = numbers_q

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(
	numbers, 
	stream = open(filename, 'w'),
	sort_keys = False, 
	#Dumper=yaml.dumper.BaseDumper,
)
