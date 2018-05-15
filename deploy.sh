#!/bin/bash

# create secret
kubectl create secret generic mysql-pass --from-literal=password=foobar

# install mysql
kubectl create -f mysql-deployment.yaml

# install wordpress
kubectl create -f wordpress-deployment.yaml
