# Module UI
introductionUI <- function(id) {
  ns<- NS(id)
  tagList(
    
    fluidPage(
      sidebarLayout(
        sidebarPanel(
      
          textOutput(ns("Intro"))
          
          
        ),
        
        mainPanel(
          img(src = "singaporemap.png", height = 400, width = 800)
        )
        
      ))
    
  )
}

# Module Server
introductionServer <-function(id) {
  moduleServer(id,function(input,
                           output,
                           session) {
    
    output$Intro <- renderText({
     
      "Abstract:
      
      Singapore is a small country with limited land resources to convert into housing. With a growing population need to meet the aggressive economic demands, Singapore Government is encouraging current residents to have more children while simultaneously importing niche and raw talent from other countries to set up their base here. This is increasing the demand for both public and private housing. Public housing (also known as HDB) is subsidized by the government to give the citizens an opportunity to make their own homes at a lower cost. While HDB website has some of the historical data, it does not have a 1 stop view of the island wide statistics. Through our R Shiny application, we hope to provide our users an interactive interface for them to perform adequate research around the property pricing in various estates. They can use different factors to perform searches and understand the historical pricing.
      
      With the one-stop application, a user can instantly retrieve information around the housing estate he/she is keen on."
       

         
    })
    
   
    
  }
  
  )}
