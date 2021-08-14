# Module UI
plotlyUI <- function(id) {
  ns<- NS(id)
  tagList(
    
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          
          selectInput(ns("year"),"Year",c(
            "2019"="2019",
            "2020"="2020",
            "2021"="2021"
          )),
          
          selectInput(ns("town"), "Select Town",
                      choices= unique(hdbtrans_data$town)),
          
          selectInput(ns("flat_type"),"Flat Type",c(
            "1 ROOM"="1 ROOM",
            "2 ROOM"="2 ROOM",
            "3 ROOM"="3 ROOM",
            "4 ROOM"="4 ROOM",
            "5 ROOM"="5 ROOM",
            "EXECUTIVE"="EXECUTIVE",
            "MULTI-GENERATION"="MULTI-GENERATION"),selected="4 ROOM"),
          
          sliderInput(ns("lease"),
                      "Select Remaining Lease left",
                      min=min(hdbtrans_data$yearsoflease),
                      max=max(hdbtrans_data$yearsoflease),
                      value=c(80)),
          
        ),
        
        mainPanel(
          
          plotlyOutput(ns("plotly"))
          
        )
        
      ))
    
  )
}

# Module Server
plotlyServer <-function(id) {
  moduleServer(id,function(input,
                           output,
                           session) {
    output$plotly <- renderPlotly({
      data<- hdbtrans_data%>%
        filter(Year==input$year)%>%
        filter(town==input$town)%>%
        filter(flat_type==input$flat_type)%>%
        filter(yearsoflease<=input$lease)%>%
        
        arrange(transdate)
      
      plot_ly(data)%>%
        
        add_trace(x=~transdate,y=~resale_price,type="bar",name="Transaction Volumes",transforms = list(
          list(
            type = 'aggregate',
            groups = ~transdate,
            aggregations = list(
              list(
                target = 'y', func = 'count', enabled = T
              )
            )
          )
        ))%>%
        add_trace(x=~transdate,y=~resale_price,name="Average Resale Prices",type="scatter",mode="lines+markers",yaxis="y2",transforms = list(
          list(
            type = 'aggregate',
            groups = ~transdate,
            aggregations = list(
              list(
                target = 'y', func = 'avg', enabled = T
              )
            )
          )
        ))%>%
        layout(title = 'Transaction Volumes vs Average Resale Price',
               xaxis = list(title = "Transaction Period"),
               yaxis = list(side = 'left', title = 'Transaction Volumes', showgrid = FALSE, zeroline = FALSE),
               yaxis2 = list(side = 'right', overlaying = "y", title = 'Average Resale Prices', showgrid = FALSE, zeroline = FALSE),hovermode = "x unified")
      
    })    
    
  }
  
)}
