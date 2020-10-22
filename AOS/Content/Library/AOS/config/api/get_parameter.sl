########################################################################################################################
#!!
#! @description: Retrieves details of a configuration parameter. Possible values are Add_to_cart_time_delay, SLA_add_delay_time, SLA_add_delay_sessions, Generate_memory_leak, Max_concurrent_users, Postgres_Locks, etc.
#!
#! @input parameter_name: The parameter to retrieve its details
#!
#! @output parameter_json: JSON document describing the parameter details
#!!#
########################################################################################################################
namespace: AOS.config.api
flow:
  name: get_parameter
  inputs:
    - parameter_name
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'%s/catalog/api/v1/DemoAppConfig/parameters/%s' % (get_sp('aos_url'), parameter_name)}"
            - proxy_host: "${get_sp('aos_proxy_host')}"
            - proxy_port: "${get_sp('aos_proxy_port')}"
        publish:
          - parameter_json: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - parameter_json: '${parameter_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_get:
        x: 109
        'y': 82
        navigate:
          e560a75a-152d-af16-a0d6-63045b009cde:
            targetId: caa32b45-0b52-a5f9-6e54-c4c35e5a9277
            port: SUCCESS
    results:
      SUCCESS:
        caa32b45-0b52-a5f9-6e54-c4c35e5a9277:
          x: 284
          'y': 81
