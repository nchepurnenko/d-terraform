## Создание облачной инфраструктуры

### Предварительная настройка
Подготовил облачную инфраструктуру в ЯО при помощи Terraform:

Для подготовки перед настройкой инфраструкты создал отдельную [terraform-конфигурацию](./init), с помощью которой создается сервисный аккаунт, бакет для terraform backend и файл его конфигурации.
1. Для начала необходимо установить и настроить [Yandex Cloud CLI](https://cloud.yandex.ru/docs/cli/quickstart)
2. После разместить в домашней директории пользователя файл `.terraformrc`
    ```js
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
3. Запустить 
    ```sh
    terrafrom apply -var-file=.tfvars
    ```
По окончании в корне проекта будут лежать два файла `backend.key` с настройками terrafrom backend и `sa_terraform_auth.key`  с ключами для сервисного аккаунта.  

### Создание Kubernetes кластера

1. Настроил workspace
    ```sh
    $ terraform workspace list
    * default
    $ terraform workspace new stage
    Created and switched to workspace "stage"!
    $ terraform workspace list
      default
    * stage
    ```
3. [Конфигурация VPC](vpc.tf)
2. Воспользовался сервисом Yandex Managed Service for Kubernetes.  
[Конфигурация кластера и нод](cluster.tf)      
3. По окончании конфигурации кластера terraform локально выполняет команду `yc managed-kubernetes cluster get-credentials --id --external`, помещая данные для доступа к созданному кластеру в `~/.kube/config`
4. [Результат](files/tf_plan1.md) выполнения `terrafrom plan` на этом этапе
5. После запуска `terraform apply` проверил, что кластер k8s успешно запустился
    ```sh
    $ kubectl get nodes
    NAME                        STATUS   ROLES    AGE     VERSION
    cl12enmbn92ddj3s31b2-ypyv   Ready    <none>   3m37s   v1.21.5
    cl1d68omrq48fueijj0o-amip   Ready    <none>   3m      v1.21.5
    cl1kuqrnaasnhq0c3v41-iwuc   Ready    <none>   3m41s   v1.21.5

    $ kubectl get pods --all-namespaces
    NAMESPACE     NAME                                                  READY   STATUS    RESTARTS   AGE
    kube-system   calico-node-skspw                                     1/1     Running   0          5m19s
    kube-system   calico-node-t7xlk                                     1/1     Running   0          4m39s
    kube-system   calico-node-xbzlw                                     1/1     Running   0          5m16s
    kube-system   calico-typha-6d7bddfb44-pwrg8                         1/1     Running   0          4m5s
    kube-system   calico-typha-horizontal-autoscaler-8495b957fc-xc5sr   1/1     Running   0          8m31s
    kube-system   calico-typha-vertical-autoscaler-6cc57f94f4-n5cw9     1/1     Running   3          8m31s
    kube-system   coredns-5f8dbbff8f-8qpjp                              1/1     Running   0          4m52s
    kube-system   coredns-5f8dbbff8f-8z2tc                              1/1     Running   0          8m29s
    kube-system   ip-masq-agent-9tm45                                   1/1     Running   0          5m19s
    kube-system   ip-masq-agent-ptf9g                                   1/1     Running   0          5m15s
    kube-system   ip-masq-agent-zvx42                                   1/1     Running   0          4m39s
    kube-system   kube-dns-autoscaler-598db8ff9c-sltmh                  1/1     Running   0          8m18s
    kube-system   kube-proxy-b7tb4                                      1/1     Running   0          4m39s
    kube-system   kube-proxy-bh7nb                                      1/1     Running   0          5m15s
    kube-system   kube-proxy-tm2q8                                      1/1     Running   0          5m19s
    kube-system   metrics-server-v0.3.1-6b998b66d6-d582n                2/2     Running   0          4m52s
    kube-system   npd-v0.8.0-f2qvt                                      1/1     Running   0          4m39s
    kube-system   npd-v0.8.0-lj8kq                                      1/1     Running   0          5m19s
    kube-system   npd-v0.8.0-sqsw9                                      1/1     Running   0          5m15s
    kube-system   yc-disk-csi-node-v2-5hgjj                             6/6     Running   0          5m19s
    kube-system   yc-disk-csi-node-v2-bg8zb                             6/6     Running   0          5m16s
    kube-system   yc-disk-csi-node-v2-l56ls                             6/6     Running   0          4m39s
    ``` 

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистр с собранным docker image. В качестве регистра может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Рекомендуемый способ выполнения:
1. Воспользовать пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). При желании можете собрать все эти приложения отдельно.
2. Для организации конфигурации использовать [qbec](https://qbec.io/), основанный на [jsonnet](https://jsonnet.org/). Обратите внимание на имеющиеся функции для интеграции helm конфигов и [helm charts](https://helm.sh/)
3. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте в кластер [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры.

Альтернативный вариант:
1. Для организации конфигурации можно использовать [helm charts](https://helm.sh/)

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ к тестовому приложению.

---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/) либо [gitlab ci](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/)

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистр, а также деплой соответствующего Docker образа в кластер Kubernetes.




# Terraform

## Требования
- файл `.terraformrc` в ~/
```js
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