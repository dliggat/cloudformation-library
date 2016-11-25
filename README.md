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

## Scaffold a Function

```bash
FUNCTION=whatever make scaffold
```

Results in the following:

```bash
lambdas
└── whatever_package
    ├── index.py          # Function entry point.
    ├── requirements
    │   ├── common.txt    # Common dependencies.
    │   ├── dev.txt       # Local development dependencies.
    │   └── lambda.txt    # Runtime dependencies.
    └── whatever          # Modules go here.
```

