// ============================================================
//  Worked example -- compact assignment template (utad-assignment.typ)
//  A short problem set: masthead header on page 1, questions flow on.
//  Compile: typst compile assignment.typ assignment.pdf
// ============================================================

#import "utad-assignment.typ": *

#show: assignment.with(
  title: [Problem Set 3],
  subtitle: [Series and Fourier Transforms],
  subject: [Mathematical Analysis],
  degree: [Software Engineering w/ AI & Data Science],
  year: [4],
  teacher: [Teacher Name],
  author: "Your Name",
  date: "May 24, 2026",
  contents: true,
)

= Convergence of a Power Series
Determine the radius of convergence $R$ of the power series
$ sum_(n=1)^oo (x^n) / (n dot 2^n). $

*Solution.* Apply the ratio test to the coefficients $a_n = 1 / (n dot 2^n)$:
$ lim_(n->oo) abs(a_(n+1) / a_n)
  = lim_(n->oo) (n dot 2^n) / ((n+1) dot 2^(n+1))
  = lim_(n->oo) n / (2(n+1)) = 1/2. $
Hence $R = 1 \/ (1\/2) = 2$. The series converges absolutely for $abs(x) < 2$
and diverges for $abs(x) > 2$; the endpoints $x = plus.minus 2$ must be
checked separately.

#note(title: [Endpoint check])[
  At $x = 2$ the series becomes the harmonic series $sum 1\/n$ (divergent);
  at $x = -2$ it becomes the alternating harmonic series $sum (-1)^n \/ n$
  (convergent). So the interval of convergence is $[-2, 2)$.
]

= Fourier Coefficients
Compute the Fourier sine-series coefficients $b_n$ of $f(x) = x$ on the
interval $(0, pi)$, given
$ b_n = 2/pi integral_0^pi x sin(n x) dif x. $

*Solution.* Integrating by parts with $u = x$, $dif v = sin(n x) dif x$:
$ integral_0^pi x sin(n x) dif x
  = [-x cos(n x) / n]_0^pi + 1/n integral_0^pi cos(n x) dif x
  = (-pi cos(n pi)) / n = (pi (-1)^(n+1)) / n. $
Therefore
$ b_n = 2/pi dot (pi (-1)^(n+1)) / n = (2 (-1)^(n+1)) / n. $

= A Short Computation
The partial sums above were checked numerically with the snippet below,
which sums the sine series and compares it against $f(x) = x$ at a set of
sample points.

#raw(lang: "python", block: true, "import numpy as np

def sine_series(x, terms=50):
    n = np.arange(1, terms + 1)
    b = 2 * (-1) ** (n + 1) / n          # Fourier sine coefficients
    return (b[:, None] * np.sin(np.outer(n, x))).sum(axis=0)

xs = np.linspace(0.1, np.pi - 0.1, 5)
err = np.max(np.abs(sine_series(xs) - xs))
print(f'max error over sample points: {err:.4f}')")

The maximum error over the sample points falls off roughly like
$O(1\/sqrt(N))$ in the number of terms $N$, consistent with the slow
convergence expected near the jump discontinuity of the periodic extension.

= Discussion Question
#exercise([State it in your own words])[
  Explain, in two or three sentences, why the Fourier series of $f(x) = x$
  exhibits the Gibbs phenomenon near $x = pi$, and what happens to the
  overshoot as the number of terms increases.
]

*Answer.* The periodic extension of $f(x) = x$ has a jump discontinuity at
$x = pi$ (from $pi$ down to $-pi$). Near a jump, the partial sums overshoot
the true value by a fixed fraction (~9%) of the jump height no matter how
many terms are taken -- the overshoot narrows and moves toward the
discontinuity as $N -> oo$, but its height does not vanish.

= References
#set enum(numbering: "[1]")
+ Stein, E. M., & Shakarchi, R. #emph[Fourier Analysis: An Introduction].
  Princeton University Press.
+ Tolstov, G. P. #emph[Fourier Series]. Dover Publications.
