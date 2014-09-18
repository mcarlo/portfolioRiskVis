# server.R
Asset <- c("Commodities","Int'l Stocks","US Stocks","Corp. Bonds","TIPS","Treasuries"
                        )

Volatility <- c(0.3, .2, .2, .12, .1, .07)
Expected_Return <- c(0.05, .07, .08, .03, .01, .02)

volDF <- data.frame(cbind(Volatility, Expected_Return))
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

maxSharpe <- solve(covariances, Expected_Return)/sum(solve(covariances, Expected_Return))
minVar <- (solve(covariances)%*%rep(1, 6))[,1]/sum(solve(covariances)%*%rep(1, 6))
riskParity <- 

axisLabels <- seq(0, 1.0, .05)
returnLabels <-  seq(0, .10, .005)
rrLabelsX <-  seq(0, 0.35, .05)
rrLabelsY <-  seq(0, 0.10, .01)

shinyServer(function(input, output) {
  
  portfolioValue <- reactive({
    sum(input$commod, input$intl, input$us, input$corp, input$tips, input$treas)
  })

  weights <- reactive({
    c(input$commod, input$intl, input$us, input$corp, input$tips, input$treas)/
      max(1, portfolioValue())
  })
  
  return_contributions <- reactive({
    weights() * Expected_Return
  })
  
  portfolio_return  <- reactive({
    sum(return_contributions())
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
  
  risk <- reactive({data.frame(cbind(Volatility, weights(), covariances,
                                     risk_contributions()))})
  
  riskDF <- data.frame(cbind(risk, Asset))
  
  output$plot <- renderPlot({
    par(mfcol = c(1,3), oma = c(0.5, 5, 0.5, 0.5))
    barplot(t(weights()), horiz = TRUE, main = "Weight", ps = 12, 
            cex.main = 1.5, xaxt = "n", col = "white", yaxt = "n", 
            mar = c(4, 20, 0.5, 0.5) + .1)
    axis(1, at = axisLabels, lab=paste0(axisLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
    axis(2, at=c(0.85,2,3.15,4.3,5.45,6.5), lab = Asset , las=TRUE, lty = 0, 
         ps = 12, cex.axis = 1.5)
    barplot(t(risk_contributions()), 
            main = "Risk Contribution", ps = 12, cex.main = 1.5, col = "red", xaxt = "n", 
            yaxt = "n", horiz = TRUE, mar = c(4, 0.5, 0.5, 0.5) + .1)
    axis(1, at = axisLabels, lab=paste0(axisLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
    barplot(t(return_contributions()), 
            main = "Return Contribution", ps = 12, cex.main = 1.5, col = "black", xaxt = "n", 
            yaxt = "n", horiz = TRUE, mar = c(4, 0.5, 0.5, 0.5) + .1)
    axis(1, at = returnLabels, lab=paste0(returnLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
  })
  
  output$plot2 <- renderPlot({
    plot(portfolio_std(), portfolio_return(), pch = "P", cex = 3, col = "red", 
         xlim = c(0, .35), ylim = c(0, 0.1), xlab = "Volatility 
         \n (Annualized standard deviation)", xaxt = "n", ylab = "Expected Return",
         yaxt = "n", main = "Portfolio Expected Return \n vs. Risk", ps = 12, 
         cex.main = 1.5, mar = c(4,14,0.5,0.5) + .1,
         oma = c(4,4,0.5,0.5) + .1)
    points(Volatility, Expected_Return, pch = 19)
    text(Volatility, Expected_Return, labels=Asset, cex= 1., pos=4)
    axis(1, at = rrLabelsX, lab=paste0(rrLabelsX * 100, " %"), las=TRUE)
    axis(2, at = rrLabelsY, lab=paste0(rrLabelsY * 100, " %"), las=TRUE)
  })
  
  # Generate an HTML table view of the data
  output$table1 <- renderTable({
    volDF
  })
  output$table2 <- renderTable({
    data.frame(correlations)
  })
})