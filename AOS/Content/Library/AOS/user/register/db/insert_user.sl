########################################################################################################################
#!!
#! @description: Inserts a user directly to AOS DB. For DB details, refer to aos system properties.
#!!#
########################################################################################################################
namespace: AOS.user.register.db
flow:
  name: insert_user
  inputs:
    - login_name
    - password
    - email
    - first_name
    - last_name
  workflow:
    - hash_password:
        do:
          AOS.user.register.db.sub_flows.sha1:
            - text: '${password}'
        publish:
          - password_sha1: '${sha1}'
        navigate:
          - SUCCESS: hash_name_password
    - hash_name_password:
        do:
          AOS.user.register.db.sub_flows.sha1:
            - text: '${login_name[::-1]+password_sha1}'
        publish:
          - username_password_sha1: '${sha1}'
        navigate:
          - SUCCESS: random_user_id
    - random_user_id:
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '100000000'
            - max: '1000000000'
        publish:
          - user_id: '${random_number}'
        navigate:
          - SUCCESS: insert_user
          - FAILURE: on_failure
    - insert_user:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: "${get_sp('db_host')}"
            - db_type: PostgreSQL
            - username: "${get_sp('db_user')}"
            - password:
                value: "${get_sp('db_password')}"
                sensitive: true
            - database_name: adv_account
            - command: "${\"INSERT INTO account (user_id, user_type, active, agree_to_receive_offers, defaultpaymentmethodid, email, internallastsuccesssullogin, internalunsuccessfulloginattempts, internaluserblockedfromloginuntil, first_name, last_name, login_name, password, country_id, address, city_name) VALUES ('\"+user_id+\"', 20, 'Y', true, 0, '\"+email+\"', 0, 0, 0, '\"+first_name+\"', '\"+last_name+\"', '\"+login_name+\"', '\"+username_password_sha1+\"', 210, '', '');\"}"
            - trust_all_roots: 'true'
        publish:
          - return_code
          - return_result
          - update_count
          - output_text
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      hash_password:
        x: 63
        'y': 105
      hash_name_password:
        x: 53
        'y': 297
      random_user_id:
        x: 204
        'y': 107
      insert_user:
        x: 201
        'y': 296
        navigate:
          bda54262-a32c-47e7-0513-57926ac70aee:
            targetId: 1279a6b5-0998-1d54-4cf4-cf73e347f089
            port: SUCCESS
    results:
      SUCCESS:
        1279a6b5-0998-1d54-4cf4-cf73e347f089:
          x: 408
          'y': 304
