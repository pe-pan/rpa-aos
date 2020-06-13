########################################################################################################################
#!!
#! @description: Removes users from an excel sheet directly from AOS DB.  For AOS DB details, refer to aos system properties.
#!!#
########################################################################################################################
namespace: AOS.user.remove.db.bulk
flow:
  name: remove_users_from_excel
  inputs:
    - excel_path: "C:\\\\Enablement\\\\HotLabs\\\\AOS\\\\shopping_list.xlsx"
    - sheet: Users
    - login_header: Username
  workflow:
    - get_cell:
        do:
          io.cloudslang.base.excel.get_cell:
            - excel_file_name: '${excel_path}'
            - worksheet_name: '${sheet}'
            - login_header: '${login_header}'
        publish:
          - data: '${return_result}'
          - header
          - login_name_list: '${str(tuple(str(row.split(",")[header.split(",").index(login_header)]) for row in data.split("|")))}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: remove_users
    - remove_users:
        do:
          AOS.user.remove.db.bulk.remove_users:
            - login_name_list: '${login_name_list}'
        publish:
          - deleted_users
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - deleted_users: '${deleted_users}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_cell:
        x: 64
        'y': 123
      remove_users:
        x: 245
        'y': 120
        navigate:
          8e46f956-0902-c36c-5760-de05f8622a14:
            targetId: ec2a89c7-51c9-ca9a-485c-31be1b90bf2d
            port: SUCCESS
    results:
      SUCCESS:
        ec2a89c7-51c9-ca9a-485c-31be1b90bf2d:
          x: 440
          'y': 125
