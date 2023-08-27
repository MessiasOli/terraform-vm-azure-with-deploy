
resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip-terraform"
  resource_group_name = var.storage_account_name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = local.commun_tags
}

resource "azurerm_network_interface" "network_interface" {
  name                = "network_interface-terraform"
  location            = var.location
  resource_group_name = var.storage_account_name

  ip_configuration {
    name                          = "public-ip-terraform"
    subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = local.commun_tags
}

resource "azurerm_network_interface_security_group_association" "nisga" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = data.terraform_remote_state.vnet.outputs.security_group_id
}

# Created to download repository and build de app to vm
resource "null_resource" "local-exec" {
  provisioner "local-exec" {
    command = "./download-apps.sh"
  }

  depends_on = [azurerm_network_interface_security_group_association.nisga]
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-terraform"
  resource_group_name = var.storage_account_name
  location            = var.location
  # size                  = "Standard_B1S"
  size                  = "Standard_B2S"
  admin_username        = "terraform"
  network_interface_ids = [azurerm_network_interface.network_interface.id]

  admin_ssh_key {
    username   = "terraform"
    public_key = file("./azure-key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  connection {
    type        = "ssh"
    user        = "terraform"
    private_key = file("./azure-key")
    host        = self.public_ip_address
  }

  provisioner "file" {
    source      = "./tmp/react-portifolio/build"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${self.public_ip_address} ***** ACCESS TO VM OK!",
      "sudo sleep 5",
      "echo ${self.public_ip_address} ***** UPDATING APT!",
      "sudo apt update",
      "sudo sleep 5",
      "echo ${self.public_ip_address} ***** BEGIN INSTALL NGINX!",
      "sudo apt install -y nginx",
      "echo ${self.public_ip_address} ***** SETTING PORTS INBOUND!",
      "sudo ufw allow 'Nginx HTTP'",
      "sudo ufw allow 8080/tcp",
      "sudo sleep 5",

      "echo ${self.public_ip_address} ***** First App on port 8080",
      "sudo mkdir /var/www/html/portifolio/",
      "sudo mv /tmp/build/* /var/www/html/portifolio/",
      "echo 'server { listen 8080; listen [::]:8080; root /var/www/html/portifolio; index index.html; location / { try_files $uri $uri/ /index.html; }}' | sudo tee /etc/nginx/sites-available/portifolio",
      "sudo ln -s /etc/nginx/sites-available/portifolio /etc/nginx/sites-enabled/",

      "echo ${self.public_ip_address} ***** Restarting Nginx",
      "sudo nginx -t",
      "sudo systemctl restart nginx",
      "echo ${self.public_ip_address} *****  FINISHED BUILD AND DEPLOY!"
    ]
  }

  depends_on = [null_resource.local-exec]
  tags       = local.commun_tags
}