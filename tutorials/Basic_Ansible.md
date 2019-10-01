# 2. Create a software component using ansible playbook

In the previous example, we used a python script to implement a software component. In this example, we use an ansible 
playbook to create a mongodb. In the `create` interface, we use an ansible script as follows:

```yaml
node_types:
  otc.nodes.SoftwareComponent.MongoDB:
    derived_from: org.ystia.nodes.SoftwareComponent
    ...
    interfaces:
      Standard:
        create:
          inputs:
            # HOST is the keyword to get more information about the hosted compute node at runtime
            IP_ADDRESS: { get_attribute: [HOST, private_address] }
            MONGODB_PORT: { get_property: [SELF, port] }
          implementation: playbooks/mongodb_install.yaml
```

Notice: 
* We use the `SELF` keyword to get information of the node itself (e.g., the property `port` of the current node mongodb).
* We use the `HOST` keyword to get information of the compute node, on which our mongodb node is hosted.
* To get user input property of a node, use `get_property`.
* To get runtime output value of a node, use `get_attribute`.

The ansible script `mongodb_install.yaml` imports an ansible role `undergreen.ansible-role-mongodb` and use it to install 
a mongodb as follows:

```yaml
# playbooks/mongodb_install.yaml
- name: Install MongoDB
  hosts: all
  strategy: free
  become: true
  become_method: sudo
  tasks:
    - name: Install MongoDB using a 3rd party role
      import_role:
        name: undergreen.ansible-role-mongodb
      vars:
        mongodb_net_bindip: "{{ IP_ADDRESS }}"
        mongodb_net_port: "{{ MONGODB_PORT }}"
        ...
```

Here, the environment variable `IP_ADDRESS` and `MONGODB_PORT` are the `inputs` param of the `create` interface.

#### Where to go from here?

* See [full example](../examples/mongodb/types.yaml "Ansible example")
* Next: [How to define a `ConnectsTo` relationship between two software components?](Basic_Relationship_ConnectsTo.md "Relationship depands on example")