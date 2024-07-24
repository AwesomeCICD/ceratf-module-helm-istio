---
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: null
  labels:
    app: jaeger
    app.kubernetes.io/component: service-account
    app.kubernetes.io/instance: jaeger
    app.kubernetes.io/managed-by: jaeger-operator
    app.kubernetes.io/name: jaeger
    app.kubernetes.io/part-of: jaeger
  name: jaeger
  namespace: ${istio_namespace}
---
apiVersion: v1
data:
  sampling: '{"default_strategy":{"param":1,"type":"probabilistic"}}'
kind: ConfigMap
metadata:
  creationTimestamp: null
  labels:
    app: jaeger
    app.kubernetes.io/component: sampling-configuration
    app.kubernetes.io/instance: jaeger
    app.kubernetes.io/managed-by: jaeger-operator
    app.kubernetes.io/name: jaeger-sampling-configuration
    app.kubernetes.io/part-of: jaeger
  name: jaeger-sampling-configuration
  namespace: ${istio_namespace}
---
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: jaeger
    app.kubernetes.io/component: service-collector
    app.kubernetes.io/instance: jaeger
    app.kubernetes.io/managed-by: jaeger-operator
    app.kubernetes.io/name: jaeger-collector
    app.kubernetes.io/part-of: jaeger
  name: jaeger-collector
  namespace: ${istio_namespace}
spec:
  ports:
  - name: http-zipkin
    port: 9411
    targetPort: 0
  - name: grpc-jaeger
    port: 14250
    targetPort: 0
  - name: http-c-tchan-trft
    port: 14267
    targetPort: 0
  - name: http-c-binary-trft
    port: 14268
    targetPort: 0
  - name: admin-http
    port: 14269
    targetPort: 0
  - name: grpc-otlp
    port: 4317
    targetPort: 0
  - name: http-otlp
    port: 4318
    targetPort: 0
  selector:
    app: jaeger
    app.kubernetes.io/component: all-in-one
    app.kubernetes.io/instance: jaeger
    app.kubernetes.io/managed-by: jaeger-operator
    app.kubernetes.io/name: jaeger
    app.kubernetes.io/part-of: jaeger
  type: ClusterIP
status:
  loadBalancer: {}
---
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: jaeger
    app.kubernetes.io/component: service-query
    app.kubernetes.io/instance: jaeger
    app.kubernetes.io/managed-by: jaeger-operator
    app.kubernetes.io/name: jaeger-query
    app.kubernetes.io/part-of: jaeger
  name: jaeger-query
  namespace: ${istio_namespace}
spec:
  ports:
  - name: http-query
    port: 16686
    targetPort: 16686
  - name: grpc-query
    port: 16685
    targetPort: 16685
  - name: admin-http
    port: 16687
    targetPort: 16687
  selector:
    app: jaeger
    app.kubernetes.io/component: all-in-one
    app.kubernetes.io/instance: jaeger
    app.kubernetes.io/managed-by: jaeger-operator
    app.kubernetes.io/name: jaeger
    app.kubernetes.io/part-of: jaeger
  type: ClusterIP
status:
  loadBalancer: {}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    linkerd.io/inject: disabled
    prometheus.io/port: "14269"
    prometheus.io/scrape: "true"
  creationTimestamp: null
  labels:
    app: jaeger
    app.kubernetes.io/component: all-in-one
    app.kubernetes.io/instance: jaeger
    app.kubernetes.io/managed-by: jaeger-operator
    app.kubernetes.io/name: jaeger
    app.kubernetes.io/part-of: jaeger
  name: jaeger
  namespace: ${istio_namespace}
spec:
  selector:
    matchLabels:
      app: jaeger
      app.kubernetes.io/component: all-in-one
      app.kubernetes.io/instance: jaeger
      app.kubernetes.io/managed-by: jaeger-operator
      app.kubernetes.io/name: jaeger
      app.kubernetes.io/part-of: jaeger
  strategy:
    type: Recreate
  template:
    metadata:
      annotations:
        linkerd.io/inject: disabled
        prometheus.io/port: "14269"
        prometheus.io/scrape: "true"
        sidecar.istio.io/inject: "false"
      creationTimestamp: null
      labels:
        app: jaeger
        app.kubernetes.io/component: all-in-one
        app.kubernetes.io/instance: jaeger
        app.kubernetes.io/managed-by: jaeger-operator
        app.kubernetes.io/name: jaeger
        app.kubernetes.io/part-of: jaeger
    spec:
      containers:
      - args:
        - --sampling.strategies-file=/etc/jaeger/sampling/sampling.json
        env:
        - name: SPAN_STORAGE_TYPE
          value: memory
        - name: METRICS_STORAGE_TYPE
        - name: COLLECTOR_ZIPKIN_HOST_PORT
          value: :9411
        - name: JAEGER_DISABLED
          value: "false"
        - name: COLLECTOR_OTLP_ENABLED
          value: "true"
        image: jaegertracing/all-in-one:1.57.0
        livenessProbe:
          failureThreshold: 5
          httpGet:
            path: /
            port: 14269
          initialDelaySeconds: 5
          periodSeconds: 15
        name: jaeger
        ports:
        - containerPort: 5775
          name: zk-compact-trft
          protocol: UDP
        - containerPort: 5778
          name: config-rest
        - containerPort: 6831
          name: jg-compact-trft
          protocol: UDP
        - containerPort: 6832
          name: jg-binary-trft
          protocol: UDP
        - containerPort: 9411
          name: zipkin
        - containerPort: 14267
          name: c-tchan-trft
        - containerPort: 14268
          name: c-binary-trft
        - containerPort: 16685
          name: grpc-query
        - containerPort: 16686
          name: query
        - containerPort: 14269
          name: admin-http
        - containerPort: 14250
          name: grpc
        - containerPort: 4317
          name: grpc-otlp
        - containerPort: 4318
          name: http-otlp
        readinessProbe:
          httpGet:
            path: /
            port: 14269
          initialDelaySeconds: 1
        resources: {}
        volumeMounts:
        - mountPath: /etc/jaeger/sampling
          name: jaeger-sampling-configuration-volume
          readOnly: true
      enableServiceLinks: false
      serviceAccountName: jaeger
      volumes:
      - configMap:
          items:
          - key: sampling
            path: sampling.json
          name: jaeger-sampling-configuration
        name: jaeger-sampling-configuration-volume
status: {}
