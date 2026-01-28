---
- dashboard: looker_community_example
  title: Looker Community Example
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: MOCKjzoNt3h5Bv7NeUv2uz
  layout: newspaper
  elements:
  - title: Looker Community Example
    name: Looker Community Example
    model: periods
    explore: order_items_pop
    type: looker_line
    fields: [order_items_pop.total_sale_price, pop_support.max_created, pop_support.periods_ago,
      pop_support.pop_date_date]
    pivots: [pop_support.periods_ago]
    fill_fields: [pop_support.pop_date_date]
    filters:
      pop_support.period_offset: quarter
      pop_support.pop_date_date: 30 days
    sorts: [pop_support.periods_ago, pop_support.pop_date_date desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: order_items_pop.total_sale_price,
            id: 0 - order_items_pop.total_sale_price, name: 0 - PoP Order Items Total
              Sale Price}, {axisId: order_items_pop.total_sale_price, id: 1 - order_items_pop.total_sale_price,
            name: 1 - PoP Order Items Total Sale Price}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: right, series: [{axisId: pop_support.max_created,
            id: 0 - pop_support.max_created, name: 0 - Pop Support Max Created}, {
            axisId: pop_support.max_created, id: 1 - pop_support.max_created, name: 1
              - Pop Support Max Created}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    series_labels:
      0 - order_items_pop.total_sale_price: Current
      1 - order_items_pop.total_sale_price: Previous
    advanced_vis_config: |
      {
        "series": [
          {
            "name": "Current",
            "color": "orange",
            "lineWidth": 2
          },
          {
            "color": "transparent",
            "states": { "hover": { "enabled": false } },
            "showInLegend": false,
            "enableMouseTracking": false,
            "yAxis": 1
          },
          {
            "name": "Previous",
            "color": "grey",
            "lineWidth": 2,
            "dashStyle": "Dash"
          },
          {
            "color": "transparent",
            "states": { "hover": { "enabled": false } },
            "showInLegend": false,
            "enableMouseTracking": false,
            "yAxis": 1
          }
        ],
        "tooltip": {
          "shared": false,
          "useHTML": true,
          "headerFormat": "<b>{point.key:%Y-%m-%d}</b><br/>",
          "pointFormat": "<span style=\"color:{series.color};\">●</span> {series.name}: <b>{point.y:.1f}</b>"
        },
        "xAxis": [
          {
            "tickLength": 0,
            "labels": {
              "format": "<b><span style=\"color: orange;\">{value:%Y-%m-%d}</span></b>"
            },
            "type": "datetime",
            "title": { "text": "Current Period", "style": { "color": "orange" } }
          },
          {
            "opposite": true,
            "linkedTo": 0,
            "tickLength": 0,
            "type": "datetime",
            "labels": {
               "format": "<b><span style=\"color: grey;\">{value:%Y-%m-%d}</span></b>"
            },
            "title": { "text": "Previous Period (Dates Shifted)", "style": { "color": "grey" } }
          }
        ],
        "yAxis": [
          { "title": { "text": "Measure Value" } },
          { "visible": false }
        ]
      }
    hidden_pivots: {}
    defaults_version: 1
    listen:
      Period Offset: pop_support.period_offset
      Pop Date Date: pop_support.pop_date_date
    row: 1
    col: 0
    width: 24
    height: 12
  - type: button
    name: button_450
    rich_content_json: '{"text":"Community Article on PoP","description":"Here you
      can find instructions on how to build this","newTab":true,"alignment":"center","size":"medium","style":"FILLED","color":"#079c98","href":"https://discuss.google.dev/t/looker-period-over-period-analysis-a-flexible-approach/187422"}'
    row: 0
    col: 0
    width: 3
    height: 1
  filters:
  - name: Period Offset
    title: Period Offset
    type: field_filter
    default_value: quarter
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: periods
    explore: order_items_pop
    listens_to_filters: []
    field: pop_support.period_offset
  - name: Pop Date Date
    title: Pop Date Date
    type: field_filter
    default_value: 30 days
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: periods
    explore: order_items_pop
    listens_to_filters: []
    field: pop_support.pop_date_date
