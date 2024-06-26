#set page(paper: "us-letter")
#set heading(numbering: "1.a.1.")
#set figure(numbering: "1")

// 这是注释
#figure(image("pic/sjtu.png", width: 50%), numbering: none) \ \ \

#align(center, text(17pt)[
  *Digital Signal Processing - Lab3* \ \
  #table(
      columns: 2,
      stroke: none,
      rows: (2.5em),
      // align: (x, y) =>
      //   if x == 0 { right } else { left },
      align: (right, left),
      [Name:], [Junjie Fang],
      [Student ID:], [521260910018],
      [Date:], [2024/4/8],
      [Score:], [],
    )
])

#pagebreak()

#set page(header: align(right)[
  DSP Lab3 Report - Junjie FANG
], numbering: "1")

#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  strong(it)
}

_Source Code_: #link("https://github.com/julyfun/dsp-lab3")

#outline(indent: 1.5em)

= Functions for Filter

==

The code for `pzmap()` function is in the appendix. We can plot its poles and zeros as below:

#figure(image("pic/1.a.png", width: 50%))

The pole is at $(0.5 + 0j)$, the zero is $(-1.5 + 0j)$. This filter system is *stable*, because the only pole is inside the unit circle.

==

`freqz()` function can be seen in the code below. We hereby draw the *modulus* and *phase* for the frequency response of the filter:

#figure(image("pic/1.b.1.png", width: 80%))
#figure(image("pic/1.b.2.png", width: 80%))

==

The I/O difference equation for $H(z) = Y(z) / X(z) = (sum_(i = 1)^(M) b_i z^(1 - i)) / (sum_(i = 1)^(N) a_i z^(1 - i))$ is:

$
  sum_(i = 1)^(M) y[n - i + 1] = sum_(i = 1)^(N) x[n - i + 1]
$

For the specific filter $H(z) = (2 + 3z^(-1)) / (1 - 0.5 z^(-1))$ in the question, the difference equation should be:

$
  y[n] = 0.5 y[n - 1] + 2 x[n] + 3 x[n - 1]
$

For $L = 100$ and $x = [1, 2, 3]$, the first $10$ of $y$ is $[2, 8, 16, 17, 8, 4, 2, 1, 0, 0]$ and we can draw the first $100$ y as below:

#figure(image("pic/1.c.png", width: 80%))

#pagebreak()

==

To draw the impulse response, we can set the input $x = [1]$ in the sequence $"xn" = [0]$. The first six output is $[2, 4, 2, 1, 0, 0]$ and the following is all $0$, where the figure is as below:

#figure(image("pic/1.d.png", width: 80%))

= Design an FIR filter with the Window method

==

We first designed a gate function of an ideal low-pass filter in the frequency domain:

$
  g(omega) &:= cases(1 "if" -omega_c <= omega <= omega_c, 0 "otherwise") \
$

Its figure:

#figure(image("pic/2.a.1.png", width: 80%))

Then we apply the inverse _DTFT_ to the function and get $h[n]$. For $N = -30 ~ 30$, the figure is:

#figure(image("pic/2.a.5.png", width: 80%))

Since $h[n]$ at this time is a non-causal sequence and is unrealizable, shift it in the time domain and obtain the new $h[n]$ as follows, here we draw the impulse response functions when $N = -30 ~ 30$ and $N = -100 ~ 100$ in the same plot:

#figure(image("pic/2.a.2.png", width: 80%))

The real part and imaginary part of the frequency response of the filter are as follows:


#figure(image("pic/2.a.3.png", width: 80%))
#figure(image("pic/2.a.4.png", width: 80%))

==

We can design a high-pass filter by first creating an inversed gate function:

$
  g(omega) &:= cases(1 "if" |omega| > |omega_c|, 0 "otherwise") \
$

The figure is:

#figure(image("pic/2.b.1.png", width: 80%))

Likewise in 2.a, we apply _IDTFT_ to this function and shift $h[n]$. We also apply Kaiser window (using `np.kaiser` with $beta = 10$) to make the window smoother. Here is the figure of their impulse responses:

#figure(image("pic/2.b.2.png", width: 80%))

The FRFs:

#figure(image("pic/2.b.3.png", width: 80%))
#figure(image("pic/2.b.4.png", width: 80%))

It can be seen that the overshoot of Kaiser window method is smaller than that of the rectangular window method.

==

As the two frequencies are $f_1 = 7, f_2 = 24$, we can choose $f_c = 15$ as the cut-off frequency, therefore, the cut-off angular frequency is $omega_c = 2 pi f_c / f_s$, where $f_s = 200$.

Now we can apply all the steps in 2.b to get a high-pass filter. To refuce the overshoot, we applied the Kaiser window method to the _IDTFT_ result. The FRF of this filter is like:


#figure(image("pic/2.c.1.png", width: 80%))
#figure(image("pic/2.c.2.png", width: 80%))

==

Using the `filter()` function developed in 1.c.
and `np.convolve()`, we can get $y_1$ and $y_2$ easily. Plotting them in the same figure:

#figure(image("pic/2.d.1.png", width: 80%))

By both the two methods, there's only one frequency of signal remaining. It can be verified that this frequency is $24$ by turning the abscissa into a $t$-based one.

==

Using `np.fft.fft()` we can get the _DFT_ of $x, y_1$ and $y_2$. The right half of the _DFT_ is the same as the left half, so we can only draw the left half. The figure is as below:

#figure(image("pic/2.e.1.png", width: 80%))
#figure(image("pic/2.e.2.png", width: 80%))

It can be verified from the plot that the signal of frequency $7$ is filtered out.

Let the sampling number be $n = 600$, we can get the remaining amplitude by $A = 2 / n sup{||y_1||}$. The result of the code is $3.79$, which is close to $4$.

= Design an IIR filter with bilinear transform and realize filtering

==

Let the input signal in the complex field be $underline(U_i)$, output signal $underline(U_o)$, the current intensity $underline(i)$ we have the equation in the circuit:

$
  underline(U_o) = underline(U_i) (C integral underline(i) dif t) / (C integral underline(i) dif t + underline(i) R + L (dif underline(i)) / (dif t))
$

Apply the Laplace transform to the equation, we can get the transfer function of the circuit:

