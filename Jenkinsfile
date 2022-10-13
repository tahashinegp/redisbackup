properties(
    [
    parameters([
    string(defaultValue: '', name: 'User'),
    string(defaultValue: '', name: 'CURRENT_REDIS_IP'),
    string(defaultValue: '', name: 'NEW_REDIS_IP'),
   
    ])
  ]
)

node {
        stage('Take redis backup'){
            sshagent(['18.200.139.106']) {
                sh "scp -v -o StrictHostKeyChecking=no -r ${HOME}/env.sh ${params.User}@${params.CURRENT_REDIS_IP}:/home/ubuntu/env.sh"
                sh "scp -v -o StrictHostKeyChecking=no -r ${HOME}/redis-backup.sh ${params.User}@${params.CURRENT_REDIS_IP}:/home/ubuntu/redis-backup.sh"
                sh "ssh -t -t -o StrictHostKeyChecking=no  ${params.User}@${params.CURRENT_REDIS_IP} 'cd /home/ubuntu && sudo ./env.sh'"
                sh "ssh -t -t -o StrictHostKeyChecking=no  ${params.User}@${params.CURRENT_REDIS_IP} 'cd /home/ubuntu && sudo rm -rf env.sh redis-backup.sh'"
            }
        }
        stage('Restore redis backup'){
            sshagent(['18.200.139.106']) {
                sh "scp -v -o StrictHostKeyChecking=no -r ${HOME}/env.sh ${params.User}@${params.NEW_REDIS_IP}:/home/ubuntu/envrestore.sh"
                sh "scp -v -o StrictHostKeyChecking=no -r ${HOME}/redis-backup.sh ${params.User}@${params.NEW_REDIS_IP}:/home/ubuntu/redis-restore.sh"
                sh "ssh -t -t -o StrictHostKeyChecking=no  ${params.User}@${params.NEW_REDIS_IP} 'cd /home/ubuntu && sudo ./envrestore.sh'"
                sh "ssh -t -t -o StrictHostKeyChecking=no  ${params.User}@${params.NEW_REDIS_IP} 'cd /home/ubuntu && sudo rm -rf envrestore.sh redis-restore.sh'"
            }
        }
}
