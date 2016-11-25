# CloudFormation Library

Various examples of CloudFormation.


## Provision a Stack

Updates a stack with the given template and params file if its stack-name exists, otherwise creates it.

```bash
STACK_NAME=foobar TEMPLATE=basic_function PARAMS=basic_function make provision
```

## Delete a Stack

Deletes a stack with the given name.

```bash
STACK_NAME=foobar make delete
```
