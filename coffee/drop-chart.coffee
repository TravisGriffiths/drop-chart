$ = jQuery
###
Drop Chart is a plug-in intended to allow for sinple d3 charts to easily be put into any html system.


###

jQuery.fn.extend

  dropchart: (options, obj_hash) ->

    unless options?
      jQuery(document).ready ->
        new ChartFetcher()
    else
      ###
        We have options, these may be:
        true -> run immediately, don't wait for document ready
        false -> don't run, just return this
        String -> bind to String event to run the scan
        String, hash -> execute String method and pass hash
      ###
      if options == true
        -> new ChatFetcher()
      return @ if options == false
      if obj_hash? #Do we have a hash argument?
        return @ #Need a ChartState object...
      else
        @.on(options
          new ChartFetcher()
        )

    class ChartFetcher

      charts: []

      constructor: ->
        @raw_charts = @fetchCharts()
        @getChartsByType()

      getChartsByType: ->
        for chart in @raw_charts
          @charts.push(new Pie(chart)) if jQuery(chart).attr('data-type') == 'pie'

      fetchCharts: ->
        jQuery(".drop-chart")


    class Chart

      constructor: (@raw) ->
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
        color = d3.scale.category20c()
        ###
        data = [{"label":"one", "value":20},
        {"label":"two", "value":50},
        {"label":"three", "value":30}]
        ###
        vis = d3.select("div.drop-chart")
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
