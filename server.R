# server.R
assets <- c("Treasuries",
            "TIPS",
            "Corp. Bonds",
            "US Stocks",
            "Int'l Stocks",
            "Commodities")

volatilities <- c(0.07, 0.1, 0.12, 0.2, 0.2, 0.3)

correlations <- matrix(cbind(c(1.00,0.95,0.60,0.10,0.10,0.10),
                             c(0.95,1.00,0.65,0.10,0.10,0.10),
                             c(0.60,0.65,1.00,0.35,0.35,0.20),
                             c(0.10,0.10,0.35,1.00,0.70,0.10),
                             c(0.10,0.10,0.35,0.70,1.00,0.15),
                             c(0.10,0.10,0.20,0.10,0.15,1.00)), nrow = 6, 
                       ncol = 6)

covariances <- correlations * (volatilities %*% t(volatilities))

axisLabels <- seq(0, 1.0, .05)

shinyServer(function(input, output) {
  
  weights <- reactive({
    c(input$treas, input$tips, input$corp, input$us, input$intl, 
      input$commod)/100
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
    axis(4, at=c(0.85,2,3.15,4.3,5.45,6.5), lab = assets , las=TRUE, lty = 0)
    barplot(t(risk_contributions()), 
            main = "Contribution to Portfolio Risk", col = "red", xaxt = "n", 
            yaxt = "n", horiz = TRUE)
    axis(1, at = axisLabels, lab=paste0(axisLabels * 100, " %"), 
         las=TRUE, cex.axis=1, padj = 0.5)
  })
  
})