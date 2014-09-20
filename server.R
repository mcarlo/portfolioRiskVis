# server.R
Asset <- c("US Stocks","Int'l Stocks","Bonds","REITs","Commodities")

Volatility <- c(0.2, .25, .05, .25, .25)
Expected_Return <- c(0.085, .08, .02, .075, .05)

volDF <- data.frame(cbind(Volatility, Expected_Return))
rownames(volDF) <- Asset

correlations <- matrix(cbind(c(1, 0.95, 0.15, 0.85, 0.6),
                             c(0.95, 1, 0.3, 0.8, 0.7),
                             c(0.15, 0.3, 1, 0.25, 0.05),
                             c(0.85, 0.8, 0.25, 1, 0.45),
                             c(0.6, 0.7, 0.05, 0.45, 1)), nrow = 5)



colnames(correlations) <- Asset
rownames(correlations) <- Asset

covariances <- correlations * (Volatility %*% t(Volatility))

maxSharpe <- (solve(covariances, Expected_Return)/sum(solve(covariances, Expected_Return)))*100
minVar <- ((solve(covariances)%*%rep(1, 5))[,1]/sum(solve(covariances)%*%rep(1, 5)))*100
riskParity <- c(10.0513601776988, 7.43196185269416, 64.187314312573,
                8.39451719877827, 9.9348464582568) 


# add RP vectors and values
portfolioRP <- sum(riskParity)

weightsRP <- riskParity

return_RP <- weightsRP * Expected_Return

portfolio_returnRP  <- sum(return_RP)/100

contributionsRP <- weightsRP * (covariances %*% weightsRP)

portfolio_varianceRP <- sum(contributionsRP)

portfolio_stdRP <- sqrt(portfolio_varianceRP)/100

risk_contributionsRP <- contributionsRP/portfolio_varianceRP



# add MinVar vectors and values
portfoliominVar <- sum(minVar)

weightsminVar <- minVar

return_minVar <- weightsminVar * Expected_Return

portfolio_returnminVar  <- sum(return_minVar)/100

contributionsminVar <- weightsminVar * (covariances %*% weightsminVar)

portfolio_varianceminVar <- sum(contributionsminVar)

portfolio_stdminVar <- sqrt(portfolio_varianceminVar)/100

risk_contributionsminVar <- contributionsminVar/portfolio_varianceminVar


# add maxSharpe vectors and values
portfoliomaxSharpe <- sum(maxSharpe)

weightsmaxSharpe <- maxSharpe

return_maxSharpe <- weightsmaxSharpe * Expected_Return

portfolio_returnmaxSharpe  <- sum(return_maxSharpe)/100

contributionsmaxSharpe <- weightsmaxSharpe * (covariances %*% weightsmaxSharpe)

portfolio_variancemaxSharpe <- sum(contributionsmaxSharpe)

portfolio_stdmaxSharpe <- sqrt(portfolio_variancemaxSharpe)/100

risk_contributionsmaxSharpe <- contributionsmaxSharpe/portfolio_variancemaxSharpe

axisLabels <- seq(-2., 2., .2)
returnLabels <-  seq(-.10, .10, .01)
rrLabelsX <-  seq(0, 0.35, .05)
rrLabelsY <-  seq(0, 0.10, .01)

