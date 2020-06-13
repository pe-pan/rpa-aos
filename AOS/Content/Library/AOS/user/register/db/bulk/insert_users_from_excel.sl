########################################################################################################################
#!!
#! @description: Inserts users from an excel sheet directly to AOS DB. For DB details, refer to aos system properties.
#!!#
########################################################################################################################
namespace: AOS.user.register.db.bulk
flow:
  name: insert_users_from_excel
  inputs:
    - excel_path: "C:\\\\Enablement\\\\HotLabs\\\\AOS\\\\shopping_list.xlsx"
    - sheet: Users
    - login_header: Username
    - password_header: Password
    - name_header: Full Name
    - email_header: Email
  workflow:
    - Get_Cell:
        do:
          io.cloudslang.base.excel.get_cell:
            - excel_file_name: '${excel_path}'
            - worksheet_name: '${sheet}'
            - login_header: '${login_header}'
            - password_header: '${password_header}'
            - email_header: '${email_header}'
            - name_header: '${name_header}'
        publish:
          - data: '${return_result}'
          - header
          - login_index: '${str(header.split(",").index(login_header))}'
          - password_index: '${str(header.split(",").index(password_header))}'
          - email_index: '${str(header.split(",").index(email_header))}'
          - name_index: '${str(header.split(",").index(name_header))}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: insert_user
    - insert_user:
        loop:
          for: 'row in data.split("|")'
          do:
            AOS.user.register.db.insert_user:
              - login_name: '${row.split(",")[int(login_index)]}'
              - password: '${row.split(",")[int(password_index)]}'
              - email: '${row.split(",")[int(email_index)]}'
              - first_name: '${row.split(",")[int(name_index)].split()[0]}'
              - last_name: '${row.split(",")[int(name_index)].split()[-1]}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_Cell:
        x: 91
        'y': 121
      insert_user:
        x: 248
        'y': 117
        navigate:
          52a148d6-6505-ed71-615a-a71ecbb47a8a:
            targetId: ec2a89c7-51c9-ca9a-485c-31be1b90bf2d
            port: SUCCESS
    results:
      SUCCESS:
        ec2a89c7-51c9-ca9a-485c-31be1b90bf2d:
          x: 418
          'y': 128
