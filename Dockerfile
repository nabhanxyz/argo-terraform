FROM alpine:latest

ENV TERRAFORM_VERSION=1.2.6
ENV TERRAFORM_PROVIDER_HELM=2.6.0
ENV TERRAFORM_PROVIDER_CLOUDFLARE=3.20.0
ENV TERRAFORM_PROVIDER_K8S=2.12.1
ENV TERRAFORM_PROVIDER_VAULT=3.8.0

RUN apk add --update bash curl openssl

ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip ./

RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin
RUN rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip


RUN ["addgroup", "-S", "appuser"]
RUN ["adduser", "-S", "-D", "-h", "/home/appuser", "-G", "appuser", "appuser"]
RUN ["mkdir", "-p", "/home/appuser/terraform.d/plugins/linux_amd64/"]

ADD https://releases.hashicorp.com/terraform-provider-azurerm/${TERRAFORM_PROVIDER_HELM}/terraform-provider-azurerm_${TERRAFORM_PROVIDER_HELM}_linux_amd64.zip ./
RUN unzip terraform-provider-azurerm_${TERRAFORM_PROVIDER_HELM}_linux_amd64.zip -d /home/appuser/terraform.d/plugins/linux_amd64/
RUN rm -f terraform-provider-azurerm_${TERRAFORM_PROVIDER_HELM}_linux_amd64.zip

ADD https://releases.hashicorp.com/terraform-provider-cloudflare/${TERRAFORM_PROVIDER_CLOUDFLARE}/terraform-provider-cloudflare_${TERRAFORM_PROVIDER_CLOUDFLARE}_linux_amd64.zip ./
RUN unzip terraform-provider-cloudflare_${TERRAFORM_PROVIDER_CLOUDFLARE}_linux_amd64.zip -d /home/appuser/terraform.d/plugins/linux_amd64/
RUN rm -f terraform-provider-cloudflare_${TERRAFORM_PROVIDER_CLOUDFLARE}_linux_amd64.zip

ADD https://releases.hashicorp.com/terraform-provider-vault/${TERRAFORM_PROVIDER_VAULT}/terraform-provider-vault_${TERRAFORM_PROVIDER_VAULT}_linux_amd64.zip ./
RUN unzip terraform-provider-vault_${TERRAFORM_PROVIDER_VAULT}_linux_amd64.zip -d /home/appuser/terraform.d/plugins/linux_amd64/
RUN rm -f terraform-provider-vault_${TERRAFORM_PROVIDER_VAULT}_linux_amd64.zip

ADD https://releases.hashicorp.com/terraform-provider-kubernetes/${TERRAFORM_PROVIDER_K8S}/terraform-provider-kubernetes_${TERRAFORM_PROVIDER_K8S}_linux_amd64.zip ./
#https://releases.hashicorp.com/terraform-provider-kubernetes/2.12.1/terraform-provider-kubernetes_2.12.1_linux_amd64.zip

RUN unzip terraform-provider-kubernetes_${TERRAFORM_PROVIDER_K8S}_linux_amd64.zip -d /home/appuser/terraform.d/plugins/linux_amd64/
RUN rm -f terraform-provider-kubernetes_${TERRAFORM_PROVIDER_K8S}_linux_amd64.zip


RUN chown appuser:appuser -R /home/appuser
RUN chmod +x -R /home/appuser/terraform.d/plugins/linux_amd64/
USER appuser
WORKDIR /home/appuser/
