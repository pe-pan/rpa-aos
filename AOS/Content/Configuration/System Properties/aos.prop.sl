########################################################################################################################
#!!
#! @system_property aos_proxy_host: Proxy server hostname to access the AOS instance (from RPA instance)
#! @system_property aos_proxy_port: Proxy server port to access the AOS instance (from RPA instance)
#!!#
########################################################################################################################
namespace: ''
properties:
  - db_host: rpa.mf-te.com
  - db_user: postgres
  - db_password:
      value: admin
      sensitive: true
  - worksheet: products
  - aos_url: 'http://rpa.mf-te.com:8080'
  - aos_proxy_host:
      value: ''
      sensitive: false
  - aos_proxy_port:
      value: ''
      sensitive: false
