import hudson.model.*

node('master'){
  stage('Clone module4 branch'){
    checkout([$class: 'GitSCM', branches: [[name: 'module4']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/Andrey1913/DevOps-training-Mogilev-Epam-2019']]])
  }

  stage('Gradle build') {
    sh label: 'build', script: './gradlew build'
    sh label: 'increment version', script: './gradlew inc'
    sh label: 'build', script: './gradlew build'
    
  }
  
  stage('Put to nexus'){
    // Не смог разобраться как плагином закинуть по урлу как в презентации
    version = sh (script: "sed 's/version.//;/[a-Z].*/d' gradle.properties",returnStdout: true).trim()
    sh label: 'create context if not exist', script: "curl -u admin:admin123 -T ./build/libs/task4.war http://127.0.0.1:8081/nexus/content/repositories/snapshots/test/${version}/"
  }
    
}

node('httpd_vm'){
    stage('Disable tomcat1'){
        httpRequest responseHandle: 'NONE', url: 'http://127.0.0.1/jkmanager?cmd=update&from=list&w=lb&sw=worker1&vwa=1'
    }
    stage('Disable tomcat2'){
        httpRequest responseHandle: 'NONE', url: 'http://127.0.0.1/jkmanager?cmd=update&from=list&w=lb&sw=worker2&vwa=1'
    }
}

node('tomcat1'){
    stage('Wgetting & deploying artifact for tomcat1')
    {
        
        sh label: '', script : """
        if [[ -f /opt/module3/apache-tomcat-8.5.37/webapps/task4.war ]]; then
        rm -r /opt/module3/apache-tomcat-8.5.37/webapps/task4.war
        fi
        wget -c 192.168.0.254:8081/nexus/content/repositories/snapshots/test/${version}/task4.war -O /opt/module3/apache-tomcat-8.5.37/webapps/task4.war
        """
    }
}

node('tomcat2'){
    stage('Wgetting & deploying artifact for tomcat2')
    {
        sh label: '', script : """
        if [[ -f /opt/module3/apache-tomcat-8.5.37/webapps/task4.war ]]; then
        rm -r /opt/module3/apache-tomcat-8.5.37/webapps/task4.war
        fi
        wget -c 192.168.0.254:8081/nexus/content/repositories/snapshots/test/${version}/task4.war -O /opt/module3/apache-tomcat-8.5.37/webapps/task4.war
        """
    }
}

node('httpd_vm'){
    stage('Enable tomcat1'){
        httpRequest responseHandle: 'NONE', url: 'http://127.0.0.1/jkmanager?cmd=update&from=list&w=lb&sw=worker1&vwa=0'
    }
    stage('Enable tomcat2'){
        httpRequest responseHandle: 'NONE', url: 'http://127.0.0.1/jkmanager?cmd=update&from=list&w=lb&sw=worker2&vwa=0'
    }
}

node('master'){
  stage('Perversion with git'){
      sh label: '', script: '''
        git config user.name "Andrey1913"
        git config user.email Andrey1913@users.noreply.github.com
        git config --global push.default simple
        git commit -am "version increased"
        '''
        withCredentials([usernamePassword(credentialsId: '8a8990fd-7804-4492-a628-a805fd32e944', passwordVariable: 'pass', usernameVariable: 'login')]) {
            sh("git push https://${login}:${pass}@github.com/Andrey1913/DevOps-training-Mogilev-Epam-2019.git HEAD:module4")
            sh("git reset --hard")
            sh("git checkout module6")
            sh("git tag -a $version -am 'tag'")
            sh("git push https://${login}:${pass}@github.com/Andrey1913/DevOps-training-Mogilev-Epam-2019.git HEAD:module6")
            sh("git checkout master")
            sh("git merge module6")
            sh("git push https://${login}:${pass}@github.com/Andrey1913/DevOps-training-Mogilev-Epam-2019.git HEAD:master")
        }
  }
    
}
