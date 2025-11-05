view: pop_support {
 # we will fan out the data to get extra copies, and we'll offset dates for POP.
    derived_table: {
      #could do fancier logic here to allow additional periods, for example
      sql:
          select 0 as periods_ago union all
          select 1 as periods_ago
          ;;
    }
#MUST PIVOT ON THIS FIELD!!!!
    dimension: periods_ago {
      type:  number
      description:  "Must Pivot on this Field"
    }
}
