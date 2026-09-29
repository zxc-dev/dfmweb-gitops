# dfmweb Helm Chart

部署 dfmweb 前端（UmiJS + React + nginx）。

## 使用方式

```bash
# 渲染（不安装）
helm template dfmweb ./charts/dfmweb \
  --set image.repository=registry.example.com/stellantis-overseas-tsp/dfmweb \
  --set image.tag=v1.0.0 \
  --set backend.host=optgateway.base.svc.cluster.local \
  --set env.TREV=dev

# 实际部署
helm upgrade --install dfmweb ./charts/dfmweb \
  --namespace dfmweb --create-namespace \
  --set image.tag=v1.0.0

# 卸载
helm uninstall dfmweb -n dfmweb
```

## 主要可配项

| Key | 说明 | 默认 |
| --- | --- | --- |
| replicaCount | 副本数 | 2 |
| image.repository | 镜像仓库 | registry.example.com/stellantis-overseas-tsp/dfmweb |
| image.tag | 镜像 tag | latest |
| backend.host | 后端网关 Service 域名 | optgateway.base.svc.cluster.local |
| backend.port | 后端网关端口 | 8080 |
| backend.path | 反代前缀 | /dfmadmin/ |
| env.TREV | 构建/环境标识 | dev |
| service.port | Service port | 80 |
| ingress.enabled | 是否启用 Ingress | false |
| autoscaling.enabled | 是否启用 HPA | false |
| resources | Pod 资源 | 见 values.yaml |

## 镜像仓库说明

`Dockerfile` 中的基础镜像 `swr.cn-south-1.myhuaweicloud.com/dftc_yun2021/pateo-node:v1` 是公司内部 SWR 仓库，
CI 在执行 `docker build` 前会切换 `DOCKER_REGISTRY_URL` 环境变量。