$
  H(s) = underline(U_o) / underline(U_i) = 1 / (R + L s + 1 / (C s))
$

==

Apply the bilinear method, where $T = 1 / f_s$:

$
  H(z) &= H(s) |_(s = 2 / T (z - 1) / (z + 1)) \
       &= 1 / (1 + R C 2 / T (z - 1) / (z + 1) + L C 4 / (T ^ 2) (z - 1) ^ 2 / ((z + 1) ^ 2)) \
       &= (z ^ 2 + 2 z + 1) / (z ^ 2 (1 + (2 R C) / T + L C) + z (2 - 2 L C) + 1 - (2 R C) / T + L C 4 / (T ^ 2)) \
       &= (z ^ 2 + 2 z + 1) / (z ^ 2 (1 + 2 R C f_s + L C) + z (2 - 2 L C) + 1 - 2 R C f_s + 4 L C f_s ^ 2)
$

Let $a_1 = 1 + 2 R C f_s + L C$, we can We can divide both the numerator and denominator by $a_1$ to get the coefficients of the difference equation.

==

Set the $f_s = 23966.14"Hz"$ (to be obtained later), The FRF of the analog filter and the digital filter are:

#figure(image("pic/t3.c.4.png", width: 80%))
#figure(image("pic/t3.c.5.png", width: 80%))

At $f_"input" = 1000"Hz"$, we can plot the difference between the output of the analog filter and the digital filter for different sampling frequencies between $10000$ and $50000$ in $"dB"$:

#figure(image("pic/t3.c.1.png", width: 80%))

As we can see in the figure, the minimum $f_s$ that makes the difference less than $0.1"dB"$ is around $23966.14"Hz"$.

Their magnitudes and in $"dB"$ and phases in radians are:

#figure(image("pic/t3.c.2.png", width: 80%))
#figure(image("pic/t3.c.3.png", width: 80%))

This is a low-pass filter with its cut-off frequency $f_c = 51.33"Hz"$ (obtained by the code, where the gain is $-3"dB"$).

==

The input ($x$, blue curve) and the output ($y$, orange curve) of the filter are as follows:

#figure(image("pic/t3.d.1.png", width: 80%))

Here we also plotted the signals with frequencies $f_1 = 5$ and $f_2 = 50$. It can be seen that these two frequencies are preserved and the component with the highest frequency $f_3 = 500$ in the blue curve are filtered out in the output signal.

The spectra shows that the frequency of $500"Hz"$ is filtered out:

#figure(image("pic/t3.d.2.png", width: 80%))

= Pole/Zero Designs

==

Idea: we want to design a filter with the zeros of $H(z)$ right at $f_c = 24$, so that the frequency of $24"Hz"$ is filterer out. Theres should also be a pole at around $f_c = 24$, so that the frequencies away from $24$ is not affected.

As the coefficients of the difference equation are real, the roots of the numerator polynomial (named bz) and denominator polynomial (az) must be conjugate complex numbers.

Let the digital cut-off angular frequency be $omega_c = 2 pi f_c / f_s$. The roots of bz should be $e^(j w_c)$ and $e^(-j w_c)$, and the roots of az should be $R e^(j w_c)$ and $R e^(-j w_c)$, where $R$ is a parameter to be determined. So we have:

$
  H(z) &= ((z - e^(j w_c)) (z - e^(-j w_c))) / ((z - R e^(j w_c)) (z - R e^(-j w_c))) \
       &= (z ^ 2 - 2 cos(w_c) z + 1) / (z ^ 2 - 2 R cos(w_c) z + R ^ 2) \
$

From this Here $R$ will decide the bandwidth of the filter. Let's plot the bandwidth of $-3"dB"$ of different $R$ from $0.97$ to $1$. How do we get the bandwidth of an $R$? We can simply calculate the frequency responses into a list in python, and find the first frequency and the last frequency that the response is less than $-3"dB"$. The bandwidth is the difference between these two frequencies. Now the bandwidth-$R$ curve is like:

#figure(image("pic/t4.a.1.png", width: 80%))

Get the first $R$ in the list that makes the the band-width less than $1.00$, we can get the $R = 0.98383$. Good!

$
  H(z) &= (z ^ 2 - 2 cos(w_c) z + 1) / (z ^ 2 - 2 R cos(w_c) z + R ^ 2) \
       &tilde.eq (z ^ 2 - 1.46 z + 1) / (z ^ 2 - 1.43 z + 0.968 ^ 2)
$

The difference equation:

$
  y[n] - 1.46 y[n - 1] + 0.968 ^ 2 y[n - 2] = x[n] - 1.46 x[n - 1] + x[n - 2]
$

Now we can get the right az and bz, plot the pole-zero map and the frequency response of the filter:

#figure(image("pic/t4.a.2.png", width: 50%))
#figure(image("pic/t4.a.3.png", width: 80%))
#figure(image("pic/t4.a.4.png", width: 80%))
#figure(image("pic/t4.a.5.png", width: 80%))

In this figure 👆🏻,we can clearly see that the notch of $-3"dB"$ is between $23.5"Hz"$ and $24.5"Hz"$.

==

We just plot it here:

#figure(image("pic/t4.b.1.png", width: 80%))

The high frequency component is filtered out. The frequency spectra is in the last figure in 4.a.

==

To design a comb filter, we make $H(z)$ something like:

#figure(image("pic/t4.c.5.png", width: 50%))

$
  H(z) &= (z ^ 2 - 2 R_"zero" cos(w_c) z + R_"zero"^2) / (z ^ 2 - 2 R_"pole" cos(w_c) z + R_"pole" ^ 2) \
$

Unlike for a notch filter, we can't simply put the poles on the unit circle to amplify the higher frequency, because this will make the system unstable. So after deciding $f_"peak" = 24$ and $omega_"peak" = 2 pi f_"peak" / f_s$, we still have 2 DoF: the radii of the poles $R_"pole"$ and of zeros $R_"zero"$. Getting a good tuples of radii is complicated, so here we use the theoretical method.

To make the bandwidth of $1"Hz"$, we use the approximation method to analyze the conditions that two radii need to meet.

#figure(image("pic/t4.c.6.png", width: 50%))

