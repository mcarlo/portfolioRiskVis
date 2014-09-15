library(shiny)

shinyUI(fluidPage(
  titlePanel("portfolioRiskVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Allocate among the asset classes listed below. 
The charts to the right will reflect your portfolio's weights and contributions
               to risk, based on the assumed covariance matrix."),
      
      sliderInput("treas", "Treasuries", value = 30.26, min = 0, max = 100, step = .01),
      
      sliderInput("tips", "TIPS", value = 20.85, min = 0, max = 100, step = .01),
      
      sliderInput("corp", "Corp. Bonds", value = 15.70, min = 0, max = 100, 
                  step = .01),
      
      sliderInput("us", "US Stocks", value = 11.84, min = 0, max = 100, 
                  step = .01),
      sliderInput("intl", "Int'l Stocks", value = 11.56, min = 0, max = 100, 
                  step = .01),

      sliderInput("commod", "Commodities", value = 9.79, min = 0, max = 100, 
                  step = .01)

    ),

    mainPanel(
      p("The charts below depict your selected portfolio weights and
  relative contributions to portfolio risk."),
      
      
      plotOutput("plot")
      )
    
  )
))