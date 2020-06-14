########################################################################################################################
#!!
#! @description: Register a user using AOS UI. For AOS details, refer to aos system properties.
#!!#
########################################################################################################################
namespace: AOS.user.register.ui
flow:
  name: register_user
  inputs:
    - url: 'http://rpa.mf-te.com:8080'
    - username: daniel
    - password: Cloud@dan1
    - first_name: Daniel
    - last_name: Crisan
    - email: d.c@mf.com
  workflow:
    - register_user_act:
        loop:
          for: retry in range(4)
          do:
            AOS.user.register.ui.register_user_act:
              - url: '${url}'
              - username: '${username}'
              - password: '${password}'
              - first_name: '${first_name}'
              - last_name: '${last_name}'
              - email: '${email}'
          break:
            - SUCCESS
            - WARNING
          publish:
            - return_result
            - error_message
            - created_user_name
        navigate:
          - SUCCESS: string_equals
          - WARNING: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${created_user_name}'
            - second_string: '${username}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - created_user_name: '${created_user_name}'
    - return_result
    - error_message
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      register_user_act:
        x: 100
        'y': 150
      string_equals:
        x: 272
        'y': 308
        navigate:
          8a7640c8-6ed4-8d96-0123-a1a7e35e4cc6:
            targetId: 2a4d992d-9cc9-311d-5e19-f8c7bc8c710b
            port: SUCCESS
    results:
      SUCCESS:
        2a4d992d-9cc9-311d-5e19-f8c7bc8c710b:
          x: 400
          'y': 150

