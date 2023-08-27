# Projeto DevOps com Terraform e Azure

## Descrição

Este projeto é uma implementação DevOps que automatiza o deployment de uma aplicação web em uma máquina virtual Ubuntu na Azure. Utiliza o Terraform para orquestrar todos os recursos necessários, incluindo a VM, Storage Account, VNet e outras configurações.

---

## Características

- **Infraestrutura como Código**: Todo o ambiente é criado usando Terraform.
- **Compilação Local**: Utiliza `null_resource` do Terraform para executar o build da aplicação localmente.
- **Provisionamento Automático**: Usa o provisionador `file` do Terraform para enviar o build para a VM.
- **Configuração de Servidor**: O provisionador `remote-exec` do Terraform instala e configura o NGINX.
- **Azure Resources**: Cria uma VM do tipo `Standard_B2S`, uma Storage Account e uma VNet na Azure.

---

## Pré-requisitos

- Terraform
- Azure CLI
- Conta no Azure

---

## Como Usar

1. **Clonar Repositório**
    ```bash
    git clone https://github.com/[seu-usuario]/[nome-do-repo].git
    ```
2. **Inicializar Terraform**
    ```bash
    terraform init
    ```
3. **Aplicar Configurações**
    ```bash
    terraform apply
    ```

---

## Detalhes de Implementação

### Compilação Local
Usa `null_resource` para executar o build da aplicação localmente.

```hcl
resource "null_resource" "local_build" {
  provisioner "local-exec" {
    command = "comando para o build"
  }
}
```
---
## Provisionamento Automático
O provisionador `file` transfere o build para a VM.

```hcl
resource "null_resource" "file_provisioner" {
  provisioner "file" {
    source      = "caminho/para/o/build"
    destination = "caminho/na/vm"
  }
}
```

---
## Configuração de Servidor
`remote-exec` é usado para instalar e configurar o NGINX na VM.

```hcl
resource "null_resource" "nginx_setup" {
  provisioner "remote-exec" {
```

