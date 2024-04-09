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

As the two frequencies are $f_1 = 7, f_2 = 24$, we can choose $f_c = 15$ as the cut-off frequency, therefore, the cut-off angular frequency is $w_c = 2 pi f_c / f_s$, where $f_s = 200$.

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

= Pole/Zero Designs

