resource "aws_instance" "myec2" {
  ami                    = "ami-063e1495af50e6fd5"
  instance_type          = "t2.micro"
  availability_zone      = "ap-southeast-1a"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name               = "ubuntusingapore"

  tags = {
    Name = "ansible-node-2"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.myec2.private_ip} >> /etc/ansible/hosts"
  }
 provisioner "file" {
    source = "ssh.sh"
    destination = "/home/ec2-user/ssh.sh"
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("./ubuntusingapore.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x ssh.sh",
      "sudo ./ssh.sh"
    ]
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("./ubuntusingapore.pem")
    }
  }
}
output "public_ip" {
  value = aws_instance.myec2.public_ip
}