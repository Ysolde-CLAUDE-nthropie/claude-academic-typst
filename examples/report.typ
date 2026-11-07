// Showcase for claude-academic. Compile from the repository root:
//   typst compile --root . --font-path fonts examples/report.typ
// All numbers in this document are synthetic and exist only to exercise the layout.

#import "../claude-academic/lib.typ": *

#show: report.with(
  title: [Calibrated Confidence in Language Models under Distribution Shift],
  subtitle: [A short technical report on temperature scaling, binning, and what they miss],
  short-title: [Calibrated confidence under shift],
  kind: [Technical report · No. 7],
  authors: (
    (name: "Ada Whitfield", affiliation: "Institute for Careful Machines", email: "ada@icm.example"),
    (name: "Rafael Okonkwo", affiliation: "Institute for Careful Machines"),
    (name: "Mei Lin Sato", affiliation: "Department of Statistics, Northbridge University", email: "msato@nbu.example"),
  ),
  date: datetime(year: 2026, month: 11, day: 7),
  abstract: [
    A model is _calibrated_ when the confidence it reports matches the frequency with which it is right. We study how calibration of a mid-sized language model degrades when the evaluation distribution drifts away from the data used to fit post-hoc corrections. Temperature scaling reduces the expected calibration error from 9.8% to 2.1% in distribution, but recovers less than half of that gain under shift. We give a simple decomposition of the error into a _sharpness_ term and a _shift_ term, prove that the latter is invariant to any monotone recalibration map, and close with practical recommendations.
  ],
  keywords: ("calibration", "distribution shift", "language models", "uncertainty"),
)

= Introduction

Probabilistic forecasts are only as useful as they are honest. A weather service that announces a 70% chance of rain should see rain on roughly seven of every ten such days; the same standard applies to a classifier, and increasingly to a language model asked to state how sure it is @brier1950 @kadavath2022. Modern neural networks, however, are often _over_-confident: their predicted probabilities are systematically higher than their accuracy @guo2017.

Post-hoc recalibration is the usual remedy. One fits a small map on held-out data, with temperature scaling the most popular choice, and applies it at test time. The method is cheap and, in distribution, remarkably effective. This report asks a narrower question: _how much of that improvement survives when the test distribution moves?_#footnote[All numbers in this document are synthetic. They exist to exercise the template, not to make a scientific claim.]

Our contributions are threefold:
- a decomposition of calibration error into components that do and do not respond to recalibration (@sec-theory);
- an empirical comparison across four shift conditions (@sec-results), summarised in @tab-main;
- a short list of recommendations for practitioners (@sec-discussion).

= Background <sec-background>

== Calibration error

Let $f: cal(X) -> Delta^(K-1)$ be a classifier that outputs a distribution over $K$ classes, with confidence $hat(p)(x) = max_k f_k (x)$ and prediction $hat(y)(x) = arg max_k f_k (x)$. The model is perfectly calibrated if
$
  PP[hat(y)(X) = Y | hat(p)(X) = p] = p quad "for all" p in [0, 1].
$ <eq-calibration>
In practice we estimate the gap between the two sides of @eq-calibration by partitioning confidences into $M$ equal-width bins $B_1, dots, B_M$ and computing the expected calibration error @naeini2015,
$
  "ECE" = sum_(m=1)^M (|B_m|) / n thin |"acc"(B_m) - "conf"(B_m)|.
$ <eq-ece>

== Temperature scaling

Given logits $z in RR^K$, temperature scaling replaces the softmax $sigma(z)$ by $sigma(z \/ T)$ for a single scalar $T > 0$ fitted by minimising negative log-likelihood on a validation set. Because $T$ rescales all logits uniformly, it never changes the predicted class, only the confidence attached to it.

#nonumber($ hat(T) = arg min_(T > 0) - sum_(i=1)^n log sigma(z_i \/ T)_(y_i) $)

= A decomposition <sec-theory>

We write $P$ for the distribution on which the recalibration map is fitted and $Q$ for the distribution on which the model is deployed.

