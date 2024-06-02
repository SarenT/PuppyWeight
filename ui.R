library(shiny)
library(DT)
library(shinyBS)
library(plotly)

ui = fluidPage(
	titlePanel("Puppies (this is not a competition :D )"),
	sidebarLayout(
		sidebarPanel(
			selectInput("puppy", "Puppy", choices = c()),
			dateInput("date", "Date of measurement (yyyy-mm-dd):"),
			tipify(numericInput("weight", "Weight (g)", min = 0, max = 100 * 1000, step = 1, value = 0), "15,5 kg would be 15500", placement = "right"),
			actionButton("add", "Add data"),
			actionButton("delete", "Delete data"),
			downloadButton("downloadData", "Download"),
			checkboxInput("log", "Log y scale")
		),
		mainPanel(
			fluidPage(
				fluidRow(
					column(12, plotlyOutput("plot"))
				),
				fluidRow(
					column(12, DT::dataTableOutput("data"))
				)
			)
		)
	)
)
