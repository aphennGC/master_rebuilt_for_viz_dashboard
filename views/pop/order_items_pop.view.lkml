view: order_items_pop {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.order_items` ;;
  view_label: "PoP Order Items"
  ########## IDs, Foreign Keys, Counts ###########

  dimension: id {
    label: "ID"
    description: "Unique identifier for each order item (5 digits)"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    value_format: "00000"
  }

  dimension: inventory_item_id {
    label: "Inventory Item ID"
    description: "Identifier for the associated inventory item (hidden)"
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: user_id {
    label: "User Id"
    description: "Identifier for the associated user (hidden)"
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    label: "Count"
    description: "Number of order items"
    type: count
    drill_fields: [detail*]
  }

  measure: count_last_28d {
    label: "Count Sold in Trailing 28 Days"
    description: "Number of items sold in the last 28 days"
    type: count_distinct
    sql: ${id} ;;
    hidden: yes
    filters:
    {field:created_date
      value: "28 days"
    }}

  measure: order_count {
    view_label: "Orders"
    description: "Number of orders"
    type: count_distinct
    drill_fields: [detail*]
    sql: ${order_id};;
  }

  dimension: order_id_no_actions {
    label: "Order ID No Actions"
    description: "Order number (without actions)"
    type: number
    hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_id {
    label: "Order ID"
    description: "Order number associated with the item"
    type: number
    sql: ${TABLE}.order_id ;;
    value_format: "00000"
  }

  ########## Time Dimensions ##########

  dimension_group: returned {
    description: "Date and time the item was returned"
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.returned_at ;;

  }

  dimension_group: shipped {
    description: "Date and time the item was shipped"
    type: time
    timeframes: [date, week, month, raw]
    sql: CAST(${TABLE}.shipped_at AS TIMESTAMP) ;;

  }

  dimension_group: delivered {
    description: "Date and time the item was delivered"
    type: time
    timeframes: [date, week, month, raw]
    sql: CAST(${TABLE}.delivered_at AS TIMESTAMP) ;;

  }

  dimension_group: created {
    description: "Date and time the item was added to the order"
    type: time
    timeframes: [time, hour, date, week, month, year, hour_of_day, day_of_week, day_of_month, month_num, raw, week_of_year,month_name]
    sql: ${TABLE}.created_at ;;
  }

  dimension: reporting_period_ytd_vs_lytd {
    description: "PoP Reporting Field for comparisons"
    group_label: "Order Date"
    sql: CASE
        WHEN EXTRACT(YEAR from ${created_raw}) = EXTRACT(YEAR from CURRENT_TIMESTAMP())
        AND ${created_raw} < CURRENT_TIMESTAMP()
        THEN 'This Year to Date'

      WHEN EXTRACT(YEAR from ${created_raw}) + 1 = EXTRACT(YEAR from CURRENT_TIMESTAMP())
      AND CAST(FORMAT_TIMESTAMP('%j', ${created_raw}) AS INT64) <= CAST(FORMAT_TIMESTAMP('%j', CURRENT_TIMESTAMP()) AS INT64)
      THEN 'Last Year to Date'

      END
      ;;
  }

  dimension: days_since_sold {
    description: "Days since the order item was sold"
    label: "Days Since Sold"
    hidden: yes
    sql: TIMESTAMP_DIFF(${created_raw},CURRENT_TIMESTAMP(), DAY) ;;
  }

########## Logistics ##########

  dimension: status {
    label: "Status"
    description: "Current status of the order item (Processing, Shipped, etc.)"
    sql: ${TABLE}.status ;;
  }

  dimension: days_to_process {
    label: "Days to Process"
    description: "Days to Process the order"
    type: number
    sql: CASE
        WHEN ${status} = 'Processing' THEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), ${created_raw}, DAY)*1.0
        WHEN ${status} IN ('Shipped', 'Complete', 'Returned') THEN TIMESTAMP_DIFF(${shipped_raw}, ${created_raw}, DAY)*1.0
        WHEN ${status} = 'Cancelled' THEN NULL
      END
       ;;
  }


  dimension: shipping_time {
    label: "Shipping Time"
    description: "Number of days between the delivery date and shipping date"
    type: number
    sql: TIMESTAMP_DIFF(${delivered_raw}, ${shipped_raw}, DAY)*1.0 ;;
  }


  measure: average_days_to_process {
    label: "Average Days to Process"
    description: "Average time it takes to process an order"
    type: average
    value_format_name: decimal_2
    sql: ${days_to_process} ;;
  }

  measure: average_shipping_time {
    label: "Average Shipping Time"
    description: "Average delivery time after shipping"
    type: average
    value_format_name: decimal_2
    sql: ${shipping_time} ;;
  }

########## Financial Information ##########

  dimension: sale_price {
    label: "Sale Price"
    description: "Price the item was sold for"
    type: number
    value_format_name: usd
    sql: ${TABLE}.sale_price;;
  }

  measure: total_sale_price {
    label: "Total Sale Price"
    description: "Total revenue from order items"
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: average_sale_price {
    label: "Average Sale Price"
    description: "Average price of an order item"
    type: average
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: median_sale_price {
    label: "Median Sale Price"
    description: "Median price of an order item"
    type: median
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }
########## POP LOGIC ##########
    parameter: period_offset {
      type: unquoted
      allowed_value: {value:"year"    label:"year"}
      allowed_value: {value:"week"    label:"week"}
      allowed_value: {value:"month"   label:"month"}
      allowed_value: {value:"quarter" label:"quarter"}
      default_value: "month" # Good to have a default
    }

    dimension_group: pop_date {
      type: time
      timeframes: [date,month,year]
      sql: timestamp(date_add(date(${created_raw}), interval ${pop_support.periods_ago} {% parameter period_offset %}));;
      description: "The date adjusted by the 'Periods Ago' offset. Use for PoP charts."
    }

    measure: max_created_in_period {
      type: date
      sql: max(timestamp_trunc(${created_raw}, {% if pop_date_month._is_selected %}MONTH{% elsif pop_date_year._is_selected %}YEAR{% else %}DAY{% endif %}));;
      description: "Max original creation date within the selected PoP period."
    }

########## Sets ##########

  set: detail {
    fields: [order_id, status, created_date, sale_price]
  }
  set: return_detail {
    fields: [id, order_id, status, created_date, returned_date, sale_price]
  }
}
