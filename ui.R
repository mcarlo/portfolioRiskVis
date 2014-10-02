library(shiny)
withMathJax()
shinyUI(fluidPage(
  #titlePanel("Portfolio Risk Visualizer"),
  #h1("Visualize portfolio risk dynamics", align = "center"),
  tags$head(includeScript("google-analytics.js")),
  tags$head( tags$script(src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML-full", type = 'text/javascript'),
             tags$script( "MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});", type='text/x-mathjax-config')
  ),  
  #wellPanel(
  #  p("This application illustrates how the risk in a portfolio changes when you 
  #            change the asset allocation.")
    
#),
  
  
  sidebarLayout(
    sidebarPanel(
      p("Change the Asset Values below to see how the portfolio's risk composition
changes in the Portfolio Composition panel."),
      p("The other panels are for background and illustration purposes; they will not change."),
      
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
                 p("This panel is reactive. Change the asset values on the left
                   to see how the portfolio risk composition changes. Scroll
                   down to see a Return/Risk plot."),                  
                 
                 plotOutput("plot"),
                 
                 plotOutput("plot2")),
        
        tabPanel("Min. Variance portfolio", 
                 p("This panel is not reactive, it is for illustration purposes
                   only. The weights were selected so as to minimize portfolio
                   variance."),
                 p("In unconstrained Minimum Variance Portfolios, notice the ",
                   strong("Weights equal the Risk Contribution."),
                   align = "left"), 
                 
                 plotOutput("plotminVar"),
                 
                 plotOutput("plotminVar2"),
        h5("Notice the Minimum Variance Portfolio's volatility is less than that
           of its least risky asset.", align = "left")), 
        
        
        tabPanel("Max. Sharpe Ratio portfolio", 
                 p("This panel is not reactive, it is for illustration purposes
                   only. The weights were selected so as to maximize
                   the portfolio's ratio of expected return to volatility."),
                 p("In unconstrained Maximum Sharpe Ratio Portfolios, ", 
                   strong("the Contributions to Risk are proportionate to
                          Contributions to Return")," which is why you might notice the Risk
                   Contribution pattern and Return Contribution pattern are
                   identical.", align = "left"), 
                 
                 
                 plotOutput("plotmaxSharpe"),
                 
                 plotOutput("plotmaxSharpe2"),
        h5("While in this example the portfolio's volatility happens to be less than that
           of its least risky asset, for Maximum Sharpe Ratio portfolios in general that is not always the case.", align = "left")),
      
        tabPanel("Risk Parity portfolio", 
                 p("This panel is not reactive, it is for illustration
                    purposes only. The weights were selected such that the
                   Contributions to Risk would be equal, an allocation technique
                   known as ",
                   a("risk parity.",
                     href = "http://www.portfoliowizards.com/risk-parity-demo-workbook/")),
                 
                 plotOutput("plotRP"),
                 
                 plotOutput("plotRP2")),
        tabPanel("Assumptions", 
                 h6("Annualized Volatility"),
                 tableOutput("table1"),
                 h6("Correlation coefficients"),
                 tableOutput("table2")),
        tabPanel("Definitions", 
                 
                 h4("Weight"),
                 p("Asset Value divided by the greater of 1 and the sum of all Asset Values"),
                 
                 withMathJax(h2(HTML("$$ Value_{Asset} / max(1, \\Sigma 
                                     Value_{Asset_{i}}) $$" ))),
                 br(),
                 h4("Risk Contribution"),
                 p("Product of Asset's Weight and its covariance with the
                   Portfolio, scaled by the Portfolio's variance"),
                 
                 withMathJax(h2(HTML("$$ weight_{Asset} * \\sigma_{Asset, Portfolio}
                                     / \\sigma^{2}_{Portfolio}  $$" ))),
                 br(),
                 h4("Return Contribution"),
        p("Product of Asset's Weight and its Expected Return"),
        withMathJax(h2(HTML("$$ weight_{Asset} * \\mu_{Asset}  $$" ))),
        br(),
        h4("Sharpe Ratio"),
        p("Ratio of Expected Return to Volatility"), 
        withMathJax(h2(HTML("$$ \\mu_{Asset} / \\sigma_{Asset}  $$" ))),
        p("Note this is simply a \"Return/Risk ratio,\" which is not exactly the
          true definition of a Sharpe Ratio. However in the vernacular of the
          investment world the terms are interchangeable and for the purpose of
          this application their meanings are similar enough."),
        p("If you would like to know the precise definition of \"Sharpe Ratio,\" ",
          a(href = "http://web.stanford.edu/~wfsharpe/art/sr/sr.htm",
            "consult the source.")  ),
        br()
        )
        )
                 )
  ),
wellPanel(
  p("This application is for illustration purposes only. It does not constitute investment advice. The assumptions and results are meant to be educational only. Do not rely on this application for your own investment decisions."),
  p("Questions? Contact the author: ", a(href = "mailto:tom@portfoliowizards.com","tom@portfoliowizards.com")))  
))