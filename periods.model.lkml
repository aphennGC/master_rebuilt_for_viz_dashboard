connection: "mock_trial_thelook"

include: "/views/**/*.view.lkml"

explore: order_items_pop{
  label: "Period Over Period"
  sql_always_where: ${order_items_pop.created_raw} <= CURRENT_TIMESTAMP() ;; #Prevent future dates created by the PoP logic from appearing
  join: pop_support {
    type: cross
    relationship: one_to_many
  }
  #consider a sql_always_where to exclude 'future' data that manifests as a result of POP logic
}
