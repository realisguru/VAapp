# Module UI
ggstatsplotlyUI <- function(id) {
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
          
          sliderInput(ns("lease"),
                      "Select Remaining Lease left",
                      min=min(hdbtrans_data$yearsoflease),
                      max=max(hdbtrans_data$yearsoflease),
                      value=c(80)),
          
          
        ),
        
        mainPanel(
          
          plotlyOutput(ns("ggstatsplotly"))
        )
        
      ))
    
    
  )
}


# Module Server
ggstatsplotlyServer <-function(id) {
  moduleServer(id,function(input,
                           output,
                           session) {
    output$ggstatsplotly <- renderPlotly({
      data<- hdbtrans_data%>%
        filter(Year==input$year)%>%
        filter(town==input$town)%>%
        filter(yearsoflease<=input$lease)
      
      p<-ggbetweenstats(
        data,
        x = flat_type,
        y = resale_price,
        title = "Distribution of Resales Price across different Flat Types",
        xlab = "Flat Type",
        ylab = "Resale Price"
      ) +
        theme(
          text = element_text(family = "roboto", size = 8, color = "black"),
          plot.title = element_text(family = "lobstertwo", size = 20,
                                    face = "bold", color="#2a475e"),
          plot.subtitle = element_text(family = "roboto", size = 15, 
                                       face = "bold", color="#1b2838"),
          axis.text = element_text(size = 10, color = "black"),
          axis.title = element_text(size=12),
          rect = element_blank(),
          panel.grid = element_line(color = "#b4aea9"),
          panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank(),
          plot.title.position = "plot",
          panel.grid.major.y = element_line(linetype="dashed"),
          axis.ticks = element_blank(),
          axis.line = element_line(colour = "grey50"),
          plot.background = element_rect(fill = '#fbf9f4', color = '#fbf9f4')
        )
      plotly::ggplotly(p,width = 1200, height = 800)
    })
  }
  
  

)}
