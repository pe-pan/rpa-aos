########################################################################################################################
#!!
#! @description: Register users from an excel sheet using AOS UI. For AOS details, refer to aos system properties.
#!!#
########################################################################################################################
namespace: AOS.user.register.ui.bulk
flow:
  name: register_users_from_excel
  inputs:
    - excel_path: "C:\\\\Enablement\\\\HotLabs\\\\AOS\\\\shopping_list.xlsx"
    - sheet: Users
    - login_header: Username
    - password_header: Password
    - name_header: Full Name
    - email_header: Email
  workflow:
    - get_cell:
        do:
          io.cloudslang.base.excel.get_cell:
            - excel_file_name: '${excel_path}'
            - worksheet_name: '${sheet}'
            - login_header: '${login_header}'
            - password_header: '${password_header}'
            - name_header: '${name_header}'
            - email_header: '${email_header}'
        publish:
          - data: '${return_result}'
          - header
          - login_index: '${str(header.split(",").index(login_header))}'
          - password_index: '${str(header.split(",").index(password_header))}'
          - email_index: '${str(header.split(",").index(email_header))}'
          - name_index: '${str(header.split(",").index(name_header))}'
        navigate:
          - SUCCESS: register_user
          - FAILURE: on_failure
    - register_user:
        parallel_loop:
          for: 'row in data.split("|")'
          do:
            AOS.user.register.ui.register_user:
              - url: "${get_sp('aos_url')}"
              - username: '${row.split(",")[int(login_index)]}'
              - password: '${row.split(",")[int(password_index)]}'
              - first_name: '${row.split(",")[int(name_index)].split()[0]}'
              - last_name: '${row.split(",")[int(name_index)].split()[-1]}'
              - email: '${row.split(",")[int(email_index)]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      register_user:
        x: 248
        'y': 117
        navigate:
          4b48769f-9324-4da9-9ea8-9c94057c7b3b:
            targetId: ec2a89c7-51c9-ca9a-485c-31be1b90bf2d
            port: SUCCESS
      get_cell:
        x: 83
        'y': 117
    results:
      SUCCESS:
        ec2a89c7-51c9-ca9a-485c-31be1b90bf2d:
          x: 418
          'y': 128
