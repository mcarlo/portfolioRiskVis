input <- data.frame("treas" = 30.26, "tips" = 20.85, "corp" = 15.70, "us" = 
                      11.84, "intl" = 11.56, "commod" = 9.79)

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

portfolioValue <- sum(input$commod, input$intl, input$us, input$corp, 
                      input$tips, input$treas)
  
weights <- c(input$commod, input$intl, input$us, input$corp, input$tips, 
             input$treas)/max(1, portfolioValue)
  
  
contributions <- weights * (covariances %*% weights)[,1]
contributions

portfolio_variance <- sum(contributions)
  
portfolio_std <- sqrt(portfolio_variance)
  
risk_contributions <- contributions/sum(contributions)    

risk <- data.frame(cbind(weights, Volatility, risk_contributions))
risk <- data.frame(cbind(risk, Asset))

symbols(risk$Volatility, risk$weights, circles=(.1*sqrt(contributions)), 
        fg="white", bg="red", xlim = c(0, .35))
text(risk$Volatility, risk$weights, risk$Asset, cex=1.)

library(ggplot2); library(scales)
ggplot(risk, aes(x = Volatility, y = weights, size = risk_contributions, 
                 label = Asset), guide = FALSE) + 
  geom_point(colour = "white", fill = "red", shape = 21)+ 
  scale_size_area(max_size = 40, name = "Risk Contribution", labels = percent) +  
  scale_x_continuous(name = "Volatility \n (Annualized Return Standard Deviation)", limits = c(0, .35), labels = percent) +
  scale_y_continuous(name = "Weight (%)", labels = percent) + 
  geom_text(size = 4) + theme_bw() +
  ggtitle("Portfolio Risk Dynamics \n Weight, Contribution vs. Volatility")