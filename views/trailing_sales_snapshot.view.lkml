view: trailing_sales_snapshot {
 derived_table: {
  datagroup_trigger: thelook_prod_etl
  sql: with calendar as
      (select distinct created_at as snapshot_date
      from 'bigquery-public-data.thelook_ecommerce.inventory_items'
      )

    select
    inventory_items.product_id
    ,date(order_items.created_at) as snapshot_date
    ,count(*) as trailing_28d_sales
    from 'bigquery-public-data.thelook_ecommerce.order_items'
    join 'bigquery-public-data.thelook_ecommerce.inventory_items'
    on order_items.inventory_item_id = inventory_items.id
    join calendar
    on date(order_items.created_at) <= date(date_add(calendar.snapshot_date, interval 28 day))
    and date(order_items.created_at) >= date(calendar.snapshot_date)
    group by 1,2
    ;;
}

dimension: product_id {
  label: "Product ID"
  type: number
  sql: ${TABLE}.product_id ;;
}

dimension: snapshot_date {
  label: "Snapshot Date"
  type: date
  sql: cast(${TABLE}.snapshot_date as timestamp) ;;
}

dimension: trailing_28d_sales {
  label: "Sales Trailing 28 days"
  type: number
  hidden: yes
  sql: ${TABLE}.trailing_28d_sales ;;
}

measure: sum_trailing_28d_sales {
  label: "Sum of Sales Trailing 28 Days"
  type: sum
  sql: ${trailing_28d_sales} ;;
}

measure: sum_trailing_28d_sales_yesterday {
  label: "Sum of Sales Trailing 28 days - Yesterday"
  type: sum
  hidden: yes
  sql: ${trailing_28d_sales} ;;
  filters: {
    field: snapshot_date
    value: "yesterday"
  }
}

measure: sum_trailing_28d_sales_last_wk {
  label: "Sum of Sales Trailing 28 days - Last Week"
  type: sum
  hidden: yes
  sql: ${trailing_28d_sales} ;;
  filters: {
    field: snapshot_date
    value: "8 days ago for 1 day"
  }
}

set: detail {
  fields: [product_id, snapshot_date, trailing_28d_sales]
}
}
