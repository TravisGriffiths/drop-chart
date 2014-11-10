$ = jQuery
###
Drop Chart is a plug-in intended to allow for sinple d3 charts to easily be put into any html system.


###

$.extend $.fn,

  dropchart: (drop_arg, obj_hash) ->

    debugger
    class ChartFetcher

      charts: []

      render: ->
        @raw_charts = @fetchCharts()
        @cleanCharts()
        @getChartsByType()

      #If this is being called post render we need to remove the former chart
      cleanCharts: ->
        for chart in @raw_charts
          jQuery(chart).find('svg').remove()

      getChartsByType: ->
        for chart in @raw_charts
          @charts.push(new Pie(chart)) if jQuery(chart).attr('data-type') == 'pie'

      setScope: (@dom_obj) ->

      fetchCharts: ->
        jQuery(@dom_obj)


    class Chart  #abstract class

      constructor: (@raw) ->
        @palFac = new paletteFactory()
        debugger
        @palette = @palFac.getPalette('earth')
        @type = jQuery(@raw).attr('data-type')
        @source = jQuery(@raw).attr('data-source')
        @fetchData()
        @draw()

      fetchData: ->
        @data = window[@source]

    class Bar extends Chart
    
      processData: ->
        #Logic here

      draw: ->
        #draw logic here

    class Line extends Chart

      processData: ->
        # process Logic

      draw: ->
        # Draw logic    

    class Pie extends Chart

      processData: ->
        processed = []
        if @data.length  # Only arrays, not hashes have length
          for datum in @data
            processed.push({label:'', value: datum})
          return [processed]
        else
          for lab, val of @data
            processed.push({label: lab, value: val})
          return [processed]

      draw: ->

        w = 1000
        h = 1000
        r = 450
        color = @palette
        vis = d3.select(@raw)
          .append("svg:svg")
          .data(@processData())
          .attr("width", w)
          .attr("height", h)
          .append("svg:g")
          .attr("transform", "translate(" + r + "," + r + ")")

        arc = d3.svg.arc()
          .outerRadius(r)

        pie = d3.layout.pie()
          .value((d) ->  d.value)

        arcs = vis.selectAll("g.slice")
          .data(pie)
          .enter()
          .append("svg:g")
          .attr("class", "slice")

        arcs.append("svg:path")
          .attr("fill", (d, i) -> color(i))
          .attr("d", arc)

        arcs.append("svg:text")
          .attr("transform", (d) ->
            d.innerRadius = 0;
            d.outerRadius = r;
            return "translate(" + arc.centroid(d) + ")"
          )
          .attr("text-anchor", "middle")
          .text((d) -> d.data.label)

    class paletteFactory
      palettes: {}
      constructor: ->
        @palettes['basic'] = (i) ->
          colors = ["#bc1c5a", "#096ab1", "#f2cf57", "#199468", "#f7230e", "#5f64c8", "#d8f20d", "#12cfb1", "#ffcd04", "#c56156", "#53548e", "#845194", "#4cb9bc", "#2bb673", "#ff9600", "#c72f48", "#65286b", "#69db45", "#0a8dc1", "#fda819", "#ff88df", "#b5ed2c", "#fcf5a5"]
          colors[i % colors.length]

        @palettes['cool'] = (i) ->
          colors = ["#26499d", "#92b8e9", "#4b6cbb", "#d4f0ff", "#99b8fb", "#a3cfff", "#0b3eb3", "#5b86f7", "#cbdee2", "#9ec5cc", "#697fef", "#2f50c1", "#6db2ff", "#6691ef", "#d5f0ff", "#7db5d0", "#99c0dd",  "#4584c9", "#9dbdfa","#2d6dd7"]
          colors[i % colors.length]

        @palettes['warm'] = (i) ->
          colors = ["#ffae1a","#d0361c","#c52108","#f47202","#dba602","#cd270f","#fcd37b","#ffb314","#d10909","#ffc511","#ec6d20","#e2ab97","#b96632","#d10909","#ea7741","#fc3200","#ffb64c","#790908","#d01a0d","#ffd109"]
          colors[i % colors.length]

        @palettes['earth'] = (i) ->
          colors = ["#fbad25","#8f511e","#55763f","#bd8b68","#bb3e28","#d4801e","#ffc233","#616d01","#e6c236","#c4d032","#325a42","#702f11","#6db2ff","#953d27","#8dab9f","#b8b580","#99c296","#4584c9","#732123","#903837"]
          colors[i % colors.length]

        #d3 standard palettes
        @palettes['category10'] = d3.scale.category10()
        @palettes['category20'] = d3.scale.category20()
        @palettes['category20b'] = d3.scale.category20b()
        @palettes['category20c'] = d3.scale.category20c()

      registerNewPalette: (paletteName ,palette) ->
        @palettes[paletteName] = palette

      getPalette: (palette) ->
        unless palette?
          @palettes['basic']
        else
          @palettes[palette]

    ###
      Load up our data object with all needed code and extend jQuery such that it can be called for each calls.
    ###
    if obj_hash then obj_hash.data = obj_hash else obj_hash = {}
    obj_hash.dropobjects =
      chartfetcher: ChartFetcher
      chart: Chart
      pie: Pie
    $.extend(drop_arg, obj_hash)
    @each  ->
      chartfetcher = new obj_hash.dropobjects.chartfetcher()
      chartfetcher.setScope(@)

      unless drop_arg?
        chartfetcher.render()
      else
        ###
          We have arguments, these may be:
          String -> bind to String event to run the scan
          String, hash -> execute String method and pass hash
        ###
        clean_arg = String(drop_arg) #some bugs come up when this is mixed type
        if obj_hash? #Do we have a hash argument?
          return @ #Need a ChartState object...
        else
          debugger
          @.on(clean_arg, ->
            chartfetcher.render()
          )
          @
