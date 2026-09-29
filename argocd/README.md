# ArgoCD 部署说明（dfmweb）

## 前置条件

ArgoCD 需要能通过 SSH 拉取 GitLab 仓库，先在 argocd 所在集群创建 repo 凭证 Secret：

```bash
# 1. 在能访问集群的机器上生成 argocd 专用密钥对
ssh-keygen -t ed25519 -f argocd-dfmweb-key -N "" -C "argocd-dfmweb"

# 2. 公钥添加到 GitLab:
#    stellantis-overseas-tsp/dfmweb -> Settings -> Repository -> Deploy Keys (只读即可)

# 3. 已知主机指纹（在能 SSH 到 10.4.3.107 的机器上执行）
ssh-keyscan -p 10022 10.4.3.107 > known_hosts

# 4. 创建 Secret
kubectl -n argocd create secret generic repo-dfmweb-ssh \
  --from-file=sshPrivateKey=argocd-dfmweb-key \
  --from-file=known_hosts=known_hosts \
  --annotation argocd.argoproj.io/secret-type=repository

# 5. 验证仓库连接（argocd UI: Settings -> Repositories 应显示 Connected）
```

## 应用 Application

```bash
kubectl apply -f argocd/dfmweb-app.yaml
```

## 部署拓扑

| 项 | 值 |
|---|---|
| 跟踪仓库 | `ssh://git@10.4.3.107:10022/stellantis-overseas-tsp/dfmweb.git` |
| 跟踪分支 | `k8s_sit_test` |
| Chart 路径 | `charts/dfmweb` |
| 目标集群 | in-cluster（argocd 所在集群） |
| 目标 namespace | `dfmweb`（自动创建） |
| 同步策略 | automated + prune + selfHeal |

## 待办

- [ ] `charts/dfmweb/values.yaml` 中 `image.repository` 仍为占位
      `registry.example.com/stellantis-overseas-tsp/dfmweb`，
      镜像仓库权限确认后改为真实地址（如 ECR：
      `602499751343.dkr.ecr.eu-west-3.amazonaws.com/dfm/dev/dfmweb`），
      并在集群中配置 imagePullSecrets。
- [ ] ELB/ingress 目前只放行了 argocd web UI 与 `/api/version`，
      `/api/v1/*` 与 gRPC 均超时，需要补路由规则才能用 CLI/API 管理。
