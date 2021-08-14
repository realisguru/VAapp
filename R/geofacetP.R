# Module UI
geofacetPUI <- function(id) {
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
          
          selectInput(ns("flat_type"),"flat_type:",c("1 ROOM"="1 ROOM","2 ROOM"="2 ROOM","3 ROOM"="3 ROOM", "4 ROOM"="4 ROOM","5 ROOM"="5 ROOM", "EXECUTIVE"="EXECUTIVE","MULTI-GENERATION"="MULTI-GENERATION"),selected="5 ROOM"),
          
          sliderInput(ns("lease"),
                      "Select Remaining Lease left",
                      min=min(hdbtrans_data$yearsoflease),
                      max=max(hdbtrans_data$yearsoflease),
                      value=c(80)),
          
          
        ),
        
        mainPanel(
          
          plotOutput(ns("geofacetp"))
          
        )
      ))
    
    
  )
}

# Module Server
geofacetPServer <-function(id) {
  moduleServer(id,function(input,
                           output,
                           session) {
   
    output$geofacetp <- renderPlot({
      data<- hdbtrans_data%>%
        filter(Year==input$year)%>%
        filter(yearsoflease<=input$lease)%>%
        filter(flat_type==input$flat_type)
      ggplot(data,aes(x=transdate,y=resale_price,color=Year))+
        geom_line(stat = "summary", fun = "mean",size=1,color="blue")+
        theme_bw() +facet_geo(~ town,grid=SGNewTownsgrid,scales = "free_y")+
        labs(x="Transaction Dates", y= "Average Transaction Price") + 
        scale_x_date(date_labels = "%b", date_breaks = "3 month") + 
        ggtitle("Average Transaction Prices Across Towns") + 
        theme(axis.title=element_text(size=12,face="bold"),plot.title = element_text(color = "red", size = 20, face = "bold"))
      
    },height = 800, width = 1200)
  }
  
  
 
  )}
