all:
	for i in $(dirname $0)/cb1-k8s/*.yaml; do echo -n "# $i"; kubectl apply -f $i; done
