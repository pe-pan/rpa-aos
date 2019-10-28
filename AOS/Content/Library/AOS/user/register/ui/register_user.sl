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
        do:
          AOS.user.register.ui.register_user_act:
            - url: '${url}'
            - username: '${username}'
            - password: '${password}'
            - first_name: '${first_name}'
            - last_name: '${last_name}'
            - email: '${email}'
        publish:
          - return_result
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - WARNING: SUCCESS
          - FAILURE: on_failure
  outputs:
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
        navigate:
          daf2c825-6d82-2594-0461-be664688f559:
            targetId: 2a4d992d-9cc9-311d-5e19-f8c7bc8c710b
            port: SUCCESS
          9a9525d3-e7f1-5f0e-8630-32e992e2356e:
            targetId: 2a4d992d-9cc9-311d-5e19-f8c7bc8c710b
            port: WARNING
    results:
      SUCCESS:
        2a4d992d-9cc9-311d-5e19-f8c7bc8c710b:
          x: 400
          'y': 150
