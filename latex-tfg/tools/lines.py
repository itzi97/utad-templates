import sys, pdfplumber
pdf, pages = sys.argv[1], [int(x) for x in sys.argv[2].split(',')]
for p in pages:
    page = pdfplumber.open(pdf).pages[p-1]
    rows = {}
    for w in page.extract_words(extra_attrs=['size','fontname']):
        rows.setdefault(round(w['top']), []).append(w)
    print(f"--- page {p}")
    last=None
    for t in sorted(rows):
        ws = rows[t]
        txt = ' '.join(w['text'] for w in ws)[:60]
        gap = f"{t-last:+4d}" if last is not None else "    "
        print(f"{t:5d} {gap} x0={ws[0]['x0']:6.1f} {ws[0]['size']:5.1f} {ws[0]['fontname'][-20:]:20s} {txt}")
        last=t