#definition(title: [Recalibration map])[
  A _recalibration map_ is a non-decreasing function $g: [0,1] -> [0,1]$ applied to the model's confidence. Temperature scaling, histogram binning, and isotonic regression all induce such maps.
]

#theorem(title: [Shift invariance])[
  Let $g$ be any recalibration map and let $Delta(p) = PP_Q [hat(y) = Y | hat(p) = p] - PP_P [hat(y) = Y | hat(p) = p]$ be the _shift gap_. Then the calibration error of $g compose hat(p)$ under $Q$ is bounded below by
  $ EE_Q [ |Delta(hat(p))| ] - "ECE"_P (g compose hat(p)). $
  In particular, no monotone recalibration fitted on $P$ can remove the shift gap.
] <thm-shift>

#proof[
  Fix $p$ and write $a_P (p)$ and $a_Q (p)$ for the conditional accuracies. By the triangle inequality, $|a_Q (p) - g(p)| >= |a_Q (p) - a_P (p)| - |a_P (p) - g(p)|$. Taking expectations under $Q$ and noting that $g$ depends on $p$ only through its value gives the claim.
]

#remark[
  @thm-shift is deliberately loose. Its value is qualitative: it separates the part of the error that a better fit on $P$ could fix from the part that only data from $Q$ can.
]

#corollary[
  If $Delta(p) = 0$ for all $p$, temperature scaling fitted on $P$ is as good under $Q$ as under $P$.
]

= Results <sec-results>

#stats(
  (value: "9.8%", label: "Raw ECE"),
  (value: "2.1%", label: "Scaled ECE, in-dist."),
  (value: "6.4%", label: "Scaled ECE, shifted"),
  (value: "1.41", label: "Fitted temperature"),
)

@fig-reliability shows reliability diagrams before and after temperature scaling. In distribution, the bars hug the diagonal; under shift, the high-confidence bins fall away from it again, as @thm-shift predicts.

#let reliability(acc, caption: none) = {
  let w = 112pt
  let h = 92pt
  let n = acc.len()
  let bw = w / n
  box(width: w + 26pt, height: h + 30pt, {
    // grid
    for i in range(5) {
      let y = h - i * h / 4
      place(dx: 22pt, dy: y, line(length: w, stroke: 0.3pt + palette.oat))
      place(dx: 0pt, dy: y - 4pt, box(width: 18pt, align(right, text(font: fonts.sans, size: 5.5pt, fill: palette.muted, str(i * 25)))))
    }
    // bars
    for (i, a) in acc.enumerate() {
      place(dx: 22pt + i * bw + 0.8pt, dy: h - a * h, rect(width: bw - 1.6pt, height: a * h, fill: palette.clay, stroke: none))
    }
    // ideal
    place(dx: 22pt, dy: 0pt, line(start: (0pt, h), end: (w, 0pt), stroke: (paint: palette.ink, thickness: 0.6pt, dash: (2pt, 1.6pt))))
    // axes
    place(dx: 22pt, dy: h, line(length: w, stroke: 0.6pt + palette.ink))
    place(dx: 22pt, dy: h + 5pt, box(width: w, align(center, text(font: fonts.sans, size: 5.8pt, fill: palette.muted)[Confidence])))
    if caption != none {
      place(dx: 22pt, dy: h + 15pt, box(width: w, align(center, text(font: fonts.sans, size: 6.5pt, weight: 600, fill: palette.ink, caption))))
    }
  })
}

#figure(
  grid(
    columns: 3, column-gutter: 4pt,
    reliability((0.04, 0.10, 0.17, 0.24, 0.31, 0.40, 0.48, 0.56, 0.66, 0.79), caption: [Uncalibrated]),
    reliability((0.05, 0.14, 0.25, 0.34, 0.46, 0.55, 0.64, 0.74, 0.84, 0.94), caption: [Scaled, in distribution]),
    reliability((0.05, 0.13, 0.23, 0.32, 0.41, 0.50, 0.57, 0.63, 0.70, 0.78), caption: [Scaled, under shift]),
  ),
  caption: [Reliability diagrams. Each bar is the accuracy within a confidence bin; the dashed line marks perfect calibration. Temperature scaling closes most of the gap in distribution, but the top bins drift away again under shift.],
) <fig-reliability>

