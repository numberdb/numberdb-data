from utils.utils import numbers_to_yaml
import yaml
import os

path = 'data/Polynomials/Orthogonal_polynomials/Gegenbauer_polynomials'

R.<x,a> = QQ[]

alphas = [(n-2)/2 for n in [0..10]]
alphas += [n/3 for n in [-3..3]]
alphas += [n/4 for n in [-4..4]]
alphas = [a] + sorted(list(set(alphas)))

numbers = {
    int(alpha) if alpha in ZZ else str(alpha): {
        int(n): str(gegenbauer(n,alpha,x)) 
        for n in [0..20]
        if (alpha != 0 or n <= 1) 
           and (alpha != -1 or n <= 3)
           and (alpha != a or n <= 15)
    }
    for alpha in alphas
}

numbers['1/2'] = {
  'equals': 'HREF{Legendre_polynomials}',
  #'comment': '...',
}

numbers[int(1)] = {
  'equals': 'HREF{Chebyshev_polynomials_of_the_second_kind}',
  #'comment': '...',
}

filename = os.path.join(path, 'polynomials.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
