---
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${REPONAME}
  namespace: ${NAMESPACE}
spec:
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
    spec:
      containers:
        - name: myapp
          image: ${REGISTRY}/${REPONAME}:${TAGS}
          ports:
            - name: http
              containerPort: 8080
          resources:
            requests:
              memory: 256Mi
              cpu: 100m
            limits:
              memory: 256Mi
              cpu: 100m
---
apiVersion: v1
kind: Service
metadata:
  name: ${REPONAME}-svc
  namespace: ${NAMESPACE}
spec:
  ports:
    - port: 8080
      targetPort: http
  selector:
    app: api-server


---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  namespace: api
spec:
  ingressClassName: nginx
  rules:
  - host: ${APP_URL}
    http:
      paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: ${REPONAME}-svc
              port:
               number: 8080

