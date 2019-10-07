# 3. Define a `ConnectsTo` relationship between two software components

This example shows how to define a `ConnectsTo` relationship from nodecellar (a `SOURCE` node) to mongodb (a `TARGET`
node)as in Figure 1.

![](../images/nodecella_mongodb.png "Python")

Figure 1: A topology with nodecellar connects to mongodb on a compute node.

#### Step 1. Define an endpoint capability in the TARGET node (mongodb)

In the mongodb node, add the following `capabilities` block:

```yaml
node_types:
  otc.nodes.SoftwareComponent.MongoDB:
    ...
    capabilities:
      mongo_db:
        type: tosca.capabilities.Endpoint.Database
```

In this example, the new capability `mongo_db` is from type `tosca.capabilities.Endpoint.Database`.

The capability `mongo_db` willl show in the editor as in Figure 2:

![](../images/database_capability.png "Capability")

Figure 2: the mongodb node now has a capability `mongo_db`

Notice:
* The `tosca.capabilities.Endpoint.Database` is a TOSCA normative type with some default properties and attributes. By 
deriving from this type, the capability `mongo_db` also has these properties as in Figure 2.
* The capability `mongo_db` now contains information for a `SOURCE` node to setup the connection in step 3.
* In the editor, users can specifiy values for the `mongo_db` capability. For example. users may set the `port`to 27017.
* The `tosca.capabilities.Endpoint` also has a default attribute `ip_address` (not shown in the Figure). The
orchestrator will automatically set the IP address of the hosted compute node to this attribute. A SOURCE node can use
the `ip_address` to setup a connection in step 3.

#### Step 2. Define a requirement in the SOURCE node (nodecellar)

In the nodecellar node, add the following `requirements` block:

```yaml
node_types:
  otc.nodes.WebApplication.Nodecellar:
    derived_from: tosca.nodes.WebApplication
    ...
    requirements:
      - mongo_db:
          # nodecellar connects to a TARGET node that has the capability Endpoint.Database
          capability: tosca.capabilities.Endpoint.Database
          relationship: tosca.relationships.ConnectsTo
```

Notice:
* The requirement name of nodecellar node has the same name `mongo_db` as the capability name in the mongodb node.
* The `tosca.relationships.ConnectsTo` defines the relationship between nodecellar and mongodb.

#### Step 3. Extend the interfaces of the SOURCE node to setup the connection

In the `interfaces` of the nodecellar node (e.g., `create` ), we can retrieve the information from the TARGET node to
and use it as an `inputs` to setup the connection:

```yaml
node_types:
  otc.nodes.WebApplication.Nodecellar:
    ...
    interfaces:
      Standard:
        create:
          implementation: scripts/install-nodecellar-app.sh
          inputs:
            DB_IP: { get_attribute: [TARGET, mongo_db, ip_address] }
            DB_PORT: { get_property: [TARGET, port] }
            NODECELLAR_PORT: {get_property: [SOURCE, port]}      
```

Notice:
* We use the keyword `TARGET` to reference to the target node in the relationship.
* The attribute `ip_address` is the default attribute of the endpoint capability `mongo_db`.
* We use `get_property` to get the properties from the endpoint capability `mongo_db` (e.g., `port`).

#### Optional requirements

When we define the requirements:
* We can use `node` to match a target node type explicitly.
* We can specify how many relationship instances (e.g., one to one, one to two, etc.). The default value is one-to-one,
if not specified.

```yaml
node_types:
  otc.nodes.WebApplication.Nodecellar:
    ...
    requirements:
      - mongo_db:
          capability: tosca.capabilities.Endpoint.Database
          relationship: tosca.relationships.ConnectsTo
          # (Optional) we accept only node type MongoDB
          node: otc.nodes.SoftwareComponent.MongoDB
          # (Optional) we specifiy relationship one-to-one
          occurrences: [1, 1]
```

#### Where to go from here?

* See [full example](../examples/nodecellar_tutorial3/types.yml "Nodecellar example")
* Next: [How to define a custom capability?](Basic_Custom_Capability.md "Custom capability")