title: "STAT 495"
output: html_document
date: "2024-02-12"

```{r Measurements of Disease Occurrence / Graphical Presentation}
#Bar graph 
table <- xtabs(percent~ gender+race, data=diabetes1)
barplot(table, main="Ground Bar Graph for Prevalence of Diagnosed Diabetes 
        by Race and Gender", ylim=c(0,16), xlab="", ylab="Percent", col=c("purple", "blue"), legend.text=row.names(table), beside=TRUE)

#Series
plot(diabetes3$year, diabetes3$diagnosed, type="l", col="blue", 
     main="Diabetes Cases (in million) in U.S. by Year", xlim=c(1999,2018), 
     ylim=c(0,35), xlab="Year", ylab="Number of Cases (in millions)", axes=FALSE, 
     panel.first=grid())
axis(side=1, at=c(seq(1999,2015, by=2), 2018))
axis(side=2)

lines(diabetes3$year, diabetes3$undiagnosed, col="black")
lines(diabetes3$year, diabetes3$total, col="red")

#pch 16=dot
points(diabetes3$year, diabetes3$diagnosed, pch=16, col="blue")
#pch 1=circle
points(diabetes3$year, diabetes3$undiagnosed, pch=1, col="black")
#pch 5=diamond
points(diabetes3$year, diabetes3$total, pch=5, col="red")

legend("topleft", c("diagnosed", "undiagnosed", "total"), lty=1,
       col=c("blue", "black", "red"))
```


```{r Binomial Exact Test and CI for Prevalence Proportion}
#Exact Binomial test 
binom.test(725,10000, p=.07, alternative = "greater")

#Exact Binomial CI 
binom.test(725,10000,conf.level = .9)

#Approximate test 
prop.test(725,10000,conf.level =.9)
```

```{r Pisson Exact Test and CI for Incidence Rate}
#Exact Poisson test 
poisson.test(12,1978,r=.01, alternative = "less")

#Exact Poisson CI 
PoissonCI(12,1978,method="exact",conf.level=.95)
```

```{r CI for Relative Risk, Odds Ratio, and Incidence Rate Ratio}
#A99% CI for relative risk
x1 <- 18 
n1 <- 1000
x2 <- 43 
n2 <- 1000

conf.level <- 99
z <- qnorm(1-.01*conf.level)
SE <- sqrt(1/x1-1/n1+1/x2-1/n2)
#Relative Risk 
print(RR <- (x1/n1) / (x2/n2))
#Lower Confidence Level 
print(LCL <- RR/exp(z*SE))
#Upper Confidence Level
print(UCL <- RR*exp(z*SE))


#A 99% CI for odds ratio 
conf.level <- 99 
z <- qnorm((1-.01*conf.level)/2)
SE <- sqrt(1/x1+1/(n1-x1)+1/x2+1/(n2-x2))
#Odds ratio
print(OR <- (x1/(n1-x1))/(x2/(n2-x2)))
#Lower Confidence Level
print(LCL <- OR/exp(z*SE))
#Upper Confidence Level 
print(UCL <- OR*exp(z*SE))

#A 90% CI for incidence rate ratio 
n1 <- 72 
T1 <- 1862 
n2 <- 511
T2 <- 36653 
conf.level <- 90 
z <- -qnorm((1-.01*conf.level)/2)
SE <- sqrt(1/n1+1/n2)
#Incidence rate ratio 
print(IRR <- (n1/T1) / (n2/T2))
#Lower Confidence Level 
print(LCL <- IRR/exp(z*SE))
#Upper Confidence Level 
print(LCU <- IRR*exp(z*SE))

#Estimating the prevalence proportions, odds, and incidence rates of concussions in football and in baseball
ConcData <- ConcussionData
football.players <- subset(ConcData, Sport == "football")
baseball.players <- subset(ConcData, Sport == "baseball")
Fcases <- sum(ifelse(football.players$Concussion=="yes", 1, 0))
Bcases <- sum(ifelse(baseball.players$Concussion=="yes", 1, 0))
Ftotal <- nrow(football.players)
Btotal <- nrow(baseball.players)
Fduration <- as.numeric(sum(as.Date(football.players$End_Date) -as.Date("2015-08-20")))
Bduration <- as.numeric(sum(as.Date(baseball.players$End_Date) -as.Date("2015-08-20")))
print(c(F_PP <- Fcases/Ftotal,
        B_PP <- Bcases/Btotal,
        F_ODDS <- Fcases/(Ftotal-Fcases), 
        B_ODDS <- Bcases/(Btotal-Bcases), 
        F_IR <- Fcases/Fduration, 
        B_IR <- Bcases/Bduration))
```

```{r ANOVA, Tukey-test,Kruskal-Wallis H-test, and Wilcoxon rank-sum test }
clinic<- c("A", "A", "A", "A", "A", "A", "B", "B", "B", "B", "B", "B",
           "C", "C", "C", "C", "C", "C")
SBP<- c(124, 123, 106, 120, 113, 103, 142, 140, 129, 131, 129, 113, 128,
        135, 146, 133, 137, 129)
#ANOVA 
summary(model <- aov(SBP ~ clinic))

#Tueky test
TukeyHSD(model)

#Kruskal-Wallis test
SBP.A<- c(124, 123, 106, 120, 113, 103)
SBP.B<- c(142, 140, 129, 131, 129, 113)
SBP.C<- c(128, 135, 146, 133, 137, 129)
SBP.list<- list(SBP.A, SBP.B, SBP.C)

kruskal.test(SBP.list)

#Wilcoxon rank-sum test
#A & B
wilcox.exact(SBP.A, SBP.B, paired=FALSE, alternative="two.sided")
#A & C 
wilcox.exact(SBP.A, SBP.C, paired=FALSE, alternative="two.sided")
#B & C 
wilcox.exact(SBP.B, SBP.C, paired=FALSE, alternative="two.sided")
```