## Very Rough Kubernetes Setup

I'm new to kubernetes, but these definitions were sufficient for me to get
it running on my manual cloud, after I manually pushed my docker images to
docker hub.  I realize that these aren't best practices, especially using NodePort
in production, or not using the Deployment resource, but this is my first go
at using kubernetes.

## To Apply

kubectl apply -f .

