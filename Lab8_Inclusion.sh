pwd
ls -lrt


mkdir /home/jcox2/ansible/tasks 
ls -lrt /home/jcox2/ansible/tasks 

cat << EOF > /home/jcox2/ansible/tasks/environment.yml
- name: Install the {{ package }}
  yum:
    name: "{{ package }}"
    state: latest
- Name Start the {{ service }} service
  service:
    name: "{{ service }}"
    state: "{{ svc_state }}" 
EOF


mkdir /home/jcox2/ansible/vars
ls -lrt /home/jcox2/ansible/tasks

cat << EOF > /home/jcox2/ansible/vars/variables.yml
firewall_pkg: firewalld 
EOF


cd /home/jcox2/ansible/

cat << EOF > /home/jcox2/ansible/Playbook2.yml
- hosts: labservers
  become: yes
  vars:
    rule: http
  tasks:
   - name: Include the variables from the YAML file
     include_vars: /home/jcox2/ansible/vars/variables.yml

   - name: Include the environment file and set the variables
     import_tasks: /home/jcox2/ansible/tasks/environment.yml
     vars:
       package: httpd
       service: httpd
       svc_state: started

   - name: Install the firewall
     yum:
       name: "{{ firewall_pkg }}"
       state: latest

   - name: Start the firewall
     service:
       name: firewalld
       state: started
       enabled: true

   - name: Open the port for {{ rule }}
     firewalld:
       service: "{{ rule }}"
       immediate: true
       permanent: true
       state: enabled

   - name: Create index.html
     copy:
       content: "{{ ansible_fqdn }} has been customized using Ansbile on the {{ ansible_date_time.date }}\n"
       dest: /var/www/html/index.html

EOF