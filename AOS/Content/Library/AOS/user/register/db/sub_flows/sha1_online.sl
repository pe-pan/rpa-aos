########################################################################################################################
#!!
#! @description: Calculates sha1 hash using an online service.
#!!#
########################################################################################################################
namespace: AOS.user.register.db.sub_flows
flow:
  name: sha1_online
  inputs:
    - text
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: 'http://www.sha1-online.com/'
            - body: "${'textToHash='+text+'&hash-algorithm-used=sha1'}"
            - content_type: application/x-www-form-urlencoded
        publish:
          - sha1: "${return_result.split(\"<span id='result-sha1'>\")[1].split(\"</span>\")[0]}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - sha1: '${sha1}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_post:
        x: 163
        'y': 178
        navigate:
          a8040635-dcf9-1883-122f-a5f3ff59ab74:
            targetId: a4ba8387-9834-ec62-ca91-5fffa758d2af
            port: SUCCESS
    results:
      SUCCESS:
        a4ba8387-9834-ec62-ca91-5fffa758d2af:
          x: 393
          'y': 176
