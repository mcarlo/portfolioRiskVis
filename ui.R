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
    
      h5("Asset values"),
      
      sliderInput("commod", "Commodities", value = 20, min = 0, max = 100, 
                  step = .01),
      
      sliderInput("reit", "REITs", value = 20, min = 0, max = 100, step = .01),
      
      sliderInput("bond", "Bonds", value = 20, min = 0, max = 100, 
                  step = .01),
            
      sliderInput("intl", "Int'l Stocks", value = 20, min = 0, max = 100, 
                  step = .01),
      
      sliderInput("us", "US Stocks", value = 20, min = 0, max = 100, 
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
                 h5("Notice the Weight and Risk Contribution plots are shaped identically. This is a feature of Minimum Variance portfolios: Weights are proportionate to Contributions to Risk.", align = "left"), 
                 
                 plotOutput("plotminVar2")),
        h5("Notice the total portfolio has a lower volatility than its least risky asset. This is possible due to diversification and, in this case, short-selling International Stocks.", align = "left"), 
        
        
        tabPanel("Maximum Sharpe Ratio portfolio", 
                 p("This panel is not reactive, it is for illustration
                   purposes only."),
                 p("The weights below were selected such that the ratio of
portfolio expected return to risk is maximized."),
                 
                 h5("Weight, Contributions to Portfolio Risk, 
                    \n and Contributions to Portfolio Return", align = "center"), 
                 plotOutput("plotmaxSharpe"),
                 h5("Notice here the Risk Contribution and Return Contribution plots are shaped identically. This is a feature of unconstrained Maximum Sharpe Ratio portfolios: Contributions to Risk are pproportionate to Contributions to Return.", align = "left"), 
                 
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
                 h5("Notice here the Risk Contributions are equal. Investors debate about the merits of such an allocation. One of the best arguments supporting Risk Parity is it minimizes your exposure to misestimation risk.", align = "left"), 
                 
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