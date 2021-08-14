# Module UI
geofacetUI <- function(id) {
  ns<- NS(id)
  tagList(
    
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          
          
          sliderInput(ns("lease"),
                      "Select Remaining Lease left",
                      min=min(hdbtrans_data$yearsoflease),
                      max=max(hdbtrans_data$yearsoflease),
                      value=c(80)),
          
          sliderInput(ns("pricerange"),
                      "Select Price Range",
                      min=min(hdbtrans_data$resale_price),
                      max=max(hdbtrans_data$resale_price),
                      value=c(200000,500000)),
        
          checkboxGroupInput(ns("year"),"Year",
                             choices = unique(hdbtrans_data$Year),
                             selected = unique(hdbtrans_data$Year),inline = TRUE),
          
          checkboxGroupInput(ns("month"),"Month",
                             choices = unique(hdbtrans_data$Month),
                             selected = unique(hdbtrans_data$Month),inline = TRUE),
          
          
        ),
        
        mainPanel(
          plotOutput(ns("geofacet"))
        )
        
      ))
    
  )
}

# Module Server
geofacetServer <-function(id) {
  moduleServer(id,function(input,
                           output,
                           session) {
    observe({
      if(is.null(input$year))
      {
        updateCheckboxGroupInput(session, "year",
                                 selected = "2020")
      }
    })
    
    observe({
      if(is.null(input$month))
      {
        updateCheckboxGroupInput(session, "month",
                                 selected = "Jan")
      }
    })
    
    output$geofacet <- renderPlot({
      data<- hdbtrans_data%>%
        
        filter(Year %in% input$year)%>%
        filter(Month %in% input$month)%>%
        filter(yearsoflease<=input$lease)%>%
        filter(resale_price>=input$pricerange[1] & resale_price<=input$pricerange[2])
      
      ggplot(data,aes(flat_type,fill=flat_type))+geom_bar()+theme_bw()+coord_flip() +facet_geo(~ town,grid=SGNewTownsgrid)+labs(x="Flat Types", y= "Transaction Volumes")+theme(axis.text.y = element_blank(),axis.ticks.y = element_blank())+ggtitle("Transcation Volumes based on Flat Types")
      
    },height = 800, width = 1200)
  }
  
)}