shinyServer(function(input, output) {
  
  portfolioValue <- reactive({
    sum(input$commod, input$reit, input$bond, input$intl, input$us)
  })

  weights <- reactive({
    c(input$us, input$intl, input$bond, input$reit, input$commod )/
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
            cex.main = 1.5, xaxt = "n", col = "#4F81BD", yaxt = "n", 
            mar = c(4, 20, 0.5, 0.5) + .1)
    axis(1, at = axisLabels, lab=paste0(axisLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
    axis(2, at=c(0.85,2,3.15,4.3,5.45), lab = Asset , las=TRUE, lty = 0, 
         ps = 12, cex.axis = 1.5)
    barplot(t(risk_contributions()), 
            main = "Risk Contribution", ps = 12, cex.main = 1.5, col = "#9BBB59", xaxt = "n", 
            yaxt = "n", horiz = TRUE, mar = c(4, 0.5, 0.5, 0.5) + .1)
    axis(1, at = axisLabels, lab=paste0(axisLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
    barplot(t(return_contributions()), 
            main = "Return Contribution", ps = 12, cex.main = 1.5, col = "#FF9800", xaxt = "n", 
            yaxt = "n", horiz = TRUE, mar = c(4, 0.5, 0.5, 0.5) + .1)
    axis(1, at = returnLabels, lab=paste0(returnLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
  })
  
  output$plot2 <- renderPlot({
    plot(portfolio_std(), portfolio_return(), pch = 19, cex = 1.5, col = "red", 
         xlim = c(0, .35), ylim = c(0, 0.1), xlab = "Volatility 
         \n (Annualized standard deviation)", xaxt = "n", ylab = "Expected Return",
         yaxt = "n", main = "Portfolio Expected Return vs. Risk", ps = 12, 
         cex.main = 1.5, mar = c(4,14,0.5,0.5) + .1,
         oma = c(4,4,0.5,0.5) + .1)
    points(Volatility, Expected_Return, pch = 19)
    text(Volatility[-c(2,4)], Expected_Return[-c(2,4)], labels=Asset[-c(2,4)], cex= 1., pos=2)
    text(Volatility[4], Expected_Return[4], labels=Asset[4], cex= 1., pos=1)
    text(Volatility[2], Expected_Return[2], labels=Asset[2], cex= 1., pos=3)
    text(portfolio_std(), portfolio_return(), labels="Portfolio", cex= 1.5, col = "red", pos=4)
    axis(1, at = rrLabelsX, lab=paste0(rrLabelsX * 100, " %"), las=TRUE)
    axis(2, at = rrLabelsY, lab=paste0(rrLabelsY * 100, " %"), las=TRUE)
  })
  
  output$plotRP <- renderPlot({
    par(mfcol = c(1,3), oma = c(0.5, 5, 0.5, 0.5))
    barplot(t(weightsRP)/100, horiz = TRUE, main = "Weight", ps = 12, 
            cex.main = 1.5, xaxt = "n", col = "#4F81BD", yaxt = "n", 
            mar = c(4, 20, 0.5, 0.5) + .1)
    axis(1, at = axisLabels, lab=paste0(axisLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
    axis(2, at=c(0.85,2,3.15,4.3,5.45), lab = Asset , las=TRUE, lty = 0, 
         ps = 12, cex.axis = 1.5)
    barplot(t(risk_contributionsRP), 
            main = "Risk Contribution", ps = 12, cex.main = 1.5, col = "#9BBB59", xaxt = "n", 
            yaxt = "n", horiz = TRUE, mar = c(4, 0.5, 0.5, 0.5) + .1)
    axis(1, at = axisLabels, lab=paste0(axisLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
    barplot(t(return_RP/100), 
            main = "Return Contribution", ps = 12, cex.main = 1.5, col = "#FF9800", xaxt = "n", 
            yaxt = "n", horiz = TRUE, mar = c(4, 0.5, 0.5, 0.5) + .1)
    axis(1, at = returnLabels, lab=paste0(returnLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
  })
  
  output$plotRP2 <- renderPlot({
    par(mfcol = c(1,1), oma = c(0.5, 5, 0.5, 0.5))
    plot(portfolio_stdRP, portfolio_returnRP,  pch = 19, cex = 1.5, col = "red", 
         xlim = c(-0.05, .40), ylim = c(0, 0.1), xlab = "\n \n Volatility 
         \n (Annualized standard deviation)", xaxt = "n", ylab = "Expected Return",
         yaxt = "n", main = "Portfolio Expected Return vs. Risk", ps = 12, 
         cex.main = 1.5, mar = c(4,14,0.5,0.5) + .1,
         oma = c(4,4,0.5,0.5) + .1)
    points(Volatility, Expected_Return, pch = 19)
    text(Volatility[-c(2,4)], Expected_Return[-c(2,4)], labels=Asset[-c(2,4)], cex= 1., pos=2)
    text(Volatility[4], Expected_Return[4], labels=Asset[4], cex= 1., pos=1)
    text(Volatility[2], Expected_Return[2], labels=Asset[2], cex= 1., pos=3)
    text(portfolio_stdRP, portfolio_returnRP, labels="Risk Parity", cex= 1.5, col = "red", pos=4)
    axis(1, at = rrLabelsX, lab=paste0(rrLabelsX * 100, " %"), las=TRUE)
    axis(2, at = rrLabelsY, lab=paste0(rrLabelsY * 100, " %"), las=TRUE)
  })
  
  output$plotminVar <- renderPlot({
    par(mfcol = c(1,3), oma = c(0.5, 5, 0.5, 0.5))
    barplot(t(weightsminVar/100), horiz = TRUE, main = "Weight", ps = 12, 
            cex.main = 1.5, xaxt = "n", col = "#4F81BD", yaxt = "n", 
            mar = c(4, 20, 0.5, 0.5) + .1)
    axis(1, at = axisLabels, lab=paste0(axisLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
    axis(2, at=c(0.85,2,3.15,4.3,5.45), lab = Asset , las=TRUE, lty = 0, 
         ps = 12, cex.axis = 1.5)
    barplot(t(risk_contributionsminVar), 
            main = "Risk Contribution", ps = 12, cex.main = 1.5, col = "#9BBB59", xaxt = "n", 
            yaxt = "n", horiz = TRUE, mar = c(4, 0.5, 0.5, 0.5) + .1)
    axis(1, at = axisLabels, lab=paste0(axisLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
    barplot(t(return_minVar/100), 
            main = "Return Contribution", ps = 12, cex.main = 1.5, col = "#FF9800", xaxt = "n", 
            yaxt = "n", horiz = TRUE, mar = c(4, 0.5, 0.5, 0.5) + .1)
    axis(1, at = returnLabels, lab=paste0(returnLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
  })
  
  output$plotminVar2 <- renderPlot({
    plot(portfolio_stdminVar, portfolio_returnminVar,  pch = 19, cex = 1.5, col = "red",  
         xlim = c(-0.05, .4), ylim = c(0, 0.1), xlab = "Volatility 
         \n (Annualized standard deviation)", xaxt = "n", ylab = "Expected Return",
         yaxt = "n", main = "Portfolio Expected Return vs. Risk", ps = 12, 
         cex.main = 1.5, mar = c(4,14,0.5,0.5) + .1,
         oma = c(4,4,0.5,0.5) + .1)
    points(Volatility, Expected_Return, pch = 19)
    text(Volatility[-c(2,4)], Expected_Return[-c(2,4)], labels=Asset[-c(2,4)], cex= 1., pos=2)
    text(Volatility[4], Expected_Return[4], labels=Asset[4], cex= 1., pos=1)
    text(Volatility[2], Expected_Return[2], labels=Asset[2], cex= 1., pos=3)
    text(portfolio_stdminVar, portfolio_returnminVar, labels="MinVar", cex= 1.5, col = "red", pos=4)
    axis(1, at = rrLabelsX, lab=paste0(rrLabelsX * 100, " %"), las=TRUE)
    axis(2, at = rrLabelsY, lab=paste0(rrLabelsY * 100, " %"), las=TRUE)
  })
  
  output$plotmaxSharpe <- renderPlot({
    par(mfcol = c(1,3), oma = c(0.5, 5, 0.5, 0.5))
    barplot(t(weightsmaxSharpe/100), horiz = TRUE, main = "Weight", ps = 12, 
            cex.main = 1.5, xaxt = "n", col = "#4F81BD", yaxt = "n", 
            mar = c(4, 20, 0.5, 0.5) + .1)
    axis(1, at = axisLabels, lab=paste0(axisLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
    axis(2, at=c(0.85,2,3.15,4.3,5.45), lab = Asset , las=TRUE, lty = 0, 
         ps = 12, cex.axis = 1.5)
    barplot(t(risk_contributionsmaxSharpe), 
            main = "Risk Contribution", ps = 12, cex.main = 1.5, col = "#9BBB59", xaxt = "n", 
            yaxt = "n", horiz = TRUE, mar = c(4, 0.5, 0.5, 0.5) + .1)
    axis(1, at = axisLabels, lab=paste0(axisLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
    barplot(t(return_maxSharpe/100), 
            main = "Return Contribution", ps = 12, cex.main = 1.5, col = "#FF9800", xaxt = "n", 
            yaxt = "n", horiz = TRUE, mar = c(4, 0.5, 0.5, 0.5) + .1)
    axis(1, at = returnLabels, lab=paste0(returnLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
  })
  
  output$plotmaxSharpe2 <- renderPlot({
    plot(portfolio_stdmaxSharpe, portfolio_returnmaxSharpe,  pch = 19, cex = 1.5, col = "red", 
         xlim = c(-0.05, .4), ylim = c(0, 0.1), xlab = "Volatility 
         \n (Annualized standard deviation)", xaxt = "n", ylab = "Expected Return",
         yaxt = "n", main = "Portfolio Expected Return vs. Risk", ps = 12, 
         cex.main = 1.5, mar = c(4,14,0.5,0.5) + .1,
         oma = c(4,4,0.5,0.5) + .1)
    points(Volatility, Expected_Return, pch = 19)
    text(Volatility[-c(2,4)], Expected_Return[-c(2,4)], labels=Asset[-c(2,4)], cex= 1., pos=2)
    text(Volatility[4], Expected_Return[4], labels=Asset[4], cex= 1., pos=1)
    text(Volatility[2], Expected_Return[2], labels=Asset[2], cex= 1., pos=3)
    text(portfolio_stdmaxSharpe, portfolio_returnmaxSharpe, labels="Max Sharpe", cex= 1.5, col = "red", pos=4)
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