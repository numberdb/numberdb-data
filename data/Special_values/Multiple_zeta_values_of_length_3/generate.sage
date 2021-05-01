import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string

path = 'data/Special_values/Multiple_zeta_values_of_length_3/'

prec10 = 100 #relative precision in base 10
s1_range = [2..10]
s2_range = [1..10]
s3_range = [1..10]

RIFprec = RealIntervalField(prec10 * 3.4 * 1.3)


numbers = {}

for s1 in s1_range:
	
	numbers_s1 = {}

	for s2 in s2_range:
		
		numbers_s1s2 = {}
	
		for s3 in s3_range:
			number = Multizeta(s3,s2,s1) #Note: Different convention!
			number = RIFprec(number.numerical_approx(prec=RIFprec.prec()))

			number_str = real_interval_to_sage_string(
				number,
				max_digits = prec10,
			).replace('?','')

			numbers_s1s2[str(s3)] = number_str

		numbers_s1[str(s2)] = numbers_s1s2

	numbers[str(s1)] = numbers_s1

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
