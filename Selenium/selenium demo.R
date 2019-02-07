# I have finally gotten around to using Rselenium! 
# The first time I had heard of this was from one 
# of my good friends who was web scraping off of Python.
# It actually took me a long time to figure out how 
# exactly I was supposed to use it because it was rather
# difficult for me to grasp the concept as a new learner.


# In layman terms, RSelenium is an R version of a website 
# testing platform. This means that Selenium allows the
# automation of website actions just as if you are pointing
# and clicking. This means that the usage of this tool is
# not only used for testing web apps, but can be used for
# scraping information on the web, or performing certain
# tasks that need to be done recursively. Of course, R may
# not be the easiest nor the best way to use the Selenium
# server (There seem to be better methods with other IDEs.
# ie. Firefox Selenium IDE) but the whole point of this blog
# is expanding the reach of R as an analytical tool.

# We'll get started right away.

# Unfortunately, since I last loaded the package, it has
# become defunct. I found out later it was because the 
# dependencies `binman` and `wdman` were deleted from the
# CRAN server due to "checks" problems. Don't ask me too
# many details, because I am no any expert. Good thing
# we can access the archived RSelenium and old dependencies!
library(devtools)
### install_version("binman", version = "0.1.0", repos = "https://cran.uni-muenster.de/")
### install_version("wdman", version = "0.2.2", repos = "https://cran.uni-muenster.de/")
### install_version("RSelenium", version = "1.7.1", repos = "https://cran.uni-muenster.de/")
library("RSelenium")


# If you are super picky about the "proper" way to use things,
# there is yet another administrative task we have to go through 
# in order to use RSelenium. You also need to get our hands on Docker 
# as rsDriver is not currently working. To solve this, make sure to go 
# and download Docker from this [site](https://store.docker.com/) after
# creating an account. It's free. Don't worry. Yet, I am not really in
# the mood to run through two separate ways to run Selenium, so I will
# show you how I use this.


# We initially will begin by using the `rsDriver()` function with the 
# correct port and browser information. Usually, as a developer tool,
# Firefox is the main, but since I have this new laptop I have not once
# touched Firefox. I suggest if you are following along, use Chrome browser
# to access Selenium. 

browse <- rsDriver(port=4444L,browser="chrome")$client
url <- "https://google.com/ncr"
browse$navigate(url)


wxbox <- browse$findElement(using = 'css selector',"#lst-ib")
wxbox$sendKeysToElement(list("Walmart"))
wxbox$sendKeysToElement(list("")) # to click out of box

browse$findElement(using = 'css selector', value = "center input")$clickElement()
browse$findElement(using = 'css selector', value = "span input")$clickElement()




industry <- browse$findElement(using = 'xpath', value = xp1)
explanation <- browse$findElement(using = 'xpath', value = xp2)
industry$getElementText()
explanation$getElementText()

browse$close() # To close window 
browse$closeServer() # to close server










