#The abc data is taken from the ABC@HOME project of Bart de Smit:
#
# https://www.math.leidenuniv.nl/~desmit/abc/
#

import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/Number_theory/Abc-triples_of_high_quality'

prec10 = 100 #relative precision in base 10
num_digits_q = 7

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

#First we parse the html files for abc-triples:
abcqs = []
abc_filename = "abc-quality.html"
#abc_filename = "abc-unbeaten.html"
#abc_filename = "abc-merit.html"
#abc_filename = "abc-size.html"
with open(os.path.join(path,abc_filename),"r") as fp:
	for line in fp:
		print("line:",line)
		if line.startswith("<tr>"):
			entries = line.strip().split('<td class="abcnum">')
			entries = entries[-3:]
			#print(len(entries))
			#print(entries)
			abc = []
			ps = []
			for s in entries:
				s = s.replace("<sup>","**")
				s = s.replace("</sup>"," ")
				s = s.replace("&#x200B;"," ")
				s = s.replace("&middot;"," ")
				factors = s.split(" ")
				x = 1
				for f in factors:
					#print(f)
					if f == "":
						continue
					if f == "BIG":
						#We omit the abc-triples where one of the
						#factors is "BIG".
						#This BIG factor can be computed 
						#from a+b=c and the other numbers.
						#However it is not necessarily a prime.
						#Thus computing rad(a*b*c) would require
						#a factorization of BIG, which seems
						#computationally difficult.
						#So for simplicity we omit them from our
						#heuristic.
						#break
						
						f = '0'
					else:
						ipower = f.find('**')
						if ipower == -1:
							prime = f
						else:
							prime = f[:ipower]
						ps.append(ZZ(prime))
					x *= eval(f)
				#print(x)
				#if f == "BIG":
				#	break
				abc.append(x)
			print("abc:",abc)
			if len(abc) == 3:
				a,b,c = abc
				if a+b==c:
					pass
				elif c == 0:
					c = a+b
				elif a == 0:
					a = c-b
				elif b == 0:
					b = c-a
				else:
					print("error in abc:",abc)
					raise
				
				#compute quality:
				BIG = a*b*c
				for p in ps:
					BIG = BIG.prime_to_m_part(p)
				assert(BIG.is_squarefree())
				rad_abc = BIG * prod(ps)
				q = RIF(log(c)/log(rad_abc))
				abcqs.append((a,b,c,q))
				
			#break
#print("abcqs:",abcqs)
print("len(abcqs):",len(abcqs))

#Convert data to numberdb-format:

numbers = {}
q_strs = set()

for a,b,c,q in abcqs:

	q_str = real_interval_to_sage_string(
		RIFprec(q),
		max_digits = num_digits_q,
	).replace('?','')
	q_strs.add(q_str)

	numbers_q = {}
	numbers_q['a'] = {
		'param-latex': '$a$',
		'number': str(a),
	}
	numbers_q['b'] = {
		'param-latex': '$b$',
		'number': str(b),
	}
	numbers_q['c'] = {
		'param-latex': '$c$',
		'number': str(c),
	}

	numbers[q_str] = numbers_q

print('len(q_sts):',len(q_strs))

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
