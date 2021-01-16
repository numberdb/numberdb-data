import yaml

r = 30
b_range = [2..r]
a_range = [-r..r]

for b in b_range:
  print("  %s: INPUT{numbers_%s.yaml}" % (b,b))
