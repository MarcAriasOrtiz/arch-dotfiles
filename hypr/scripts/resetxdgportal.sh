#!/bin/bash

# Detener el servicio xdg-desktop-portal
systemctl --user stop xdg-desktop-portal

# Iniciar el servicio xdg-desktop-portal
systemctl --user start xdg-desktop-portal