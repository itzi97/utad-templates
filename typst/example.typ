// ============================================================
//  Machine Learning Project Report — Typst edition, worked example
//
//  A FICTIONAL, generic sample used to exercise every feature in
//  utad-report.typ: the title page, Introduction, dataset/approach,
//  one complete workstream (with its evolution-chain diagram), the
//  Gantt-style timeline, the full development log, and References.
//  It is not a real submission and describes no real person or
//  organisation — swap in your own content. Mirrors example.tex so
//  the two templates can be compared.
//
//  Every helper used below is documented — Typst and LaTeX side by
//  side — in ../docs/GUIDE.md under "Component reference".
// ============================================================

#import "utad.typ": *
#import "utad-report.typ": *

#show: utad-doc.with(
  title: [Image Classification with CNNs],
  subtitle: [Machine Learning Project],
  subject: [Machine Learning],
  degree: [B.S. in Software Engineering, Minor in Data Science & AI],
  year: [4],
  teacher: [Teacher Name],
  author: "Your Name",
  date: "May 2026",
  variant: "full",
  short-title: [ML Project Report],
)

#utad-outline()


= Abstract
#note(title: [Summary])[
  A convolutional neural network is trained to classify the Fashion-MNIST
  dataset (28×28 grayscale images, 10 clothing categories). Starting from a
  plain baseline, the model is refined across eight tracked revisions; the
  final network reaches competitive test accuracy, evaluated once on a
  held-out set.
]

= Introduction

== Context and Motivation
Image classification is a canonical supervised-learning task and a natural
vehicle for practicing the full machine-learning workflow: preparing data,
choosing and iterating on a model, tuning it against a validation set, and
reporting an honest estimate of generalization. This project takes
Fashion-MNIST -- a drop-in, harder replacement for the classic
handwritten-digit dataset -- and builds a convolutional classifier for it
from a simple baseline upward.

The task is a good fit for the degree's focus in that it combines software
engineering (a clean, reproducible training pipeline in Python) with the
data-science reasoning behind each modeling decision, so that every accuracy
gain can be attributed to a specific, justified change rather than to
undocumented trial and error. Every design choice in @ws-model is measured
against a fixed validation split before it is kept, and the test set is
touched only once.

== Objectives
+ *General objective:* To apply and consolidate the machine-learning
  competencies acquired during the degree by building, training, and
  evaluating an image classifier end to end.
+ Iteratively refine a convolutional model, replacing a naive baseline with
  a tuned network whose every change is measured against a fixed validation
  split.
+ Apply sound evaluation practice -- a single, final test-set measurement --
  so the reported accuracy is an unbiased estimate of generalization.
+ Document the modeling decisions and their measured effect clearly enough
  that the experiment is reproducible.
+ Extend the trained model into a small inference pipeline suitable for a
  deployment demo.

== Report Structure
This report is organized as follows: Chapter 3 describes the dataset, the
pipeline architecture, and the tools used. Chapter 4 details the modeling
work, organized by workstream. Chapter 5 maps this work to the degree's
stated competencies. Chapter 6 reflects on the challenges encountered.
Chapter 7 presents overall conclusions. Appendices A and B provide a
week-by-week development log and references, respectively.

= Dataset and Approach

== Dataset
Fashion-MNIST consists of 70,000 grayscale images (60,000 train, 10,000
test) at 28×28 resolution, in ten balanced classes (t-shirt, trouser,
pullover, dress, coat, sandal, shirt, sneaker, bag, ankle boot). A fixed 10%
slice of the training set is held out as a validation split; the official
test set is reserved for a single final measurement.

== Pipeline Architecture
The classifier is organized as a small pipeline: preprocessing, a
convolutional feature extractor, and a dense classifier head. The
convolutional feature extractor (highlighted) was the focus of the iteration
work described in @ws-model.

