library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)

data_file_path = "~/git/puppies/weights_long.csv"
load_data = function(){
	return(read.csv(data_file_path) %>% as_tibble())
}

server = function(input, output, session) {
	update = reactiveVal(0)
	data = reactive({
		update = update()
		df = load_data() %>% group_by(name)
		df
	})
	
	uniqueNames = reactive({
		return(unique(data()$name))
	})
	
	observeEvent(input$add, {
		current_data = load_data()
		updated_data = add_row(current_data, name = input$puppy, date = as.character(input$date), weight = input$weight)
		write.csv(updated_data, data_file_path, row.names = F)
		update(update() + 1)
	})
	
	observeEvent(input$delete, {
		row = input$data_rows_current
		if(is.null(input$data_rows_selected)){
			return()
		}
		
		write.csv(data()[-1 * input$data_rows_selected, ], data_file_path, row.names = F)
		update(update() + 1)
	})
	
	observeEvent(uniqueNames(), {
		updateSelectInput(session, "puppy", choices = uniqueNames())
	})
	
	output$data = DT::renderDataTable({
		update()
		data()
	}, selection = "single")
	
	output$plot = renderPlotly({
		update()
		
		plot = ggplot(data(), aes(x = as.Date(date), y = weight, color = name)) + geom_path() + geom_point() + theme_classic() + 
			ggtitle("Puppies Weight by Day") + xlab("Date")# + scale_x_discrete(breaks = scales::pretty_breaks(n = 10))
		if(input$log){
			plot = plot + scale_y_log10() + ylab("log(Weight) [log(g)]")
		}else{
			plot = plot + ylab("Weight [g]")
		}
		plot
	})
	
	output$downloadData = downloadHandler(filename = function(file) {
		return("weights_long.csv")
	},
	content = function(file) {
		write.csv(data(), file, row.names = F)
	})
}