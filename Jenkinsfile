node('master') {
# clone my repo
    stage('checkout branch 10 from my repo '){
        checkout([$class: 'GitSCM', branches: [[name: '*/module10']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/Andrey1913/DevOps-training-Mogilev-Epam-2019']]])
    }
     
    stage('Replace image version in attributes'){
        dir('module10/'){
            println image_tag
            change_version = "default['module10']['tag'] = '" +image_tag +"'"
            println change_version
            sh label: '', script: """sed -i "s/.*tag.*/$change_version/g" attributes/default.rb"""
        }
    }   

    stage('replace version in metadata'){
        dir('module10/') {
            Properties props = new Properties()
            File prop_f = new File("/var/lib/jenkins/workspace/module10/module10/metadata.rb")
            props.load(prop_f.newDataInputStream())
            vers_prop = props.getProperty('version')
            vers_prop = vers_prop.replaceAll(/'/, "")
            
	    String minor=vers_prop.substring(vers_prop.lastIndexOf('.')+1)
	    int m=minor.toInteger()+1
	    String major=vers_prop.substring(0,vers_prop.lastIndexOf("."))
	    String new="version '"+major+ "." +m+"'"
	    println new
	    sh label: '', script: """sed -i "s/.*version.*/$new/g" metadata.rb"""
        }
    }
	
	stage('Rewrite ENV'){
        def envFile = sh returnStdout:true, script: "knife environment show $ENV -F json"
        envProperties = readJSON text: envFile;
        
        envProperties.default_attributes.module10.tag = image_tag
        writeJSON file: "module10${ENV}.json", json: envProperties
        sh label: '', script: "knife environment from file module10${ENV}.json"
    }
    
    stage('push cookbook'){
        dir('module10/'){
            sh label: 'upload and install dependencies', script: "berks install && berks upload"
        }
    }
    
    stage('CHEF chef client'){
        dir('module10/'){
            withCredentials([usernamePassword(credentialsId: 'h5g9qlk1-aa34-aly5-1199-nq8kl0lm1t80', passwordVariable: 'password', usernameVariable: 'user')]){ 
                sh label: '', script: "knife ssh 'chef_environment:$ENV' 'sudo chef-client' -x ${user} -P ${password}"
            } 
        }
    }
    
}

node('slave') {

    stage('Check container'){
    
        def check = sh returnStdout:true, script: "docker ps"
        println check
        
        if (check.contains("0.0.0.0:8080")) {
            def check_blue = sh returnStdout:true, script: "curl localhost:8080/test/"
            
            if (check_blue.contains(image_tag)){
                println "version -- OK"
            }
            
        }
        
        else if (check.contains("0.0.0.0:8081")) {
            def check_green = sh returnStdout:true, script: "curl localhost:8081/test/"
            
            if (check_green.contains(image_tag)){
                println "version -- OK"
            }
        }
        
        else {
            error("not work")
        }
        
    }
}

node('master'){ 
    stage('Push to git'){
        sh label: '', script: '''
        git config user.name "Andrey1913"
        git config user.email "Andrey1913@users.noreply.github.com"
        git config --global push.default simple
        git status
        git add . 
        git commit -m "push from Jenkins"
        git status
        '''        
         withCredentials([usernamePassword(credentialsId: 'ee18572c-20ab-4249-95cf-89ea8a395999', passwordVariable: 'update', usernameVariable: 'push')]) {
            sh("git push https://${push}:${update}@github.com/DevOps-training-Mogilev-Epam-2019/DevOps.git HEAD:module10")    
        }
    }
}
