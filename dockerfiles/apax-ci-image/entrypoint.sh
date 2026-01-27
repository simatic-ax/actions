#!/bin/bash
set -e

# Informationen in die Logs schreiben
{
    echo "##[group]SIMATIC AX Runner Image Information"
    echo "Title: $SIMATIC_AX_TITLE"
    echo "Description: $SIMATIC_AX_DESCRIPTION"
    echo "Vendor: $SIMATIC_AX_VENDOR"
    echo "Authors: $SIMATIC_AX_AUTHORS"
    echo "License: $SIMATIC_AX_LICENSE"
    echo "Product URL: $SIMATIC_AX_URL"
    echo "Documentation: $SIMATIC_AX_DOCUMENTATION"
    echo "Source: $SIMATIC_AX_SOURCE"
    echo "##[endgroup]"
} >&2

# Führe das übergebene Kommando aus
exec "$@"