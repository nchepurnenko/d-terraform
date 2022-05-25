# Terraform

## Требования
- файл `.terraformrc` в ~/
```json
cat ~/.terraformrc 
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```
- установленный и настроенный yandex cloud CLI

## Terraform Backend
S3 в Яндекс Облаке
Конфигурация хранится в файле backend.key, который создается при запуске init

## Init

Запустить в папке init 
```sh
terrafrom apply -var-file=.tfvars
```
Создает: 
- сервисный аккаунт и его токены и ключи
- бакет для terraform backend
- подставляет токены в файл конфигурации backend - backend.key
- json файл с ключами сервисного аккаунта для конфигурации provider

## Создание инфраструктуры в Яндекс Облаке
```sh
terraform init -backend-config=backend.key
terraform apply -var-file=.tfvars
```