We consider a tiny part of the unit circle close to the pole. $A B$ is a very small part of the unit circle, so it is approximately a line. At $omega = omega_"peak"$, the magnification is $y / x$ according to the property of a comb filter. To normalize the gain function, we will multiply bz by $x / y$. Given $x$ and $y$. We can deduce that the proper $Delta omega$ that makes that bandwidth $1"Hz"$ is: $ Delta omega = 2 pi times (1"Hz") / (2 f_s) tilde.eq 0.0157 $. Let's now find that condition that $x$ and $y$ should meet:

$
  q / p x / y = 1 / sqrt(2)
$

With all the variable positive real numbers. Square both sides:

$
  q^2 / p^2 x^2 / y^2 = 1 / 2
$

Using the Pythagorean theorem:

$
  ((y^2 + Delta omega^2) x^2) / ((x^2 + Delta omega^2) y^2) = 1 / 2
$

Shift the terms:

$
  x^2 = (Delta omega^2 y^2) / (2 Delta omega^2 + y^2)
$

As $x, y, Delta omega > 0$:

$
  x = (Delta omega y) / sqrt(2 Delta omega^2 + y^2)
$

There's now only $1$ DoF: the radius of the zero point (or the pole point, they are limited by the equation above). It should be close to $1$ in order that frequencies away from $f_"peak"$ are not affected (and after normalization, they are elimited).

On the other hand, the magnification is $y / x$. Likewise, we deduce that: $ y / x = sqrt(2 + y ^ 2 / w^2) $

The figure of magnification-$y$:

#figure(image("pic/t4.c.7.png", width: 80%))
Larger the $y$, larger the magnification. We can set $y = 0.15$ for magnification $y / x tilde.eq 9.65 = 19.7"dB"$. We then have $x tilde.eq 0.0155, R_"zero" = 0.85, R_"pole" tilde.eq 0.9845$, and the transfer function:

$
  H(z) &tilde.eq 1 / 9.65 times (z ^ 2 - 1.70 z + 0.722) / (z ^ 2 - 1.97 z + 0.969 ^ 2) \
       &tilde.eq (0.104 z ^ 2 - 0.130 z + 0.0748) / (z ^ 2 - 1.97 z + 0.969 ^ 2)
$

The difference equation:

$
  y[n] - 1.97 y[n - 1] + 0.969 ^ 2 y[n - 2] = 0.104 x[n] - 0.130 x[n - 1] + 0.0748 x[n - 2]
$

Plotting the poles and zeros:

#figure(image("pic/t4.c.1.png", width: 50%))

FRFs:

#figure(image("pic/t4.c.2.png", width: 80%))
#figure(image("pic/t4.c.3.png", width: 80%))

==

Time sequences:

#figure(image("pic/t4.d.1.png", width: 80%))

The frequency spectra:

#figure(image("pic/t4.c.4.png", width: 80%))

The higher frequency of $24$ is preserved. 

= Appendix Code (Python)

#import "@preview/codelst:2.0.0": sourcecode
#show raw.where(block: true): it => {
  set text(size: 10.5pt, )
  sourcecode(it)
}

== Problem 1

=== Code for 1.a

```python
# [1.a]
import numpy as np
import matplotlib.pyplot as plt

def expand(arr, n):
    return np.pad(arr, (0, n - len(arr)), 'constant')

def pzmap(bz, az):
    m = len(bz)
    n = len(az)
    level = max(m, n)
    pad_bz = expand(bz, level)
    pad_az = expand(az, level)
    return [np.roots(pad_bz), np.roots(pad_az)]

class HFunc:
    def __init__(self, bz, az):
        self.bz: np.array = bz
        self.az: np.array = az

def plot_complex_numbers(bz, az):
    # Create a new figure with custom size
    fig = plt.figure(figsize=(6, 6))
    
    # Extract real and imaginary parts for both lists
    real_parts1 = [z.real for z in bz]
    imaginary_parts1 = [z.imag for z in bz]
    real_parts2 = [z.real for z in az]
    imaginary_parts2 = [z.imag for z in az]
    
    # Create scatter plots for both lists
    plt.scatter(real_parts1, imaginary_parts1, marker='o', color='blue', label='Zeros')
    plt.scatter(real_parts2, imaginary_parts2, marker='x', color='red', label='Poles')
    
    # Draw the unit circle
    theta = np.linspace(0, 2 * np.pi, 100)
    x_circle = np.cos(theta)
    y_circle = np.sin(theta)
    plt.plot(x_circle, y_circle, color='green', label='Unit Circle')
    
    # Set axis limits
    plt.xlim(-3, 3)
    plt.ylim(-3, 3)
    
    # Force the x and y axis to be the same scale (each 1x1 grid should look like a square)
    plt.gca().set_aspect('equal', adjustable='box')
    
    # Add labels and title
    plt.xlabel('Real Part')
    plt.ylabel('Imaginary Part')
    plt.title('Complex Numbers in the Complex Plane')
    
    # Add legend
    plt.legend()
    
    # Show the plot
    plt.grid(True)
    plt.show()

# Example usage
bz = [2, 3]
az = [1, -0.5]
plot_complex_numbers(*pzmap(bz, az))

```

=== Code for 1.b

```python
# [1.b]
def h_value(bz, az, z: complex):
    num = sum([bz[i] * z ** (-i) for i in range(len(bz))])
    den = sum([az[i] * z ** (-i) for i in range(len(az))])
    return num / den
def freqz(bz, az, w):
    ... # w between -pi and pi?
    hs = np.array([h_value(bz, az, np.exp(1j * omega)) for omega in w])
    return w, hs

SAMPLE_N = 5000

def get_mod_pha_real_imag(c):
    return np.abs(c), np.angle(c), c.real, c.imag

ws = np.linspace(-np.pi, np.pi, SAMPLE_N)
ws, hs = freqz(bz, az, ws)

hs_plots = get_mod_pha_real_imag(hs)
names = ['Modulus', 'Phase', 'Real', 'Imaginary']

for i in range(2):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(ws, hs_plots[i], 'r-', label=f'Frequency response {names[i]}')
    plt.xlabel('w')
    plt.legend()
    fig.show()
```

