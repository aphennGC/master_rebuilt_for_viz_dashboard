view: user_order_facts {
 view_label: "Users"
  derived_table: {
    sql:
    SELECT
        user_id
        , COUNT(DISTINCT order_id) AS lifetime_orders
        , SUM(sale_price) AS lifetime_revenue
        , CAST(MIN(created_at)  AS TIMESTAMP) AS first_order
        , CAST(MAX(created_at)  AS TIMESTAMP)  AS latest_order
        , COUNT(DISTINCT FORMAT_TIMESTAMP('%Y%m', created_at))  AS number_of_distinct_months_with_orders
        --, FIRST_VALUE(CONCAT(uniform(2, 9, random(1)),uniform(0, 9, random(2)),uniform(0, 9, random(3)),'-',uniform(0, 9, random(4)),uniform(0, 9, random(5)),uniform(0, 9, random(6)),'-',uniform(0, 9, random(7)),uniform(0, 9, random(8)),uniform(0, 9, random(9)),uniform(0, 9, random(10)))) OVER (PARTITION BY user_id ORDER BY user_id) AS phone_number
      FROM 'bigquery-public-data.thelook_ecommerce.order_items'
      GROUP BY user_id
    ;;
    datagroup_trigger: thelook_prod_etl
  }

  dimension: user_id {
    label: "User ID"
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

#   dimension: phone_number {
#     type: string
#     tags: ["phone"]
#     sql: ${TABLE}.phone_number ;;
#   }


  ##### Time and Cohort Fields ######

  dimension_group: first_order {
    label: "First Order"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.first_order ;;
  }
  }
