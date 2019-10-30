########################################################################################################################
#!!
#! @description: Adds the given product with the given color code into the shopping cart of the given user.
#!!#
########################################################################################################################
namespace: AOS.product.purchase.api
flow:
  name: add_product_to_cart
  inputs:
    - url: 'http://rpa.mf-te.com:8080'
    - username: joe.doe
    - password:
        default: Cloud@joe1
        sensitive: true
    - product_id: '29'
    - color_code: '414141'
  workflow:
    - authenticate:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${url+'/accountservice/AccountLoginRequest'}"
            - body: "${'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><AccountLoginRequest xmlns=\"com.advantage.online.store.accountservice\"><email></email><loginUser>%s</loginUser><loginPassword>%s</loginPassword></AccountLoginRequest></soap:Body></soap:Envelope>' % (username, password)}"
            - content_type: text/xml
        publish:
          - soap: '${return_result}'
        navigate:
          - SUCCESS: get_user_id
          - FAILURE: on_failure
    - get_user_id:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${soap}'
            - xpath_query: '//ns2:userId/text()'
        publish:
          - user_id: '${selected_value}'
        navigate:
          - SUCCESS: get_auth_token
          - FAILURE: on_failure
    - get_auth_token:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${soap}'
            - xpath_query: '//ns2:t_authorization/text()'
        publish:
          - token: '${selected_value}'
        navigate:
          - SUCCESS: add_product_to_cart
          - FAILURE: on_failure
    - add_product_to_cart:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${"%s/order/api/v1/carts/%s/product/%s/color/%s" % (url, user_id, product_id, color_code)}'
            - headers: '${"Authorization: Basic "+token}'
        publish:
          - cart_json: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - cart_json: '${cart_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      authenticate:
        x: 50
        'y': 110
      get_user_id:
        x: 41
        'y': 318
      get_auth_token:
        x: 216
        'y': 316
      add_product_to_cart:
        x: 207
        'y': 118
        navigate:
          dff8241b-b3c7-6a56-8b6a-302b9739d415:
            targetId: 40df5564-57e7-adef-47a4-c37d3e030378
            port: SUCCESS
    results:
      SUCCESS:
        40df5564-57e7-adef-47a4-c37d3e030378:
          x: 397
          'y': 125