=== Code for 1.c

```python
# [1.c]
def filter(bz, az, x, L):
    ...
    # y[n] = 
    xs = expand(x, L) # first several x
    ys = np.zeros_like(xs)
    def y_at(n):
        return 0 if n < 0 else ys[n]
    def x_at(n):
        return 0 if n < 0 else xs[n]
    for n in range(L):
        # calculate y[n]
        ys[n] = sum([bz[i] * x_at(n - i) for i in range(len(bz))]) - sum([az[i] * y_at(n - i) for i in range(1, len(az))])
    return xs, ys


L = 100
xs = [1, 2, 3]
xs, ys = filter(bz, az, xs, L)
print(*ys[:20], sep=", ")
ys_plots = get_mod_pha_real_imag(ys)

fig = plt.figure(figsize=(18, 6))
plt.plot(np.arange(L), ys_plots[0], 'r-', label=f'first {L} y')
plt.xlabel('w')
plt.legend()
fig.show()
```

=== Code for 1.d

```python
# [1.d]
impulse_xs = [1] # impulse response
xs, ys = filter(bz, az, impulse_xs, L)
ys_plots = get_mod_pha_real_imag(ys)

print(ys[:20])

for i in range(1):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(np.arange(L), ys_plots[i], 'r-', label=f'Impulse response {names[i]}')
    plt.xlabel('w')
    plt.legend()
    fig.show()
```

== Problem 2

=== Code for 2.a

```python
# [2.a]
import numpy as np
import matplotlib.pyplot as plt

def expand(arr, n):
    return np.pad(arr, (0, n - len(arr)), 'constant')

def get_mod_pha_real_imag(c):
    return np.abs(c), np.angle(c), c.real, c.imag

def gen_g(d, h):
    def g(t):
        return np.where((t >= -d) & (t <= d), h, 0)
    return g

W_C = 0.3 * np.pi
low_pass_g = gen_g(W_C, 1)

SAMPLE_N = 5000
def discret_samples(f, d):
    t_values = np.linspace(-d, d, SAMPLE_N)
    return t_values, f(t_values)

def __draw(xs, ys):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(xs, ys)
    plt.xlabel('x')
    fig.show()
    
def __draw_ys(ys):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(ys)
    plt.xlabel('x')
    fig.show()
    
__draw(*discret_samples(low_pass_g, np.pi))

def idtft_window(minn, maxn, dtft_func):
    ns = np.arange(minn, maxn + 1)
    hs = np.zeros_like(ns, dtype=complex)
    w_samples, f_samples = discret_samples(dtft_func, np.pi)
    dw = w_samples[1] - w_samples[0]
    for i in range(len(ns)):
        hs[i] = 1 / (2 * np.pi) * np.sum(f_samples * np.exp(1j * ns[i] * w_samples) * dw)
    return ns, hs # hs itself is causal

ns, hs = idtft_window(-30, 30, low_pass_g)
__draw(ns, hs)

def filter(bz, x, L):
    ...
    # y[n] = 
    xs = expand(x, L) # first several x
    ys = np.zeros_like(xs)
    def y_at(n):
        return 0 if n < 0 else ys[n]
    def x_at(n):
        return 0 if n < 0 else xs[n]
    for n in range(L):
        # calculate y[n]
        ys[n] = sum([bz[i] * x_at(n - i) for i in range(len(bz))])
    return xs, ys

fig = plt.figure(figsize=(18, 6))
test_n = [30, 100]
colors = ['r-', 'b--']
for j in range(len(test_n)):
    n = test_n[j]
    ns, hs = idtft_window(-n, n, low_pass_g)
    bz = hs
    impulse_xs = np.array([1 + 0j])
    L = 200
    xs, ys = filter(bz, impulse_xs, L)
    plt.plot(np.arange(L), ys, colors[j],label=f'Impulse response of window length {n}'),
plt.xlabel('w')
plt.legend()
fig.show()

def cap_h_value(bz, z: complex):
    num = sum([bz[i] * z ** (-i) for i in range(len(bz))])
    den = 1
    return num / den

def frequency_response(bz):
    ws = np.linspace(-np.pi, np.pi, SAMPLE_N)
    cap_hs = np.array([cap_h_value(bz, np.exp(1j * omega)) for omega in ws])
    return ws, cap_hs
    

prop_desc = ['Modulus', 'Phase']
for i in range(2):
    fig = plt.figure(figsize=(18, 6))
    test_n = [30, 100]
    colors = ['r-', 'b--']
    for j in range(len(test_n)):
        n = test_n[j]
        ns, hs = idtft_window(-n, n, low_pass_g)
        bz = hs
        ws, cap_hs = frequency_response(bz)
        hs_plots = get_mod_pha_real_imag(cap_hs)
        plt.plot(ws, hs_plots[i], colors[j],label=f'FRF\'s {prop_desc[i]} of window length {n}'),
    plt.xlabel('w')
    plt.legend()
    fig.show()
```

=== Code for 2.b

```python
# [2.b]
def gen_pit(d, h):
    def g(t):
        return np.where((t <= -d) | (t >= d), h, 0)
    return g

high_pass_g = gen_pit(W_C, 1)
__draw(*discret_samples(high_pass_g, np.pi))

WINDOW_N = 61
ns, hs = idtft_window(-30, 30, high_pass_g)
# print(hs)
kaiser_hs = np.kaiser(WINDOW_N, beta=10) * hs
window_names = ['Rectangular', 'Kaiser']

fig = plt.figure(figsize=(18, 6))
colors = ['r-', 'b--']
for i in range(2):
    bz = hs if i == 0 else kaiser_hs
    impulse_xs = np.array([1 + 0j])
    L = 200
    xs, ys = filter(bz, impulse_xs, L)
    plt.plot(np.arange(L), ys, colors[i], label=f'Impulse response of {window_names[i]} window'),
plt.xlabel('w')
plt.legend()
fig.show()

prop_desc = ['Modulus', 'Phase']
for i in range(2):
    fig = plt.figure(figsize=(18, 6))
    colors = ['r-', 'b--']
    for j in range(2):
        bz = hs if j == 0 else kaiser_hs
        ws, cap_hs = frequency_response(bz)
        hs_plots = get_mod_pha_real_imag(cap_hs)
        plt.plot(ws, hs_plots[i], colors[j], label=f'FRF\'s {prop_desc[i]} of {window_names[j]} window'),
    plt.xlabel('w')
    plt.legend()
    fig.show()

```

