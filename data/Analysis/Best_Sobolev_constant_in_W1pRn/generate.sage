import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/Analysis/Best_Sobolev_constant_in_W1pRn'

prec10 = 100 #relative precision in base 10

#p_range = [1..100]
p_range = [a/b for a,b in cartesian_product([[1..24],[1..24]])
			if gcd(a,b) == 1 and a >= b]
q_range = p_range

npq_range = []
for p in p_range:
	for q in q_range:
		if not q > p:
			continue
		n = p*q/(q-p)
		if n not in ZZ:
			continue
		if not n > p:
			continue
		n = ZZ(n)
		npq_range.append((n,p,q))
		
npq_range.sort(key = lambda x: x[1])
npq_range.sort(key = lambda x: x[0])

n_range = sorted(set(n for n,p,q in npq_range))

print("len(npq_range):", len(npq_range))

RIFprec = RealIntervalField(prec10 * 3.4 * 2)
RBFprec = RealBallField(RIFprec.prec())

numbers = {}
for n in n_range:
	numbers_n = {}
	
	for p in p_range:
		if not n > p:
			continue
		q = n*p/(n-p)
		if (n,p,q) not in npq_range:
			continue
			
		#print("n,p,q:",n,p,q)
			
		if p == 1:
			number = RIFprec(pi)^(1/2) * n / RIFprec(gamma(1+n/2))^(1/n)
		else:
			number = RIFprec(pi)^(1/2) * n^(1/p) * ((n-p)/(p-1))^(1-1/p) * \
						(gamma(n/p)*gamma(n+1-n/p)/gamma(n)/gamma(1+n/2))^(1/n)
		
		#print("number:",number)
		
		number_str = real_interval_to_sage_string(
			RIFprec(number),
			max_digits = prec10,
		).replace('?','')

		numbers_n[str(p)] = {str(q): number_str}
	
	if len(numbers_n) > 0:
		numbers[str(n)] = numbers_n

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