@fig-shift shows the same story as a function of shift severity: the scaled error and the shift gap rise together, while the raw error rises more slowly from a higher base.

#figure(
  image("figures/shift.svg", width: 100%),
  caption: [Left: calibration error as the evaluation distribution moves away from the validation distribution. Right: scaled ECE per condition; the adversarial condition is highlighted. Drawn with matplotlib using `scripts/plot_style.py`.],
) <fig-shift>

@tab-main breaks the error down by shift condition. Two patterns stand out. First, the after-scaling error tracks the size of the shift gap almost exactly. Second, the Brier score, a proper scoring rule, moves far less than ECE, a reminder that ECE is sensitive to binning choices.

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr),
    align: (left, right, right, right, right),
    table.header[Condition][ECE (raw)][ECE (scaled)][Shift gap][Brier],
    [In distribution], [9.8], [*2.1*], [0.3], [0.142],
    [Paraphrase], [10.4], [3.0], [1.2], [0.149],
    [New domain], [12.9], [6.4], [4.6], [0.171],
    [Adversarial], [17.2], [11.8], [9.9], [0.208],
    [Temporal (+12 mo.)], [11.1], [4.7], [2.8], [0.158],
  ),
  caption: [Calibration under four shift conditions. ECE and shift gap in percentage points; lower is better throughout.],
) <tab-main>

#callout(title: [Key finding], tone: "accent")[
  Under shift, the residual calibration error after temperature scaling is almost entirely explained by the shift gap $Delta$. Fitting the temperature more carefully on in-distribution data cannot help; collecting even a small labelled sample from the target distribution can.
]

= Discussion <sec-discussion>

The decomposition suggests a division of labour. Recalibration on held-out data handles _sharpness_, and does so well. Robustness to shift has to come from elsewhere: from target-domain data, from ensembles, or from models whose uncertainty is better grounded in the first place @vaswani2017.

#pullquote(attribution: [A reviewer, paraphrased])[
  Calibration is not a property of a model. It is a property of a model _and_ a distribution.
]

== Practical recommendations

+ Report calibration on the deployment distribution, not only on a held-out split of the training data.
+ Prefer proper scoring rules, such as the Brier score or log-loss, alongside ECE.
+ When the deployment distribution is known to drift, refit the temperature periodically on fresh labels.

The procedure we used is short enough to reproduce in full:

```python
import torch
import torch.nn.functional as F

def fit_temperature(logits: torch.Tensor, labels: torch.Tensor) -> float:
    """Fit a single temperature by minimising NLL on held-out data."""
    log_t = torch.zeros(1, requires_grad=True)
    opt = torch.optim.LBFGS([log_t], lr=0.1, max_iter=200)

    def closure():
        opt.zero_grad()
        loss = F.cross_entropy(logits / log_t.exp(), labels)
        loss.backward()
        return loss

    opt.step(closure)
    return log_t.exp().item()  # T > 1 softens, T < 1 sharpens
```

== Limitations

We study a single model family and four hand-picked shift conditions. The bound in @thm-shift is loose, and the inline `ECE` estimator is biased for small bins. None of these caveats change the qualitative conclusion.

#heading(numbering: none)[Acknowledgments]

We thank the anonymous reviewers for their careful reading, and the maintainers of Typst for a typesetting system that made this report pleasant to write.

#bibliography("refs.bib")

#show: appendix

= Additional details <sec-appendix>

== Binning

All ECE numbers use $M = 15$ equal-width bins. With equal-mass bins the ranking of conditions in @tab-main is unchanged.

#lemma[
  For any binning scheme with $M$ bins, $"ECE" <= max_m |"acc"(B_m) - "conf"(B_m)|$.
]

#proof[Immediate: ECE is a convex combination of the per-bin gaps.]

== Notation

/ $hat(p)(x)$: confidence, the largest predicted class probability.
/ $T$: temperature; $T > 1$ softens the distribution.
/ $Delta(p)$: shift gap between deployment and validation accuracy at confidence $p$.