=== Code for 2.c

```python
# [2.c]
f_s = 200
f_c = 15
w_c = 2 * np.pi * f_c / f_s
# [pit]
high_pass_g = gen_pit(w_c, 1)
# [idtft]
ns, hs = idtft_window(-30, 30, high_pass_g)
kaiser_hs = np.kaiser(WINDOW_N, beta=10) * hs
# [draw frequency response]
prop_desc = ['Modulus', 'Phase']
for i in range(2):
    fig = plt.figure(figsize=(18, 6))
    bz = kaiser_hs
    ws, cap_hs = frequency_response(bz)
    hs_plots = get_mod_pha_real_imag(cap_hs)
    plt.plot(ws, hs_plots[i], 'r-', label=f'Designed FRF\'s {prop_desc[i]}'),
    plt.xlabel('w')
    plt.legend()
    fig.show()
```

=== Code for 2.d

```python
# [2.d]
a_1 = 8
a_2 = 4
f_1 = 7
f_2 = 24
T = 1 / f_s
ns = np.arange(-200, 400)
xs = a_1 * np.cos(2 * np.pi * f_1 * T * ns) + a_2 * np.cos(2 * np.pi * f_2 * T * ns)
xs, ys = filter(kaiser_hs, xs, len(xs))

blocks = [xs[i:i + 200] for i in range(0, len(xs), 200)]
blocks_ys = [np.convolve(hs, block)[:200] for block in blocks] # for a 200 block, length is 200 + len(hs) - 1, the last several is removed
pieced_ys = np.concatenate(blocks_ys)

fig = plt.figure(figsize=(18, 6))
plt.plot(ns, ys, 'r-', label=f'y1'),
plt.plot(ns, pieced_ys, 'b--', label=f'y2'),
plt.xlabel('n')
plt.legend()
fig.show()
```

=== Code for 2.e

```python
# [2.e]
FFT_N = 1024
pad_x = np.arange(FFT_N)
pad_w = np.array([2 * np.pi * k / FFT_N for k in range(FFT_N)])
pad_ys = expand(ys, FFT_N)
pad_xs = expand(xs, FFT_N)
pad_pieced_ys = expand(pieced_ys, FFT_N)

fft_ys = np.fft.fft(pad_ys)
fft_xs = np.fft.fft(pad_xs)
fft_pieced_ys = np.fft.fft(pad_pieced_ys)

for part in range(2):
    fig = plt.figure(figsize=(18, 6))
    fft_ys_plots = get_mod_pha_real_imag(fft_ys)
    fft_xs_plots = get_mod_pha_real_imag(fft_xs)
    fft_pieced_ys_plots = get_mod_pha_real_imag(fft_pieced_ys)

    half = FFT_N // 2
    plt.plot(pad_w[:half], fft_ys_plots[part][:half], 'b-', label=f'FFT {prop_desc[part]} of y1')
    plt.plot(pad_w[:half], fft_xs_plots[part][:half], 'r--', label=f'FFT {prop_desc[part]} of x')
    plt.plot(pad_w[:half], fft_pieced_ys_plots[part][:half], 'g--', label=f'FFT {prop_desc[part]} of pieced y2')
    plt.legend()
    plt.xlabel('w')
    fig.show()
    
print(f'The amplitude of the remaining of frequency 24 is {max(fft_ys_plots[0]) / 600 * 2}')
```

== Problem 3

=== Code for 3.c

