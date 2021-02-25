'''
Data taken from
John D. Barrow, "The Constants of Nature: From Alpha to Omega--the Numbers That Encode the Deepest Secrets of the Universe", 2003.
'''

from utils.utils import iterated_union
from utils.utils import number_with_uncertainty_to_real_ball
from utils.utils import real_ball_to_string


data = '1836.15267343(11)'

mu = number_with_uncertainty_to_real_ball(data)

print("mu:",real_ball_to_string(mu,extra_digits=3))

mu_inv = 1/mu

print("mu_inv:",real_ball_to_string(mu_inv,extra_digits=3))
