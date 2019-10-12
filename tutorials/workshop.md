# Workshop (30 - 45 min)

#### Our mission today:

* create a database mongodb (with ansible).
* create a nodecellar (a front-end website based on nodejs).
* connect nodecellar to mongodb as in Figure 1:

![](../images/nodecella_mongodb.png "workshop")

Figure 1: Overview

#### Step 1. Edit templete version of mongodb

Open [examples/mongodb/types.yaml](../examples/mongodb/types.yaml "Mongodb example")

Replace `ỲOURNAME` with your name (line 11).

```yaml
  template_version: 1.0.0-YOURNAME
```

#### Step 2. Add a `port` property for mongodb

Under

```yaml
    properties:
```

Add

```yaml
      port:
        type: integer
        description: MongoDB port
        default: 27017
        required: true
```

#### Step 3. Add a new capability `mongo_db` for mongodb

Under

```yaml
    capabilities:
```

Add

```yaml
      mongo_db:
        type: tosca.capabilities.Endpoint.Database
```

Notice:
* This defines a new endpoint `mongo_db` for mongodb. Nodecellar will connect to mongodb node via this endpoint in step 8.

#### Step 4. Define the create interface for mongodb

Under `inputs` of the `cretae` interface:

```yaml
    interfaces:
      Standard:
        create:
          description: MongoDB installation step
          inputs:
```

Add

```yaml
            MONGODB_PORT: { get_property: [SELF, port] }
```

Add the ansible playbook `playbooks/mongodb_install.yaml` in the `implementation` of the `create` interface as follows:

```yaml
          implementation: playbooks/mongodb_install.yaml
```

Notice:
* The `create` interfaces in TOSCA defines how a node is deployed.
* Here we tell the TOSCA orchestration engine to use an ansible `playbooks/mongodb_install.yaml` to deploy mongodb.
* The input `MONGODB_PORT` is available as an ansible variable in `mongodb_install.yaml` 
* Here we tell the input `MONGODB_PORT` to have the value from the property `port` of the node.

#### Step 5. Modify the ansible playbook for getting the input

Open [examples/mongodb/playbooks/mongodb_install.yaml](../examples/mongodb/playbooks/mongodb_install.yaml "Mongodb ansible playbook")

Add the input `MONGODB_PORT` as an ansible variable as follows (line 14)

```yaml
        mongodb_net_port: "{{ MONGODB_PORT }}"
```

#### Step 6. Zip the content of folder mongodb

```shell script
cd examples/mongodb && zip -r mongodb.zip *
```

CONGRATULATION! You have completed the mongodb node. Now continue with the nodecellar node.

#### Step 7. Edit templete version of nodecellar

Open [examples/nodecellar_tutorial3/types.yml](../examples/nodecellar_tutorial3/types.yml "Nodecellar example")

Replace `ỲOURNAME` with your name (line 5).

```yaml
  template_version: 1.0.0-YOURNAME
```

#### Step 8. Define the `requirements` for nodecellar to connect to mongodb

Under

```yaml
    requirements:
```

Add

```yaml
      - mongo_db:
          capability: tosca.capabilities.Endpoint.Database
          relationship: tosca.relationships.ConnectsTo
          occurrences: [1, 1]
```

Notice:
* Here the nodecellar node requires a node with the `mongo_db` capability. Recall that we have already defined the
`mongo_db` capability for the mongodb node (in step 3).
* The requirement has a `ConnectsTo` relationship (i.e., nodecellar `ConnectsTo` mongodb).

#### Step 9. Add `inputs` for nodecellar

Under the `inputs` of the `cretae` interface:

```yaml
    interfaces:
      Standard:
        create:
          implementation: scripts/install-nodecellar-app.sh
          inputs:
```

Add

```yaml
            DB_IP: { get_attribute: [TARGET, mongo_db, ip_address] }
            DB_PORT: { get_property: [TARGET, port] }
```

Notice:
* `get_attribute` get the `ip_address` from the capability `mongo_db` of the TARGET node at runtime.
* Here the TARGET node in the relationship is the mongodb node.

#### Step 10. Zip the content of the folder nodecellar_tutorial3

```shell script
cd examples/nodecellar_tutorial3 && zip -r nodecellar.zip *
```

CONGRATULATION! You have completed the nodecellar node.

#### Step 11. Upload the zip files

Now we upload the zip files `mongodb.zip` and `nodecellar.zip` to the topology designer:

1. Login to topology designer
2. Go to `Catalog` / `Manage archives` / `Drop archive files to upload here`

#### Step 12. Design the application

The nodecellar and mongodb nodes are now ready to use. Follow the instructions of the tutor to continue the following 
steps:

1. Drag a `Ǹetwork` node to the topology.
2. Drag 2 `Compute` node to the topology (one is for nodecellar, one is for mongodb).
3. Connects the `Compute` node (nodecellar) to the `Network` node.
4. Drag the `nodejs` on the nodecellar compute.
5. Drag the `Nodecellar` node on `nodejs` node.
6. Drag the `MongoDB` node on the compute mongodb.
7. Connects `Nodecellar` to the endpoint `mongo_db` of `MongoDB` node.

SAVE