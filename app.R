library(plotly)
library(ggstatsplot)
library(shiny)
library(tidyverse)
library(geofacet)
library(dplyr)
library(lubridate)
library(geofacet)
library(ggplot2)

# Define UI
ui <- navbarPage(
    "RealisGuru",   
    tabPanel("Introduction", introductionUI("intro")),
    navbarMenu("Geofacet Overview",
               tabPanel("HDB Resale Transaction Volumes Across Towns",geofacetUI("geofacet")),
               tabPanel("HDB Average Resale Price Across Towns",geofacetPUI("geofacet2"))),
    tabPanel("HDB Average Resale Prices and Transactions Analysis", plotlyUI("plot")),
    tabPanel("HDB Flats Resale Price Analyser", ggstatsplotlyUI("statsplot")),
    tabPanel("HDB Flats Resale Data Search", trans_tableUI("table Trans"))
    
    ,theme = bslib::bs_theme(bootswatch = "darkly")
)

# Define server 
server <- function(input, output,session) {
    
    introductionServer("intro")
    geofacetServer("geofacet")
    geofacetPServer("geofacet2")
    trans_tableServer("table Trans")
    plotlyServer("plot")
    ggstatsplotlyServer("statsplot")
}

# Run the application 
shinyApp(ui = ui, server = server)
