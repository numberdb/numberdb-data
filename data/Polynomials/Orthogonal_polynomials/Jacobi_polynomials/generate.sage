from utils.utils import numbers_to_yaml
import yaml
import os

path = 'data/Polynomials/Orthogonal_polynomials/Jacobi_polynomials'

#R.<x,a,b> = QQ[]
a,b,x = var('a b x')

alphas = [a] + [n/2 for n in [-1..4]]
betas = [b] + [n/2 for n in [-1..4]]

numbers = {}

for alpha in alphas[:-1]: #skip the last one
    i_alpha = int(alpha) if alpha in ZZ else str(alpha)    
    numbers[i_alpha] = {}

    if alpha == a:
         numbers[i_alpha][i_alpha] = {
          'equals': 'HREF{Gegenbauer_polynomials}',
          #'comment': '...',
        }

    for beta in betas:
        if alpha != a and beta == b:
            continue #break symmetry
        if alpha != a and beta != b and beta <= alpha:
            continue #break symmetry
        i_beta = int(beta) if beta in ZZ else str(beta)
        numbers[i_alpha][i_beta] = {}

        for n in [0..10]:
            if alpha == a or beta == b:
                if n > 5:
                    continue #restrict data
            
            P = jacobi_P(n,alpha,beta,x)
            numbers[i_alpha][i_beta][str(n)] = str(P)


filename = os.path.join(path, 'polynomials.yaml')
yaml.dump(numbers, stream = open(filename, 'w'), sort_keys = False)
