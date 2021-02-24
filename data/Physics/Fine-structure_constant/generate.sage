'''
The following data is extracted from:
  WikiMeas:
    title: "Wikipedia: History_of_measurements"
    url: https://en.wikipedia.org/wiki/Fine-structure_constant#History_of_measurements
'''

from utils.utils import iterated_union
from utils.utils import number_with_uncertainty_to_real_ball
from utils.utils import real_ball_to_string


data = [
('0.0072973525664(17)','137.035999139(31)','CODATA 2014'),
('0.0072973525657(18)','137.035999150(33)','Aoyama et al. 2017'),
('0.0072973525713(14)','137.035999046(27)','Parker et al. 2018'),
('0.0072973525693(11)','137.035999084(21)','CODATA 2018'),
('0.0072973525628(6)','137.035999206(11)','Morel et al. 2020'),
]

alpha = iterated_union(number_with_uncertainty_to_real_ball(a)
                                        for a, a_inv, reference in data)
print("alpha:",real_ball_to_string(alpha,extra_digits=3))

alpha_inv = iterated_union(number_with_uncertainty_to_real_ball(a_inv)
                                        for a, a_inv, reference in data)
print("alpha_inv:",real_ball_to_string(alpha_inv,extra_digits=3))
