# Module UI
trans_tableUI <- function(id) {
  ns<- NS(id)
  tagList(
    
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          
          selectInput(ns("flat_type"),"Flat Type",c(
            "1 ROOM"="1 ROOM",
            "2 ROOM"="2 ROOM",
            "3 ROOM"="3 ROOM",
            "4 ROOM"="4 ROOM",
            "5 ROOM"="5 ROOM",
            "EXECUTIVE"="EXECUTIVE",
            "MULTI-GENERATION"="MULTI-GENERATION"),selected="4 ROOM"),
          
          selectInput(ns("town"), "Select Town",
                      choices= unique(hdbtrans_data$town)),

          
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
          
          DT::dataTableOutput(ns("trans_table"))
          
        )
        
      ))
  )
}

# Module Server
trans_tableServer <-function(id) {
  
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
    
    output$trans_table <- DT::renderDataTable({
      
      data<- hdbtrans_data%>%
        
        filter(Year %in% input$year)%>%
        filter(Month %in% input$month)%>%
        filter(flat_type==input$flat_type)%>%
        filter(town==input$town)%>%
        filter(yearsoflease<=input$lease)%>%
        filter(resale_price>=input$pricerange[1] & resale_price<=input$pricerange[2])
      
      
      DT::datatable(data %>% select(2:15),
                    options = list(pageLenght = 10),
                    rownames=FALSE)
      
      
    })
  })
}