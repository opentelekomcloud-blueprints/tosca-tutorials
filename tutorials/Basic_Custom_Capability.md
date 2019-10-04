# 4. How to define a custom capability?

In the [previous example](Basic_Relationship_ConnectsTo.md "Relationship depands on example"), we used the default
capability `tosca.capabilities.Endpoint.Database`, which has the some default properties: `port`, `protocol` as in
Figure 2:

![](../images/database_capability.png "Capability")

Figure 1: Default properties of an endpoint capability

To add more properties to a capability, or to set a default value to a capability, we define a custom one as follows:

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

Here, the custom capability `tosca.capabilities.Endpoint.Database.Mongo` inherits all properties from the parent 
type `tosca.capabilities.Endpoint.Database` and set the `port` property to the default value 27017.

* Next: [How to manage the lifecycle of a relationship?](Basic_Custom_Relationship.md "Custom relationship connects to example")