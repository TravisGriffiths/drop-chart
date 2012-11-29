###
Drop Chart is a plug-in intended to allow for sinple d3 charts to easily be put into any html system.


###

class ChartFetcher

  charts: []

  constructor: ->
    @raw_charts = @fetchCharts()
    for chart in @raw_charts
      @charts.push(new Chart(chart))
    debugger

  fetchCharts: ->
    jQuery(".drop-chart")


class Chart

  constructor: (@raw) ->
    @type = jQuery(@raw).attr('data-type')
    @source = jQuery(@raw).attr('data-source')
    @fetchData()

  fetchData: ->
    @data = window[@source]

class Pie extends Chart

  constructor: (@chart) ->
    debugger



jQuery(document).ready ->
  new ChartFetcher()