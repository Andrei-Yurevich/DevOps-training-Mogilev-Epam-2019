import groovy.json.JsonSlurper
URL registryapiUrl = new URL("http://192.168.43.12:5000/v2/module4/tags/list")
def json = new JsonSlurper().parseText(registryapiUrl.text)
return json.tags
