resource "aws_instance" "test-server" {
  ami = "ami-02d26659fd82cf299"
  instance_type = "t2.micro"
  key_name = "server-key"
  vpc_security_group_ids = ["sg-07f2f93d5e23047ea"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./server-key.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/BankingProject/ansibleplaybook.yml"
     }
  }
