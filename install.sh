# Create docker images:
declare -a images
images=("users" "products" "orders" "email")

for image in ${images[@]}; do
  echo "Building microservices image: $image"
  docker build --no-cache -t "${image}:ecommerce" ./"ms-$image" 

  [[ $? -ne 0 ]] && echo "Build failed for: $image"
done

docker build --no-cache -t "frontend:ecommerce" ./frontend

# Copy and paste the following output
# into MONGO_URI value: kubernetes/secrets.yaml 
echo -n mongodb://database:27017/ecommerce?directConnection=true | base64

# Same for JWT_SECRET
echo -n SECRET | base64

# Create kubernetes namespace:
kubectl create namespace ecommerce

# Apply deployments and secret:
for deployment in $(find .); do
  echo "Applying deployment: ${deployment}"
  kubectl apply -f $deployment;
done

# Verify by curl or use web browser: 
curl http://kubernetes.docker.internal

# OPTIONAL:
# Local dev:

# Apply local ingress: (backend)
kubectl apply -f kubernetes/local-ingress.yaml
curl http://kubernetes.docker.internal/api/products

# Start yarn:
yarn install & yarn start /frontend
curl http://localhost:3000/

# In case of connecting to mongo:
kubectl port-forward $(kubectl get pod -n ecommerce | egrep -Eo 'database-(\w+\-)\w+') -n ecommerce 27017:27017