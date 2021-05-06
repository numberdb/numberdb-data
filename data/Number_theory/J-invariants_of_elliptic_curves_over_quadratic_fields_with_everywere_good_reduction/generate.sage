#The table of j-invariants of elliptic curves was taken from:
#
# https://github.com/bmatschke/s-unit-equations/blob/master/elliptic-curve-tables/good-reduction-away-from-first-primes/K_deg_1/js_K_1.1.1.1_S_2_3_5.sobj
#

import yaml
import os
import mpmath
from utils.utils import numbers_to_yaml
from utils.utils import complex_interval_to_sage_string

path = 'data/Number_theory/J-invariants_of_elliptic_curves_over_quadratic_fields_with_everywere_good_reduction'

prec10 = 100 #relative precision in base 10

RIFprec = RealIntervalField(prec10 * 3.4 * 2)
CIFprec = ComplexIntervalField(RIFprec.prec())

data = load(os.path.join(path,'curves_deg_2_Dmax_20000*.sobj'))[1]

numbers = {}
js = set()
R.<x> = QQ[x]

for K_str, Es_str in data:
    f = R(K_str[3])
    K.<theta_K> = NumberField(f)
    
    D = K.discriminant()
    print('D:',D)
    K_to_C = K.complex_embeddings(prec=CIFprec.prec()*2)[0]
    
    if D > 20000:
        continue
        
    numbers_D = []
    
    for c4_str, c6_str in Es_str:
        c4 = K(c4_str)
        c6 = K(c6_str)

        E = EllipticCurve_from_c4c6(c4,c6)
        j = E.j_invariant()
        #print("j.norm():",j.norm())
        #js.append(j)
        if j in QQ:
            j = QQ(j)
        if j in js:
            continue
        js.add(j)
        
        if j in QQ:
            number_str = str(j)
        else:
            print("j:",j)
            number_str = complex_interval_to_sage_string(
                CIFprec(K_to_C(j)),
                max_digits = prec10,
            ).replace('?','')
        
        numbers_D.append(number_str)

    if numbers_D != []:
        numbers[str(D)] = numbers_D
        

filename = os.path.join(path, 'numbers.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = True) #sorted keys!!!