```python
# [3.c]
import numpy as np
import matplotlib.pyplot as plt

def expand(arr, n):
    return np.pad(arr, (0, n - len(arr)), 'constant')

def pzmap(bz, az):
    m = len(bz)
    n = len(az)
    level = max(m, n)
    pad_bz = expand(bz, level)
    pad_az = expand(az, level)
    return [np.roots(pad_bz), np.roots(pad_az)]

def plot_complex_numbers(bz, az):
    # Create a new figure with custom size
    fig = plt.figure(figsize=(6, 6))
    
    # Extract real and imaginary parts for both lists
    real_parts1 = [z.real for z in bz]
    imaginary_parts1 = [z.imag for z in bz]
    real_parts2 = [z.real for z in az]
    imaginary_parts2 = [z.imag for z in az]
    
    # Create scatter plots for both lists
    plt.scatter(real_parts1, imaginary_parts1, marker='o', color='blue', label='Zeros')
    plt.scatter(real_parts2, imaginary_parts2, marker='x', color='red', label='Poles')
    
    # Draw the unit circle
    theta = np.linspace(0, 2 * np.pi, 100)
    x_circle = np.cos(theta)
    y_circle = np.sin(theta)
    plt.plot(x_circle, y_circle, color='green', label='Unit Circle')
    
    # Set axis limits
    plt.xlim(-3, 3)
    plt.ylim(-3, 3)
    
    # Force the x and y axis to be the same scale (each 1x1 grid should look like a square)
    plt.gca().set_aspect('equal', adjustable='box')
    
    # Add labels and title
    plt.xlabel('Real Part')
    plt.ylabel('Imaginary Part')
    plt.title('Complex Numbers in the Complex Plane')
    
    # Add legend
    plt.legend()
    
    # Show the plot
    plt.grid(True)
    plt.show()

# Example usage
# bz = [2, 3]
# az = [1, -0.5]

def cap_h_value(bz, az, z: complex):
    num = sum([bz[i] * z ** (-i) for i in range(len(bz))])
    den = sum([az[i] * z ** (-i) for i in range(len(az))])
    return num / den
def freqz(bz, az, w):
    ... # w between -pi and pi?
    hs = np.array([cap_h_value(bz, az, np.exp(1j * omega)) for omega in w])
    return w, hs

SAMPLE_N = 5000

def get_mod_pha_real_imag(c):
    return [np.abs(c), np.angle(c), c.real, c.imag]

def filter(bz, az, x, L):
    ...
    # y[n] = 
    xs = expand(x, L) # first several x
    ys = np.zeros_like(xs)
    def y_at(n):
        return 0 if n < 0 else ys[n]
    def x_at(n):
        return 0 if n < 0 else xs[n]
    for n in range(L):
        # calculate y[n]
        ys[n] = sum([bz[i] * x_at(n - i) for i in range(len(bz))]) - sum([az[i] * y_at(n - i) for i in range(1, len(az))])
    return xs, ys

R = 3
L = 0.02
C = 0.001
def gen_bz_az(f_s):
    bz = np.array([1, 2, 1])
    a1 = 1 + 2 * R * C * f_s + 4 * L * C * f_s ** 2
    az = np.array([a1, 2 - 8 * L * C * f_s ** 2, 1 - 2 * R * C * f_s + 4 * L * C * f_s ** 2])
    return bz / a1, az / a1

def hw(w):
    return 1 / (1 + 1j * w * R * C - w ** 2 * L * C)

def hz_w(w, w_s, bz, az):
    real_w = w / w_s * np.pi * 2
    return cap_h_value(bz, az, np.exp(1j * real_w))

def frequency_response(bz, az):
    ws = np.linspace(-np.pi, np.pi, SAMPLE_N)
    cap_hs = np.array([cap_h_value(bz, az, np.exp(1j * omega)) for omega in ws])
    return ws, cap_hs

# def analog_frequency_response(hw_func, ws):
#     return ws, np.array([hw_func(w) for w in ws])

def db(x):
    return 20 * np.log10(np.abs(x))

TEST_F = 1000
TEST_W = 2 * np.pi * TEST_F
def __draw(xs, ys, xlabel='x', ylabel='y'):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(xs, ys, label=ylabel)
    plt.legend()
    plt.xlabel(xlabel)
    fig.show()

try_f_s = np.linspace(10000, 50000, 100000)
try_diff = []
for f_s in try_f_s:
    bz, az = gen_bz_az(f_s)
    diff = np.abs(hz_w(TEST_W, 2 * np.pi * f_s, bz, az)) / np.abs(hw(TEST_W))
    try_diff.append(diff)
try_diff = db(np.array(try_diff))
fig = plt.figure(figsize=(18, 6))
plt.plot(try_f_s, try_diff, label='Difference (dB)')
plt.legend()
plt.xlabel('fs')

min_index = min(i for i, x in enumerate(try_diff) if abs(x) < 0.1)
min_f_s_that_makes_diff_less_than_0_point_1_db = try_f_s[min_index]
print(min_f_s_that_makes_diff_less_than_0_point_1_db)

plt.plot(min_f_s_that_makes_diff_less_than_0_point_1_db, try_diff[min_index], 'ro')  # 'ro'表示红色圆点
plt.text(min_f_s_that_makes_diff_less_than_0_point_1_db, try_diff[min_index],
         f'({min_f_s_that_makes_diff_less_than_0_point_1_db:.2f}, {try_diff[min_index]:.2f})', ha='right', va='bottom')  # 标注坐标
# hhh
fig.show()

f_s = min_f_s_that_makes_diff_less_than_0_point_1_db
bz, az = gen_bz_az(f_s)

prop_desc = ['Magnitude', 'Phase', 'Real', 'Imaginary']
for prop in range(2):
    fig = plt.figure(figsize=(18, 6))
    ws, cap_hs = frequency_response(bz, az)
    analog_hs = np.array([hw(w * f_s) for w in ws])

    hs_plots = get_mod_pha_real_imag(cap_hs)
    analog_hs_plots = get_mod_pha_real_imag(analog_hs)
    plt.plot(ws, analog_hs_plots[prop], '-', label=f'Analog filter FRF {prop_desc[prop]}')
    plt.plot(ws, hs_plots[prop], '--', label=f'Digital filter {prop_desc[prop]}')

    plt.xlabel('w')
    plt.legend()
    fig.show()

```

```python
frequencies = np.linspace(1, f_s / 2, SAMPLE_N)
analog_output = np.array([hw(2 * np.pi * f) for f in frequencies])
digital_output = np.array([hz_w(2 * np.pi * f, 2 * np.pi * f_s, bz, az) for f in frequencies])
# Why tf the transform makes w_real in 0 and 2pi?
analog_plots = get_mod_pha_real_imag(analog_output)
digital_plots = get_mod_pha_real_imag(digital_output)
analog_plots[0] = db(analog_plots[0])
digital_plots[0] = db(digital_plots[0])

for prop in range(2):
    fig = plt.figure(figsize=(18, 6))
    plt.semilogx(frequencies, analog_plots[prop], '-',  label=f'Analog {prop_desc[prop]}')
    plt.semilogx(frequencies, digital_plots[prop], '--', label=f'Digital {prop_desc[prop]}')
    plt.xlabel('f (Hz)')
    plt.ylabel('Gain (dB)' if prop == 0 else 'Phase (rad)')
    plt.legend()
    fig.show()
    
cut_off_frequency = frequencies[[i for i, x in enumerate(digital_plots[0]) if x < -3][0]]
print(cut_off_frequency)
```

=== Code for 3.d

```python
# [3.d]
# 模拟角频率转数字角频率
f1, f2, f3 = 5, 50, 500
def attenuate(f):
    return db(hz_w(2 * np.pi * f, 2 * np.pi * f_s, bz, az))

print(attenuate(f1), attenuate(f2), attenuate(f3))

def x(n):
    return np.cos(2 * np.pi * f1 * n / f_s) + np.cos(2 * np.pi * f2 * n / f_s) + np.cos(2 * np.pi * f3 * n / f_s)

def f1_x(n):
    return np.cos(2 * np.pi * f1 * n / f_s)

def f2_x(n):
    return np.cos(2 * np.pi * f2 * n / f_s)

# 原来 T = 1 / fs。在数字输入中，T = 1，故角频率放缓 fs 倍
ns = np.arange(10000)
xs = x(ns)
ys = filter(bz, az, xs, len(ns))[1]
f1_xs = f1_x(ns)
f2_xs = f2_x(ns)
fig = plt.figure(figsize=(18, 6))
plt.plot(ns, xs, label='x')
plt.plot(ns, ys, label='y')
plt.plot(ns, f1_xs, '--', label='f1_x')
plt.plot(ns, f2_xs, '--', label='f2_x')
plt.legend()
fig.show()

fig = plt.figure(figsize=(18, 6))

def dtft(ns, xs, ws=np.linspace(-np.pi, np.pi, SAMPLE_N)):
    cap_xs = np.zeros(len(ws), dtype=complex)
    for i in range(len(ws)):
        cap_xs[i] = np.sum(xs * np.exp(-1j * ws[i] * ns))
    return ws, cap_xs

_, input_dtft = dtft(ns, xs, np.linspace(0, 600 / f_s * 2 * np.pi, SAMPLE_N))
ws, output_dtft = dtft(ns, ys, np.linspace(0, 600 / f_s * 2 * np.pi, SAMPLE_N))
input_dtft = input_dtft / len(ns) * 2
output_dtft = output_dtft / len(ns) * 2
ws *= f_s / 2 / np.pi

plt.plot(ws, np.abs(input_dtft) , label='Input DTFT')
plt.plot(ws, np.abs(output_dtft), label='Output DTFT')
plt.legend()
fig.show()
```

