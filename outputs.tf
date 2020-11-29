# Generate inventory file
resource "local_file" "inventory" {
 filename = "./ansible_build/hosts.ini"
 content = <<EOF
[monitor]
${aws_instance.toolbox.public_ip}

[proxy]
${aws_instance.proxy.public_ip}

[blue_green]
${aws_instance.appserver-1.private_ip}
${aws_instance.appserver-2.private_ip}

EOF

}



