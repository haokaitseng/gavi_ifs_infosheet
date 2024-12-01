// Used to collect sidebar articles which states "articles"
#let articles = state("articles", ())

// This "info-sheet" function gets your whole document as its `body` and formats, aligning with the file names in the extension folder
// These lines introduce the titles in the beginning
#let info-sheet(
  // The infosheet's title.
  title: "Newsletter title",

  // The last date updated, displayed at the top of the sidebar.
  edition: none,

  // A hero image at the start of the newsletter.
  hero-image: none,

  // Details about the publication, displayed at the end of the document.
  publication-info: none,

  // The infosheet's content.
  body
) = {
  // Set document metadata.
  set document(title: title)

  // Configure pages. The background parameter is used to
  // add the left rectangle background to the pages.
  set page(
    margin: (left: 1.5cm, right: 1.5cm, top: 0.9cm, bottom: 0.9cm),
    background: place(left+ top, rect( 
      fill: rgb("#005CB9"), // Gavi blue
      height: 100%,
      width: 0.3cm,
    ))
  )
  // Insert Gavi logo at the top left
  image("images/Gavi-logo_1b.png", width: 3.9cm)


  // Download Gavi fonts online and intall them in your laptop in advance: 
  // Carnero (heading) > Frutiger (body text) > Arial
  set text(11pt, font: "Frutiger")// Body font

  // Configure headings.
  show heading: set text(font: "Carnero", fill: rgb("#005CB9"))// Gavi blue
  show heading.where(level: 1): set text(0.8em)
  show heading.where(level: 1): set par(leading: 0.1em)  //for headings going to second line, useless
  show heading.where(level: 1): set block(below: 0.4em, above: 0.3em) //blank below&above heading
  show heading: it => {
    set text(weight: 200) if it.level > 2
    it
  }

  // Hyperlinks should be underlined.
  show link: underline

  // Configure figures. The "it"" parameter represents the figure being iteratd
  show figure: it => block({ 
    // Display a backdrop rectangle for table and figures
    move(dx: -0.3%, dy: 0.3%, rect( // !!!need to delete
      fill: white, 
      inset: 0pt,
      move(dx: 0.3%, dy: -0.3%, it.body)
    ))
    
    v(5pt, weak: true)// adds vertical space of 48 points but flexible 
  })
  
    // edition text, outside of main flow
  place(right + top, text(fill: black, font: "Frutiger", weight: "medium", 8pt, edition))

  // The document is in one grid/column "(1fr)""
  grid(
    columns: (1fr), 
    column-gutter: 20pt,
    row-gutter: 5pt, // controls the spacing between title and first paragraph

    // Title.
    text(font: "Carnero",
         15pt, 
         weight: 700, 
         align(center, title),
         fill: rgb("#005CB9")), 


    // The main flow with body and publication info. can be used for double column?
    {
      set par(justify: true)
      body
      v(1fr)
      set text(3em)
      publication-info
    }
   
  )
}


// An article that is displayed in the sidebar. Can be added
// anywhere in the document. All articles are collected automatically.
#let article(body) = articles.update(it => it + (body,))


