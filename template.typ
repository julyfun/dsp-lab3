#set page(paper: "us-letter")
#set heading(numbering: "1.a.1.")
#set figure(numbering: "1")

// 这是注释
#figure(image("pic/sjtu.png", width: 50%), numbering: none) \ \ \

#align(center, text(17pt)[
  *Laboratory Report of Digital Signal Processing* \ \
  #table(
      columns: 2,
      stroke: none,
      rows: (2.5em),
      // align: (x, y) =>
      //   if x == 0 { right } else { left },
      align: (right, left),
      [Name:], [Junjie Fang],
      [Student ID:], [521260910018],
      [Date:], [2024/3/4],
      [Score:], [],
    )
])

#pagebreak()

#set page(header: align(right)[
  DSP Lab2 Report - Junjie FANG
], numbering: "1")

#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  strong(it)
}

_Source Code_: #link("https://github.com/julyfun/dsp-lab2")

#outline(indent: 1.5em)

= Signal operations <1>

Given the parameters $A = 3, B = 4, D = 8$, the three gate functions are defined
by:

$
  g_0(t) &:= cases(4 "if" 0 <= t <= 3, 0 "otherwise") \
  g_1(t) &:= cases(4 "if" -3 / 8 <= t <= -3 / 5 \
  0 "otherwise") \
  g_2(t) &:= cases(8 "if" 8 <= t <= 11 \
  0 "otherwise")
$

And we know:

$
  x(t) := sum_(i = 0)^2 g_i (t)
$

We plot the $x$ function in the figure below:


It can be seen that the images of the three gate functions do not overlap.

In practice, we use python's `matplotlib` to draw function images. For
scalability, we use the `gate_func()`, `func_transform()` and
`add_func()` to generate, transform and add functions.

= Aliasing phenomenon in sampling process

Let the frequencies corresponding to the two peaks in the image be $f_(a 1) = 14, f_(a 2) = 3$ and
the function values be $X_1 = 2, X_2 = 1$. The sampling frequency is $f_s = 100"Hz"$.
According to the sampling theorem, we have:

$
  f_(a 1) &= plus.minus f_1 - k_1 f_s\
  f_(a 2) &= plus.minus f_2 - k_2 f_s\
$

where:

$
  k_1, k_2 != 0 \
  800"Hz" <= f_1, f_2 <= 850"Hz"
$

Plug the data $f_(a 1) = 14, f_(a 2) = 3$ into the equation and we can determine
that the only solution is:

$
  k_1 = 8, f_1 = 814"Hz" \
  k_2 = 8, f_2 = 803"Hz"
$

Next, we can determine the amplitudes $A_1$ and $A_2$ by reviewing some of the
properties of _Contiunous-Time Fourier Transform (CTFT)_. The Fourier Transform 
used in this question is in the form:

$
  X(j f) &= integral_(-oo)^(+oo) x(t) e^(-j 2 pi f t) dif t \
  x(t) &= integral_(-oo)^(+oo) X(j f) e^(j 2 pi f t) dif f
$

To sample the function from $0s$ to $5s$ is equivalent to 

In this form, the sine wave with amplitude $1$ and the following sum of two
impulse function form a Fourier Transform pair, and we take modulo in this formula:

$
  ||cal(F)[sin(2 pi f_0 t)]|| = 1 / 2 (delta(f - f_0) + delta(f + f_0)) \
$

Due to linearity of Fourier Transform, we have:

$
  ||cal(F)[x(t)]|| &= ||cal(F)[A_1 sin(2 pi f_1 t) + A_2 sin(2 pi f_2 t)]|| \
  &= A_1 / 2 (delta(f - f_1) + delta(f + f_1)) + A_2 / 2 (delta(f - f_2) + delta(f + f_2)) \
$

Sampling the function from $0s$ to $5s$ is equivalent to multiplying a gate function with height $1$ and width $5$, that is,
the Fourier tranform of the two functions is convolved in the frequency domain. Suppose this gate function is $g$, and we have:

$
  ||cal(F)[g(t)]|| = |5 sinc(5 f)|
$

Where $5$ is the width of the gate function. From the above conclusion, we can infer that the image of _CTFT_ is the convolution of the two:

$
  ||cal(F)[x(t)]|| &= lr(||cal(F)[g(t)] * cal(F)[A_1 sin(2 pi f_1 t) + A_2 sin(2 pi f_2 t)]||) \
  &= norm(5 sinc(5f) * (A_1 / 2 (delta(f - f_1) + delta(f + f_1)) + A_2 / 2 (delta(f - f_2) + delta(f + f_2)))) \ 
  &= norm(5 / 2 lr((A_1 sinc(5(f - f_1)) + A_1 sinc(5(f + f_1)) + A_2 sinc(5(f - f_2)) + A_2 sinc(5(f + f_2)))))
$

Therefore, the peak values $X_1, X_2$ is $5 / 2$ times the amplitudes $A_1$ and $A_2$:

$
  A_1 = 2 / 5 X_1 = 4 / 5 \
  A_2 = 2 / 5 X_2 = 2 / 5
$