#figure(
  orgchart(
    org-node("Classification Pipeline", style: "root",
      org-node("Preprocessing",
        org-node("Normalize / augment")),
      org-node("CNN Model",
        org-node("Conv feature extractor", style: "highlight"),
        org-node("Classifier head")),
      org-node("Evaluation")),
  ),
  caption: [Architecture of the classification pipeline.],
)

== Tools and Libraries
#utad-table(
  columns: (auto, 1fr),
  header: ([Category], [Tools / Libraries]),
  [Language], [Python 3.11],
  [Modeling], [PyTorch, torchvision],
  [Numerics], [NumPy],
  [Plotting], [Matplotlib],
  [Experiment Tracking], [Weights & Biases (logging only)],
  [Environment], [Jupyter, Conda],
  [Version Control], [Git, GitLab (feature-branch workflow)],
)

= Experiments

The workstreams below are presented topically rather than strictly in
calendar order; data preparation and early modeling genuinely overlapped in
time.

#timeline(total-days: 31, rows: (
  ("Model Development (v1–v8)", 1, 15, "done"),
  ("Validation Sweeps", 13, 15, "done"),
  ("Final Test Eval", 14, 14, "milestone"),
  ("Data Augmentation Study (v1–v5)", 12, 20, "done"),
  ("Self-Directed Upskilling", 13, 31, "done"),
  ("Inference Pipeline Setup", 20, 20, "done"),
  ("Deployment Demo (planned)", 21, 31, "planned"),
), links: (
  (0, 5),   // Model Development  ->  Inference Pipeline Setup
  (5, 6),   // Inference Pipeline Setup  ->  Deployment Demo (planned)
))

== Model Development <ws-model>

=== Objective
Develop a convolutional classifier that generalizes well to unseen
Fashion-MNIST images, improving on a naive baseline through a sequence of
individually-measured changes, each validated on the fixed validation split
before being kept.

=== Model Evolution (v1 -- v8)
#evolution-chain(
  ("v1", "Baseline MLP", "start"),
  ("v2", "Simple CNN", "mid"),
  ("v3", "Normalization", "mid"),
  ("v4", "Deeper net", "mid"),
  ("v5", "Dropout", "mid"),
  ("v6", "Augmentation", "mid"),
  ("v7", "LR schedule", "mid"),
  ("v8", "Final model", "final"),
)

- *v1 -- Baseline MLP.* A single fully-connected hidden layer on flattened
  pixels, as a measured floor for everything that follows.
- *v2 -- Simple CNN.* Two convolution-and-pool blocks, which cut the
  validation error sharply by exploiting spatial structure the MLP ignored.
- *v3 -- Normalization.* Added batch normalization, which stabilized
  training and allowed a higher learning rate.
- *v4 -- Deeper network.* A third convolutional block, trading a little
  compute for a further validation-accuracy gain.
- *v5 -- Dropout.* Added dropout to the dense head to close the
  train/validation gap that appeared once the network was deep enough to
  overfit.
- *v6 -- Data augmentation.* Random crops and horizontal flips, studied
  separately in the augmentation workstream, folded in here.
- *v7 -- Learning-rate schedule.* A cosine decay schedule, which squeezed
  out the last fraction of a percent on the validation split.
- *v8 -- Final model.* Locked architecture and hyperparameters after the
  validation sweeps; this is the only version measured on the test set.

=== Technical Details
#raw(lang: "python", block: true, "# One training epoch: forward pass, cross-entropy loss, backprop, SGD step.
def train_epoch(model, loader, optimizer, device):
    model.train()
    running = 0.0
    for images, labels in loader:
        images, labels = images.to(device), labels.to(device)
        optimizer.zero_grad()
        logits = model(images)
        loss = F.cross_entropy(logits, labels)   # softmax + NLL
        loss.backward()
        optimizer.step()
        running += loss.item() * images.size(0)
    return running / len(loader.dataset)")

#important(title: [Measured once, not tuned against])[
  Every architecture and hyperparameter choice above was selected using the
  validation split only. The held-out test set was evaluated exactly once,
  on the final model (v8), so the reported test accuracy is an honest
  estimate of generalization rather than a number the model was tuned
  toward.
]

