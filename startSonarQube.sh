#!/bin/sh

echo "-----> Making java available"
export PATH=$PATH:/home/vcap/app/.java/bin

echo "-----> Setting sonar.properties"
echo "       sonar.web.port=${PORT}"
echo "\n ------- The following properties were automatically created by the buildpack -----\n" >> ./sonar.properties
echo "sonar.web.port=${PORT}\n" >> ./sonar.properties
#echo "sonar.search.javaAdditionalOpts=-Dnode.store.allow_mmapfs=false\n" >> ./sonar.properties
#echo "SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true\n" >> ./sonar.properties

# Replace all environment variables with syntax ${MY_ENV_VAR} with the value
# thanks to https://stackoverflow.com/questions/5274343/replacing-environment-variables-in-a-properties-file
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' ./sonar.properties > ./sonar_replaced.properties
mv ./sonar_replaced.properties ./sonar.properties

echo "------------------------------------------------------" > /home/vcap/app/sonarqube/logs/sonar.log

echo "-----> Starting SonarQube"

/home/vcap/app/sonarqube/bin/linux-x86-64/sonar.sh start


#echo "print debug logs"
#ls -larth /etc/sysctl.d
#echo "print sysctl"

#echo "-----adding values------"
#sudo echo "vm.max_map_count=524288" >> /etc/sysctl.conf2
#sudo echo "fs.file-max=131072" >> /etc/sysctl.conf2
#sudo mv /etc/sysctl.conf2 /etc/sysctl.conf
#echo "-----print file-max------"
#cat /etc/sysctl.conf|grep -v 'fs.file-max' 
#echo "-----end of print file-max------"

#sudo sysctl --system
#sudo sysctl -w vm.max_map_count=524288
#sudo sysctl -w fs.file-max=131072
#echo "print ulimit"
#sudo ulimit -n 131072
#sudo ulimit -u 8192

echo "-----> Tailing log"
sleep 10 # give it a bit of time to create files
cd /home/vcap/app/sonarqube/logs
tail -f ./sonar.log ./es.log ./web.log ./ce.log ./access.log
