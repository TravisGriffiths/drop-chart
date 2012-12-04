define ['d3'], (d3)->
  fetchModule: () ->

    class paletteFactory
      palettes: {}
      constructor: ->
        @palettes['general'] = (i) ->
          colors = [
            #ea7db0,
            #df9ac4,
            #ea4f4f,
            #c56156,
            #53548e,
            #747dbc,
            #bec2e2,
            #3e499f,
            #747dbc,
            #bec2e2,
            #3e499f,
            #53548e,
            #8ecea5,
            #106735,
            #2bb673,
            #d7ecdd,
            #f6dcc6,
            #e8b087,
            #d16a28,
            #d88349,
            #766692,
            #845194,
            #6f2a82,
            #b59bc2
          ]
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


      window.paletteFactory = new paletteFactory