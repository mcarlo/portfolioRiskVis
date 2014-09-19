library(shiny)

shinyUI(fluidPage(
  titlePanel("portfolioRiskViz"),
  h1("Visualize portfolio risk dynamics", align = "center"),
  wellPanel(
            
            p("You are in charge of investing a portfolio with initial value 100, allocated
              according to the values on the left. You have access to more capital, that is,
              you may invest up to 100 in each of the six asset classes listed.")
),
  
  
  sidebarLayout(
    sidebarPanel(
      #radioButtons("radio", 
      #                   label = h3("Allocation type"), 
      #                   choices = list("Equal Weight" = 1, 
      #                                  "Minimum Variance" = 2, "Maximum Sharpe
      #                                  Ratio" = 3, "Risk Parity" = 4, "Manual"
      #                                   = 5),
      #                   selected = 3),
    
      h5("Asset values"),
      
      sliderInput("treas", "Treasuries", value = 16.67, min = 0, max = 100, step = .01),
      
      sliderInput("tips", "TIPS", value = 16.67, min = 0, max = 100, step = .01),
      
      sliderInput("corp", "Corp. Bonds", value = 16.66, min = 0, max = 100, 
                  step = .01),
      
      sliderInput("us", "US Stocks", value = 16.67, min = 0, max = 100, 
                  step = .01),
      
      sliderInput("intl", "Int'l Stocks", value = 16.67, min = 0, max = 100, 
                  step = .01),
      
      sliderInput("commod", "Commodities", value = 16.66, min = 0, max = 100, 
                  step = .01)
      
      ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Portfolio Composition", 
                 p("This panel is reactive. Change the asset values on the left to see how the portfolio risk composition
              changes. "),                  
                 
                 h5("Weight, Contributions to Portfolio Risk, 
                    \n and Contributions to Portfolio Return", align = "center"), 
                 plotOutput("plot"),
                 
                 plotOutput("plot2")),
        
        tabPanel("Minimum Variance portfolio", 
                 p("This panel is not reactive, it is for illustration
                   purposes only."),
                 p("The weights below were selected such that portfolio
                   variances is minimized"),
                 
                 h5("Weight, Contributions to Portfolio Risk, 
                    \n and Contributions to Portfolio Return", align = "center"), 
                 plotOutput("plotminVar"),
                 
                 plotOutput("plotminVar2")),
        
        tabPanel("Maximum Sharpe Ratio portfolio", 
                 p("This panel is not reactive, it is for illustration
                   purposes only."),
                 p("The weights below were selected such that the ratio of
portfolio expected return to risk is maximized."),
                 
                 h5("Weight, Contributions to Portfolio Risk, 
                    \n and Contributions to Portfolio Return", align = "center"), 
                 plotOutput("plotmaxSharpe"),
                 
                 plotOutput("plotmaxSharpe2")),
        
        tabPanel("Risk Parity portfolio", 
                 p("This panel is not reactive, it is for illustration
                    purposes only."),
                 p("The weights below were selected such that the Contributions to Risk would be 
                   equal, an allocation technique known as ", 
                   a("risk parity.", 
                     href = "http://www.portfoliowizards.com/risk-parity-demo-workbook/")),
                 
                 h5("Weight, Contributions to Portfolio Risk, 
                    \n and Contributions to Portfolio Return", align = "center"), 
                 plotOutput("plotRP"),
                 
                 plotOutput("plotRP2")),
        tabPanel("Assumptions", 
                 h6("Annualized Volatility"),
                 tableOutput("table1"),
                 h6("Correlation coefficients"),
                 tableOutput("table2")),
        tabPanel("Notes", 
                 h6("The role of risk contribution in portfolio construction"),
                 p("Contribution to portfolio risk is the product of an asset's 
                   portfolio weight and its covariance with the portfolio. This
                   measure holds a key role in portfolio optimization. When the 
                   investor is not subject to any portfolio constraints, an 
                   optimal growth portfolio (also known as a ", em("maximum 
                                                                   Sharpe Ratio"), 
                   " portfolio) will have the condition that all assets' 
                   contribution to the portfolio's excess return are 
                   proportionate to their contribution to portfolio risk."
                   ),
                 br(),
                 h6("Assets"),
                 p("Treasuries: US Treasury Notes and Bonds, spanning maturities
                   from short to long"),
                 p("TIPS: Treasury Inflation-Protected Securities"),
                 p("Corp. Bonds: Investment grade US Corporate bonds"),
                 p("US Stocks: US stocks, spanning all market capitalizations"),
                 p("Int'l Stocks: Developed market non-US stocks"),
                 p("Commodities: broad basket commodities futures")
                 )
        )
                 )
  )
))