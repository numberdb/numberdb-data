from sage import *
from sage.rings.all import *

import re
import decimal

def number_with_uncertainty_to_real_inverval(N, standard_deviations = 5):
    #Number with uncertainty:
    cNU = re.compile(r'([+-]?)(\d*)((?:\.\d*))((?:\(\d+\)))((?:[eE]-?\d+)?)')

    #Determine type of search term:

    match = cNU.match(N)
    #print('match:', match)
    #print('groups:',match.groups())
    sign,uA,B,U,E = match.groups()
    A = sign + uA
    if B == '':
        B == '.'
    if U == '':
        U = '(0)'
    p = len(B)-1
    ab = int(A + B[1:])
    u = int(U[1:-1])
    radius = u * standard_deviations
    N_lower = str(ab - radius) + E
    N_upper = str(ab + radius) + E
    #print('N_lower:',N_lower)
    #print('N_upper:',N_upper)
    r = RIF(N_lower,N_upper) * RIF(10)**(-p)
    return r

def number_with_uncertainty_to_real_ball(N, standard_deviations = 5):
    #Number with uncertainty:
    cNU = re.compile(r'([+-]?)(\d*)((?:\.\d*))((?:\(\d+\)))((?:[eE]-?\d+)?)')

    #Determine type of search term:

    match = cNU.match(N)
    #print('match:', match)
    #print('groups:',match.groups())
    sign,uA,B,U,E = match.groups()
    A = sign + uA
    if B == '':
        B == '.'
    if U == '':
        U = '(0)'
    if E != '':
        raise NotImplementedError()
    p = len(B)-1
    ab = ZZ(int(A + B[1:])) #first calling int strips trailing zeros
    u = ZZ(int(U[1:-1]))
    radius = u * standard_deviations
    #N_center = str(ab) + E
    #N_radius = str(radius) + E
    #print('N_center:',N_center)
    #print('N_radius:',N_radius)
    r = RBF(ab,radius) * ZZ(10)**(-p)
    return r

def iterated_union(intervals):
    '''
    INPUT: List of real balls or real intervals.
    OUTPUT: The union of the balls or intervals.    
    '''
    result = None
    for r in intervals:
        if result == None:
            result = r
        else:
            result = result.union(r)
    return result

'''
def real_interval_to_string(r):
    return '[%s, %s]' % (r.lower(), r.upper())
'''

def real_interval_to_real_ball(r):
    center = r.center()
    radius = (r-center).abs().upper()
    return RBF(center,radius)

def int_to_string(i,e):
    '''
    Convert i * 10^e to a humanly readable string.    
    '''
    
    if i == 0:
        return '0'
    s = i.__str__()
    l = len((abs(i)).__str__())
    p = l + e #num digits in front of period (with sign)
    if p >= 7 or p <= -5:
        s = s[0] + '.' + s[1:]
        e = e + (l-1)
        result = '%se%s' % (s,e)
    else:
        #Avoid e-notation:
        if p <= 0:
            result = '0.%s%s' % (
                ''.join('0' for k in range(-p)),
                s,
            )
        elif p < l:
            result = s[:p] + '.' + s[p:]
        else:
            result = s + ''.join('0' for k in range(e))
            
    return result

def real_ball_to_string(r,extra_digits=0):
    d = (r.rad_as_ball().log() / RBF(10).log()).upper().ceil() - extra_digits

    rEd = r * RBF(10)**(-d)
    
    center = rEd.center()
    
    a = center.floor()
    b = center.ceil()
    if center-a > b-center:
        a = b

    rad = (rEd-RBF(a)).abs().upper().ceil()
    #print("A,rad,d:",a,rad,d)
    
    '''
    context = decimal.Context(
        prec = int(max(len(abs(a).__str__()),len(abs(rad).__str__())) + extra_digits),
        rounding = decimal.ROUND_UP
    )
    a_dec = decimal.Decimal(int(a),context).shift(int(d))
    rad_dec = decimal.Decimal(int(rad),context).shift(int(d))
    print("a_dec,rad_dec:",a_dec,rad_dec)
    '''
    
    result = '%s +/- %s' % (int_to_string(a,d),int_to_string(rad,d))
    return result
    

