/*
  Jump Hosts
*/
resource "aws_security_group" "jumphost" {
    name = "vpc_jumpost"
    description = "Allow incoming SSH connections."

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "JumphostSG"
    }
}

resource "aws_instance" "jumphost-1" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "eu-central-1a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.jumphost.id}"]
    subnet_id = "${aws_subnet.eu-central-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false


    tags {
        Name = "Jumphost 1"
    }
}

resource "aws_eip" "jumphost-1" {
    instance = "${aws_instance.jumphost-1.id}"
    vpc = true
}
