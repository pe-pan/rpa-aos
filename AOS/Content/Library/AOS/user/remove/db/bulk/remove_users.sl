########################################################################################################################
#!!
#! @input login_name_list: Each item in the list must be enclosed in quotes
#!!#
########################################################################################################################
namespace: AOS.user.remove.db.bulk
flow:
  name: remove_users
  inputs:
    - login_name_list: "('daniel','michael')"
  workflow:
    - is_enclosed_with_brackets:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(login_name_list.startswith('(') and login_name_list.endswith(')'))}"
        publish: []
        navigate:
          - 'TRUE': delete_shippingaddress
          - 'FALSE': enclose_with_brackets
    - delete_shippingaddress:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: "${get_sp('db_host')}"
            - db_type: PostgreSQL
            - username: "${get_sp('db_user')}"
            - password:
                value: "${get_sp('db_password')}"
                sensitive: true
            - database_name: adv_account
            - command: "${'DELETE FROM shippingaddress WHERE user_id IN (SELECT user_id FROM account where login_name IN '+login_name_list+');'}"
            - trust_all_roots: 'true'
        publish:
          - update_count
        navigate:
          - SUCCESS: delete_account
          - FAILURE: on_failure
    - delete_account:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: "${get_sp('db_host')}"
            - db_type: PostgreSQL
            - username: "${get_sp('db_user')}"
            - password:
                value: "${get_sp('db_password')}"
                sensitive: true
            - database_name: adv_account
            - command: "${'DELETE FROM account WHERE login_name IN '+login_name_list+';'}"
            - trust_all_roots: 'true'
        publish:
          - update_count
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - enclose_with_brackets:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '0'
            - login_name_list: '${login_name_list}'
        publish:
          - login_name_list: "${'('+login_name_list+')'}"
        navigate:
          - SUCCESS: delete_shippingaddress
          - FAILURE: on_failure
  outputs:
    - deleted_users: '${update_count}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      delete_shippingaddress:
        x: 275
        'y': 120
      delete_account:
        x: 411
        'y': 118
        navigate:
          28b5b68e-6b25-9d2a-ac86-91e7e39c5145:
            targetId: ec2a89c7-51c9-ca9a-485c-31be1b90bf2d
            port: SUCCESS
      enclose_with_brackets:
        x: 146
        'y': 300
      is_enclosed_with_brackets:
        x: 95
        'y': 104
    results:
      SUCCESS:
        ec2a89c7-51c9-ca9a-485c-31be1b90bf2d:
          x: 538
          'y': 123
