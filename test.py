import numpy as np
import matplotlib.pyplot as plt

a = [1 for _ in range(20)]
k = np.kaiser(20, beta=10)
print(a * k)
