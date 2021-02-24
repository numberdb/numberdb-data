import yaml

from utils.utils import real_interval_to_sage_string

path = 'data/Special_values/Special_values_of_the_Gamma_function/'

prec10 = 100 #relative precision in base 10
r = 30
b_range = [1..r]
a_range = [-r..r]

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

"""
def real_to_string(x, prec10=prec10):
	'''
	INPUT:
	  x: element of some RealIntervalField or RealBallField
	  prec10: a positive integer
	  
	OUTPUT:
	  A string of a decimal number with prec10+1 digits, only 
	  the last of which may be off by 1.
	'''
	
	RIF = RealIntervalField(x.prec()) 
	ri = RIF(x)
	
	if ri.contains_zero:
		#Check whether ri is exactly zero.
		if ri.is_exact():
			return '0'
		raise NotImplementedError()

	#Compute number of digits of x before comma:
	d = (log(abs(ri))/log(RIF(10))).upper().floor()
	if not ri.diameter() < RIF(10)^(d-prec10):
		raise ValueError("Input value has not enough precision.")
	s = str(ri)
	if "?" not in s:
		
		
	s1, power = s.split("?")
"""	
	

for b in b_range:
  print("  %s: INPUT{numbers_%s.yaml}" % (b,b))

for b in b_range:
	filename_b = "numbers_%s.yaml" % (b,)
	with open(path + filename_b,"w") as f:
		#print('f:',f)
		for a in a_range:
			if gcd(a,b) != 1:
				continue
			if b == 1 and a <= 0:
				continue
			x = RIFprec(a)/RIFprec(b)
			n = gamma(x)
			#print("n:",n)
			n_str = real_interval_to_sage_string(n,max_digits = prec10).replace('?','')			
			f.write("%s: %s\n" % (a,n_str))
			
