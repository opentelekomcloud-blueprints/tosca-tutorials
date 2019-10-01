# 3. Define a `ConnectsTo` relationship between two software components

In the previous example, we used a python script to implement a software component. In this example, we use an ansible 
playbook to create a mongodb. In the `create` interface, we use an ansible script as follows:

```yaml
node_types:
  otc.nodes.SoftwareComponent.MongoDB:
```
