(json) <- d3.json \result.json, _
xrange = d3.extent(json.map -> it.3.length)
yrange = d3.extent(json.map(-> d3.extent(it.3.map(->it.1))).reduce(((a,b) -> a ++ b),[]))
link = d3.select \#link
data = json.map -> [it.0, it.1, it.2, it.3.map(->it.1)]
xscale = d3.scale.linear!
  .domain xrange
  .range [10,1190]
yscale = d3.scale.linear!
  .domain yrange
  .range [1190,10]
lineBuilder = d3.svg.line!
  .x (d,i) -> i
  .y (d,i) -> yscale(d)

d3.select(\#svg).selectAll(\path).data(data).enter!append \path
  .attr do
    d: -> lineBuilder it.3
    stroke: \#999
    "stroke-width": 1.5
    fill: \none
  .on \mousemove, ->
    link.attr do
      href: "http://www.ptt.cc/bbs/Gossiping/#{it.0}.html"
    .text ("#{it.1}: #{it.2}")
    d3.select(@).attr do
      stroke: \#f00
      "stroke-width": 2
  .on \mouseout, ->
    d3.select(@).attr do
      stroke: \#999
      "stroke-width": 1

