#The abc data is taken from the ABC@HOME project of Bart de Smit:
#
# https://www.math.leidenuniv.nl/~desmit/abc/
#

import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string


path = 'data/Number_theory/Abc-triples_of_high_merit'

prec10 = 100 #relative precision in base 10
num_digits_m = 14

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

#First we parse the html files for abc-triples:
abcms = []
#abc_filename = "abc-quality.html"
#abc_filename = "abc-unbeaten.html"
abc_filename = "abc-merit.html"
#abc_filename = "abc-size.html"
with open(os.path.join(path,abc_filename),"r") as fp:
	for line_index, line in enumerate(fp):
		print("line:",line)
		print("line_index:",line_index)
		if line.startswith("<tr>"):
			entries = line.strip().split('<td class="abcnum">')
			entries = entries[-3:]
			#print(len(entries))
			#print(entries)
			abc = []
			ps = []
			BIG_exponent = 1
			for s in entries:
				s = s.replace("<sup>","**")
				s = s.replace("</sup>"," ")
				s = s.replace("&#x200B;"," ")
				s = s.replace("&middot;"," ")
				s = s.replace("BIG **","BIG**")
				factors = s.split(" ")
				x = 1
				for f in factors:
					print(f)
					if f == "":
						continue
					if f.startswith("BIG"):
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
						
						ipower = f.find('**')
						if ipower != -1:
							BIG_exponent = ZZ(f[ipower+2:])
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
				if BIG > 1:
					print("BIG:",BIG)
				BIG = ZZ(BIG^(1/BIG_exponent))
				if BIG > 1:
					print("BIG:",BIG)
				#if BIG.is_square():
				#	BIG = ZZ(sqrt(BIG))
				#assert(BIG.is_perfect_power())

				reliable_m = False
				try:
					alarm(1)
					BIG = BIG.radical()
					reliable_m = True
				except AlarmInterrupt:
					pass
				cancel_alarm()

				#BIG = BIG.squarefree_part()
				rad_abc = RIF(BIG * prod(ps))
				q = RIF(log(c)/log(rad_abc))
				m = (q-1)^2*log(rad_abc)*log(log(rad_abc))
				abcms.append((a,b,c,m,reliable_m))
				
			#break
#print("abcms:",abcms)
print("len(abcms):",len(abcms))

#Convert data to numberdb-format:

numbers = {}

for a,b,c,m,reliable_m in abcms:

	m_str = real_interval_to_sage_string(
		RIFprec(m),
		max_digits = num_digits_m,
	).replace('?','')
	if not reliable_m:
		m_str += "*"

	numbers_m = {}
	numbers_m['a'] = {
		'param-latex': '$a$',
		'number': str(a),
	}
	numbers_m['b'] = {
		'param-latex': '$b$',
		'number': str(b),
	}
	numbers_m['c'] = {
		'param-latex': '$c$',
		'number': str(c),
	}

	numbers[m_str] = numbers_m


filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
