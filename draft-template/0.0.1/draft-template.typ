#import "@preview/ctheorems:1.1.3": *
#import "@preview/drafting:0.2.2": inline-note, margin-note

#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eee"))
#let example = thmplain("example", "Example")
#let proof = thmproof("proof", "Proof")
#let abstract_block(body) = pad(left: 2em, right: 2em, {body})
#let today() = datetime.today().display("[month repr:long] [day], [year]")

// authors & affiliations setup copied from https://github.com/typst/typst/discussions/1504
#let to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(to-string).join("")
  } else if content.has("body") {
    to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

#let draft-template(
  title: [Insert your very good title here],
  // A dictionary of authors.
  // Dictionary keys are authors' names.
  // Dictionary values are meta data of every author, including
  // label(s) of affiliation(s), email, contact address,
  // or a self-defined name (to avoid name conflicts).
  // Once the email or address exists, the author(s) will be labelled
  // as the corresponding author(s), and their address will show in footnotes.
  // 
  // Example:
  // (
  //   "Auther Name": (
  //     "affiliation": "affil-1",
  //     "email": "author.name@example.com", // Optional
  //     "address": "Mail address",  // Optional
  //     "name": "Alias Name" // Optional
  //   )
  // )
  authors: (),
  affiliations: (),
  number_lines: false,
  fontchoice: "Arial",
  fontsize: 11pt,
  bib: none,
  doc) = {
  show: thmrules.with(qed-symbol: $square$)

  // Basic global settings
  set page("us-letter", margin: 1in, numbering: "1", number-align: right)
  set text(
    font: (fontchoice, "Helvetica", "Times New Roman", "Libertinus Serif"),
    size: fontsize,  
    weight: "regular"
  )
  show link: underline
  set enum(numbering: "1.a.i.")
  set math.equation(numbering: "(1.1)", supplement: [Eq.])

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

  // Title block
  set align(center)
  block(
    text(size: 17pt, weight: "bold", title)
  )
  
  // Authors block
  block(
    // Process the text for each author one by one
    for (ai, au) in authors.keys().enumerate() {
      let au_meta = authors.at(au)
      
      // Don't put comma before the first author
      if ai != 0 {
        text([, ])
      }
      
      // Write auther's name
      if au_meta.keys().contains("name") {
        text([#au_meta.name])
      } else {
        text([#au])
      }

      // Get labels of author's affiliation
      let au_inst_id = au_meta.affiliation
      let au_inst_primary = ""
      // Test whether the author belongs to multiple affiliations
      if type(au_inst_id) == array {
        // If the author belongs to multiple affiliations,
        // record the first affiliation as the primary affiliation,
        au_inst_primary = affiliations.at(au_inst_id.first())
        // and convert each affiliation's label to index
        let au_inst_index = au_inst_id.map(id => affiliations.keys().position(key => key == id) + 1)
        // Output affiliation
        super([#(au_inst_index.map(id => [#id]).join([,]))])
      } else if (type(au_inst_id) == string) {
        // If the author belongs to only one affiliation,
        // set this as the primary affiliation
        au_inst_primary = affiliations.at(au_inst_id)
        // convert the affiliation's label to index
        let au_inst_index = affiliations.keys().position(key => key == au_inst_id) + 1
        // Output affiliation
        super([#au_inst_index])
      }

      if au_meta.keys().contains("first_author") {
        [#super[,$star$]]
      }
      
      // Corresponding author
      if au_meta.keys().contains("email") {
        [#super[,$dagger$]]
      }
    }
  )
  
  set align(left)

  // Affiliations block
  block(
    for (ik, key) in affiliations.keys().enumerate() {
      text(
        [#super([#(ik+1)]) #(affiliations.at(key))]
      )
      linebreak()
    }
  )

  // First & Corresponding Authors block
  block({
    // First Authors
    if authors.values().any(author => author.keys().contains("first_author")) {
      [#super[$star$] Authors contributed equally]
      linebreak()
    }
    // Corresponding Author
    for author in authors.values() {
      if author.keys().contains("email") {
        [#super[$dagger$] Corresponding author. Email: #link(author.email).]
      }
    }
  })  

  // Set body paragraph styles //
  
  // set heading(numbering: "i.")
  set par(
    leading: 1em,
    spacing: 2em,
    justify: true,
    linebreaks: "optimized",
  )
  
  // Line numbering for draft, comment out for proof stage
  set par.line(numbering: if number_lines {"1"} else {})


  // Set equation numbering style
  set math.equation(numbering: "(1)", supplement: "Eq.")
  set figure(numbering: "1", supplement: "Fig.")

  show figure.caption: it => {
    let body_sentences = to-string(it.body).split(".")
    [
      #set align(left)
      *#it.supplement #context it.counter.display(it.numbering): *
      *#body_sentences.remove(0).*
      #body_sentences.join(".")
    ]
  }
  
  show ref: strong
  
  // Display body text
  doc

  // Display bibliography.
  if bib != none {
    show bibliography: set text(1em)
    show bibliography: set par(first-line-indent: 0em)
    bibliography(bib, title: [References], style: "vancouver-superscript")
  }
}


