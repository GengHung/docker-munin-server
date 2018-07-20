build:
	docker build -t munin:v1 .

run:
	docker run -d \
        -p 8080:8080 \
        -e MUNIN_USER=munin \
        -e MUNIN_PASSWORD=1234567890 \
        -e SMTP_HOST=smtp.example.com \
        -e SMTP_PORT=587 \
        -e SMTP_USERNAME=smtp-username \
        -e SMTP_PASSWORD=smtp-password \
        -e SMTP_USE_TLS=false \
        -e SMTP_ALWAYS_SEND=true \
        -e SMTP_MESSAGE='[${var:group};${var:host}] -> ${var:graph_title} -> warnings: ${loop<,>:wfields  ${var:label}=${var:value}} / criticals: ${loop<,>:cfields  ${var:label}=${var:value}}' \
        -e ALERT_RECIPIENT=monitoring@example.com \
        -e ALERT_SENDER=alerts@example.com \
        -e NODES="server1:127.0.0.1" \
        munin:v1

        #-e NODES="server1:192.168.33.30 db:192.168.33.31" \
        #-e SNMP_NODES="router1:192.0.0.254:9999" \
