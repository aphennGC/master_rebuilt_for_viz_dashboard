view: pop_support {
  derived_table: {
    sql:
    select 0 as periods_ago union all
    select 1 as periods_ago
    ;;
  }

  dimension: periods_ago {
    type:  number
    description:  "MUST PIVOT ON THIS FIELD!!!!"
  }

  parameter: period_offset {
    type: unquoted
    allowed_value: {value:"year"    label:"Year"}
    allowed_value: {value:"quarter" label:"Quarter"}
    allowed_value: {value:"month"   label:"Month"}
    allowed_value: {value:"week"    label:"Week"}
    allowed_value: {value:"day"     label:"Day"}
  }

  dimension_group: pop_date {
    type: time
    timeframes: [date, week, month, quarter, year]
    # This shifts the dates of the "periods_ago = 1" rows forward
    sql: timestamp(date_add(date(${order_items_pop.created_raw}), interval ${periods_ago} {% parameter period_offset %}));;
  }

  measure: max_created {
    type: date
    sql: max(${order_items_pop.created_raw});;
  }
}
