namespace: AOS.contact_form.ui
flow:
  name: send_question
  inputs:
    - url: 'http://rpa.mf-te.com:8080'
    - catalog: Mice
    - item: HP Z3600 Wireless Mouse
    - email: joe.doe@mf.com
    - subject: Simple Question
  workflow:
    - send_question_act:
        do:
          AOS.contact_form.ui.send_question_act:
            - url: '${url}'
            - catalog: '${catalog}'
            - item: '${item}'
            - email: '${email}'
            - subject: '${subject}'
        publish:
          - contact_status
          - return_result
          - error_message
        navigate:
          - SUCCESS: string_equals
          - WARNING: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${contact_status}'
            - second_string: Thank you for contacting Advantage support.
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - contact_status: '${contact_status}'
    - return_result: '${return_result}'
    - error_message: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      send_question_act:
        x: 90
        'y': 94
      string_equals:
        x: 203
        'y': 240
        navigate:
          575786da-89f6-b45d-c3e4-3561ac643d33:
            targetId: 20e7977f-0999-b5bf-e3f2-a98a61130659
            port: SUCCESS
    results:
      SUCCESS:
        20e7977f-0999-b5bf-e3f2-a98a61130659:
          x: 302
          'y': 80