def real_interval_to_sage_string(r, max_digits = None):
    '''
    if max_digits != None:
        RIF_r = r.parent()
        r *= RIF_r(1).union(1+RIF_r(10)**(-max_digits))
    return r.__str__()
    '''
    s = r.__str__()
    if not '?' in s:
        return s
    a, e = s.split('?')
    if not '.' in a:
        return s
    a1, f = a.split('.')
    digits_a1 = len(a1.lstrip('-'))
    digits_f = len(f)
    if not digits_f > max_digits - digits_a1:
        return s
    f = f[:(max_digits - digits_a1)]
    result = '%s.%s?%s' % (a1, f, e)
    return result
    
def real_interval_to_pretty_string(r):
    if r.contains_zero():
        #Relative diameter won't make sense, 
        #so just print it normally:
        return r.__str__()

    if r.relative_diameter() < 0.001:
        #Enough relative precision,
        #thus print the number normally:
        return r.__str__()

    else:
        #Not enough relative precision, 
        #thus rather print the number as an interval:
        Rup = RealField(15,rnd='RNDU')
        Rdown = RealField(15,rnd='RNDD')
        return '[%s,%s]' % (Rdown(r.lower()),Rup(r.upper()))

def numbers_to_yaml(numbers):
    '''
    TODO!
    '''
    
    raise NotImplementedError()
    
    def number_to_yaml(r):
        if r.parent() == ZZ:
            return r.__str__()
            
        elif r.parent() == QQ:
            return r.__str__()
        
        elif r.parent() == RIF:
            result = real_interval_to_pretty_string(r)
            if result.startswith('['):
                result = '"%s"' % (result,)
            return result
        
        elif r.parent() == RBF:
            return real_ball_to_string(r)
            
        else:
            print("r:",r)
            raise NotImplementedError()
           

    if isinstance(numbers,list):
        #A list of number without parameters is given:
        result = '\n'.join('- %s' % (number_to_yaml(r),) for r in numbers)
        return result
        
    elif isinstance(numbers,dict):
        #Main case:
        #A dictionary is given, 
        #whose keys are the parameters and
        #whose values are corresponding numbers.
        if len(numbers) == 0:
            return ''
        
        #Read off number of parameters:
        num_params = None
        parsed_numbers = {}
        for param, number in numbers.items():
            parsed_param = tuple(p.strip(' ') for p in str(param).split(","))
            parsed_numbers[parsed_param] = number
            
            if num_params == None:
                num_params = len(parsed_param)
            elif num_params != len(parsed_param):
                raise ValueError("Number of parameters is non-constant.")
                
        def build_yaml(parsed_numbers, prefix = '', num_params_left = num_params):
            if num_params_left == 0:
                result = '%s  %s\n' % (prefix,number_to_yaml(parsed_numbers[()]))
                return result
                
            first_params = [param[0] for param in parsed_numbers]
            for first_param in first_params:
                numbers_rec = {tuple(list(param)[1:]): number for param,number in parsed_numbers if param[0] == first_param}
                result = '%s%s:\n' % (prefix, first_param) 
                result += build_yaml(numbers_rec, prefix+'  ', num_params_left-1)
            return result
        
        result = build_yaml(parsed_numbers)
        return result

    else:
        #Assume a single number is given:
        result = '- %s' % (number_to_yaml(numbers),)
        return result

def string_of_numbers_to_yaml(s, param0 = 'auto'):
    '''
    INPUT: A string (list of numbers with seperator ',', 
            e.g. '-4, -3, -2, -1, 1, 2, 3, 4, 5'.
    OUTPUT: A string in yaml format    
    '''
    
    numbers = [n.strip() for n in s.replace('−','-').split(',')]
    if param0 == 'auto':
        param0 = -ZZ(len([n for n in numbers if n[0] == '-']))
        skip_0 = True
    else:
        skip_0 = False

    result = ''
    for n in numbers:
        if param0 == 0 and skip_0:
            param0 += 1
        result += '%s: %s\n' % (param0, n)
        param0 += 1
    
    return result
