#!/bin/env bash

export LB_IP=$(terraform output -raw lb_public_ip)
curl $LB_IP
