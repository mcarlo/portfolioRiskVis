# server.R
Asset <- c("Commodities","Int'l Stocks","US Stocks","Corp. Bonds","TIPS","Treasuries"
                        )

Volatility <- c(0.3, .2, .2, .12, .1, .07)
volDF <- data.frame(Volatility)
rownames(volDF) <- Asset

correlations <- matrix(cbind(c(1, 0.15, 0.1, 0.2, 0.1, 0.1),
                             c(0.15, 1, 0.7, 0.35, 0.1, 0.1),
                             c(0.1, 0.7, 1, 0.35, 0.1, 0.1),
                             c(0.2, 0.35, 0.35, 1, 0.65, 0.6),
                             c(0.1, 0.1, 0.1, 0.65, 1, 0.95),
                             c(0.1, 0.1, 0.1, 0.6, 0.95, 1)), nrow = 6)

colnames(correlations) <- Asset
rownames(correlations) <- Asset

covariances <- correlations * (Volatility %*% t(Volatility))

axisLabels <- seq(0, 1.0, .05)

shinyServer(function(input, output) {
  
  portfolioValue <- reactive({
    sum(input$commod, input$intl, input$us, input$corp, input$tips, input$treas)
  })

  weights <- reactive({
    c(input$commod, input$intl, input$us, input$corp, input$tips, input$treas)/
      max(1, portfolioValue ())
  })
  
  
  contributions <- reactive({
    weights() * (covariances %*% weights())
  })
  
  portfolio_variance <- reactive({
    sum(contributions())
  })
  
  portfolio_std <- reactive({
    sqrt(portfolio_variance())
  })
  
  risk_contributions <- reactive({
    contributions()/sum(contributions())    
  })
  
  output$plot <- renderPlot({
    par(mfcol = c(1,2))
    barplot(t(weights()), horiz = TRUE, main = "Portfolio Weight", xaxt = "n", 
            col = "black", yaxt = "n")
    axis(1, at = axisLabels, lab=paste0(axisLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
    barplot(t(risk_contributions()), 
            main = "Contribution to Portfolio Risk", col = "red", xaxt = "n", 
            yaxt = "n", horiz = TRUE)
    axis(1, at = axisLabels, lab=paste0(axisLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
    axis(2, at=c(0.85,2,3.15,4.3,5.45,6.5), lab = Asset , las=TRUE, lty = 0)
  })

  # Generate an HTML table view of the data
  output$table1 <- renderTable({
    volDF
  })
  output$table2 <- renderTable({
    data.frame(correlations)
  })
})