# 4. Define a custom `ConnectsTo` relationship

##### 4.1. How to define a custom capability?

In the previous example, we used the default capability `tosca.capabilities.Endpoint.Database`, which has the following
properties: `port`, `protocol` as in Figure 2:

![](../images/database_capability.png "Capability")

Figure 1

To add more properties to a capability, or to set a default value, we define a custom one as follows:

```yaml
capability_types:
  # define a custom capability
  tosca.capabilities.Endpoint.Database.Mongo:
    derived_from: tosca.capabilities.Endpoint.Database
    properties:
      port:
        type: integer
        default: 27017
```

Here, the custom capability `tosca.capabilities.Endpoint.Database.Mongo` will inherit all properties from the parent 
type `tosca.capabilities.Endpoint.Database` and set the `port` property to the default value 27017.

##### 2. How to define a custom relationship?

