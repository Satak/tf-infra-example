# Terraform Entra ID Group Example

This repository contains a Terraform module that can be used to create an Entra ID groups and assign members and owners to the group. Client configuration is defined as a yaml configuration file under the folder `/groups`.

## Data model

```yaml
my-group-name:
  description: my group description
  members:
    - my-member.1@mydomain.onmicrosoft.com
    - my-member.2@mydomain.onmicrosoft.com
  owners:
    - my.owner@mydomain.onmicrosoft.com
```
