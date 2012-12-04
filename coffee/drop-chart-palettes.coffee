define ['d3'], (d3)->
  fetchModule: () ->

    class paletteFactory
      palettes: {}
      constructor: ->
        @palettes['general'] = (i) ->
          colors = [
            "#ea4f4f",
            "#3e499f",
            "#cece29",
            "#106735",
            "#d16a28",
            "#6f2a82",
            "#c56156",
            "#53548e",
            "#d8d65a",
            "#2bb673",
            "#d88349",
            "#845194",
            "#ea7db0",
            "#747dbc",
            "#e0de84",
            "#8ecea5",
            "#e8b087",
            "#766692",
            "#df9ac4",
            "#bec2e2",
            "#f7f385",
            "#d7ecdd",
            "#f6dcc6",
            "#b59bc2"
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