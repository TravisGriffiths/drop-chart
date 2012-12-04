// Generated by CoffeeScript 1.3.3
(function() {
  var $,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $ = jQuery;

  /*
  Drop Chart is a plug-in intended to allow for sinple d3 charts to easily be put into any html system.
  */


  $.extend($.fn, {
    dropchart: function(drop_arg, obj_hash) {
      var Chart, ChartFetcher, Pie, chartfetcher, clean_arg, paletteFactory;
      ChartFetcher = (function() {

        function ChartFetcher() {}

        ChartFetcher.prototype.charts = [];

        ChartFetcher.prototype.render = function() {
          this.raw_charts = this.fetchCharts();
          this.cleanCharts();
          return this.getChartsByType();
        };

        ChartFetcher.prototype.cleanCharts = function() {
          var chart, _i, _len, _ref, _results;
          _ref = this.raw_charts;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            chart = _ref[_i];
            _results.push(jQuery(chart).find('svg').remove());
          }
          return _results;
        };

        ChartFetcher.prototype.getChartsByType = function() {
          var chart, _i, _len, _ref, _results;
          _ref = this.raw_charts;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            chart = _ref[_i];
            if (jQuery(chart).attr('data-type') === 'pie') {
              _results.push(this.charts.push(new Pie(chart)));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        };

        ChartFetcher.prototype.fetchCharts = function() {
          return jQuery(".drop-chart");
        };

        return ChartFetcher;

      })();
      Chart = (function() {

        function Chart(raw) {
          this.raw = raw;
          this.palFac = new paletteFactory();
          this.palette = this.palFac.getPalette('general');
          this.type = jQuery(this.raw).attr('data-type');
          this.source = jQuery(this.raw).attr('data-source');
          this.fetchData();
          this.draw();
        }

        Chart.prototype.fetchData = function() {
          return this.data = window[this.source];
        };

        return Chart;

      })();
      Pie = (function(_super) {

        __extends(Pie, _super);

        function Pie() {
          return Pie.__super__.constructor.apply(this, arguments);
        }

        Pie.prototype.processData = function() {
          var datum, lab, processed, val, _i, _len, _ref, _ref1;
          processed = [];
          if (this.data.length) {
            _ref = this.data;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              datum = _ref[_i];
              processed.push({
                label: '',
                value: datum
              });
            }
            return [processed];
          } else {
            _ref1 = this.data;
            for (lab in _ref1) {
              val = _ref1[lab];
              processed.push({
                label: lab,
                value: val
              });
            }
            return [processed];
          }
        };

        Pie.prototype.draw = function() {
          var arc, arcs, color, h, pie, r, vis, w;
          w = 600;
          h = 600;
          r = 200;
          color = this.palette;
          vis = d3.select("div.drop-chart").append("svg:svg").data(this.processData()).attr("width", w).attr("height", h).append("svg:g").attr("transform", "translate(" + r + "," + r + ")");
          arc = d3.svg.arc().outerRadius(r);
          pie = d3.layout.pie().value(function(d) {
            return d.value;
          });
          arcs = vis.selectAll("g.slice").data(pie).enter().append("svg:g").attr("class", "slice");
          arcs.append("svg:path").attr("fill", function(d, i) {
            return color(i);
          }).attr("d", arc);
          return arcs.append("svg:text").attr("transform", function(d) {
            d.innerRadius = 0;
            d.outerRadius = r;
            return "translate(" + arc.centroid(d) + ")";
          }).attr("text-anchor", "middle").text(function(d) {
            return d.data.label;
          });
        };

        return Pie;

      })(Chart);
      paletteFactory = (function() {

        paletteFactory.prototype.palettes = {};

        function paletteFactory() {
          this.palettes['general'] = function(i) {
            var colors;
            colors = ["#bc1c5a", "#096ab1", "#f2cf57", "#199468", "#f7230e", "#5f64c8", "#ffcd04", "#d8f20d", "#12cfb1", "#5f64c8", "#4cb9bc", "#c56156", "#53548e", "#d8d65a", "#845194", "#2bb673", "#d88349", "#ea7db0", "#747dbc", "#e0de84", "#766692", "#8ecea5", "#e8b087", "#df9ac4", "#bec2e2", "#f7f385", "#b59bc2", "#d7ecdd", "#f6dcc6"];
            return colors[i % colors.length];
          };
          this.palettes['category10'] = d3.scale.category10();
          this.palettes['category20'] = d3.scale.category20();
          this.palettes['category20b'] = d3.scale.category20b();
          this.palettes['category20c'] = d3.scale.category20c();
        }

        paletteFactory.prototype.registerNewPalette = function(paletteName, palette) {
          return this.palettes[paletteName] = palette;
        };

        paletteFactory.prototype.getPalette = function(palette) {
          if (palette == null) {
            return this.palettes['basic'];
          } else {
            return this.palettes[palette];
          }
        };

        return paletteFactory;

      })();
      chartfetcher = new ChartFetcher();
      if (drop_arg == null) {
        return jQuery(document).ready(function() {
          return chartfetcher.render();
        });
      } else {
        /*
                We have arguments, these may be:
                true -> run immediately, don't wait for document ready
                false -> don't run, just return this
                String -> bind to String event to run the scan
                String, hash -> execute String method and pass hash
        */

        clean_arg = String(drop_arg);
        if (clean_arg === 'true') {
          chartfetcher.render();
          return this;
        }
        if (clean_arg === 'false') {
          return this;
        }
        if (obj_hash != null) {
          return this;
        } else {
          this.on(clean_arg, function() {
            return chartfetcher.render();
          });
          return this;
        }
      }
    }
  });

}).call(this);
