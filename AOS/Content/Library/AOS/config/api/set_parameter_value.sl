########################################################################################################################
#!!
#! @description: Sets value of a given parameter. Retrieves details of a configuration parameter. Possible values are Add_to_cart_time_delay, SLA_add_delay_time, SLA_add_delay_sessions, Generate_memory_leak, Max_concurrent_users, Postgres_Locks, etc.
#!
#! @input parameter_name: Which parameter to set
#! @input parameter_value: What will be the new value of the parameter
#!
#! @output result_json: JSON document describing the result of the operation
#!!#
########################################################################################################################
namespace: AOS.config.api
flow:
  name: set_parameter_value
  inputs:
    - parameter_name
    - parameter_value
  workflow:
    - http_client_put:
        do:
          io.cloudslang.base.http.http_client_put:
            - url: "${'%s/catalog/api/v1/DemoAppConfig/update/parameter/%s/value/%s' % (get_sp('aos_url'), parameter_name, parameter_value)}"
            - proxy_host: "${get_sp('aos_proxy_host')}"
            - proxy_port: "${get_sp('aos_proxy_port')}"
        publish:
          - result_json: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - result_json: '${result_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_put:
        x: 76
        'y': 103
        navigate:
          b0f7e8bd-5209-2e79-0096-1e825d03de81:
            targetId: 6f9f2283-e99a-eb2d-5af2-587762187491
            port: SUCCESS
    results:
      SUCCESS:
        6f9f2283-e99a-eb2d-5af2-587762187491:
          x: 248
          'y': 103
