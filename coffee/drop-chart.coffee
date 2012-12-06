$ = jQuery
###
Drop Chart is a plug-in intended to allow for sinple d3 charts to easily be put into any html system.


###

$.extend $.fn,

  dropchart: (drop_arg, obj_hash) ->

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
        @palette = @palFac.getPalette('general')
        @type = jQuery(@raw).attr('data-type')
        @source = jQuery(@raw).attr('data-source')
        @fetchData()
        @draw()

      fetchData: ->
        @data = window[@source]

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

        w = 600
        h = 600
        r = 200
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
        @palettes['general'] = (i) ->
          colors = ["#bc1c5a", "#096ab1", "#f2cf57", "#199468", "#f7230e", "#5f64c8", "#d8f20d", "#12cfb1", "#ffcd04", "#c56156", "#53548e", "#845194", "#4cb9bc", "#2bb673", "#ff9600", "#c72f48", "#65286b", "#69db45", "#0a8dc1", "#fda819", "#ff88df", "#b5ed2c", "#fcf5a5"]
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
          true -> run immediately, don't wait for document ready
          false -> don't run, just return this
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