import yaml
import os
import mpmath

path = 'data/P-adic_numbers/Kubota-Leopoldt_zeta_function_at_integers/'

prec10 = 50 #relative precision in base 10

p_range = prime_range(30)
i_range = [-50..50] 

numbers = {}
for p in p_range:
	print("p:",p)
	numbers_p = {}

	prec_p = ceil(prec10*log(10,p))
	Q_p = Qp(p, prec=prec_p, print_mode='val-unit')
	Q_p_prec = Qp(p, prec=prec_p+20, print_mode='val-unit')

	for i in i_range:
		k = i
		if k == 1:
			#pole
			continue

		number = pari.zeta(pari(Q_p_prec(k).add_bigoh(Q_p_prec.precision_cap())))
		print("p,i,number:",p,i,number)
		number = Q_p(number)
		
		number_str = str(number)
		numbers_p[str(k)] = number_str

	numbers[str(p)] = numbers_p

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