== Problem 4

=== Code for 4.a

```python
# [4.a]
import numpy as np
import matplotlib.pyplot as plt

def __draw_ys(ys):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(ys)
    plt.xlabel('x')
    fig.show()

def __draw(xs, ys):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(xs, ys)
    plt.xlabel('x')
    fig.show()

def expand(arr, n):
    return np.pad(arr, (0, n - len(arr)), 'constant')

def pzmap(bz, az):
    m = len(bz)
    n = len(az)
    level = max(m, n)
    pad_bz = expand(bz, level)
    pad_az = expand(az, level)
    return [np.roots(pad_bz), np.roots(pad_az)]

def plot_complex_numbers(bz, az):
    # Create a new figure with custom size
    fig = plt.figure(figsize=(6, 6))
    
    # Extract real and imaginary parts for both lists
    real_parts1 = [z.real for z in bz]
    imaginary_parts1 = [z.imag for z in bz]
    real_parts2 = [z.real for z in az]
    imaginary_parts2 = [z.imag for z in az]
    
    # Create scatter plots for both lists
    plt.scatter(real_parts1, imaginary_parts1, marker='o', color='blue', label='Zeros')
    plt.scatter(real_parts2, imaginary_parts2, marker='x', color='red', label='Poles')
    
    # Draw the unit circle
    theta = np.linspace(0, 2 * np.pi, 100)
    x_circle = np.cos(theta)
    y_circle = np.sin(theta)
    plt.plot(x_circle, y_circle, color='green', label='Unit Circle')
    
    # Set axis limits
    # plt.xlim(k1, 3)
    # plt.ylim(-3, 3)
    
    # Force the x and y axis to be the same scale (each 1x1 grid should look like a square)
    plt.gca().set_aspect('equal', adjustable='box')
    
    # Add labels and title
    plt.xlabel('Real Part')
    plt.ylabel('Imaginary Part')
    plt.title('Complex Numbers in the Complex Plane')
    
    # Add legend
    plt.legend()
    
    # Show the plot
    plt.grid(True)
    plt.show()

# Example usage
# bz = [2, 3]
# az = [1, -0.5]

def cap_h_value(bz, az, z: complex):
    num = sum([bz[i] * z ** (-i) for i in range(len(bz))])
    den = sum([az[i] * z ** (-i) for i in range(len(az))])
    return num / den
def freqz(bz, az, w):
    ... # w between -pi and pi?
    hs = np.array([cap_h_value(bz, az, np.exp(1j * omega)) for omega in w])
    return w, hs

SAMPLE_N = 5000

def get_mod_pha_real_imag(c):
    return [np.abs(c), np.angle(c), c.real, c.imag]

def filter(bz, az, x, L):
    ...
    # y[n] = 
    xs = expand(x, L) # first several x
    ys = np.zeros_like(xs)
    def y_at(n):
        return 0 if n < 0 else ys[n]
    def x_at(n):
        return 0 if n < 0 else xs[n]
    for n in range(L):
        # calculate y[n]
        ys[n] = sum([bz[i] * x_at(n - i) for i in range(len(bz))]) - sum([az[i] * y_at(n - i) for i in range(1, len(az))])
    return xs, ys

def frequency_response(bz, az, sample_n=SAMPLE_N):
    ws = np.linspace(-np.pi, np.pi, sample_n)
    cap_hs = np.array([cap_h_value(bz, az, np.exp(1j * omega)) for omega in ws])
    return ws, cap_hs

# def analog_frequency_response(hw_func, ws):
#     return ws, np.array([hw_func(w) for w in ws])

def db(x):
    return 20 * np.log10(np.abs(x))

```

```python
f_s = 200
a_1 = 8
a_2 = 4
f_1 = 7
f_2 = 24
T = 1 / f_s
ns = np.arange(-200, 400)
xs = a_1 * np.cos(2 * np.pi * f_1 * T * ns) + a_2 * np.cos(2 * np.pi * f_2 * T * ns)

notch_f = 24
def ana_f_to_dig_w(f):
    return f / f_s * 2 * np.pi

def dig_w_to_ana_f(w):
    return w / (2 * np.pi) * f_s

notch_dig_w = ana_f_to_dig_w(notch_f)

rs = np.linspace(0.97, 1, 500)
band_fs = []
for r in rs:
    # get the band width of -3dB
    ...
    bz = [1, -2 * np.cos(notch_dig_w), 1]
    az = [1, -2 * r * np.cos(notch_dig_w), r ** 2]
    ws, hs = frequency_response(bz, az)
    hs = np.abs(hs)
    ws, hs = ws[len(ws) // 2:], hs[len(hs) // 2:]
    # first one lower than -3dB
    those_w_higher_than_minus_3_db = [w for w, h in zip(ws, hs) if db(h) < -3]
    if len(those_w_higher_than_minus_3_db) < 2:
        band_fs.append(0)
        continue
    l_f = dig_w_to_ana_f(those_w_higher_than_minus_3_db[0])
    r_f = dig_w_to_ana_f(those_w_higher_than_minus_3_db[-1])
    # print(l_f, r_f)
    band_f = r_f - l_f
    band_fs.append(band_f)

__draw(rs, band_fs)
min_r_making_band_with_1 = [r for r, band_f in zip(rs, band_fs) if band_f <= 1][0]
print(min_r_making_band_with_1)
```

