"""Success-criteria checks for the stress test. Run: python3 check.py thesis-en"""
import sys, re, pdfplumber
job = sys.argv[1]
log = open(job + '.log', encoding='latin-1').read()
pdf = pdfplumber.open(job + '.pdf')
print(f"== {job}: {len(pdf.pages)} pages")
print("errors:", log.count('\n! '), "| overfull:", len(re.findall(r'Overfull \\hbox \(([\d.]+)pt', log)),
      "| overfull >2pt:", sum(1 for m in re.findall(r'Overfull \\hbox \(([\d.]+)pt', log) if float(m) > 2),
      "| undefined refs/cites:", len(re.findall(r'undefined', log)), "| rerun warnings:", len(re.findall(r'Rerun to get|Please \(re\)run', log)))
# figures / tables: captions in the .lof/.lot versus the source
lof = open(job + '.lof').read(); lot = open(job + '.lot').read()
figs = [int(x) for x in re.findall(r'\\numberline \{(\d+)\}', lof)]
tabs = [int(x) for x in re.findall(r'\\numberline \{(\d+)\}', lot)]
src = open('thesis.tex').read()
nfig = len(re.findall(r'\\begin\{figure\}', src)); ntab = len(re.findall(r'\\begin\{table\}', src)) + src.count('\\begin{longtable}')
print(f"figures: {nfig} in source, {len(figs)} in image index, continuous: {figs == list(range(1, len(figs)+1))}")
print(f"tables:  {ntab} in source, {len(tabs)} in table index, continuous: {tabs == list(range(1, len(tabs)+1))}")
# page numbers bottom-left on every page but the cover
bad = []
for i, pg in enumerate(pdf.pages):
    if i == 0: continue
    ws = [w for w in pg.extract_words() if w['top'] > 780]
    ok = any(w['text'] == str(i+1) and abs(w['x0'] - 85.04) < 1.5 and abs(w['top'] - 787.6) < 2 for w in ws)
    if not ok: bad.append((i+1, [(w['text'], round(w['x0'],1), round(w['top'],1)) for w in ws]))
print("page numbers bottom-left (x0=85, top=788) on every page 2..N:", "yes" if not bad else bad[:5])
cover = pdf.pages[0]; cw = cover.extract_words()
print("cover lines ending in a hyphen:", [w['text'] for w in cw if w['text'].endswith('-')] or "none")
# index depth as rendered on pages 3-4, and deepest heading number in the body
import subprocess
idx = subprocess.run(['pdftotext','-f','3','-l','4',job+'.pdf','-'],capture_output=True,text=True).stdout
nums = re.findall(r'^\s*([\d.]+) ', idx, re.M)
print("index: rendered entries", len(nums), "deepest level", max(len(n.split('.')) for n in nums), "(tocdepth 2 -> 3)")
body = '\n'.join((p.extract_text() or '') for p in pdf.pages)
deep = re.findall(r'\n(\d+\.\d+\.\d+\.\d+\.\d+\.\d+) ', body)
print("subparagraph-level numbers in the body:", deep[:3])
# bibliography alphabetical: entry-start lines (x0 = left margin) between 6.1 and 6.2
names=[]; inbib=False
for i,pg in enumerate(pdf.pages):
    rows={}
    for w in pg.extract_words(): rows.setdefault(round(w['top']),[]).append(w)
    for tp in sorted(rows):
        ws=rows[tp]; line=' '.join(w['text'] for w in ws)
        if re.match(r'^6\.1 ', line): inbib=True; continue
        if re.match(r'^6\.2 ', line): inbib=False
        if inbib and abs(ws[0]['x0']-85.04)<1 and tp<780: names.append(line[:38])
keys=[re.sub(r'[^a-z]','',n.split(',')[0].lower()) for n in names]
print("bibliography entries:", len(names), "alphabetical:", keys==sorted(keys))
