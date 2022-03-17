# secondterraformproject
secondterraformproject

# USAGE

```hcl
module "vpcmodule" {
  source = "./vpcmodule"

  vpccidr = vpc_cidr
  websubnetnames  =3 (how many websubnet names desire)
  Appsubnames     =3 (How many Appp subnames you desire) Appsubnames
  websubnet_cidr  = [for each in range(1,225,2) : cidrsubnet(var.vpccidr, 8, each)]
  appsubnet_cidr  = [for each in range(0,225,2) : cidrsubnet(var.vpccidr, 8, each)]
}
```
