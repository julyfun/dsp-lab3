import numpy as np
import matplotlib.pyplot as plt


a = np.array((1, 2, 3, 4, 10))
idx = np.where(a > 2)
print(a[idx])
