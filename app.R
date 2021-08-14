library(shiny)
library(tidyverse)
library(geofacet)
library(dplyr)
library(lubridate)
library(geofacet)
library(plotly)
library(ggplot2)
library(ggstatsplot)


# load data

hdbdata <- read_csv("data/Resale_flats_prices.csv")

# Data Preparation
hdbdata$date=ym(hdbdata$month)
hdbdata$Month=month(hdbdata$date,label = TRUE, abbr = TRUE)
hdbdata$Year=year(hdbdata$date)
hdbdata$yearsoflease=parse_number(hdbdata$remaining_lease)
hdbdata$sqft=hdbdata$floor_area_sqm*10.76
hdbdata$psf=round(hdbdata$resale_price/hdbdata$sqft,digits=0)
hdbdata$psm=round(hdbdata$resale_price/hdbdata$floor_area_sqm,digits = 0)
hdbdata$transdate=ym(hdbdata$month)


# Grid of Singapore New Town for geoFacet

SGNewTownsgrid <- data.frame(
    row = c(1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6),
    col = c(5, 4, 5, 8, 2, 3, 7, 5, 2, 9, 7, 3, 6, 5, 8, 1, 2, 5, 3, 8, 7, 6, 4, 6, 7, 5),
    code = c("SBW", "WDL", "YS", "PG", "CCK", "BPJ", "SK", "AMK", "BBT", "PSR", "HG", "BTM", "SG", "BS", "TAMP", "JW", "JE", "TPY", "CMT", "BD", "GL", "KW", "QT", "CA", "MP", "BM"),
    name = c("SEMBAWANG", "WOODLANDS", "YISHUN", "PUNGGOL", "CHOA CHU KANG", "BUKIT PANJANG", "SENGKANG", "ANG MO KIO", "BUKIT BATOK", "PASIR RIS", "HOUGANG", "BUKIT TIMAH", "SERANGOON", "BISHAN", "TAMPINES", "JURONG WEST", "JURONG EAST", "TOA PAYOH", "CLEMENTI", "BEDOK", "GEYLANG", "KALLANG/WHAMPOA", "QUEENSTOWN", "CENTRAL AREA", "MARINE PARADE", "BUKIT MERAH"),
    stringsAsFactors = FALSE
)
geofacet::grid_preview(SGNewTownsgrid)


# Transforming Town

hdbtrans_data<-hdbdata%>%
    filter(Year %in% c("2019","2020","2021"))%>%
    select(transdate,Month,Year,town,block,street_name,flat_type,storey_range,floor_area_sqm,sqft,flat_model,resale_price,psf,psm,yearsoflease)


# Define UI
ui <- navbarPage(
    "RealisGuru",   
    tabPanel("Introduction", "Display information"),
    navbarMenu("Geofacet Overview",
               tabPanel("HDB Resale Transaction Volumes Across Towns",geofacetUI("geofacet")),
               tabPanel("HDB Average Resale Price Across Towns",geofacetPUI("geofacet2"))),
    tabPanel("HDB Average Resale Prices and Transactions Analysis", plotlyUI("plot")),
    tabPanel("HDB Flats Resale Price Analyser", ggstatsplotlyUI("statsplot")),
    tabPanel("HDB Flats Resale Data Search", trans_tableUI("table Trans"))
    
    ,theme = bslib::bs_theme(bootswatch = "darkly")
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
    
    geofacetServer("geofacet")
    geofacetPServer("geofacet2")
    trans_tableServer("table Trans")
    plotlyServer("plot")
    ggstatsplotlyServer("statsplot")
}

# Run the application 
shinyApp(ui = ui, server = server)
