#!/bin/env bash

export LB_IP=$(terraform output -raw lb_public_ip_inbound)
curl -I $LB_IP
