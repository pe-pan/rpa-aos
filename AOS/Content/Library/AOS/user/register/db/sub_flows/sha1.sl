########################################################################################################################
#!!
#! @description: Calculates sha1 hash using python library.
#!!#
########################################################################################################################
namespace: AOS.user.register.db.sub_flows
operation:
  name: sha1
  inputs:
    - text
  python_action:
    script: |-
      import hashlib
      sha1 = hashlib.sha1(text).hexdigest()
  outputs:
    - sha1: '${sha1}'
  results:
    - SUCCESS