=== Objective Function
The network outputs class scores $z_c$ that a softmax turns into a
probability distribution over the $C = 10$ classes:
$ p_c = e^(z_c) / (sum_(j=1)^C e^(z_j)). $
For a single labeled example with one-hot target $y$, training minimizes the
cross-entropy between the target and the predicted distribution:
$ cal(L) = - sum_(c=1)^C y_c log p_c . $
Over a training set of $N$ examples, the optimizer minimizes the mean loss,
taking a stochastic-gradient step with learning rate $eta$ each iteration:
$ J(theta) = 1/N sum_(i=1)^N cal(L)_i, quad
  theta <- theta - eta nabla_theta J(theta) . $

=== Results
#utad-table(
  columns: (1fr, auto, auto),
  cell-align: (left, right, right),
  header: ([Model], [Val. accuracy], [Params]),
  [v1 -- Baseline MLP], [87.9%], [0.10M],
  [v2 -- Simple CNN], [90.6%], [0.23M],
  [v5 -- + Dropout], [91.8%], [0.23M],
  [v8 -- Final model], [93.1%], [0.41M],
)

The final model reached *92.7%* accuracy on the held-out test set -- close
to its validation figure, indicating little overfitting to the validation
split.

#pagebreak()
== Data Augmentation Study <ws-aug>
#note(title: [Not fully written up])[
  This workstream is stubbed in this sample. It exists so the
  cross-reference from Model Development resolves to something real --
  replace it with your own content.
]

#note(title: [Remaining sections -- placeholder])[
  Validation Sweeps, Inference Pipeline Setup, and the Deployment Demo are
  stubbed here -- replace with your own write-ups.
]

= Competencies and Learning Outcomes
#note(title: [Status])[Placeholder.]

= Challenges and Lessons Learned
#note(title: [Status])[Placeholder.]

= Conclusions
#note(title: [Status])[Placeholder.]

#counter(heading).update(0)
#set heading(numbering: "A.1")

= Development Log

#weeklog("1 (Week 1)",
  [Set up the data pipeline and reproducible training loop; established the validation split; trained the baseline MLP (v1) as a measured floor.],
  [Python, PyTorch, NumPy.],
  [Reproducible pipeline and a measured baseline (v1, 87.9% val).])

#weeklog("2 (Week 2)",
  [Introduced convolutional blocks and batch normalization; iterated the model through several revisions (v2--v4); began plotting learning curves.],
  [PyTorch, torchvision, Matplotlib.],
  [Convolutional model clearly beat the MLP baseline; first learning-curve plots for review.])

#weeklog("3 (Week 3)",
  [Added dropout and data augmentation (v5--v6); ran validation sweeps over learning rate and augmentation strength; introduced a learning-rate schedule (v7).],
  [PyTorch, Weights & Biases (logging).],
  [Closed the train/validation gap; selected hyperparameters entirely on the validation split.])

#weeklog("4 (Week 4)",
  [Locked the final model (v8); ran the single test-set evaluation; assembled an inference pipeline and a 24-test regression suite to a green result.],
  [PyTorch, Git, GitLab.],
  [Final test accuracy of 92.7%; green regression suite; reproducible end-to-end run.])

= References

#reference-list((
  [Goodfellow, I., Bengio, Y., & Courville, A. #emph[Deep Learning]. MIT Press. #link("https://www.deeplearningbook.org/")],
  [Xiao, H., Rasul, K., & Vollgraf, R. #emph[Fashion-MNIST: a Novel Image Dataset for Benchmarking Machine Learning Algorithms]. #link("https://arxiv.org/abs/1708.07747")],
  [Kingma, D. P., & Ba, J. #emph[Adam: A Method for Stochastic Optimization]. #link("https://arxiv.org/abs/1412.6980")],
  [PyTorch Team. #emph[PyTorch Documentation]. #link("https://pytorch.org/docs/")],
))
