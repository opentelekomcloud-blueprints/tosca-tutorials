# 5. How to manage the lifecycle of a relationship?

In the previous example, we used the default relationship `tosca.relationships.ConnectsTo`:

```yaml
    ...
    requirements:
      - mongo_db:
          capability: tosca.capabilities.Endpoint.Database
          # the default relationship ConnectsTo
          relationship: tosca.relationships.ConnectsTo
```

#### Step 1: Define custom relationship

To fully control the lifecycle of a relationship in further details, we define a new one by extending 
`tosca.relationships.ConnectsTo`:

```yaml
relationship_types:
  org.alien4cloud.relationships.NodejsConnectToMongo:
    derived_from: tosca.relationships.ConnectsTo
    interfaces:
      Configure:
          pre_configure_source:
            inputs:
              DB_IP: { get_attribute: [TARGET, ip_address] }
              NODECELLAR_PORT: {get_property: [SOURCE, port]}
            implementation: scripts/set-mongo-url.sh
```

#### Step 2: Update the node requirements with custom relationship

```yaml
    ...
    requirements:
      - mongo_db:
          capability: tosca.capabilities.Endpoint.Database
          # the custom relationship ConnectsTo
          relationship: org.alien4cloud.relationships.NodejsConnectToMongo
```

Notice:
* The interface `pre_configure_source` is executed after the `SOURCE` node is created (See Figure 1).
* We use `SOURCE` and `TARGET` to reference to the source node (nodecellar) and target node (mongodb) in a relationship.

![](../images/relationship_lifecycle.png "Relationship lifecycle")

Figure 1: Lifecycle of a relationship

#### Relationship interfaces:

Relationship interfaces executed on the `SOURCE` node:
* `pre_configure_source` is executed after the `SOURCE` node is created, and before it is configured.
* `post_configure_source`: executes after the `SOURCE` node is configured, and before it starts.


* `add_target`: executes after the `TARGET` node is started.
* `remove_target`: executes after the `TARGET` node is removed.
* `target_changed`: executes whenever the `TARGET` node changes.

Relationship interfaces executed on the `TARGET` node:
* `pre_configure_target`: executes after the `TARGET` node is created, and before it is configured.
* `post_configure_target`: executes after the `TARGET` node is configured, and before it starts.

Notice:
* The interfaces `create`,`configure`, and `start` are the interfaces of a node type definition (not a relationship type
definition).

#### Where to go from here?

* See [full example](../examples/nodecellar/nodecellar-type.yml "Custom relationship example")
* Next: [How to deploy a file or a folder (i.e., an `artifact`) to a target compute node?](Basic_Artifact.md "Artifact")