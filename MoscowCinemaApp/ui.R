library(shiny)
library(rCharts)
require(markdown)


shinyUI(
  navbarPage("Film fund \"Moscow cinema\" explorer" ,
    tabPanel("Visual",
      sidebarPanel(
        sliderInput("years", "Year released", 1938, 2008, value = c(1938, 2008),sep=""),
        uiOutput("countries"),
        uiOutput("studio")
      ),
      mainPanel(
        h4('Films by year of production', align = "center"),
                 showOutput("filmsByYears", "nvd3"),
        h4('Films by genre', align = "center"),
        showOutput("filmsByIno", "nvd3")
      )
    ),
    tabPanel('Data',mainPanel(dataTableOutput(outputId="data"),downloadButton('downloadData', 'Download'))),
    tabPanel("About",mainPanel(includeMarkdown("AboutData.Rmd")))
  )
)