#{
#  "request": {
#    "mbean": "java.lang:type=Runtime",
#    "attribute": "Uptime",
#    "type": "read"
#  },
#  "value": 72579506,
#  "timestamp": 1473263169,
#  "status": 200
#}
# value is in ms
curl -s localhost:8999/jolokia/read/java.lang:type=Runtime/Uptime
