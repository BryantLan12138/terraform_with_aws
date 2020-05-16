[Unit]
Description=TechTestApp
Requires=network-online.target
After=network-online.target

[Service]
WorkingDirectory=/etc/app/dist 
Type=simple
ExecStart=/etc/app/dist/TechTestApp serve 
Restart=on-failure

[Install]
WantedBy=multi-user.target