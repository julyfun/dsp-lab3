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

#figure(image("pic/1.b.1.png", width: 70%))
#figure(image("pic/1.b.2.png", width: 70%))

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

#figure(image("pic/1.c.png", width: 70%))

#pagebreak()

==

To draw the impulse response, we can set the input $x = [1]$ in the sequence $"xn" = [0]$. The first six output is $[2, 4, 2, 1, 0, 0]$ and the following is all $0$, where the figure is as below:

#figure(image("pic/1.d.png", width: 70%))

=

