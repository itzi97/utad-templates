"""Line-position diff between two PDFs, per the handoff method:
rounded word 'top' per page, merged within 4pt, diffed line by line.
The footer page number (top > 780) is reported on its own row, not in
the text metric, which is how the README's 65-line figure was counted.
When the two pages have different line counts the lines are aligned by
a monotone DP (gap cost 20pt) so one saved line does not shift the rest.
--baseline measures the glyph baseline (text matrix) instead of 'top':
pdfplumber's 'top' is baseline minus the FONT's declared ascent, and
TeXGyreTermesX-Bold declares 2.6pt more ascent than Regular (11.96 vs
9.37 at 12pt) while LibreOffice's Liberation Serif declares 9.41 for both,
so 'top' reports every bold heading line ~2.6pt high in the LaTeX build."""
import sys, pdfplumber

FOOTER = 780
BASELINE = False   # --baseline: use the text-matrix baseline instead of 'top'
def lines(pdf, pageno):
    page = pdfplumber.open(pdf).pages[pageno-1]
    if BASELINE:
        tops = sorted(set(round(page.height - c['matrix'][5]) for c in page.chars if c['text'].strip()))
    else:
        tops = sorted(set(round(w['top']) for w in page.extract_words()))
    merged = []
    for t in tops:
        if merged and t - merged[-1][-1] <= 4:
            merged[-1].append(t)
        else:
            merged.append([t])
    m = [sum(x)/len(x) for x in merged]
    return [t for t in m if t < FOOTER], [t for t in m if t >= FOOTER]

def align(a, b, gap=20.0):
    n, m = len(a), len(b)
    INF = float('inf')
    D = [[INF]*(m+1) for _ in range(n+1)]; P = [[None]*(m+1) for _ in range(n+1)]
    D[0][0] = 0
    for i in range(n+1):
        for j in range(m+1):
            if i and D[i-1][j]+gap < D[i][j]: D[i][j] = D[i-1][j]+gap; P[i][j] = 'a'
            if j and D[i][j-1]+gap < D[i][j]: D[i][j] = D[i][j-1]+gap; P[i][j] = 'b'
            if i and j and D[i-1][j-1]+abs(a[i-1]-b[j-1]) < D[i][j]:
                D[i][j] = D[i-1][j-1]+abs(a[i-1]-b[j-1]); P[i][j] = 'm'
    pairs = []; i, j = n, m
    while i or j:
        p = P[i][j]
        if p == 'm': pairs.append((a[i-1], b[j-1])); i -= 1; j -= 1
        elif p == 'a': pairs.append((a[i-1], None)); i -= 1
        else: pairs.append((None, b[j-1])); j -= 1
    return pairs[::-1]

def compare(ref, mine, pages, verbose=False):
    tot_n = tot_d = 0
    print(f"{'page':>4} {'ref':>4} {'mine':>4} {'n':>3} {'mean':>6} {'max':>5}  footer")
    rows = []
    for p in pages:
        (a, fa), (b, fb) = lines(ref, p), lines(mine, p)
        pairs = align(a, b)
        d = [abs(x-y) for x, y in pairs if x is not None and y is not None]
        n = len(d); mean = sum(d)/n if n else 0
        foot = f"{fb[0]-fa[0]:+.0f}" if fa and fb else "-"
        print(f"{p:>4} {len(a):>4} {len(b):>4} {n:>3} {mean:>6.2f} {max(d) if d else 0:>5.1f}  {foot}")
        rows.append((p, n, mean, max(d) if d else 0))
        if verbose:
            for x, y in pairs:
                ra = f"{x:7.1f}" if x is not None else "      -"
                rb = f"{y:7.1f}" if y is not None else "      -"
                dd = f"{y-x:+6.1f}" if x is not None and y is not None else ""
                print(f"        {ra} {rb} {dd}")
        tot_n += n; tot_d += sum(d)
    print(f"overall mean {tot_d/tot_n:.2f} over {tot_n} lines")
    return rows

if __name__ == '__main__':
    ref, mine = sys.argv[1], sys.argv[2]
    globals()["BASELINE"] = "--baseline" in sys.argv
    args = [a for a in sys.argv[3:] if not a.startswith('-')]
    pages = [int(x) for x in args[0].split(',')] if args else list(range(1, 15))
    compare(ref, mine, pages, verbose='-v' in sys.argv)
