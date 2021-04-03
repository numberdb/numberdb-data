import yaml
import os
from utils.utils import numbers_to_yaml
from utils.utils import real_interval_to_sage_string

path = 'data/Analysis/Gibbs_constant/'

prec10 = 100 #relative precision in base 10

RIFprec = RealIntervalField(prec10 * 3.4 * 2)

WG = RIFprec(Si(pi))
print('Gp:', real_interval_to_sage_string(WG,prec10).replace('?',''))

G = RIFprec(2/pi) * WG
print('G:', real_interval_to_sage_string(G,prec10).replace('?',''))

print('G-1:', real_interval_to_sage_string(G-1,prec10).replace('?',''))

print('(G-1)/2:', real_interval_to_sage_string((G-1)/2,prec10).replace('?',''))

