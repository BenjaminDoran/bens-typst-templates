#import "@preview/ctheorems:1.1.3": *
#import "@preview/drafting:0.2.2": inline-note, margin-note

#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eee"))
#let example = thmplain("example", "Example")
#let proof = thmproof("proof", "Proof")
#let abstract_block(body) = pad(left: 2em, right: 2em, {body})
#let today() = datetime.today().display("[month repr:long] [day], [year]")

#let shortdoc-template(
  title: [My Supercalifragilisticexpialidocious Mathematics Write-up],
  author: [Benjamin Doran],
  date: today(),
  abstract: none,
  fontchoice: "Times New Roman",
  fontsize: 12pt,
  bib: none,
  doc,
) = {

  show: thmrules.with(qed-symbol: $square$)
  set page(margin: 1in, numbering: "1")
  set heading(numbering: "1.1.")
   show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    it
  }
  set text(
    font: (fontchoice, "Times New Roman", "Libertinus Serif"), 
    size: fontsize,
  )
  show link: underline
  set enum(numbering: "1.a.i.")
  
  // Number equations by section
  // set math.equation(numbering: "(1.1)", supplement: "Eq.",)
  set math.equation(numbering: it => {
      let count = counter(heading.where(level: 1)).at(here()).first()
      if count > 0 {
        numbering("(1.1)", count, it)
      } else {
        numbering("(1)", it)
      }
    }, supplement: [Eq.]
  )
  
  // default table format
  let frame(stroke) = (x, y) => (
    left: if x != 1 { 0pt } else { stroke },
    top: if y == 1 { stroke } else { 0pt },
    bottom: stroke,
  )
  set table(stroke: frame(black+0.5pt), align: left)
  set table.header(repeat: true)
  show table: set align(center)
  show table: set par(justify: false)
  show table.cell.where(y: 0): set text(weight: "bold", size: 1.2 * fontsize)
  show table.cell.where(x: 0): set text(style: "italic")
  show figure.caption: set align(left)

  // heading
  text(size: 18pt)[_*#title*_]
  linebreak()
  [ *#author* | _ #date _ ]
  line(length: 100%)
  
  // body
  set par(justify: true, leading: 0.8 * fontsize)
  if abstract != none {
    abstract_block(abstract)
    line(length: 100%)
  }

  doc

  // Display bibliography.
  if bib != none {
    pagebreak()
    show bibliography: set text(1em)
    show bibliography: set par(first-line-indent: 0em)
    bibliography(bib, title: [References], style: "vancouver-superscript")
  }
}


