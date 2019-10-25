namespace: AOS.product.purchase.ui
operation:
  name: buy_item_act
  inputs:
  - host: rpa.mf-te.com
  - user: joe.doe
  - password: Cloud@joe1
  - catalog: TABLETS
  - item: HP ELITE X2 1011 G1 TABLET
  outputs:
  - total_price:
      robot: true
      value: ${total_price}
  - return_result: ${return_result}
  - error_message: ${error_message}
  sequential_action:
    gav: com.microfocus.seq:AOS.buy_item:1.0.0
    external: true
  results:
  - SUCCESS
  - WARNING
  - FAILURE
