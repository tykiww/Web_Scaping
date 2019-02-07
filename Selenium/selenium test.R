# selenium testing

install.packages("RSelenium")
library("RSelenium")
vignette("RSelenium-docker", package = "RSelenium")
checkForServer() # search for and download Selenium Server java binary.  Only need to run once.
startServer() # run Selenium Server binary
remDr <- remoteDriver(browserName="chrome", port=4444) # instantiate remote driver to connect to Selenium Server
remDr$open(silent=T) # open web browser





# BF 2










