library(shiny)
library(leaflet)
library(dplyr)
library(plotly)
library(googleVis)
load("Rats.Rda")
load("RatTS.rda")
load("RatSum.Rda")
library(DT)

ratIcon <- makeIcon(
  iconUrl = "https://image.freepik.com/free-vector/rat-silhouette-black-mouse-vector_91-8505.jpg",
  iconWidth = 25, iconHeight = 15
) 
