# 3. Define a `ConnectsTo` relationship between two software components

This example shows how to define a nodecellar connects to a mongodb as in Figure 1.

![](../images/nodecella_mongodb.png "Python")

Figure 1: A topology with nodecellar connects to mongodb on a compute node.

We have 3 steps to define a `ConnectsTo` relationship from nodecellar (a `SOURCE` node) to mongodb (a `TARGET` node) as
follows:

#### Step 1. Define an endpoint capability in the TARGET node (mongodb)

First, we define a new capability name `mongo_db` from type `tosca.capabilities.Endpoint.Database`:

```yaml
node_types:
  otc.nodes.SoftwareComponent.MongoDB:
    ...
    capabilities:
      # an arbitrary name
      mongo_db:
        # mongodb offers a capability Endpoint.Database for any SOURCE nodes to connect
        type: tosca.capabilities.Endpoint.Database
```

The capability `mongo_db` contains endpoint information for a `SOURCE` node to setup the connection later on (more 
details in step 3).

The capability `mongo_db` willl show in the editor as in Figure 2:

![](../images/database_capability.png "Capability")

Figure 2: the mongodb node now has a capability `mongo_db`

Notice:
* The `tosca.capabilities.Endpoint.Database` is a TOSCA normative type with some default properties and attributes. By 
deriving from this type, the capability `mongo_db` also has these properties as in Figure 2.
* In the editor, users can manually specifiy values for the `mongo_db` capability. For example. users may set the `port`
to 27017.
* The `tosca.capabilities.Endpoint` also has a default attribute `ip_address` (not shown in the Figure). The
orchestrator will automatically set the IP address of the hosted compute node to this attribute. As a result, a SOURCE
node can get the `ip_address` from the endpoint capability to setup a connection (more details in step 3).

#### Step 2. Define a requirement in the SOURCE node (nodecellar)

In this step, we define a new requirement **with the same name** `mongo_db` for nodecellar. We also define a `ConnectsTo`
relationship in the requirement as follows:

```yaml
node_types:
  org.alien4cloud.nodes.Application.Docker.Nodecellar:
    ...
    requirements:
      - mongo_db:
          # nodecellar requires a TARGET node that has a capability from type Endpoint.Database
          capability: tosca.capabilities.Endpoint.Database
          relationship: tosca.relationships.ConnectsTo
```

#### Step 3. Extend the interfaces of the SOURCE node to setup the connection

In the `interface` of the nodecellar node (e.g., `create` ), we can get the information from the TARGET node to setup
the connection:

```yaml
node_types:
  org.alien4cloud.nodes.Application.Docker.Nodecellar:
    ...
    interfaces:
      Standard:
        create:
          inputs:
            ENV_MONGO_HOST: { get_attribute: [TARGET, mongo_db, ip_address] }
            ENV_MONGO_PORT: { get_property: [TARGET, mongo_db, port] }
            ENV_NODECELLAR_PORT: { get_property: [SELF, nodecellar_app, port] }
```

Notice:
* We use the keyword `TARGET` to reference to the target node in the relationship.
* The attribute `ip_address` is the default attribute of the endpoint capability `mongo_db`.
* We use `get_property` to get the properties from the endpoint capability `mongo_db` (e.g., `port`).

#### Advanced options

When we define the requirements:
* We can use `node` to match a target node type explicitly.
* We can specify how many relationship instances (e.g., one to one, one to two, etc.). The default value is one-to-one,
if not specified.

```yaml
node_types:
  org.alien4cloud.nodes.Application.Docker.Nodecellar:
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
