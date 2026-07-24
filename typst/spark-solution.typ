// ============================================================
//  Worked example -- solution-set style with the question() box
//  (content adapted from a SparkSQL2 exercise sheet)
//  Compile: typst compile spark-solution.typ spark-solution.pdf
// ============================================================

#import "utad-assignment.typ": *

#show: assignment.with(
  title: [SparkSQL 2],
  subtitle: [Outlier detection & categorical encoding],
  subject: [Big Data],
  degree: [Software Engineering w/ AI & Data Science],
  year: [4],
  teacher: [Teacher Name],
  author: "Your Name",
  date: "June 3, 2026",
  contents: true,
)

Working dataframe used throughout:

#raw(lang: "scala", block: true, "val winesdf = spark.read.format(\"csv\")
  .option(\"header\", \"true\").option(\"delimiter\", \"|\")
  .option(\"inferSchema\", \"true\").load(\"/root/winequality-red-white.txt\")

val double_cols = winesdf.dtypes
  .filter { case (c, t) => t.equalsIgnoreCase(\"DoubleType\") }.map(_._1)")

= Outlier detection with the IQR rule
#question[
  Apply the following rule to identify candidate values as *outliers* for each
  variable. We mark as anomalous those points that have the majority of their
  dimensions flagged as outliers.

  #set enum(numbering: "a.")
  + Candidate outliers variable by variable using the Interquartile Range.
    With $"IQR" = Q_3 - Q_1$, a value is an outlier if it falls below
    $Q_1 - 1.5 dot "IQR"$ or above $Q_3 + 1.5 dot "IQR"$. Generate a new column
    `variable_outlier` for each variable.
  + For each sample, count the dimensions in which it is anomalous and keep
    those with three or more.
]

#solution[] We take the quantiles with `approxQuantile`, then fold over the
numeric columns adding one `_outlier` flag column per variable.

#note(title: [`approxQuantile`])[
  Computes approximate quantiles of a numeric column. For a request at
  probability $p$ with relative error `err`, the returned value $x$ satisfies
  $ floor((p - "err") dot N) <= "rank"(x) <= ceil((p + "err") dot N). $
  Setting `relativeError = 0.0` computes the exact quantiles (expensive).
]

#raw(lang: "scala", block: true, "val out_winesdf = double_cols.foldLeft(winesdf) { case (acc, c) =>
  val Array(q1, q3) = acc.stat.approxQuantile(c, Array(0.25, 0.75), 0.0)
  acc.withColumn(c + \"_outlier\",
    when((col(c) < (lit(q1) - lit(1.5) * (lit(q3) - lit(q1)))) ||
         (col(c) > (lit(q3) + lit(1.5) * (lit(q3) - lit(q1)))), 1).otherwise(0))
}")

For part (b) we sum the per-variable flags and keep the rows that are clean in
all but two dimensions:

#raw(lang: "scala", block: true, "val clean_winesdf = out_winesdf
  .withColumn(\"num_outliers\", double_cols.map(c => col(c + \"_outlier\")).reduce(_ + _))
  .filter(col(\"num_outliers\") < 3)")

= Encoding a categorical variable
#question[
  Encode the categorical column `style`: first build an index column
  `idx_style` with `StringIndexer`, then one-hot encode it.
]

#solution[] `StringIndexer` maps the string labels to numeric indices ordered by
frequency (most frequent gets index `0`); `OneHotEncoder` then turns those
indices into sparse binary vectors, dropping the last category by default so
the entries stay linearly independent.

#raw(lang: "scala", block: true, "import org.apache.spark.ml.feature.{StringIndexer, OneHotEncoder}

val idxr = new StringIndexer()
  .setInputCol(\"style\").setOutputCol(\"idx_style\").fit(winesdf)
val encdr = new OneHotEncoder()
  .setInputCol(\"idx_style\").setOutputCol(\"enc_style\").fit(idxr.transform(winesdf))")
