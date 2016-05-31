library(shiny)
library(jsonlite)
library(rCharts)
library(dplyr)

Sys.setlocale(locale = "en_US")

films <- fromJSON("data/films.json")[["Cells"]]
films$Filmino_en[lapply(films$Filmino_en,length)==0] = "undefined"

countries <<- sort(unique(unlist(films$ProducingCountry_en)))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  dt <- reactive({
    films$ProducingCountry_en <- lapply(films$ProducingCountry_en,paste)
    minyear <- input$years[1]
    maxyear <- input$years[2]
    fCountries <- input$countries
    
    # Apply filters
    dt <- films %>%
      filter(
        Year_en >= minyear,
        Year_en <= maxyear,
        ProducingCountry_en %in% fCountries
      )
    dt
  })
  
  output$countries <- renderUI({
    if(1) {
      checkboxGroupInput('countries', 'Producing Country', countries, selected=countries)
    }
  })
  
  output$filmsByYears <- renderChart({
    df <- dt()
    df <- aggregate(df$global_id, by=list(df$Year_en, df$FilmType_en), FUN = length)
    n1 <- nPlot(x ~ Group.1, group = "Group.2", data = df, type = 'multiBarChart', dom = 'filmsByYears', width = 650)
  })

  output$filmsByIno <- renderChart({
    df <- dt()
    df$FilmStudio_en <- unlist(df$FilmStudio_en)
    df$Filmino_en <- unlist(df$Filmino_en)
    df <- aggregate(df$global_id, by=list(df$Filmino_en, df$AgeRestrictions_en), FUN = length)
    n1 <- nPlot(x ~ Group.1, group = "Group.2", data = df, type = 'multiBarHorizontalChart', dom = 'filmsByIno', width = 650)
  })
  
  output$data <- renderDataTable ({
    films$ProducingCountry_en <- lapply(films$ProducingCountry_en,paste)
    films$Duration_en <- lapply(films$Duration_en,paste)
    films$FilmStudio_en <- lapply(films$FilmStudio_en,paste)
    films$Filmino_en <- lapply(films$Filmino_en,paste)
    films
  }, options = list(searching = FALSE, pageLength = 50))
  
  
})
