resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags {
    Name = "main-vpc-igw"
  }
}

resource "aws_route_table" "webservers_rt" {
  vpc_id     = "${aws_vpc.main_vpc.id}"
  depends_on = ["aws_subnet.webservers"]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "webservers_rt"
  }
}

resource "aws_route_table_association" "webservers" {
  subnet_id      = "${aws_subnet.webservers.*.id[count.index]}"
  route_table_id = "${aws_route_table.webservers_rt.id}"
  count          = "${length(aws_subnet.webservers.*.id)}"
  depends_on     = ["aws_subnet.webservers"]
}

# Create Private Route Table

resource "aws_route_table" "rds_rt" {
  vpc_id     = "${aws_vpc.main_vpc.id}"
  depends_on = ["aws_subnet.rds"]

  tags {
    Name = "rds_rt"
  }
}

resource "aws_route_table_association" "rds" {
  count          = "${length(aws_subnet.rds.*.id)}"
  subnet_id      = "${aws_subnet.rds.*.id[count.index]}"
  route_table_id = "${aws_route_table.rds_rt.id}"

  # depends_on     = ["aws_subnet.rds"]
}

# Terraform Import Demo

resource "aws_route_table" "manusl_rt" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "ManualRT"
  }
}
