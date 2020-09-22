########################################################################################################################
#!!
#! @description: Removes given users directly from AOS DB.  For AOS DB details, refer to aos system properties.
#!
#! @input login_name_list: Items must not be enclosed in quotes
#!!#
########################################################################################################################
namespace: AOS.user.remove.db.bulk
flow:
  name: remove_users
  inputs:
    - login_name_list: 'daniel, michael, mok.pui, marc.bernis, joe.doe'
  workflow:
    - format_input:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '0'
            - login_name_list: '${login_name_list.strip()}'
        publish:
          - login_name_list_no_brackets: "${login_name_list[1:-1] if login_name_list.startswith('(') and login_name_list.endswith(')') else login_name_list}"
          - login_name_list_quoted: "${str(tuple([x.strip('\\t\\'\\\" ') for x in login_name_list_no_brackets.split(\",\")]))}"
        navigate:
          - SUCCESS: delete_shippingaddress
          - FAILURE: on_failure
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
            - command: "${'DELETE FROM shippingaddress WHERE user_id IN (SELECT user_id FROM account where login_name IN '+login_name_list_quoted+');'}"
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
            - command: "${'DELETE FROM account WHERE login_name IN '+login_name_list_quoted+';'}"
            - trust_all_roots: 'true'
        publish:
          - update_count
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - deleted_users: '${update_count}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      format_input:
        x: 38
        'y': 107
      delete_shippingaddress:
        x: 213
        'y': 107
      delete_account:
        x: 388
        'y': 108
        navigate:
          28b5b68e-6b25-9d2a-ac86-91e7e39c5145:
            targetId: ec2a89c7-51c9-ca9a-485c-31be1b90bf2d
            port: SUCCESS
    results:
      SUCCESS:
        ec2a89c7-51c9-ca9a-485c-31be1b90bf2d:
          x: 559
          'y': 110
