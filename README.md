# NFL - Data Analysis & Bar chart race

This project has the objective to gather NFL data from the [NFL website](http://www.nfl.com/stats/player), it is focused on the individual stats from the first Superbowl season (1966) until the last season played.

It mixes Python and R coding, being used mostly the BeautifulSoup library for the Web Scrapper and dplyr and ggplot2 libraries for the Data Analysis and visualisation

The video below shows the cumulative yards race among active and retired players over the years

![alt text](https://github.com/loumishima/NFL-Data-Analysis/blob/master/images/race.gif "Yards leaders")

## Web Crawler Usage

For the data gathering on the Jupyter notebook, there are two parameters that have to be set on the function **getNFLData**:

* Attribute: What kind of stats you want to gather, it could be:
  * Passing
  * Rushing
  * Receiving
  * Sacks
  * Touchdowns
  * and more (Check the [Players stats](http://www.nfl.com/stats/categorystats?tabSeq=0&statisticCategory=PASSING&conference=null&season=2018&seasonType=POST&d-447263-s=PASSING_YARDS&d-447263-o=2&d-447263-n=1))
* Season type: Nfl's playing period
  * Offseason
  * Regular Season
  * Post-season and Superbowls


## Bar Chart Race usage

For now the Bar chart race is not very user friendly, but to change the attribute being used for the race just change the **Yds** variable name for the stats of your desire:


## More to come:

1. Make a better interface to gather and create customs bar charts
2. Integrating the two codes into one (Still too emotionally connected to R language haha)
  1. Or maybe two versions (with some language usage analysis)
3. Create an web page for the data gathering
