import yaml

prec10 = 100 #relative precision)
r = 30
b_range = [2..r]
a_range = [-r..r]

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
		#We could check whether ri is exactly zero.
		raise NotImplementedError()
	#Compute number of digits of x before comma:
	d = (log(abs(ri))/log(RIF(10))).upper().floor()
	if not ri.diameter() < RIF(10)^(d-prec10):
		raise ValueError("Input value has not enough precision.")
	s = str(ri)
	if "?" not in s:
		
		
	s1, power = s.split("?")
	
	

for b in b_range:
  print("  %s: INPUT{numbers_%s.yaml}" % (b,b))

for b in b_range:
	filename_b = "numbers_%b" % (b,)
	with open(filename_b,"w") as f:
		for a in a_range:
			
			print("%s: %s" % (a,n_str))
			
