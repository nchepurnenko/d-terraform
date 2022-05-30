## Создание облачной инфраструктуры

### Предварительная настройка
Подготовил облачную инфраструктуру в ЯО при помощи Terraform:

Для подготовки перед настройкой инфраструкты создал отдельную [terraform-конфигурацию](./init), с помощью которой создается сервисный аккаунт.
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
По окончании в корне проекта будут лежать файл `sa_terraform_auth.key`  с ключами для сервисного аккаунта.  

### Создание Kubernetes кластера

2. В качестве terraform backend использую terraform cloud
3. [Конфигурация VPC](vpc.tf)
2. Воспользовался сервисом Yandex Managed Service for Kubernetes.  
[Конфигурация кластера и нод](cluster.tf)      
3. По окончании конфигурации кластера необходимо локально выполнить команду 
`yc managed-kubernetes cluster get-credentials --id catp18doqplbue4ced05 --external`, для генерации конфига для доступа к созданному кластеру в `~/.kube/config`
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

Подготовил тестовое приложение и Dockerfile для него.
[Github](https://github.com/nchepurnenko/d-app)  
[Dockerhub](https://hub.docker.com/r/chebyrek/d-app)

---
### Подготовка cистемы мониторинга и деплой приложения

Задеплоил в кластер стек Prometheus-Alertmanager-Grafana с помощью helm
```
$ helm install stable prometheus-community/kube-prometheus-stack
NAME: stable
LAST DEPLOYED: Mon May 30 10:11:22 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1

$ kubectl --namespace default get pods -l "release=stable"
NAME                                                   READY   STATUS    RESTARTS   AGE
stable-kube-prometheus-sta-operator-6ff96ff48d-9tmkh   1/1     Running   0          2m47s
stable-kube-state-metrics-65bcb89bd9-ssgd8             1/1     Running   0          2m48s
stable-prometheus-node-exporter-7qthb                  1/1     Running   0          2m48s
stable-prometheus-node-exporter-w6kq4                  1/1     Running   0          2m48s
stable-prometheus-node-exporter-wgq6p                  1/1     Running   0          2m48s
```
Для доступа к интерфейсу grafana изменил тип на LoadBalancer.
```
$ kubectl edit svc stable-grafana

$ kubectl get svc
NAME                                      TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)                      AGE
alertmanager-operated                     ClusterIP      None            <none>         9093/TCP,9094/TCP,9094/UDP   14m
kubernetes                                ClusterIP      10.96.128.1     <none>         443/TCP                      22m
prometheus-operated                       ClusterIP      None            <none>         9090/TCP                     14m
stable-grafana                            LoadBalancer   10.96.172.130   51.250.42.99   80:31234/TCP                 15m
stable-kube-prometheus-sta-alertmanager   ClusterIP      10.96.253.181   <none>         9093/TCP                     15m
stable-kube-prometheus-sta-operator       ClusterIP      10.96.248.228   <none>         443/TCP                      15m
stable-kube-prometheus-sta-prometheus     ClusterIP      10.96.196.111   <none>         9090/TCP                     15m
stable-kube-state-metrics                 ClusterIP      10.96.230.76    <none>         8080/TCP                     15m
stable-prometheus-node-exporter           ClusterIP      10.96.155.190   <none>         9100/TCP                     15m
```

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