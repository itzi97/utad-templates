// Aggregated entrypoint for the @local/utad package: re-exports the base
// template (utad.typ) plus the report extras, the assignment template, and
// the slide theme — so a document can `#import "@local/utad:0.1.0": *` and
// get the whole toolkit: utad-doc, assignment, the slide functions,
// callouts, tables, and all diagrams.
#import "utad.typ": *
// evolution-chain now lives in utad.typ (above via *); report extras only.
#import "utad-report.typ": weeklog, reference-list, timeline, orgchart, org-node
#import "utad-assignment.typ": assignment, compact-info
#import "utad-slides.typ": title-slide, section-slide, slide, focus-slide, slide-columns, agenda-slide, stat, no-logo-slides