```python
min_r = min_r_making_band_with_1
bz = [1, -2 * np.cos(notch_dig_w), 1]
az = [1, -2 * min_r * np.cos(notch_dig_w), min_r ** 2]
print(bz, az)
plot_complex_numbers(*pzmap(bz, az))
ws, hs = frequency_response(bz, az)
hs_plots = get_mod_pha_real_imag(hs)
ana_fs = dig_w_to_ana_f(ws)

prop_desc = ['Magnitude', 'Phase', 'Real', 'Imaginary']
for prop in range(2):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(ws, hs_plots[prop], '-', label=f'FTF {prop_desc[prop]}')
    plt.xlabel('w')
    plt.legend()
    fig.show()

DISPLAY_N = len(ws) // 2
fig = plt.figure(figsize=(18, 6))
plt.plot(ana_fs[DISPLAY_N:], db(hs_plots[0][DISPLAY_N:]), '-', label=f'Gain')
plt.axhline(y=-3, color='r', linestyle='--')  # Draw horizontal line at y = 0.707
plt.text(0, -2, 'y = -3', color='r', fontsize=12, va='center')  # Add text annotation
plt.scatter([23.5, 24.5], [-3, -3], color='red')
# 添加文本标注
plt.text(23.5, -3, '(23.5, -3)', color='red', fontsize=10, va='bottom', ha='right')
plt.text(24.5, -3, '(24.5, -3)', color='red', fontsize=10, va='bottom', ha='left')
plt.xlabel('f')
plt.legend()
fig.show()

```

=== Code for 4.b

```python
# [4.b]
_, ys = filter(bz, az, xs, 600)
fig = plt.figure(figsize=(18, 6))
plt.plot(ns, xs, '-', label=f'x')
plt.plot(ns, ys, '-', label=f'y')
plt.xlabel('n')
plt.legend()
fig.show()

```

=== Code for 4.c

```python
# [4.c]
comb_f = 24
notch_dig_w = ana_f_to_dig_w(comb_f)

def coef_of_r(r):
    return np.array([1, -2 * r * np.cos(notch_dig_w), r ** 2])
del_w = ana_f_to_dig_w(0.5)
print(del_w)
good_y = 0.15 # zero 必须接近单位圆，使得远离此频率时，不受该点影响
zero_r = 1 - good_y
x_with_band_1 = (del_w * good_y) / (2 * del_w ** 2 + good_y ** 2) ** 0.5
pole_r = 1 - x_with_band_1
print(x_with_band_1, del_w)
max_gain = (1 - zero_r) / (1 - pole_r)
print(max_gain)
bz = coef_of_r(zero_r) / max_gain
az = coef_of_r(pole_r)
print(bz, az)
ws, hs = frequency_response(bz, az, 50000)
plot_complex_numbers(*pzmap(bz, az))

# for r in rs:
#     # get the band width of -3dB
#     ...
#     bz = coef_of_r(r)
#     az = coef_of_r(omg_r)
#     max_gain = (1 - r) / (1 - omg_r)
#     ws, hs = frequency_response(bz, az, 30000)
#     hs = np.abs(hs) / max_gain
#     ws, hs = ws[len(ws) // 2:], hs[len(hs) // 2:]

#     # first one lower than -3dB
#     if r == rs[0]:
#         __draw(ws, hs)
#     those_w_higher_than_minus_3_db = [w for w, h in zip(ws, hs) if db(h) > -3]
#     if len(those_w_higher_than_minus_3_db) < 2:
#         band_fs.append(0)
#         continue
#     l_f = dig_w_to_ana_f(those_w_higher_than_minus_3_db[0])
#     r_f = dig_w_to_ana_f(those_w_higher_than_minus_3_db[-1])
#     # print(l_f, r_f)
#     band_f = r_f - l_f
#     band_fs.append(band_f)

# __draw(rs, band_fs)
# min_zero_r_making_band_with_1 = [r for r, band_f in zip(rs, band_fs) if band_f >= 1][0]
# print(min_zero_r_making_band_with_1)
```

```python
m_ys = np.linspace(0, 1, 1000)
m_ms = [(2 / (1 - (1 / (2 * del_w ** 2 / y ** 2 + 1)))) ** 0.5 for y in m_ys]
__draw(m_ys, db(m_ms))
mm_ms = [(2 + y ** 2 / del_w ** 2) ** 0.5 for y in m_ys]
__draw(m_ys, db(mm_ms))
```

```python
hs_plots = get_mod_pha_real_imag(hs)
ana_fs = dig_w_to_ana_f(ws)

prop_desc = ['Magnitude', 'Phase', 'Real', 'Imaginary']
for prop in range(2):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(ws, hs_plots[prop], '-', label=f'FTF {prop_desc[prop]}')
    plt.xlabel('w')
    plt.legend()
    fig.show()

ana_fs_idx_around_24 = np.where((ana_fs > 0))

fig = plt.figure(figsize=(18, 6))
plt.plot(ana_fs[ana_fs_idx_around_24], db(hs_plots[0][ana_fs_idx_around_24]), '-', label=f'Gain')
plt.axhline(y=-3, color='r', linestyle='--')  # Draw horizontal line at y = 0.707
plt.text(23, -2.8, 'y = -3', color='r', fontsize=12, va='center')  # Add text annotation
plt.scatter([23.5, 24.5], [-3, -3], color='red')
# 添加文本标注
plt.text(23.5, -3, '(23.5, -3)', color='red', fontsize=10, va='bottom', ha='right')
plt.text(24.5, -3, '(24.5, -3)', color='red', fontsize=10, va='bottom', ha='left')
plt.xlabel('f')
plt.legend()
fig.show()
```

=== Code for 4.d

```python
# [4.d]
_, ys = filter(bz, az, xs, 600)
fig = plt.figure(figsize=(18, 6))
plt.plot(ns, xs, '-', label=f'x')
plt.plot(ns, ys, '-', label=f'y')
plt.xlabel('n')
plt.legend()
fig.show()
```

