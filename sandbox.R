weights <- c(.3026, .2085, .1570, .1184, .1156, .0979)

wcov <- covariances %*% weights

portVar <- (t(weights) %*% wcov)[1,1]
portSD <- sqrt(portVar)

betas <- wcov / portVar

