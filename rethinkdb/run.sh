#!/bin/sh
POD_NAMESPACE="${POD_NAMESPACE:-default}"
POD_IP="$(getent hosts ${HOSTNAME} | awk '{print $1}')"

# Get k8s authentication token and build URL to retrieve stateful set info.
token="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"
ca_path="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
svc_endpoint="https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT_HTTPS}/api/v1/namespaces/${POD_NAMESPACE}/endpoints/rethinkdb"

# Get IPs of other pods in this stateful set, if any.
existing=$(wget -q --ca-certificate "${ca_path}" --header "Authorization: Bearer ${token}" -O - "${svc_endpoint}" | jq -s -r --arg h "${POD_IP}" '.[0].subsets | .[].addresses // [] | [ .[].ip ] | map(select(. != $h)) | .[0] // ""') || exit 1

# If there are no other pods, check if we need to join ourselves or
if [[ -n "${existing}" ]]; then
  join="--server-tag default --server-tag secondary --join ${existing}"
  echo "Joining cluster at ${existing}"
else
  if [[ -n "${JOIN_CLUSTER}" ]]; then
    join="--server-tag default --server-tag primary --join ${JOIN_CLUSTER}"
    echo "Joining external cluster at ${JOIN_CLUSTER}"
  else
    join="--server-tag default --server-tag primary"
    echo "This is the primary server"
  fi
fi

# Build URL and retrieve load balancer IP if it exists.
lb_endpoint="https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT_HTTPS}/api/v1/namespaces/${POD_NAMESPACE}/services"
lb_ip=$(wget -q --ca-certificate "${ca_path}" --header "Authorization: Bearer ${token}" -O - "${lb_endpoint}" | jq -s -r '.[].items | map(select(.spec.selector.app == "rethinkdb")) | .[0].status.loadBalancer.ingress[0].ip // ""') || exit 1

# Set canonical address based on IP addresses found
if [[ -n "${lb_ip}" ]]; then
  addresses="--canonical-address ${POD_IP} --canonical-address 127.0.0.1 --canonical-address ${lb_ip}"
else
  addresses="--canonical-address ${POD_IP} --canonical-address 127.0.0.1"
fi

exec rethinkdb --bind all ${join} ${addresses}
