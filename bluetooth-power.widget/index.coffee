options =
  # Enable or disable the widget.
  widgetEnable : true                   # true | false

  # Choose where the widget should sit on your screen.
  verticalPosition    : "10px"
  horizontalPosition    : "670px"

command: """
2>/dev/null system_profiler SPBluetoothDataType | grep -E "Battery|Services" | sed "s/Services://g" | sed "s/Battery Level://g" | sed "s/Apple Wireless//g" | sed -e 's/^[ \t]*//' | paste -d" " - -
"""
refreshFrequency: '30s'
style: """

// setup
// --------------------------------------------------
display: none
font-family system, -apple-system, "Helvetica Neue"
font-size: 10px
margin = 10px
position: absolute
top: #{options.verticalPosition}
left: #{options.horizontalPosition}

// variables
// --------------------------------------------------
widgetWidth 300px
borderRadius 6px
infoWidth @widgetWidth

// styles
// --------------------------------------------------
.container
    width: @widgetWidth
    height: @infoHeight
    text-align: left
    position: relative
    clear: both
    color #fff
    background rgba(#000, .5)
    padding 10px
    border-radius @borderRadius

.title
    text-align: widget-align
    font-size: 10px
    text-transform: uppercase
    font-weight: bold
    margin-bottom: 1px

.stat-container
    width: @infoWidth
    margin-bottom: 5px

.stat
    font-size: 14px
    font-weight: 300
    text-transform: uppercase

.percent
    float: right

.bar-container
    width: 100%
    height: @borderRadius
    border-radius: @borderRadius
    background: rgba(#ccc, .5)

.bar
    height: @borderRadius
    border-radius: @borderRadius
    transition: width .2s ease-in-out

.bar-remaining
    background: rgba(#df5077, 1)

"""

options : options

render: -> """
<div class="container">
    <div class="title">Bluetooth Power</div>
</div>
"""

renderItem: (name, pctg) -> """
<div class="item">
    <div class="stat-container">
        <div class="stat">#{name} <span class="percent">&nbsp;#{pctg}</span></div>
    </div>
    <div class="bar-container">
      <div class="bar bar-remaining" style="width: #{pctg}"></div>
    </div>
</div>
"""

renderData: (data) -> """
    <div>#{data}</div>
"""

update: (output, domEl) ->
  div = $(domEl)
  devices = output.split('\n')
  patt = /(.*?)(\d{1,3}%)/

  for item in div.find(".item")
      item.remove()

  renderItem = @renderItem

  for device, i in devices when device.match patt
    do (device) ->
      [match, name, pct] = device.match patt

      if device.match patt
          div.show(1).animate({opacity: 1}, 250, 'swing')
      else
          div.animate({opacity: 0}, 250, 'swing').hide(1)

      div.find(".container").append renderItem(name, pct)
