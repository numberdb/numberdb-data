'''
The following data is extracted from:

  https://physics.nist.gov/cuu/Constants/index.html
  which uses as source: CODATA 2018
  
See also:
- m_e: https://en.wikipedia.org/wiki/Electron_rest_mass
- m_P: https://en.wikipedia.org/wiki/Planck_units
'''

from utils.utils import iterated_union
from utils.utils import number_with_uncertainty_to_real_ball
from utils.utils import real_ball_to_string

#m_e = 9.1093837015(28)×10−31 kg
#m_P = 2.176434(24)×10−8 kg

m_e = number_with_uncertainty_to_real_ball('9.1093837015(28)') * 10^-31
m_P = number_with_uncertainty_to_real_ball('2.176434(24)') * 10^-8

alpha_G = (m_e / m_P)^2

print("alpha_G:",real_ball_to_string(alpha_G,extra_digits=3))

